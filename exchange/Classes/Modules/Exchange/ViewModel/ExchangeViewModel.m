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
@property (nonatomic, strong, readonly) MoneyController *moneyController;
@end

@implementation ExchangeViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _topListViewModel = [[ExchangeListViewModel alloc] init];
        _bottomListViewModel = [[ExchangeListViewModel alloc] init];
        _moneyController = [[MoneyController alloc] init];
        _moneyController.balance = [self createBalance];
    }
    return self;
}


- (void)setupViewModel {
    
    @weakify(self);
    _loadRates = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id input) {
        @strongify(self);
        return [[[self.service fetchRateSet] collect] map:^id(NSArray *rates) {
            return [[Exchange alloc] initWithRates:rates];
        }];
    }];
    
    RAC(self.moneyController, exchange) = [self.loadRates.executionSignals switchToLatest];
    
//    [[RACSignal combineLatest:@[
//                              self.topListViewModel.currentViewModelSignal,
//                              self.bottomListViewModel.currentViewModelSignal,
//                              [RACObserve(self.moneyController, exchange) ignore:nil]
//                              ]
//                      reduce:^(MoneyInputViewModel *topMoneyInput, MoneyInputViewModel *bottomMoneyInput, Exchange *exchange) {
//                          topMoneyInput.targetCurrency = bottomMoneyInput.sourceCurrency;
//                          bottomMoneyInput.targetCurrency = topMoneyInput.sourceCurrency;
//                          return topMoneyInput;
//                      }] subscribe:[RACSubject subject]];

    [[[[RACSignal combineLatest:@[
                                self.topListViewModel.currentViewModelDidChange,
                                self.bottomListViewModel.currentViewModelDidChange,
                                [RACObserve(self.moneyController, exchange) ignore:nil]
                                ]
                       reduce:^id(MoneyInputViewModel *topMoneyInput, MoneyInputViewModel *bottomMoneyInput, Exchange *exchange) {
//                           RACTupleUnpack(MoneyInputViewModel *topMoneyInput, NSDecimalNumber *topValue) = sourceTuple;
//                           RACTupleUnpack(MoneyInputViewModel *bottomMoneyInput, NSDecimalNumber *bottomValue) = targetTuple;
                           if (bottomMoneyInput.selected) {
                               topMoneyInput.selected = NO;
                           } else if (topMoneyInput.selected) {
                               bottomMoneyInput.selected = NO;
                           }
                           
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
    
    [[RACObserve(self.moneyController, exchange) ignore:nil] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.topListViewModel.items = @[
                                       [self moneyInputViewModelWithCurrency:[Currency USD]],
                                       [self moneyInputViewModelWithCurrency:[Currency GBP]],
                                       [self moneyInputViewModelWithCurrency:[Currency EUR]],
                                       ];
        self.bottomListViewModel.items = @[
                                       [self moneyInputViewModelWithCurrency:[Currency USD]],
                                       [self moneyInputViewModelWithCurrency:[Currency GBP]],
                                       [self moneyInputViewModelWithCurrency:[Currency EUR]],
                                       ];
    }];
    
    RAC(self, topListViewModel.active) = [[[RACObserve(self.bottomListViewModel, active) not] distinctUntilChanged] skip:1];
    RAC(self, bottomListViewModel.active) = [[[RACObserve(self.topListViewModel, active) not] distinctUntilChanged] skip:1];
    
    [self.loadRates execute:nil];
}

- (MoneyInputViewModel *)moneyInputViewModelWithCurrency:(Currency *)currency {
    return [[MoneyInputViewModel alloc] initWithCurrency:currency moneyController:self.moneyController];
}


- (Balance *)createBalance {
    Account *accountUSD = [[Account alloc] initWithMoney:[Money moneyWithCurrency:[Currency USD] amount:[NSDecimalNumber decimalNumberWithString:@"100"]]];
    Account *accountGBP = [[Account alloc] initWithMoney:[Money moneyWithCurrency:[Currency GBP] amount:[NSDecimalNumber decimalNumberWithString:@"100"]]];
    Account *accountEUR = [[Account alloc] initWithMoney:[Money moneyWithCurrency:[Currency EUR] amount:[NSDecimalNumber decimalNumberWithString:@"100"]]];
    return [[Balance alloc] initWithAccounts:@[accountUSD, accountGBP, accountEUR]];
}

@end
