//
//  NSNumber+Compare.h
//  exchange
//
//  Created by Alexander Desyatov on 16/02/2017.
//  Copyright © 2017 Desyatov Alexander. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (Compare)

- (BOOL) isGreaterThanOrEqualToNuber:(NSNumber *)number;

- (BOOL)isZero;

@end
