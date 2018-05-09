//
//  TJY_SearchViewController.m
//  TJYFoundation
//
//  Created by wang_wei on 2018/5/8.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import "TJY_SearchViewController.h"

@interface TJY_SearchViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TJY_SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark - UISearchResultsUpdating
//每输入一个字符都会执行一次
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
     searchController.searchResultsController.view.hidden = NO;
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
