//
//  MoneyInputViewModel.m
//  exchange
//
//  Created by Alexander Desyatov on 11/02/2017.
//  Copyright © 2017 Desyatov Alexander. All rights reserved.
//

#import "MoneyInputViewModel.h"
#import "Currency.h"
#import "Exchange.h"
#import "MoneyController.h"
#import "Money.h"

@implementation MoneyInputViewModel

- (NSNumberFormatter *)formatter {
    static NSNumberFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSNumberFormatter alloc] init];
//        formatter.numberStyle = NSNumberFormatterCurrencyStyle;
        formatter.maximumFractionDigits = 2;
        formatter.minimumFractionDigits = 0;
        formatter.minimumIntegerDigits = 1;
        formatter.currencyCode = @"";
        formatter.currencySymbol = @"";
    });
    return formatter;
}

- (instancetype)initWithCurrency:(Currency *)currency moneyController:(MoneyController *)moneyController {
    self = [super init];
    if (self) {
        _sourceCurrency = currency;
        _hasEnoughMoney = YES;
        _value = [NSDecimalNumber zero];

        _active = NO;
        _selected = NO;
        _activeSignal = [[RACObserve(self, active) distinctUntilChanged] replayLast];
        
        RAC(self, currencyString) = [RACObserve(self, sourceCurrency) map:^id _Nullable(Currency  *_Nullable currency) {
            return currency ? [currency stringValue] : @"";
        }];
        
        RAC(self, exchangeRateString) = [RACSignal combineLatest:@[
                                                                   [RACObserve(moneyController, exchange) ignore:nil],
                                                                   [RACObserve(self, sourceCurrency) ignore:nil],
                                                                   RACObserve(self, targetCurrency)
                                                                  ]
                                            reduce:^NSString *(Exchange *exchange, Currency *sourceCurrency, Currency *targetCurrency) {
                                                return [exchange rateStringFromCurrency:sourceCurrency toCurrency:targetCurrency];
                                            }];
        
        RAC(self, value) = [[RACObserve(self, textValue) distinctUntilChanged]  map:^id _Nullable(NSString * _Nullable text) {
            return text.length == 0 ? [NSDecimalNumber zero] : [NSDecimalNumber decimalNumberWithString:text];
        }];
        
        @weakify(self);
        RAC(self, textValue) = [[RACObserve(self, value) distinctUntilChanged]  map:^id _Nullable(NSDecimalNumber * _Nullable value) {
            @strongify(self);
            return (value && ![value isEqual:[NSDecimalNumber zero]]) ? [self.formatter stringFromNumber:value] : @"";
        }];
        
        RAC(self, moneyAvailableString) = [[[moneyController moneyForCurrency:self.sourceCurrency] ignore:nil] map:^id _Nullable(Money  *money) {
            return [money stringValue];
        }];
        
        _valueSignal = [[RACObserve(self, value) ignore:nil] distinctUntilChanged];
        _selectedSignal = [RACObserve(self, selected) distinctUntilChanged];
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"Dealloc %@", self);
}

@end
