//
//  ExchangeViewController.h
//  exchange
//
//  Created by Alexander Desyatov on 08/02/2017.
//  Copyright © 2017 Desyatov Alexander. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ExchangeViewModel;

@interface ExchangeViewController : UIViewController

@property (nonatomic, strong, readonly) ExchangeViewModel *viewModel;

@end
