//
//  Rate.h
//  exchange
//
//  Created by Alexander Desyatov on 09/02/2017.
//  Copyright © 2017 Desyatov Alexander. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelBase.h"

@class Currency;

@interface Rate: ModelBase

@property (nonatomic, strong, readonly) Currency *currency;
@property (nonatomic, strong, readonly) NSDecimalNumber *multiplier;

@end
