//
//  MainVC.m
//  ZQDemoWeek
//
//  Created by 张泉(平安好房技术中心智慧城市房产云研发团队前端研发组) on 2018/7/3.
//  Copyright © 2018年 张泉(平安好房技术中心智慧城市房产云研发团队前端研发组). All rights reserved.
//

#import "MainVC.h"
#import "PATransactionContainerController.h"

@interface MainVC ()

@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"测试修改")
    
    
    // Do any additional setup after loading the view.
}

-(IBAction)nextBtnClick:(UIButton *)sender{
    
    PATransactionContainerController * nextVC =  [[PATransactionContainerController alloc] init];
    [self.navigationController pushViewController:nextVC animated:YES];
    
     NSLog(@"测试修改")
 }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
