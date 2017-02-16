//
//  MoneyInputViewModel.h
//  exchange
//
//  Created by Alexander Desyatov on 11/02/2017.
//  Copyright © 2017 Desyatov Alexander. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Currency, MoneyController, Money;

@interface MoneyInputViewModel : NSObject

@property (nonatomic, copy, readonly) NSString *currencyString;
@property (nonatomic, copy, readonly) NSString *moneyAvailableString;
@property (nonatomic, copy, readwrite) NSString *exchangeRateString;
@property (nonatomic, strong, readwrite) NSDecimalNumber *value;
@property (nonatomic, strong, readonly) RACSignal *valueSignal;
@property (nonatomic, copy, readwrite) NSString *textValue;
@property (nonatomic, assign, readonly) BOOL hasEnoughMoney;
@property (nonatomic, assign, readwrite) BOOL active;
@property (nonatomic, assign, readwrite) BOOL selected;
@property (nonatomic, strong, readonly) RACSignal *selectedSignal;
@property (nonatomic, strong, readonly) RACSignal *activeSignal;
@property (nonatomic, strong, readonly) RACSignal *validateSignal;
@property (nonatomic, assign, readwrite, getter=isSource) BOOL source;

@property (nonatomic, strong, readonly) Currency *sourceCurrency;
@property (nonatomic, strong, readwrite) Currency *targetCurrency;

- (instancetype)initWithCurrency:(Currency *)currency moneyController:(MoneyController *)moneyController;

@end
