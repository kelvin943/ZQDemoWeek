//
//  PAViewController.m
//  haofang
//
//  Created by PengFeiMeng on 3/17/14.
//  Copyright (c) 2014 平安好房. All rights reserved.
//

#import "PAViewController.h"
#import "UIColor+Category.h"
#import "UIBarButtonItem+Category.h"
#import "PAMediator+AppConfig.h"

@interface PAViewController ()

@property(nonatomic,retain) UITapGestureRecognizer *tap;

@end

@implementation PAViewController

#pragma mark - init

- (instancetype)initWithQuery:(NSDictionary *)query {
    if (self = [super init]) {
        
    }
    return self;
}

#pragma mark - view life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 在键盘弹出之后，点击页面让键盘消失
    self.needsTapToDismissKeyborad = @YES;
    
    // 设置默认返回按钮
    if ([self shouldSetBackBarButton]) {
        [self setBackBarButton];
    } else {
        [self hideBackBarButton];
    }
    
    self.view.backgroundColor = [UIColor colorWithHex:0xf4f4f4];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self becomeFirstResponder];
}

#pragma mark - Keyboard Notification

- (void)registerKeyboardNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification{
    if ([self.needsTapToDismissKeyborad boolValue]) {
        [self.view addGestureRecognizer:self.tap];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification{
    if (_tap) {
        [self.view removeGestureRecognizer:self.tap];
    }
}

- (void)unregisterNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Properties

- (UITapGestureRecognizer *)tap{
    if (_tap == nil) {
        self.tap                    = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfViewTapped:)];
        _tap.cancelsTouchesInView   = YES;
    }
    
    return _tap;
}


#pragma mark - Events

- (void)selfViewTapped:(UITapGestureRecognizer *)tap{
    if (tap.view == self.view) {
        [self dismissKeyboard];
    }
}

- (void)dismissKeyboard{
    [self.view endEditing:YES];
}

#pragma mark - Back Action

// 返回上级视图
- (void)backTo {
    if ([self.navigationController respondsToSelector:@selector(popViewControllerAnimated:)]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if([self.tabBarController.navigationController respondsToSelector:@selector(popViewControllerAnimated:)]){
        [self.tabBarController.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

// 通用返回按钮
- (void)setBackBarButton {
    NSString *backIconCode = [[PAMediator sharedInstance] PAICONFONT_BACK];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barItemWithIconTitle:backIconCode target:self action:@selector(backTo)];
}

// 清空返回按钮
- (void)hideBackBarButton {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIView new]];
}

#pragma mark - PAViewControllerProtocol Methods

- (BOOL)shouldSetBackBarButton {
    return YES;
}

@end
