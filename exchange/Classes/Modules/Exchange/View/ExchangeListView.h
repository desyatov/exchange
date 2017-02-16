//
//  ExchangeListView.h
//  exchange
//
//  Created by Alexander Desyatov on 12/02/2017.
//  Copyright © 2017 Desyatov Alexander. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iCarousel/iCarousel.h>

@class ExchangeListViewModel;

@interface ExchangeListView : UIView <iCarouselDelegate, iCarouselDataSource>

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet iCarousel *carusel;

@property (nonatomic, strong, readwrite) ExchangeListViewModel *viewModel;


@end
