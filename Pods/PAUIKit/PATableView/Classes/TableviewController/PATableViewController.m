//
//  PATableViewController.m
//  haofang
//
//  Created by PengFeiMeng on 3/28/14.
//  Copyright (c) 2014 平安好房. All rights reserved.
//

#import "PATableViewController.h"
#import "UIColor+Category.h"

@interface PATableViewController ()

@end

@implementation PATableViewController

#pragma mark - view life circle

- (void)viewDidLoad {
    [super viewDidLoad];

    // 添加tableview
    [self.view addSubview:self.tableView];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];

    // 调整tableview
    self.tableView.frame = self.view.bounds;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - PAListTableViewAdaptorDelegate

- (void)tableView:(UITableView *)tableView didSelectObject:(id<PATableViewCellItemBasicProtocol>)object rowAtIndexPath:(NSIndexPath *)indexPath{

}

#pragma mark - Property Methods

- (UITableView *)tableView {
    if (!_tableView) {
        // 初始化tableview
        _tableView                      = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor      = [UIColor colorWithHex:0xf4f4f4];
        _tableView.backgroundView       = nil;
        _tableView.separatorStyle       = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource           = self.tableViewAdaptor;
        _tableView.delegate             = self.tableViewAdaptor;
        
        if (@available(iOS 11.0, *)) {
            // iOS 11 弃用了 automaticallyAdjustsScrollViewInsets 属性，Never 表示不计算内边距
            _tableView.contentInsetAdjustmentBehavior   = UIScrollViewContentInsetAdjustmentNever;
            
            // iOS 11 开启 Self-Sizing 之后，tableView 使用 estimateRowHeight 一点点地变化更新的 contentSize 的值。
            // 这样导致 setContentOffset 为 0 不能回到顶部，故禁用 Self-Sizing
            _tableView.estimatedRowHeight               = 0;
            _tableView.estimatedSectionHeaderHeight     = 0;
            _tableView.estimatedSectionFooterHeight     = 0;
        }

        _tableViewAdaptor.tableView     = _tableView;
    }

    return _tableView;

}

- (PAListTableViewAdaptor *)tableViewAdaptor {
    if (!_tableViewAdaptor) {
        _tableViewAdaptor               = [[PAListTableViewAdaptor alloc] init];
        _tableViewAdaptor.delegate      = self;
    }

    return _tableViewAdaptor;
}

@end
