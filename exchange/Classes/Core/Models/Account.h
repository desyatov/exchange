//
//  Account.h
//  exchange
//
//  Created by Alexander Desyatov on 12/02/2017.
//  Copyright © 2017 Desyatov Alexander. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Money, Currency;

@interface Account : NSObject

@property (nonatomic, strong, readonly) Money *money;

- (instancetype)initWithMoney:(Money *)money;

- (Currency *)currency;
- (Money *)plus:(Money *)money;
- (Money *)minus:(Money *)money;

@end
