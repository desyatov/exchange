//
//  ExchangeViewModel.m
//  exchange
//
//  Created by Alexander Desyatov on 08/02/2017.
//  Copyright © 2017 Desyatov Alexander. All rights reserved.
//

#import "ExchangeViewModel.h"
#import "ExchangeService.h"
#import "Rate.h"
#import "ExchangeListViewModel.h"
#import "MoneyInputViewModel.h"
#import "Exchange.h"
#import "Currency.h"
#import "Balance.h"
#import "Account.h"
#import "Money.h"
#import "MoneyController.h"

@interface ExchangeViewModel ()
@property (nonatomic, strong, readwrite) id <ExchangeService> service;
@property (nonatomic, strong, readwrite) MoneyController *moneyController;
@property (nonatomic, strong, readwrite) ExchangeListViewModel *topListViewModel;
@property (nonatomic, strong, readwrite) ExchangeListViewModel *bottomListViewModel;
@property (nonatomic, strong, readonly) RACCommand *validationCommand;
@end

@implementation ExchangeViewModel

- (void)setupViewModel {
    
    @weakify(self);
    _loadDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id input) {
        @strongify(self);
        return [[[self.service fetchRateSet] collect] map:^id(NSArray *rates) {
            return [[Exchange alloc] initWithRates:rates];
        }];
    }];
    
    RAC(self.moneyController, exchange) = [self.loadDataCommand.executionSignals switchToLatest];
    
    [[[[RACSignal combineLatest:@[
                                self.topListViewModel.currentViewModelDidChange,
                                self.bottomListViewModel.currentViewModelDidChange,
                                [RACObserve(self.moneyController, exchange) ignore:nil]
                                ]
                       reduce:^id(MoneyInputViewModel *topMoneyInput, MoneyInputViewModel *bottomMoneyInput, Exchange *exchange) {
                           topMoneyInput.targetCurrency = bottomMoneyInput.sourceCurrency;
                           bottomMoneyInput.targetCurrency = topMoneyInput.sourceCurrency;
                           
                           if (topMoneyInput.active) {
                               return RACTuplePack(bottomMoneyInput, topMoneyInput.value, topMoneyInput.sourceCurrency, exchange);
                           }
                           if (bottomMoneyInput.active) {
                               return RACTuplePack(topMoneyInput, bottomMoneyInput.value, bottomMoneyInput.sourceCurrency, exchange);
                           }
                           return nil;
                       }] ignore:nil] reduceEach:^id(MoneyInputViewModel *viewModel, NSDecimalNumber *value, Currency *toCurrency, Exchange *exchange){
                           viewModel.value = [exchange convertAmount:value fromCurrency:viewModel.sourceCurrency toCurrency:toCurrency];
                           return viewModel;
                       }] subscribe:[RACSubject subject]];
    
    
    RAC(self.topListViewModel, active) = [[[RACObserve(self.bottomListViewModel, active) distinctUntilChanged] skipUntilBlock:^BOOL(NSNumber * _Nullable x) {
        return x.boolValue;
    }] not];
    RAC(self.bottomListViewModel, active) = [[[RACObserve(self.topListViewModel, active) distinctUntilChanged] skipUntilBlock:^BOOL(NSNumber * _Nullable x) {
        return x.boolValue;
    }] not];
    
    RAC(self, topListViewModel.currentViewModel.selected) = [[[[RACObserve(self.bottomListViewModel, currentViewModel.selected) ignore:nil] not] distinctUntilChanged] skip:1];
    RAC(self, bottomListViewModel.currentViewModel.selected) = [[[[RACObserve(self.topListViewModel, currentViewModel.selected) ignore:nil] not] distinctUntilChanged] skip:1];
    
    _validationCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        return [[[self.topListViewModel.currentViewModelSignal take:1] map:^id(MoneyInputViewModel *viewModel) {
            return viewModel.validateSignal;
        }] switchToLatest];
    }];
    
    _exchangeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        return [[[self.validationCommand execute:nil] take:1] flattenMap:^__kindof RACSignal * _Nullable(id value) {
            return [[RACSignal combineLatest:@[
                                        [self.topListViewModel.currentViewModelSignal take:1],
                                        [self.bottomListViewModel.currentViewModelSignal take:1],
                                        [[RACObserve(self.moneyController, balance) ignore:nil] take:1]
                                        ] reduce:^id (MoneyInputViewModel *topMoneyInput, MoneyInputViewModel *bottomMoneyInput, Balance *balance){
                                            [balance plus:[Money moneyWithCurrency:bottomMoneyInput.sourceCurrency amount:bottomMoneyInput.value]];
                                            [balance minus:[Money moneyWithCurrency:topMoneyInput.sourceCurrency amount:topMoneyInput.value]];
                                            return nil;
                                        }] ignoreValues];
        }];
        
        
    }];
    
    
    self.topListViewModel.items = @[
                                    [self moneyInputViewModelWithCurrency:[Currency USD] isSource:YES],
                                    [self moneyInputViewModelWithCurrency:[Currency GBP] isSource:YES],
                                    [self moneyInputViewModelWithCurrency:[Currency EUR] isSource:YES],
                                    ];
    self.bottomListViewModel.items = @[
                                       [self moneyInputViewModelWithCurrency:[Currency EUR]],
                                       [self moneyInputViewModelWithCurrency:[Currency GBP]],
                                       [self moneyInputViewModelWithCurrency:[Currency USD]],
                                       ];
    
    [[RACSignal interval:30 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSDate * _Nullable x) {
        @strongify(self);
        [self.loadDataCommand execute:nil];
    }];

}

- (MoneyInputViewModel *)moneyInputViewModelWithCurrency:(Currency *)currency {
    return [self moneyInputViewModelWithCurrency:currency isSource:NO];
}
- (MoneyInputViewModel *)moneyInputViewModelWithCurrency:(Currency *)currency isSource:(BOOL)isSource {
    MoneyInputViewModel *viewModel = [[MoneyInputViewModel alloc] initWithCurrency:currency moneyController:self.moneyController];
    viewModel.source = isSource;
    return viewModel;
}

@end
