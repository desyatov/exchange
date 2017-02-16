//
//  ExchangeViewModel.h
//  exchange
//
//  Created by Alexander Desyatov on 08/02/2017.
//  Copyright © 2017 Desyatov Alexander. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewModeling.h"

@protocol ExchangeService;
@class ExchangeListViewModel;

@interface ExchangeViewModel : NSObject <ViewModeling>

@property (nonatomic, strong, readonly) id <ExchangeService> service;

@property (nonatomic, strong, readonly) ExchangeListViewModel *topListViewModel;
@property (nonatomic, strong, readonly) ExchangeListViewModel *bottomListViewModel;
@property (nonatomic, strong, readonly) RACCommand *loadRates;

@end
