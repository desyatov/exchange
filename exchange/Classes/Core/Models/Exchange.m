//
//  Exchange.m
//  exchange
//
//  Created by Alexander Desyatov on 09/02/2017.
//  Copyright © 2017 Desyatov Alexander. All rights reserved.
//

#import "Exchange.h"
#import "Money.h"
#import "Rate.h"
#import "Currency.h"

@implementation Exchange

- (instancetype)initWithRates:(NSArray<Rate *> *)rates
{
    self = [super init];
    if (self) {
        _rates = rates;
    }
    return self;
}

- (Money *)convertMoney:(Money *)money toCurrency:(Currency *)toCurrency {
    
    NSDecimalNumber *amount = [self convertAmount:money.amount fromCurrency:money.currency toCurrency:toCurrency];
    return [Money moneyWithCurrency:toCurrency amount:amount];
}

- (NSDecimalNumber *)convertAmount:(NSDecimalNumber *)amount fromCurrency:(Currency *)fromCurrency toCurrency:(Currency *)toCurrency {
    NSDecimalNumber *multiplier = [self multiplierFromCurrency:fromCurrency toCurrency:toCurrency];
    return [amount decimalNumberByMultiplyingBy:multiplier];
}


- (NSDecimalNumber *)multiplierFromCurrency:(Currency *)fromCurrency toCurrency:(Currency *)toCurrency
{
    Rate *fromRate = [self.rates first:^BOOL(Rate *object) {
        return [object.currency isEqualToCurrency:fromCurrency];
    }];
    Rate *toRate = [self.rates first:^BOOL(Rate *object) {
        return [object.currency isEqualToCurrency:toCurrency];
    }];
    return [fromRate.multiplier decimalNumberByDividingBy:toRate.multiplier];
}

@end


@implementation Exchange (Description)

- (NSString *)rateStringFromCurrency:(Currency *)fromCurrency toCurrency:(Currency *)toCurrency {
    if (fromCurrency == nil || toCurrency == nil) {
        return @"";
    }
    NSDecimalNumber *multiplier = [self multiplierFromCurrency:toCurrency toCurrency:fromCurrency];
    Money *sourceMoney = [Money moneyWithCurrency:fromCurrency amount:[NSDecimalNumber decimalNumberWithString:@"1"]];
    Money *targetMoney = [Money moneyWithCurrency:toCurrency amount:multiplier];
    return [NSString stringWithFormat:@"%@ = %@", [sourceMoney stringValue], [targetMoney stringValue]];
}

@end
