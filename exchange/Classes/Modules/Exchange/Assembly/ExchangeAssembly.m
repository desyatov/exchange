//
//  ExchangeAssembly.m
//  exchange
//
//  Created by Alexander Desyatov on 08/02/2017.
//  Copyright © 2017 Desyatov Alexander. All rights reserved.
//

#import "ExchangeAssembly.h"
#import "ExchangeServiceBase.h"
#import "ExchangeViewModel.h"
#import "ExchangeViewController.h"
#import "ExchangeListViewModel.h"
#import "MoneyInputViewModel.h"
#import "MoneyController.h"
#import "CoreComponents.h"
#import "Account.h"
#import "Balance.h"
#import "Currency.h"
#import "Money.h"

@interface ExchangeAssembly ()
@property (nonatomic, strong, readwrite) CoreComponents *coreComponent;
@end

@implementation ExchangeAssembly


- (id <ExchangeService>)exchangeService {
    return [TyphoonDefinition withClass:[ExchangeServiceBase class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(baseURL) with:TyphoonConfig(@"exchange.service.url")];
        [definition injectProperty:@selector(client) with:self.coreComponent.client];
        definition.scope = TyphoonScopeLazySingleton;
    }];
}

- (ExchangeViewModel *)exchangeViewModel {
    return [TyphoonDefinition withClass:[ExchangeViewModel class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(service) with:[self exchangeService]];
        [definition injectProperty:@selector(moneyController) with:[self moneyController]];
        [definition injectProperty:@selector(topListViewModel) with:[self topExchangeListViewModel]];
        [definition injectProperty:@selector(bottomListViewModel) with:[self bottomExchangeListViewModel]];
        [definition performAfterAllInjections:@selector(setupViewModel)];
    }];
}

- (MoneyController *)moneyController {
    return [TyphoonDefinition withClass:[MoneyController class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(balance) with:[self balance]];
        definition.scope = TyphoonScopeSingleton;
    }];
}


- (ExchangeListViewModel *)topExchangeListViewModel {
    return [TyphoonDefinition withClass:[ExchangeListViewModel class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(identifier) with:@"topExchangeListViewModel"];
    }];
}

- (ExchangeListViewModel *)bottomExchangeListViewModel {
    return [TyphoonDefinition withClass:[ExchangeListViewModel class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(identifier) with:@"bottomExchangeListViewModel"];
    }];
}


- (Balance *)balance {
    Account *accountUSD = [[Account alloc] initWithMoney:[Money moneyWithCurrency:[Currency USD] amount:[NSDecimalNumber decimalNumberWithString:@"100"]]];
    Account *accountGBP = [[Account alloc] initWithMoney:[Money moneyWithCurrency:[Currency GBP] amount:[NSDecimalNumber decimalNumberWithString:@"100"]]];
    Account *accountEUR = [[Account alloc] initWithMoney:[Money moneyWithCurrency:[Currency EUR] amount:[NSDecimalNumber decimalNumberWithString:@"100"]]];
    return [[Balance alloc] initWithAccounts:@[accountUSD, accountGBP, accountEUR]];
}

- (ExchangeViewController *)exchangeViewController {
    return [TyphoonDefinition withClass:[ExchangeViewController class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(viewModel) with:[self exchangeViewModel]];
    }];
}

- (id)config
{
    return [TyphoonDefinition withConfigName:@"Configuration.plist"];
}

- (MoneyInputViewModel *)moneyInputViewModelWithCurrency:(Currency *)currency {
    return [TyphoonDefinition withClass:[MoneyInputViewModel class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithCurrency:moneyController:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:currency];
            [initializer injectParameterWith:[self moneyController]];
        }];
    }];
}

@end
