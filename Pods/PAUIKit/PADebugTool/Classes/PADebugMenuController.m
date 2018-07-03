//
//  PADebugMenuController.m
//  manpanxiang
//
//  Created by 刘玉龙 on 2017/8/22.
//  Copyright © 2017年 Mapping Shine (Shanghai) Network Technology Co.,Ltd. All rights reserved.
//

#import "PADebugMenuController.h"

@implementation PADebugAction

+ (instancetype)actionWithTitle:(NSString *)title selector:(SEL)selector {
    PADebugAction *action = [[self class] new];
    action.title = title;
    action.selector = selector;

    return action;
}

@end

@interface PADebugMenuController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView                           *tableView;

@end

static NSString *kDebugActionCellIdentifier = @"DebugActionCellIdentifier";

@implementation PADebugMenuController

- (void)loadView {
    [super loadView];

    self.tableView                          = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.dataSource               = self;
    self.tableView.delegate                 = self;

    self.view = self.tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"调试工具";

    self.actions = @[];

    // 注册 Cell 类型
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kDebugActionCellIdentifier];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.actions count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.actions[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PADebugAction *action = self.actions[indexPath.section][indexPath.row];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDebugActionCellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = action.title;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    PADebugAction *action = self.actions[indexPath.section][indexPath.row];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:action.selector withObject:nil];
#pragma clang diagnostic pop
}

#pragma mark - Override Methods

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    // Leave this method empty to disable shaking gesture for debug tool.
}

@end
