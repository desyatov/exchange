//
//  ExchangeViewController.m
//  exchange
//
//  Created by Alexander Desyatov on 08/02/2017.
//  Copyright © 2017 Desyatov Alexander. All rights reserved.
//

#import "ExchangeViewController.h"
#import "ExchangeViewModel.h"
#import <iCarousel/iCarousel.h>
#import "ExchangeListViewModel.h"
#import "ExchangeListView.h"

@interface ExchangeViewController ()
@property (nonatomic, strong, readwrite) ExchangeViewModel *viewModel;
@property (weak, nonatomic) IBOutlet ExchangeListView *sourceExchangeListView;
@property (weak, nonatomic) IBOutlet ExchangeListView *targetExchangeListView;



@end

@implementation ExchangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem.rac_command = self.viewModel.exchangeCommand;
    [self setupNavigationBar];
    self.sourceExchangeListView.viewModel = self.viewModel.topListViewModel;
    self.targetExchangeListView.viewModel = self.viewModel.bottomListViewModel;
    @weakify(self);
    [[RACSignal merge:@[self.viewModel.loadDataCommand.errors, self.viewModel.exchangeCommand.errors]] subscribeNext:^(NSError * _Nullable x) {
        @strongify(self);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:x.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:NULL]];
        [self presentViewController:alert animated:YES completion:NULL];
    }];
    
    [self.viewModel.loadDataCommand execute:nil];
}



- (void)setupNavigationBar {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
}

@end
