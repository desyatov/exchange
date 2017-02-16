//
//  MoneyController.m
//  exchange
//
//  Created by Alexander Desyatov on 14/02/2017.
//  Copyright © 2017 Desyatov Alexander. All rights reserved.
//

#import "MoneyController.h"
#import "Balance.h"
#import "Account.h"

@implementation MoneyController


- (RACSignal *)moneyForCurrency:(Currency *)currency {
    return [[[RACObserve(self, balance) ignore:nil] map:^__kindof RACSignal * _Nullable(Balance *balance) {
        Account *account = [balance accountForCurrency:currency];
        return RACObserve(account, money);
    }] switchToLatest];
}

@end
