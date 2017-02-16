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
#import "CoreComponents.h"

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
        [definition performAfterAllInjections:@selector(setupViewModel)];
    }];
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

@end
