//
//  Balance.h
//  exchange
//
//  Created by Alexander Desyatov on 12/02/2017.
//  Copyright © 2017 Desyatov Alexander. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Money, Currency, Account;

@interface Balance : NSObject

@property (nonatomic, strong, readonly) NSArray *accounts;

- (instancetype)initWithAccounts:(NSArray *)accounts;

- (Account *)accountForCurrency:(Currency *)currency;
- (Money *)moneyForCurrency:(Currency *)currency;
- (Money *)plus:(Money *)money;
- (Money *)minus:(Money *)money;

@end
