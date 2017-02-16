//
//  ExchangeAssembly.h
//  exchange
//
//  Created by Alexander Desyatov on 08/02/2017.
//  Copyright © 2017 Desyatov Alexander. All rights reserved.
//

#import <Typhoon/Typhoon.h>

@protocol ExchangeService;
@class ExchangeViewModel, ExchangeViewController;

@interface ExchangeAssembly : TyphoonAssembly

- (id <ExchangeService>)exchangeService;
- (ExchangeViewModel *)exchangeViewModel;
- (ExchangeViewController *)exchangeViewController;

@end
