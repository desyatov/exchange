//
//  Balance.m
//  exchange
//
//  Created by Alexander Desyatov on 12/02/2017.
//  Copyright © 2017 Desyatov Alexander. All rights reserved.
//

#import "Balance.h"
#import "Account.h"
#import "Money.h"
#import "Currency.h"

@implementation Balance

- (instancetype)initWithAccounts:(NSArray *)accounts
{
    self = [super init];
    if (self) {
        _accounts = accounts;
    }
    return self;
}

- (Account *)accountForCurrency:(Currency *)currency {
    return [self.accounts first:^BOOL(Account *object) {
        return [object.currency isEqualToCurrency:currency];
    }];
}

- (Money *)moneyForCurrency:(Currency *)currency {
    return [self accountForCurrency:currency].money;
}

- (Money *)plus:(Money *)money {
    Account *account = [self accountForCurrency:money.currency];
    return account ? [account plus:money] : nil;
}

- (Money *)minus:(Money *)money {
    Account *account = [self accountForCurrency:money.currency];
    return account ? [account minus:money] : nil;
}

@end
