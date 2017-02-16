//
//  iCarouseViewModelAdapter.m
//  exchange
//
//  Created by Alexander Desyatov on 12/02/2017.
//  Copyright © 2017 Desyatov Alexander. All rights reserved.
//

#import "CarouselViewModelAdapter.h"
#import <iCarousel/iCarousel.h>
#import <objc/runtime.h>
#import "ViewModeling.h"

@interface CarouselViewModelAdapter ()
@property (nonatomic, weak, readwrite) iCarousel *carusel;
@end

@implementation CarouselViewModelAdapter

- (instancetype)init
{
    return [self initWithViewModel:nil];
}

- (instancetype)initWithViewModel:(id <CaruselViewModeling> )viewModel {
    self = [super init];
    if (self) {
        _viewModel = viewModel;
        @weakify(self);
        [[RACObserve(self, viewModel.items) ignore:nil] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self.carusel reloadData];
        }];
    }
    return self;
}

- (void)setCarusel:(iCarousel *)carusel
{
    if (_carusel == carusel) return;
    [self _willDetachFromCarusel];
    _carusel = carusel;
    [self _didAttachToCarusel];
}

- (void)_willDetachFromCarusel
{
    [self willDetachFromCarusel];
    self.carusel.delegate = nil;
    self.carusel.dataSource = nil;
}

- (void)willDetachFromCarusel
{
    
}

- (void)_didAttachToCarusel
{
    self.carusel.delegate = self;
    self.carusel.dataSource = self;
    [self didAttachToCarusel];
}

- (void)didAttachToCarusel
{
    
}

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return  self.viewModel.items.count;
}
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(nullable UIView *)view {
    
    return [self carousel:carousel viewForViewModel:self.viewModel.items[index] reusingView:view];
}

- (UIView *)carousel:(iCarousel *)carousel viewForViewModel:(id)viewMdeol reusingView:(UIView *)view {
    return nil;
}

@end

static void *iCarouseViewModelAdaptorKey = &iCarouseViewModelAdaptorKey;

@implementation iCarousel (ViewModelAdaptor)
- (void)setViewModelAdaptor:(CarouselViewModelAdapter *)viewModelAdaptor
{
    self.viewModelAdaptor.carusel = nil;
    viewModelAdaptor.carusel = self;
    objc_setAssociatedObject(self, iCarouseViewModelAdaptorKey, viewModelAdaptor, OBJC_ASSOCIATION_RETAIN);
}

- (CarouselViewModelAdapter *)viewModelAdaptor
{
    return objc_getAssociatedObject(self, iCarouseViewModelAdaptorKey);
}
@end
