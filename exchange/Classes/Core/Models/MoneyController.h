//
//  MoneyController.h
//  exchange
//
//  Created by Alexander Desyatov on 14/02/2017.
//  Copyright © 2017 Desyatov Alexander. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Exchange, Balance, Currency;

@interface MoneyController : NSObject

@property (nonatomic, strong, readwrite) Exchange *exchange;
@property (nonatomic, strong, readwrite) Balance *balance;

- (RACSignal *)moneyForCurrency:(Currency *)currency;

@end
