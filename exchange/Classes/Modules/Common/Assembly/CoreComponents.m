//
//  CoreComponents.m
//  exchange
//
//  Created by Alexander Desyatov on 08/02/2017.
//  Copyright © 2017 Desyatov Alexander. All rights reserved.
//

#import "CoreComponents.h"
#import "ClientBase.h"

@implementation CoreComponents


- (id <Client>)client
{
    return [TyphoonDefinition withClass:[ClientBase class] configuration:^(TyphoonDefinition *definition) {
        definition.scope = TyphoonScopeLazySingleton;
    }];
}



@end
