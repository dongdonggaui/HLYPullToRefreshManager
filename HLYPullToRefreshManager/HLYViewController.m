//
//  HLYViewController.m
//  HLYPullToRefreshManager
//
//  Created by huangluyang on 14-8-24.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "HLYViewController.h"
#import "HLYPullToRefreshManager.h"
#import "UIView+Frame.h"

@interface HLYViewController () <UITableViewDataSource>

@property (nonatomic, strong) HLYPullToRefreshManager *pullToRefreshManager;

@end

@implementation HLYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    __weak HLYViewController *safeSelf = self;
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableView.dataSource = self;
    self.pullToRefreshManager = [[HLYPullToRefreshManager alloc] initWithTableView:tableView];
    self.pullToRefreshManager.loadNew = ^ {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [safeSelf.pullToRefreshManager endLoad];
        });
    };
    self.pullToRefreshManager.loadMore = ^ {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [safeSelf.pullToRefreshManager endLoad];
        });
    };
    [self.pullToRefreshManager setHeaderUpdateTimeIdentifier:@"header"];
    [self.pullToRefreshManager setFooterUpdateTimeIdentifier:@"footer"];
    
    [self.view addSubview:tableView];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.pullToRefreshManager.tableView.frame = self.view.bounds;
    
    if ([self respondsToSelector:@selector(topLayoutGuide)]) {
        
        [self.pullToRefreshManager.tableView hly_setTop:[self.topLayoutGuide length]];
        [self.pullToRefreshManager.tableView hly_setHeight:[self.view hly_height] - [self.topLayoutGuide length]];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.pullToRefreshManager triggerLoadNew];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)trigger:(id)sender {
    [self.pullToRefreshManager triggerLoadNew];
}

#pragma mark -
#pragma mark - table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 12;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = @"test";
    
    return cell;
}

@end
