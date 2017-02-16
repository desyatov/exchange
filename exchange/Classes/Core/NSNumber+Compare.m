//
//  NSNumber+Compare.m
//  exchange
//
//  Created by Alexander Desyatov on 16/02/2017.
//  Copyright © 2017 Desyatov Alexander. All rights reserved.
//

#import "NSNumber+Compare.h"

@implementation NSNumber (Compare)

- (NSComparisonResult) compareWithNumber:(NSNumber *)number{
    return [self compare:number];
}

- (BOOL) isEqualToNuber:(NSNumber *)number{
    return [self compareWithNumber:number] == NSOrderedSame;
}

- (BOOL) isGreaterThanInt:(NSNumber *)number{
    return [self compareWithNumber:number] == NSOrderedDescending;
}

- (BOOL) isGreaterThanOrEqualToNuber:(NSNumber *)number {
    return [self isGreaterThanInt:number] || [self isEqualToNuber:number];
}

- (BOOL) isLessThanInt:(NSNumber *)number{
    return [self compareWithNumber:number] == NSOrderedAscending;
}

- (BOOL) isLessThanOrEqualToNuber:(NSNumber *)number{
    return [self isLessThanInt:number] || [self isEqualToNuber:number];
}

- (BOOL)isZero {
    return [self isEqualToNumber:[NSDecimalNumber zero]];
}

@end
