//
//  ExchangeService.h
//  exchange
//
//  Created by Alexander Desyatov on 08/02/2017.
//  Copyright © 2017 Desyatov Alexander. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSignal;

@protocol ExchangeService <NSObject>

- (RACSignal *)fetchRateSet;

@end
