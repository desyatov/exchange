//
//  ExchangeListView.m
//  exchange
//
//  Created by Alexander Desyatov on 12/02/2017.
//  Copyright © 2017 Desyatov Alexander. All rights reserved.
//

#import "ExchangeListView.h"
#import "ExchangeListViewModel.h"
#import "MoneyInputViewModel.h"
#import "MoneyInputView.h"

@implementation ExchangeListView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.carusel.pagingEnabled = YES;
    self.carusel.type = iCarouselTypeLinear;
    self.carusel.delegate = self;
    self.carusel.dataSource = self;
    
    @weakify(self);
    [[RACObserve(self, viewModel.items) ignore:nil] subscribeNext:^(NSArray *x) {
        @strongify(self);
        [self.carusel reloadData];
        self.pageControl.numberOfPages = x.count;
    }];
    
}

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return self.viewModel.items.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(MoneyInputView *)view {
    MoneyInputViewModel *viewModel = self.viewModel.items[index];
    if (view) {
        view.viewModel = viewModel;
        return  view;
    } else {
        MoneyInputView *moneyInputView = [[[NSBundle mainBundle] loadNibNamed:@"MoneyInputView" owner:self options:nil] lastObject];
        moneyInputView.viewModel = viewModel;
        moneyInputView.frame = CGRectMake(0, 0, carousel.bounds.size.width, carousel.bounds.size.height);
        return moneyInputView;
    }
}
- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel {
    if ([carousel.currentItemView canBecomeFirstResponder]) {
        [carousel.currentItemView becomeFirstResponder];
    }
    self.pageControl.currentPage = carousel.currentItemIndex;
    self.viewModel.currentItemIndex = carousel.currentItemIndex;
}

@end
