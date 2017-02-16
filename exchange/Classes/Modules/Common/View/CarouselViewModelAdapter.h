//
//  iCarouseViewModelAdapter.h
//  exchange
//
//  Created by Alexander Desyatov on 12/02/2017.
//  Copyright © 2017 Desyatov Alexander. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iCarousel/iCarousel.h>

@protocol CaruselViewModeling;

@interface CarouselViewModelAdapter : NSObject <iCarouselDelegate, iCarouselDataSource>

@property (nonatomic, weak, readonly) iCarousel * _Nullable carusel;
@property (nonatomic, strong, readonly) _Nullable id <CaruselViewModeling> viewModel;

- (instancetype _Nonnull)initWithViewModel:(_Nullable id <CaruselViewModeling> )viewModel;

- (void)willDetachFromCarusel;
- (void)didAttachToCarusel;

- (UIView * _Nonnull )carousel:(iCarousel * _Nonnull)carousel viewForViewModel:(id _Nonnull)viewMdeol reusingView:(nullable UIView *)view;

@end

@interface iCarousel (ViewModelAdaptor)

- (void)setViewModelAdaptor:(CarouselViewModelAdapter * _Nonnull)viewModelAdaptor;
- (CarouselViewModelAdapter * _Nullable)viewModelAdaptor;

@end


