//
//  ExchangeService.h
//  exchange
//
//  Created by Alexander Desyatov on 08/02/2017.
//  Copyright © 2017 Desyatov Alexander. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExchangeService.h"

@protocol Client;

@interface ExchangeServiceBase : NSObject <ExchangeService>

@property (nonatomic, strong, readonly) NSURL *baseURL;
@property (nonatomic, strong, readonly) id <Client> client;

@end
