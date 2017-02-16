//
//  CoreComponents.h
//  exchange
//
//  Created by Alexander Desyatov on 08/02/2017.
//  Copyright © 2017 Desyatov Alexander. All rights reserved.
//

#import <Typhoon/Typhoon.h>
#import "Client.h"

@interface CoreComponents : TyphoonAssembly

- (id <Client>)client;

@end
