//
//  PATableViewController.h
//  haofang
//
//  Created by PengFeiMeng on 3/28/14.
//  Copyright (c) 2014 平安好房. All rights reserved.
//

#import "PAViewController.h"
#import "PAListTableViewAdaptor.h"

/*!
 @class
 @abstract  自定义tableviewcontroller
 */
@interface PATableViewController : PAViewController <PAListTableViewAdaptorDelegate, UITableViewDelegate, UITableViewDataSource>

/**
 tableview
 */
@property (nonatomic, strong) UITableView               *tableView;

/**
 tableview adpator
 */
@property (nonatomic, strong) PAListTableViewAdaptor    *tableViewAdaptor;

@end
