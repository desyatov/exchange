//
//  Money.m
//  exchange
//
//  Created by Alexander Desyatov on 09/02/2017.
//  Copyright © 2017 Desyatov Alexander. All rights reserved.
//

#import "Money.h"
#import "Currency.h"

@implementation Money

+ (instancetype)moneyWithCurrency:(Currency *)currency amount:(NSDecimalNumber *)amount
{
    return [[self alloc] initWithCurrency:currency amount:amount];
}


- (instancetype)initWithCurrency:(Currency *)currency amount:(NSDecimalNumber *)amount
{
    NSParameterAssert(currency != nil);
    NSParameterAssert(amount != nil);
    
    self = [super init];
    if (self)
    {
        _currency = currency;
        _amount = amount;
    }
    return self;
}

- (Money *)plus:(Money *)money {
    NSParameterAssert([money.currency isEqualToCurrency:self.currency]);
    return [Money moneyWithCurrency:self.currency amount:[self.amount decimalNumberByAdding:money.amount]];
}

- (Money *)minus:(Money *)money {
    NSParameterAssert([money.currency isEqualToCurrency:self.currency]);
    return [Money moneyWithCurrency:self.currency amount:[self.amount decimalNumberBySubtracting:money.amount]];
}

- (NSNumberFormatter *)formatter {
    static NSNumberFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    });
    formatter.currencyCode = self.currency.code;
    return formatter;
}


- (BOOL)isZero
{
    return [self.amount isEqual:[NSDecimalNumber zero]];
}

- (NSString *)stringValue
{
    return [self.formatter stringFromNumber:self.amount];
}

- (NSString *)description {
    return [[super description] stringByAppendingFormat:@" %@", self.stringValue];
}

- (BOOL)isEqual:(id)object
{
    if (self == object) return YES;
    if (![object isKindOfClass:self.class]) return NO;
    return [self isEqualToMoney:object];
}

- (BOOL)isEqualToMoney:(Money *)money
{
    return [self.currency isEqual:money.currency] && [self.amount isEqualToNumber:money.amount];
}

- (NSUInteger)hash
{
    return [self.currency hash] + [self.amount hash];
}


@end
