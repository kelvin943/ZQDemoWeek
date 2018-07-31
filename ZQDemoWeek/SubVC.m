//
//  SubVC.m
//  ZQDemoWeek
//
//  Created by 张泉(平安好房技术中心智慧城市房产云研发团队前端研发组) on 2018/7/3.
//  Copyright © 2018年 张泉(平安好房技术中心智慧城市房产云研发团队前端研发组). All rights reserved.
//

#import "SubVC.h"

@interface SubVC ()

@end

@implementation SubVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    NSLog(@"develop 修复 BUG");

    NSLog(@"develop 2 开发需求");

}

-(void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    NSLog (@" Disappear: %@",self.title);
    NSLog(@"develop bug修改");
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog (@"Appear:%@",self.title);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
