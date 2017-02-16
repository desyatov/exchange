//
//  Exchange.h
//  exchange
//
//  Created by Alexander Desyatov on 09/02/2017.
//  Copyright © 2017 Desyatov Alexander. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Money, Currency, Rate;

@interface Exchange : NSObject

@property (nonatomic, strong, readonly) NSArray<Rate *> *rates;

- (instancetype)initWithRates:(NSArray<Rate *> *)rates;

- (Money *)convertMoney:(Money *)money toCurrency:(Currency *)toCurrency;
- (NSDecimalNumber *)convertAmount:(NSDecimalNumber *)amount fromCurrency:(Currency *)fromCurrency toCurrency:(Currency *)toCurrency;

@end


@interface Exchange (Description)

- (NSString *)rateStringFromCurrency:(Currency *)fromCurrency toCurrency:(Currency *)toCurrency;

@end
