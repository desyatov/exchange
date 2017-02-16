//
//  Currency.h
//  exchange
//
//  Created by Alexander Desyatov on 09/02/2017.
//  Copyright © 2017 Desyatov Alexander. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Currency : NSObject

@property (nonatomic, copy, readonly) NSString *code;

+ (instancetype)currencyWithCode:(NSString *)code;

- (NSString *)stringValue;

- (BOOL)isEqualToCurrency:(Currency *)currency;

@end

@interface Currency (Popular)

+ (instancetype)EUR;
+ (instancetype)USD;
+ (instancetype)GBP;

@end
