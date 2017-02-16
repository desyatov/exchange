//
//  ViewModeling.h
//  exchange
//
//  Created by Alexander Desyatov on 09/02/2017.
//  Copyright © 2017 Desyatov Alexander. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ViewModeling <NSObject>

- (void)setupViewModel;

@end

@protocol CaruselViewModeling <NSObject>

@property (nonatomic, strong, readonly) NSArray *items;

@end
