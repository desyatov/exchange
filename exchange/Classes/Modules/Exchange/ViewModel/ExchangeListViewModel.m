//
//  ExchangeListViewModel.m
//  exchange
//
//  Created by Alexander Desyatov on 11/02/2017.
//  Copyright © 2017 Desyatov Alexander. All rights reserved.
//

#import "ExchangeListViewModel.h"
#import "MoneyInputViewModel.h"

@implementation ExchangeListViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _active = NO;
        
        [[RACSignal combineLatest:@[[RACObserve(self, active) distinctUntilChanged], [RACObserve(self, items) ignore:nil]]] subscribeNext:^(RACTuple  * _Nullable x) {
            RACTupleUnpack(NSNumber *active, NSArray<MoneyInputViewModel *> *viewModels) = x;
            for (MoneyInputViewModel *viewModel in viewModels) {
                viewModel.active = active.boolValue;
            }
        }];
        
        RAC(self, active) = [[[[RACObserve(self, items) ignore:nil] map:^id _Nullable(NSArray <MoneyInputViewModel *>  *_Nullable items) {
            return [items map:^id(MoneyInputViewModel *obj, NSUInteger idx) {
                return obj.activeSignal;
            }];
        }] flattenMap:^__kindof RACSignal * _Nullable(NSArray * _Nullable signals) {
            return [[RACSignal combineLatest:signals] or];
        }] distinctUntilChanged];
        
        RAC(self, currentViewModel) = [RACSignal combineLatest:@[
                                                                   [RACObserve(self, items) ignore:nil],
                                                                   [RACObserve(self, currentItemIndex) distinctUntilChanged]
                                                                ]
                reduce:^id(NSArray * _Nullable items, NSNumber *index){
                    return items[index.integerValue];
                }];
        
        _currentViewModelSignal = [RACObserve(self, currentViewModel) ignore:nil];
        _currentViewModelDidChange = [[self.currentViewModelSignal map:^id (MoneyInputViewModel *x) {
            @weakify(x);
            return [[RACSignal merge:@[x.selectedSignal, x.valueSignal]] map:^id _Nullable(id  _Nullable value) {
                @strongify(x);
                return x;
            }];
        }] switchToLatest];
    }
    return self;
}

@end
