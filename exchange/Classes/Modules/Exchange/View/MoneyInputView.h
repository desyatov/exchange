//
//  ExchangeListView.h
//  exchange
//
//  Created by Alexander Desyatov on 12/02/2017.
//  Copyright © 2017 Desyatov Alexander. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MoneyInputViewModel;

@interface MoneyInputView : UIView

@property (weak, nonatomic) IBOutlet UILabel *currencyLabel;
@property (weak, nonatomic) IBOutlet UITextField *sumTextField;
@property (weak, nonatomic) IBOutlet UILabel *moneyAvailableLabel;
@property (weak, nonatomic) IBOutlet UILabel *exchangeRateLabel;

@property (nonatomic, strong, readwrite) MoneyInputViewModel *viewModel;


@end
