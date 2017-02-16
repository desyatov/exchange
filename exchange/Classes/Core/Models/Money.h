//
//  Money.h
//  exchange
//
//  Created by Alexander Desyatov on 09/02/2017.
//  Copyright © 2017 Desyatov Alexander. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Currency;

@interface Money : NSObject

@property (nonatomic, strong, readonly) Currency *currency;
@property (nonatomic, strong, readonly) NSDecimalNumber *amount;

+ (instancetype)moneyWithCurrency:(Currency *)currency amount:(NSDecimalNumber *)amount;

- (BOOL)isZero;
- (NSString *)stringValue;

- (BOOL)isEqualToMoney:(Money *)money;

- (Money *)plus:(Money *)money;
- (Money *)minus:(Money *)money;

@end
