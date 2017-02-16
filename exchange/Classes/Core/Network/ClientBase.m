//
//  Client.m
//  exchange
//
//  Created by Alexander Desyatov on 08/02/2017.
//  Copyright © 2017 Desyatov Alexander. All rights reserved.
//

#import "ClientBase.h"
#import <AFNetworking/AFNetworking.h>
#import <Mantle/Mantle.h>

@implementation NSError (Client)

+ (NSError *)p_unknownError {
    return [NSError errorWithDomain:@"ClientBase"
                               code:0
                           userInfo:nil];
}
@end

@interface ClientBase ()
@property (nonatomic, strong, readonly) AFHTTPSessionManager *sessionManager;
@end

@implementation ClientBase

- (instancetype)init {
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _sessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    }
    return self;
}

- (RACSignal *)executeURLRequest:(NSURLRequest *)request resultClass:(Class)resultClass {
    return [self executeURLRequest:request resultClass:resultClass responseSerializer:nil];
}

- (RACSignal *)executeURLRequest:(NSURLRequest *)request resultClass:(Class)resultClass responseSerializer:(id <AFURLResponseSerialization>)responseSerializer {
    NSParameterAssert(self.sessionManager);
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        self.sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.sessionManager.responseSerializer = responseSerializer ? : [AFJSONResponseSerializer serializer];
        NSURLSessionDataTask * dataTask = [self.sessionManager dataTaskWithRequest:request completionHandler:^void(NSURLResponse *response, id responseObject, NSError * error) {
            if(error) {
                [subscriber sendError:error];
            }else {
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
            }
        }];
        [dataTask resume];
        
        return [RACDisposable disposableWithBlock:^{
            [dataTask cancel];
        }];
    }] setNameWithFormat:@"%@ -rac_%@: %@", request.HTTPMethod, self.class, request.URL.absoluteString] flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        NSLog(@"Response: %@", value);
        return [self parsedResponseOfClass:resultClass fromJSON:value responseResultKey:nil];
    }];
}

- (RACSignal *)parsedResponseOfClass:(Class)resultClass fromJSON:(id)responseObject responseResultKey:(NSString *)responseResultKey {
    NSParameterAssert(resultClass == nil || [resultClass isSubclassOfClass:MTLModel.class]);
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        BOOL (^parseJSONDictionary)(NSDictionary *) = ^(NSDictionary *JSONDictionary) {
            if (resultClass == nil) {
                [subscriber sendNext:JSONDictionary];
                return YES;
            }
            
            NSError *error = nil;
            id parsedObject = [MTLJSONAdapter modelOfClass:resultClass fromJSONDictionary:JSONDictionary error:&error];
            if (parsedObject == nil) {
                if (![error.domain isEqual:MTLJSONAdapterErrorDomain] || error.code != MTLJSONAdapterErrorNoClassFound) {
                    [subscriber sendError:error];
                    return NO;
                }
                return YES;
            }
            [subscriber sendNext:parsedObject];
            return YES;
        };
        
        NSDictionary *responseJSON = responseObject;
        if([responseJSON isKindOfClass:NSDictionary.class]) {
            NSString *responseKey = responseResultKey ? : @"result";
            if(responseJSON[responseKey] != nil) {
                responseJSON = responseJSON[responseKey];
            } else if(responseJSON[@"items"] != nil) {
                responseJSON = responseJSON[@"items"];
            }
        }
        
        if ([responseJSON isKindOfClass:NSArray.class]) {
            for (NSDictionary *JSONDictionary in responseJSON) {
                if (![JSONDictionary isKindOfClass:NSDictionary.class]) {
                    [subscriber sendError:[NSError p_unknownError]];
                    return nil;
                }
                if (!parseJSONDictionary(JSONDictionary)) return nil;
            }
            [subscriber sendCompleted];
        } else if ([responseJSON isKindOfClass:NSDictionary.class]) {
            parseJSONDictionary(responseJSON);
            [subscriber sendCompleted];
        } else if (responseJSON != nil) {
            [subscriber sendError:[NSError p_unknownError]];
        } else {
            [subscriber sendCompleted];
        }
        return nil;
    }];
}


@end

