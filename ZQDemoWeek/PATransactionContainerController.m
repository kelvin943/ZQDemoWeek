//
//  PATransactionContainerController.m
//  Agent
//
//  Created by Linkou Bian on 2018/5/16.
//  Copyright © 2018 Ping'anfang (Shanghai) E-commerce Co., Ltd. All rights reserved.
//

#import "PATransactionContainerController.h"
#import "SubVC.h"
//#import "PATransactionViewController.h"
//#import "PAXFTransactionController.h"
//#import "PASearchDomainEnum.h"

@interface PATransactionContainerController () <PAPageControllerDataSource, PAPageControllerDelegate>

@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) SubVC *transactionController;   // 二手房&租房 交易列表
@property (nonatomic, strong) SubVC *xfTransactionController;   // 新房 交易列表

@property (nonatomic, strong) SubVC *threeVC;   // 新房 交易列表

@end

@implementation PATransactionContainerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    if ([self shouldShowSegmentControl]) {
        self.navigationItem.titleView = self.segmentedControl;
//    }
    
//    self.title = [PAAccessCtrManager canAccessTransactionData] ? @"租售交易" : @"新房交易";
    
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barItemWithTitle:@"right" font:[UIFont iconFontWithSize:30] target:self action:@selector(onSearchBarButtonItemTapped:)];

    self.dataSource = self;
    self.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}

#pragma mark - Private Methods

//- (BOOL)shouldShowSegmentControl {
//    if ([PAAccessCtrManager canAccessTransactionData] && [PAAccessCtrManager canAccessXFTransactionData]) {
//        return YES;
//    }
//
//    return NO;
//}

#pragma mark - PAPageControllerDataSource

- (NSInteger)numberOfPagesInPageController:(PAPageController *)pageController {
//    if ([self shouldShowSegmentControl]) {
        return 3;
//    }
    
//    return 1;
}

- (UIViewController *)pageController:(PAPageController *)pageController pageAtIndex:(NSInteger)index {
    if (index == 0) {
        return self.transactionController;
    } else if(index ==1) {
        return self.xfTransactionController;
    }else{
        return self.threeVC;
    }
}

#pragma mark - PAPageControllerDelegate

- (void)pageController:(PAPageController *)pageController willStartTransition:(id<PAPageControllerTransitionCoordinatorContext>)context {
    // Add your own animations using pageCoordinator
    [pageController.pageTransitionCoordinator animateAlongsidePagingInView:self.segmentedControl animation:^(id<PAPageControllerTransitionCoordinatorContext> context) {
        // Update your segmented control according to the context object
        self.segmentedControl.userInteractionEnabled = NO;
        self.segmentedControl.selectedSegmentIndex = [context toIndex];
    } completion:^(id<PAPageControllerTransitionCoordinatorContext> context) {
        if ([context isCancelled]) {
            // If transition canceled, restore to the previous state
            [self.segmentedControl setSelectedSegmentIndex:[context fromIndex]];
        }
        self.segmentedControl.userInteractionEnabled = YES;
    }];
    
}

#pragma mark - Action Handlers

- (void)onSegmentedControlValueChanged:(UISegmentedControl *)segmentControl {
    [self setCurrentIndex:self.segmentedControl.selectedSegmentIndex animated:NO];
}

- (void)onSearchBarButtonItemTapped:(id)sender {
//    NSMutableDictionary *params = [NSMutableDictionary new];
//
//    UIViewController *currentVC = [self pageController:self pageAtIndex:self.currentIndex];
//    if (currentVC == self.transactionController) {
//        params[@"_currentSearchDomain"] = @(SearchDomainTransaction);
//    } else {
//        params[@"_currentSearchDomain"] = @(SearchDomainXFTransaction);
//    }
//
//    params[APPURL_PARAM_ANIMATED] = @NO;
//
//    [[PANavigator sharedInstance] gotoViewWithIdentifier:APPURL_VIEW_IDENTIFIER_HOMESEARCH queryForInit:params propertyDictionary:nil];
}

#pragma mark - Properties

- (UISegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"租售", @"新房",@"二手房"]];
//        _segmentedControl.frame.size.width = 170
        [_segmentedControl setTintColor:[UIColor grayColor]];
        [_segmentedControl addTarget:self action:@selector(onSegmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
        _segmentedControl.selectedSegmentIndex = 0;
    }
    
    return _segmentedControl;
}

- (SubVC *)transactionController {
    if (!_transactionController) {
        _transactionController = [[SubVC alloc] init];
        _transactionController.view.backgroundColor = [UIColor redColor];
        _transactionController.title = @"123";
//        [self configStatsForViewController:_transactionController withPageID:@"20206"];
    }
    
    return _transactionController;
}

- (SubVC *)xfTransactionController {
    if (!_xfTransactionController) {
        _xfTransactionController = [[SubVC alloc] init];
        _xfTransactionController.view.backgroundColor = [UIColor greenColor];
        _xfTransactionController.title = @"456";
//        [self configStatsForViewController:_xfTransactionController withPageID:@"20209"];
    }
    
    return _xfTransactionController;
}
- (SubVC *)threeVC{
    if (!_threeVC) {
        _threeVC = [[SubVC alloc] init];
        _threeVC.view.backgroundColor = [UIColor yellowColor];
        _threeVC.title = @"789";
    }
    return _threeVC;
}

//#pragma mark - PAStats Related Methods
//
//// controller 不是直接包含在导航栏，需要手动配置参数
//- (void)configStatsForViewController:(UIViewController *)controller withPageID:(NSString *)pageID {
//    controller.pastats_pageID = pageID;
//    controller.pastats_refPageID = self.pastats_refPageID;
//    controller.pastats_didDisappearInjectBlock = ^(UIViewController *viewController, BOOL animated) {
//       [PAStatsAPI trackPageEventWithBeginTime:viewController.pastats_beginTime
//                                         inPage:viewController.pastats_pageID
//                                       fromPage:viewController.pastats_refPageID];
//    };
//}
//
//// 从 container 页面 push 到其他页面时，ref page id 应该是 container 当前展示的页面
//- (NSString *)pastats_pageID {
//    if ([PAAccessCtrManager canAccessTransactionData] && self.currentIndex == 0) {
//        return self.transactionController.pastats_pageID;
//    } else {
//        return self.xfTransactionController.pastats_pageID;
//    }
//}
//
//// container vc 不是产品关心的页面
//- (BOOL)pastats_didDisappearInjectBlockIgnored{
//    return YES;
//}

@end
