//
//  PAListTableViewAdaptor.m
//  haofang
//
//  Created by PengFeiMeng on 3/27/14.
//  Copyright (c) 2014 平安好房. All rights reserved.
//

#import "PAListTableViewAdaptor.h"

#define LOADMORE_HEIGHT 44.0

@interface PAListTableViewAdaptor() <PARefreshTableHeaderDelegate>

@end

@implementation PAListTableViewAdaptor

#pragma mark - facilities

- (PATableViewCell *)generateCellForObject:(id<PATableViewCellItemBasicProtocol>)object indexPath:(NSIndexPath *)indexPath identifier:(NSString *)identifier {
    PATableViewCell *cell = nil;
    
    if (object) {
        Class cellClass = [self cellClassForObject:object];
        cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    return cell;
}

// 获取cell数据模型item对应的cell的类对象
- (Class)cellClassForObject:(id<PATableViewCellItemBasicProtocol>)object {
    Class cellClass = nil;
    
    if (object && [object respondsToSelector:@selector(cellClass)]) {
        cellClass = [object cellClass];
    }
    
    return cellClass;
}

// 根据indexPath获取对应的cellClass
- (Class)cellClassForIndexPath:(NSIndexPath *)indexPath {
    Class cellClass                                 = nil;
    id<PATableViewCellItemBasicProtocol> object     = [self objectForRowAtIndexPath:indexPath];
    
    cellClass                                       = [self cellClassForObject:object];
    
    return cellClass;
}

// 获取indexpath位置上cell的数据模型
- (id<PATableViewCellItemBasicProtocol>)objectForRowAtIndexPath:(NSIndexPath *)indexPath {
    id object           = nil;
    
    if (self.items.count > indexPath.row) {
        object          = [self.items objectAtIndex:indexPath.row];
    }
    
    return object;
}

// 对应的row 数量
- (NSInteger)numberOfRows {
    return self.items.count;
}

// 设置sections 数量
- (int)numberOfSections {
    return 1;
}

// 根据cell中实现rowHeightForObject方法，获取高度
- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowHeight       = 0;
    
    UITableView *tableView  = self.tableView;
    id<PATableViewCellItemBasicProtocol> object = [self objectForRowAtIndexPath:indexPath];
    
    Class cellClass         = [self cellClassForIndexPath:indexPath];
    rowHeight               = [cellClass tableView:tableView rowHeightForObject:object];
    
    return rowHeight;
}

// 根据indexPaht 获取CellType
- (NSString *)cellTypeAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellType      = nil;
    
    id<PATableViewCellItemBasicProtocol> object = [self objectForRowAtIndexPath:indexPath];
    if (object) {
        cellType            = [object cellType];
    }
    
    return cellType;
}

// 根据 indexPaht 获取 Cell 的 Identifier
- (NSString *)identifierForCellAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier    = nil;
    
    Class cellClass         = [self cellClassForIndexPath:indexPath];
    identifier              = [cellClass cellIdentifier];
    
    return identifier;
}

#pragma mark - setter/getter

- (NSMutableArray *)items {
    if (_items == nil) {
        self.items = [NSMutableArray array];
    }
    
    return _items;
}

- (PATableHeaderDragRefreshView *)headerRefreshView {
    if (_headerRefreshView == nil) {
        // Add our refresh header
        _headerRefreshView = [[PATableHeaderDragRefreshView alloc]
                              initWithFrame:CGRectMake(0, -CGRectGetHeight(self.tableView.bounds), CGRectGetWidth(self.tableView.bounds), CGRectGetHeight(self.tableView.bounds))];
        _headerRefreshView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _headerRefreshView.backgroundColor = [UIColor clearColor];
        _headerRefreshView.delegate = self;
    }
    
    return _headerRefreshView;
}

- (PALoadFooterView *)loadMoreView {
    if (_loadMoreView == nil) {
        _loadMoreView = [[PALoadFooterView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.tableView.bounds), LOADMORE_HEIGHT)];
        _loadMoreView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _loadMoreView.backgroundColor = [UIColor whiteColor];
    }
    
    return _loadMoreView;
}

- (void)setDragRefreshEnable:(BOOL)dragRefreshEnable {
    _dragRefreshEnable = dragRefreshEnable;
    if (_dragRefreshEnable) {
        [self.tableView addSubview:self.headerRefreshView];
    } else {
        [self.headerRefreshView removeFromSuperview];
    }
}

