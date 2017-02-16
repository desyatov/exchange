//
//  Client.h
//  exchange
//
//  Created by Alexander Desyatov on 08/02/2017.
//  Copyright © 2017 Desyatov Alexander. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AFURLResponseSerialization;
@class RACSignal;

@protocol Client <NSObject>

- (RACSignal *)executeURLRequest:(NSURLRequest *)request resultClass:(Class)resultClass;
- (RACSignal *)executeURLRequest:(NSURLRequest *)request resultClass:(Class)resultClass responseSerializer:(id <AFURLResponseSerialization>)responseSerializer;

@end
