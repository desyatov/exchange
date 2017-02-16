//
//  Currency.m
//  exchange
//
//  Created by Alexander Desyatov on 09/02/2017.
//  Copyright © 2017 Desyatov Alexander. All rights reserved.
//

#import "Currency.h"

@implementation Currency

+ (instancetype)currencyWithCode:(NSString *)code {
    return [[self alloc] initWithCode:code];
}

- (instancetype)initWithCode:(NSString *)code {
    self = [super init];
    if (self) {
        _code = [code copy];
    }
    return self;
}

- (NSString *)stringValue {
    return self.code;
}

- (BOOL)isEqual:(id)object {
    if (self == object) return YES;
    if (![object isKindOfClass:self.class]) return NO;
    return [self isEqualToCurrency:object];
}

- (BOOL)isEqualToCurrency:(Currency *)currency {
    return [self.code isEqualToString:currency.code];
}

- (NSUInteger)hash {
    return [self.code hash];
}

- (NSString *)description {
    return [[super description] stringByAppendingFormat:@" %@", self.code];
}

@end


@implementation Currency (Popular)

+ (instancetype)EUR {
    return [self currencyWithCode:@"EUR"];
}

+ (instancetype)USD {
    return [self currencyWithCode:@"USD"];
}

+ (instancetype)GBP {
    return [self currencyWithCode:@"GBP"];
}

@end
