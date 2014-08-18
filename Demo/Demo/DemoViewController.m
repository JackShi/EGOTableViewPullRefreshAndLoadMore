//
//  DemoViewController.m
//  Demo
//
//  Created by Jack Shi on 18/08/2014.
//  Copyright (c) 2014 Jack Shi. All rights reserved.
//

#import "DemoViewController.h"

@interface DemoViewController ()

@end

@implementation DemoViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    _isRefreshing = NO;
    
    _dataRows = 20;
    
    if (_egoRefreshTableHeaderView == nil)
    {
		_egoRefreshTableHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		_egoRefreshTableHeaderView.delegate = self;
		[self.tableView addSubview:_egoRefreshTableHeaderView];
	}
	[_egoRefreshTableHeaderView refreshLastUpdatedDate];
    
    if (_loadMoreTableFooterView == nil)
    {
        _loadMoreTableFooterView = [[LoadMoreTableFooterView alloc] initWithFrame:CGRectMake(0.0f, self.tableView.contentSize.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		_loadMoreTableFooterView.delegate = self;
		[self.tableView addSubview:_loadMoreTableFooterView];
    }
    
    [self reloadData];
}

- (void)reloadData
{
    [self.tableView reloadData];
    
    _loadMoreTableFooterView.frame = CGRectMake(0.0f, self.tableView.contentSize.height, self.view.frame.size.width, self.tableView.bounds.size.height);
}

#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[_egoRefreshTableHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
    [_loadMoreTableFooterView loadMoreScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	[_egoRefreshTableHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
    [_loadMoreTableFooterView loadMoreScrollViewDidEndDragging:scrollView];
}

#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    _isRefreshing = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        //从网络刷新数据需要一定延迟
        sleep(3);
        
        _dataRows = 20; //刷新后又重新显示前20条最新数据
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            //下载完成
            _isRefreshing = NO;
            [self reloadData];
            
            [_egoRefreshTableHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
        });
    });
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
    return _isRefreshing;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
    return [NSDate date];
}

#pragma mark LoadMoreTableFooterDelegate Methods

- (void)loadMoreTableFooterDidTriggerLoadMore:(LoadMoreTableFooterView*)view
{
    _isLoadMoreing = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        //从网络下载更多数据需要一定延迟
        sleep(3);
        
        _dataRows += 20;//多加载20条数据
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            //下载完成
            _isLoadMoreing = NO;
            
            [self reloadData];
            
            [_loadMoreTableFooterView loadMoreScrollViewDataSourceDidFinishedLoading:self.tableView];
        });
    });
}
- (BOOL)loadMoreTableFooterDataSourceIsLoading:(LoadMoreTableFooterView*)view
{
    return _isLoadMoreing;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return _dataRows;
    }
    else
    {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"第 %04d 行数据", [indexPath row]+1];
    
    return cell;
}

@end