// 是否开启加载更多的动画
- (void)setLoadMoreEnable:(BOOL)loadMoreEnable {
    _loadMoreEnable = loadMoreEnable;
    if (_loadMoreEnable) {
        self.tableView.tableFooterView = self.loadMoreView;
        [self.loadMoreView startAnimation];
    } else {
        self.tableView.tableFooterView = nil;
        [self.loadMoreView stopAnimation];
    }
}

#pragma mark - 

- (BOOL)dataIsLoading {
    return [self.delegate respondsToSelector:@selector(tableViewDataIsLoading:)] &&
    [self.delegate tableViewDataIsLoading:self.tableView];
}

- (void)finishLoadingData {
    if (self.dragRefreshEnable) {
        [self.headerRefreshView paRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self numberOfRows];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self numberOfSections];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<PATableViewCellItemBasicProtocol> object = [self objectForRowAtIndexPath:indexPath];
    
    NSString *identifier    = [self identifierForCellAtIndexPath:indexPath];
    UITableViewCell *cell   = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        // 初始化cell
        cell                = [self generateCellForObject:object indexPath:indexPath identifier:identifier];
    }
    
    // 更新数据
    if ([cell isKindOfClass:[PATableViewCell class]]) {
        [(PATableViewCell *)cell setObject:object];
    }
    
    if ([self.delegate respondsToSelector:@selector(tableView:didSetObject:cell:)]) {
        [self.delegate tableView:tableView didSetObject:object cell:cell];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height          = 0;
    
    height                  = [self heightForRowAtIndexPath:indexPath];
    
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id<PATableViewCellItemBasicProtocol> object = [self objectForRowAtIndexPath:indexPath];
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(tableView:didSelectObject:rowAtIndexPath:)]) {
            [self.delegate tableView:tableView didSelectObject:object rowAtIndexPath:indexPath];
        }
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(tableView:editingStyleForRowAtIndexPath:)]) {
        return [self.delegate tableView:tableView editingStyleForRowAtIndexPath:indexPath];
    }
    
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(tableView:commitEditingStyle:forRowAtIndexPath:)]) {
        [self.delegate tableView:self.tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(tableView:titleForDeleteConfirmationButtonForRowAtIndexPath:)]) {
        return [self.delegate tableView:self.tableView titleForDeleteConfirmationButtonForRowAtIndexPath:indexPath];
    }
    
    return @"Delete";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(tableView:canEditRowAtIndexPath:)]) {
        return [self.delegate tableView:self.tableView canEditRowAtIndexPath:indexPath];
    }
    
    return NO;
}

#pragma mark - PARefreshTableHeaderDelegate

// 获取是否处于加载状态
- (BOOL)paRefreshTableHeaderDataSourceIsLoading:(PATableHeaderDragRefreshView *)view {
    if ([self.delegate respondsToSelector:@selector(tableViewDataIsLoading:)]) {
        return [self.delegate tableViewDataIsLoading:self.tableView];
    } else {
        return YES;
    }
}

// 下拉刷新回调
- (void)paRefreshTableHeaderDidTriggerRefresh:(PATableHeaderDragRefreshView *)view {
    if ([self.delegate respondsToSelector:@selector(tableViewTriggerRefresh:)]) {
        return [self.delegate tableViewTriggerRefresh:self.tableView];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView*)scrollView {
    
    // 保证delegate里的scrollViewDidScroll方法正常回调
    if ([self.delegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.delegate performSelector:@selector(scrollViewDidScroll:) withObject:scrollView];
    }
    
    // 更新headerRefreshView状态
    if (self.dragRefreshEnable && self.tableView.contentOffset.y < 0.0) {
        [self.headerRefreshView paRefreshScrollViewDidScroll:scrollView];
    }
    
    // 触发上拉加载回调
    if (self.loadMoreEnable && self.tableView.contentOffset.y > 0.0 && [self reachToEnd:scrollView]) {
        if ([self.delegate respondsToSelector:@selector(tableViewReachToEnd:)]) {
            [self.delegate tableViewReachToEnd:self.tableView];
        }
    }
}

- (BOOL)reachToEnd:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y + CGRectGetHeight(scrollView.bounds) >= scrollView.contentSize.height) {
        return YES;
    }
    
    return NO;
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [self.delegate performSelector:@selector(scrollViewWillBeginDragging:) withObject:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([self.delegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [self.delegate performSelector:@selector(scrollViewDidEndDragging:willDecelerate:) withObject:scrollView withObject:[NSNumber numberWithBool:decelerate]];
    }
    
    if (self.dragRefreshEnable) {
        [self.headerRefreshView paRefreshScrollViewDidEndDragging:scrollView];
    }
}

@end
