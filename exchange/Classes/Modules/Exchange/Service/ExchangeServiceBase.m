//
//  ExchangeService.m
//  exchange
//
//  Created by Alexander Desyatov on 08/02/2017.
//  Copyright © 2017 Desyatov Alexander. All rights reserved.
//

#import "ExchangeServiceBase.h"
#import "Client.h"
#import <AFNetworking/AFNetworking.h>
#import <RaptureXML/RXMLElement.h>
#import "Rate.h"

@interface RateXMLParserResponseSerializer: AFXMLParserResponseSerializer

@end

@interface ExchangeServiceBase ()
@property (nonatomic, strong, readwrite) NSURL *baseURL;
@property (nonatomic, strong, readwrite) id <Client> client;
@end

@implementation ExchangeServiceBase

- (RACSignal *)fetchRateSet {
    NSParameterAssert(self.client);
    NSURLRequest *request = [NSURLRequest requestWithURL:self.baseURL];
    return [self.client  executeURLRequest:request resultClass:[Rate class] responseSerializer:[RateXMLParserResponseSerializer serializer]];
}

@end


@implementation RateXMLParserResponseSerializer

- (id)responseObjectForResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError *__autoreleasing  _Nullable *)error {
    if (![self validateResponse:(NSHTTPURLResponse *)response data:data error:error]) {
        return nil;
    }
    RXMLElement *element = [RXMLElement elementFromXMLData:data];
    NSMutableArray *result = [NSMutableArray array];
    [element iterate:@"Cube.Cube.Cube" usingBlock: ^(RXMLElement *e) {
        NSDictionary *rate = @{
                               @"currency": [e attribute:@"currency"],
                               @"multiplier": [e attribute:@"rate"]
                               };
        [result addObject: rate];
    }];
    [result addObject:@{
                        @"currency": @"EUR",
                        @"multiplier": @"1"
                        }];
    
    return [result copy];
}

@end

