//
//  PAAPIEnvListViewController.m
//  manpanxiang
//
//  Created by Linkou Bian on 27/08/2017.
//  Copyright © 2017 Mapping Shine (Shanghai) Network Technology Co.,Ltd. All rights reserved.
//

#import "PAAPIEnvListViewController.h"
#import "PAURLMap.h"
#import "PANavigator.h"
#import "PAURLCommon.h"

@PAURLMap(apiEnvListController, PAAPIEnvListViewController)
@interface PAAPIEnvListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView   *tableView;         //
@property (nonatomic, copy) NSArray         *sectionTitles;     //
@property (nonatomic, copy) NSArray         *apiEnvs;           // array of env dictionary, see hosts.plist

@end

static NSString *kAPIEnvCellIdentifier       = @"kAPIEnvCellIdentifier";

@implementation PAAPIEnvListViewController

- (void)loadView {
    [super loadView];

    self.tableView                          = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.dataSource               = self;
    self.tableView.delegate                 = self;

    self.view = self.tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title                              = @"环境切换";

    // 注册 Cell 类型
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kAPIEnvCellIdentifier];

    // 隐藏多余的分隔线
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sectionTitles count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: return 1;
        case 1: return [self.apiEnvs count];
        default: return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.sectionTitles[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *apiEnvCell = [tableView dequeueReusableCellWithIdentifier:kAPIEnvCellIdentifier forIndexPath:indexPath];

    NSDictionary *apiEnv = [self apiEnvForIndexPath:indexPath];
    apiEnvCell.textLabel.text = apiEnv[@"name"];

    if (indexPath.section == 1 && [self isCurrentAPIEnv:indexPath.row]) {
        apiEnvCell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        apiEnvCell.accessoryType = UITableViewCellAccessoryNone;
    }

    return apiEnvCell;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    // 在 api env 列表中选中非当前环境
    if (indexPath.section == 1 && ![self isCurrentAPIEnv:indexPath.row]) {

        // 关闭页面，同时更新 api env
        openURL([PAURLMap urlForServiceWithIdentifier:APPURL_SERVICE_IDENTIFIER_VIEWEXIT params:nil]);

        [PAURLCommon sharedInstance].apiConfigure = indexPath.row;
        [[NSNotificationCenter defaultCenter] postNotificationName:PANotificationAPIEnvChanged object:nil];

    }
}

#pragma mark - Private Methods

- (NSDictionary *)apiEnvForIndexPath:(NSIndexPath *)indexPath {
    NSUInteger apiEnvIndex = indexPath.section == 0 ? [PAURLCommon sharedInstance].apiConfigure : indexPath.row;
    NSDictionary *apiEnv = [self.apiEnvs objectAtIndex:apiEnvIndex];

    return apiEnv;
}

- (BOOL)isCurrentAPIEnv:(NSInteger)index {
    return [PAURLCommon sharedInstance].apiConfigure == index;
}

#pragma mark - Properties

- (NSArray *)sectionTitles {
    if (!_sectionTitles) {
        _sectionTitles = @[@"当前环境", @"全部环境"];
    }

    return _sectionTitles;
}

- (NSArray *)apiEnvs {
    if (!_apiEnvs) {
        PAURLCommon *urlCommon = [PAURLCommon sharedInstance];
        _apiEnvs = urlCommon.hostsManager.listData;
    }

    return _apiEnvs;
}

#pragma mark - Override Methods

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    // Leave this method empty to disable shaking gesture for debug tool.
}

@end
