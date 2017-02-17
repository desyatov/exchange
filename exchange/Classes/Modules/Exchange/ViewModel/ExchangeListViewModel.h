//
//  ExchangeListViewModel.h
//  exchange
//
//  Created by Alexander Desyatov on 11/02/2017.
//  Copyright © 2017 Desyatov Alexander. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewModeling.h"

@class MoneyInputViewModel;

@interface ExchangeListViewModel : NSObject

@property (nonatomic, strong, readwrite) NSString *identifier;
@property (nonatomic, strong, readonly) MoneyInputViewModel *currentViewModel;
@property (nonatomic, strong, readonly) RACSignal *currentViewModelSignal;
@property (nonatomic, strong, readonly) RACSignal *currentViewModelDidChange;
@property (nonatomic, assign, readwrite) NSInteger currentItemIndex;
@property (nonatomic, assign, readwrite) BOOL active;

@property (nonatomic, strong, readwrite) NSArray<MoneyInputViewModel *> *items;

@end
