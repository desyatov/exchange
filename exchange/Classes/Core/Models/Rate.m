//
//  Rate.m
//  exchange
//
//  Created by Alexander Desyatov on 09/02/2017.
//  Copyright © 2017 Desyatov Alexander. All rights reserved.
//

#import "Rate.h"
#import "Currency.h"

@implementation Rate

+ (NSValueTransformer *)currencyJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *code, BOOL *success, NSError *__autoreleasing *error) {
        return [Currency currencyWithCode:code];
    }];
}

+ (NSValueTransformer *)multiplierJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *value, BOOL *success, NSError *__autoreleasing *error) {
        return [NSDecimalNumber decimalNumberWithString:value];
    }];
}

@end
