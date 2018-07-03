//
//  PASandBoxBrowserController.m
//  manpanxiang
//
//  Created by 刘玉龙 on 2017/8/23.
//  Copyright © 2017年 Mapping Shine (Shanghai) Network Technology Co.,Ltd. All rights reserved.
//

#import "PASandBoxBrowserController.h"
#import "PAURLMap.h"

#pragma mark -

typedef NS_ENUM(NSInteger, FileItemType) {
    FileItemTypeBack                        = 0,  // 返回上一级
    FileItemTypeFolder                      = 1,  // 文件夹
    FileItemTypeFile                        = 2,  // 文件
};

#pragma mark -

@interface LocalFileModel : NSObject

@property (nonatomic, copy) NSString        *fileName;
@property (nonatomic, copy) NSString        *filePath;
@property (nonatomic, assign) FileItemType  fileType;
@property (nonatomic, assign) BOOL          isHiddenFile;

@end

@implementation LocalFileModel
@end

#pragma mark -

static NSString *kSandBoxBrowserCellIdentifier = @"SandBoxBrowserCellIdentifier";

@PAURLMap(sandBoxBrowserController, PASandBoxBrowserController)
@interface PASandBoxBrowserController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, strong) NSArray       *items;     // 当前所有的目录
@property (nonatomic, copy) NSString        *rootPath;  // 所查看的文件结构的根目录

@end

@implementation PASandBoxBrowserController

- (void)loadView {
    [super loadView];

    self.tableView                          = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.dataSource               = self;
    self.tableView.delegate                 = self;

    self.view = self.tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"沙盒查看";

    // 注册 Cell 类型
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kSandBoxBrowserCellIdentifier];

    // 隐藏多余的分隔线
    self.tableView.tableFooterView          = [[UIView alloc] initWithFrame:CGRectZero];

    [self loadFiles:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LocalFileModel* item                    = [self.items objectAtIndex:indexPath.row];

    UITableViewCell* cell                   = [tableView dequeueReusableCellWithIdentifier:kSandBoxBrowserCellIdentifier forIndexPath:indexPath];
    cell.textLabel.text                     = item.fileName;
    cell.textLabel.lineBreakMode            = NSLineBreakByTruncatingMiddle;
    cell.textLabel.textColor                = item.isHiddenFile ? [UIColor lightGrayColor] : [UIColor blackColor];

    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:false];

    LocalFileModel* item                    = [self.items objectAtIndex:indexPath.row];
    switch (item.fileType) {
        case FileItemTypeBack:
            [self loadFiles:[item.filePath stringByDeletingLastPathComponent]];
            break;
        case FileItemTypeFolder:
            [self loadFiles:item.filePath];
            break;
        case FileItemTypeFile:
            [self shareFile:item.filePath];
            break;
        default:
            break;
    }

}

#pragma mark - Private Methods

- (void)loadFiles:(NSString*)filePath {
    NSMutableArray *filesArray = [NSMutableArray new];

    if (!filePath || [filePath isEqualToString:@""]) {
        filePath = self.rootPath;
    }

    if (filePath && ![filePath isEqualToString:self.rootPath]) {
        // 非root path 添加返回item
        LocalFileModel *backItem            = [[LocalFileModel alloc] init];
        backItem.fileType                   = FileItemTypeBack;
        backItem.filePath                   = filePath;
        backItem.fileName                   = @"🔙...";
        [filesArray addObject:backItem];
    }

    NSFileManager *fileManager              = [NSFileManager defaultManager];
    NSError* error                          = nil;
    NSArray *files                          = [fileManager contentsOfDirectoryAtPath:filePath error:&error];
    for (NSString *str in files) {

        BOOL isHidden                       = NO;  // 是否是隐藏文件
        BOOL isFolder                       = NO;  // 是否是文件夹
        if ([[str lastPathComponent] hasPrefix:@"."]) {
            isHidden                        = YES;  // 隐藏文件
        }

        NSString *fileFullPath              = [filePath stringByAppendingPathComponent:str];
        [fileManager fileExistsAtPath:fileFullPath isDirectory:&isFolder];

        LocalFileModel *fileItem            = [[LocalFileModel alloc] init];
        fileItem.filePath                   = fileFullPath;
        fileItem.isHiddenFile               = isHidden;
        fileItem.fileName                   = [NSString stringWithFormat:@"%@ %@", isFolder ? @"📁" : @"📃", str];
        fileItem.fileType                   = isFolder?FileItemTypeFolder:FileItemTypeFile;

        [filesArray addObject:fileItem];
    }

    self.items                              = filesArray.copy;

    [self.tableView reloadData];
}

- (void)shareFile:(NSString *)filePath {
    NSURL *fileURL                          = [NSURL fileURLWithPath:filePath];
    UIActivityViewController *controller    = [[UIActivityViewController alloc] initWithActivityItems:@[fileURL] applicationActivities:nil];
    // 排除的选, 只保留AirDrop / message / email
    controller.excludedActivityTypes        = @[UIActivityTypePostToFacebook,
                                                UIActivityTypePostToTwitter,
                                                UIActivityTypePostToWeibo,
                                                UIActivityTypeMessage,
                                                UIActivityTypePrint,
                                                UIActivityTypeCopyToPasteboard,
                                                UIActivityTypeAssignToContact,
                                                UIActivityTypeSaveToCameraRoll,
                                                UIActivityTypeAddToReadingList,
                                                UIActivityTypePostToFlickr,
                                                UIActivityTypePostToVimeo,
                                                UIActivityTypePostToTencentWeibo
                                                ];

    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - Properties

- (NSString *)rootPath {
    if (!_rootPath) {
        _rootPath                           = NSHomeDirectory();
    }

    return _rootPath;
}

#pragma mark - Override Methods

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    // Leave this method empty to disable shaking gesture for debug tool.
}

@end
