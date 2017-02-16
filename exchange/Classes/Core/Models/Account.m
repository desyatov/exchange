//
//  Account.m
//  exchange
//
//  Created by Alexander Desyatov on 12/02/2017.
//  Copyright © 2017 Desyatov Alexander. All rights reserved.
//

#import "Account.h"
#import "Money.h"

@interface Account ()
@property (nonatomic, strong, readwrite) Money *money;
@end

@implementation Account

- (instancetype)initWithMoney:(Money *)money {
    self = [super init];
    if (self) {
        _money = money;
    }
    return self;
}

- (Currency *)currency {
    return self.money.currency;
}

- (Money *)plus:(Money *)money {
    self.money = [self.money plus:money];
    return self.money;
}

- (Money *)minus:(Money *)money {
    self.money = [self.money minus:money];
    return self.money;
}

@end
