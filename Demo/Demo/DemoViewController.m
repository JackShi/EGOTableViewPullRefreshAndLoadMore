//
//  DemoViewController.m
//  Demo
//
//  Created by Jack Shi on 18/08/2014.
//  Copyright (c) 2014 Jack Shi. All rights reserved.
//

#import "DemoViewController.h"

@interface DemoViewController ()
{
    EGORefreshTableHeaderView *egoRefreshTableHeaderView;
    BOOL isRefreshing;
    
    LoadMoreTableFooterView *loadMoreTableFooterView;
    BOOL isLoadMoreing;
    
    int dataRows;
}

@end

@implementation DemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    isRefreshing = NO;
    dataRows = 20;

    if (egoRefreshTableHeaderView == nil)
    {
		egoRefreshTableHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height )];
		egoRefreshTableHeaderView.delegate = self;
		[self.tableView addSubview:egoRefreshTableHeaderView];
	}
	[egoRefreshTableHeaderView refreshLastUpdatedDate];
    
    if (loadMoreTableFooterView == nil)
    {
        loadMoreTableFooterView = [[LoadMoreTableFooterView alloc] initWithFrame:CGRectMake(0.0f, self.tableView.contentSize.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		loadMoreTableFooterView.delegate = self;
		[self.tableView addSubview:loadMoreTableFooterView];
    }
    
    [self reloadData];
}

- (void)reloadData
{
    [self.tableView reloadData];
    
    loadMoreTableFooterView.frame = CGRectMake(0.0f, self.tableView.contentSize.height, self.view.frame.size.width, self.tableView.bounds.size.height);
}

#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[egoRefreshTableHeaderView egoRefreshScrollViewDidScroll:scrollView];
    [loadMoreTableFooterView loadMoreScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	[egoRefreshTableHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    [loadMoreTableFooterView loadMoreScrollViewDidEndDragging:scrollView];
}

#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    isRefreshing = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        // waiting for loading data from internet
        sleep(3);
        dataRows = 20; // show first 20 records after refreshing
        dispatch_sync(dispatch_get_main_queue(), ^{
            // complete refreshing
            isRefreshing = NO;
            [self reloadData];
            
            [egoRefreshTableHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
        });
    });
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
    return isRefreshing;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
    return [NSDate date];
}

#pragma mark LoadMoreTableFooterDelegate Methods

- (void)loadMoreTableFooterDidTriggerLoadMore:(LoadMoreTableFooterView*)view
{
    isLoadMoreing = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        // waiting for loading data from internet
        sleep(3);
        dataRows += 20; // add 20 more records
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            // complete loading...
            isLoadMoreing = NO;
            
            [self reloadData];
            
            [loadMoreTableFooterView loadMoreScrollViewDataSourceDidFinishedLoading:self.tableView];
        });
    });
}
- (BOOL)loadMoreTableFooterDataSourceIsLoading:(LoadMoreTableFooterView*)view
{
    return isLoadMoreing;
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
        return dataRows;
    }
    else {
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
    
    cell.textLabel.text = [NSString stringWithFormat:@"Row %d", [indexPath row] + 1];
    
    return cell;
}

@end