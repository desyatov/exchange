//
//  ExchangeListView.m
//  exchange
//
//  Created by Alexander Desyatov on 12/02/2017.
//  Copyright © 2017 Desyatov Alexander. All rights reserved.
//

#import "MoneyInputView.h"
#import "MoneyInputViewModel.h"

@interface MoneyInputView () <UITextFieldDelegate>
@property (nonatomic, assign, readwrite) BOOL selected;
@end

@implementation MoneyInputView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    
    self.sumTextField.text = @"";
    
    self.exchangeRateLabel.hidden = YES;
    
    RAC(self.exchangeRateLabel, hidden) = [[[RACObserve(self, viewModel.selected) ignore:nil] skip:1] distinctUntilChanged];
    
    RAC(self.exchangeRateLabel, text) = [RACObserve(self, viewModel.exchangeRateString) distinctUntilChanged];
    RAC(self.currencyLabel, text) = [RACObserve(self, viewModel.currencyString) distinctUntilChanged];
    RAC(self.moneyAvailableLabel, text) = [[RACObserve(self, viewModel.moneyAvailableString) distinctUntilChanged] map:^id _Nullable(NSString *value) {
        return [NSString stringWithFormat:@"You have %@", value];
    }];

    [[RACSignal combineLatest:@[[self.sumTextField.rac_textSignal distinctUntilChanged], RACObserve(self, viewModel)]] subscribeNext:^(RACTuple  * _Nullable x) {
        RACTupleUnpack(NSString *text, MoneyInputViewModel *viewModel) = x;
        viewModel.textValue = text;
    }];
    
    RAC(self.sumTextField, text) = [RACObserve(self, viewModel.textValue) distinctUntilChanged];
    
    self.sumTextField.delegate = self;

}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.viewModel.active = YES;
    self.viewModel.selected = YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.viewModel.selected = NO;
}

- (BOOL)canBecomeFirstResponder {
    if (self.viewModel.active) {
        return [self.sumTextField canBecomeFirstResponder];
    }
    return NO;
}

- (BOOL)becomeFirstResponder {
    return [self.sumTextField becomeFirstResponder];
}


@end
