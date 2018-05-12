//
//  TJY_CustomerInfoViewController.m
//  TJYFoundation
//
//  Created by wang_wei on 2018/5/7.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import "TJY_CustomerInfoViewController.h"
#import "TJY_SearchViewController.h"
#import "TJY_CustomerViewModel.h"
@interface TJY_CustomerInfoViewController ()<UISearchBarDelegate,UISearchResultsUpdating,UITableViewDelegate,UITableViewDataSource,UISearchControllerDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeightContrsint;

@property (weak, nonatomic) IBOutlet UIView *moveLine;
@property (weak, nonatomic) IBOutlet UIView *searchBarView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UISearchController *searchController;
@property(nonatomic,strong)TJY_SearchViewController *  searchVC;
// 数据源数组
@property (nonatomic, strong) NSMutableArray *dataArray;
// 搜索结果数组
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingContraint;
@property (nonatomic, strong) NSMutableArray *resultArray;
@end

@implementation TJY_CustomerInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self  configUI];
  
    [self  initData:[RACTuple  tupleWithObjects:@"1",@"1",@"",@"1", nil]];
}
-(void)initData:(RACTuple *)tupe{
   
    TJY_CustomerViewModel *   model = [TJY_CustomerViewModel  new];

    [[model.customerListCommand execute:tupe]  subscribeNext:^(id  _Nullable x) {
        
    }error:^(NSError * _Nullable error) {
        GMLog("%@",error);
    }];
}
-(void)configUI{
    self.titleView.titleLabel.text = @"编辑客户";
    UIButton  *  btn = [UIButton  buttonWithType:UIButtonTypeCustom];
    [btn  setTitle:@"提交" forState:UIControlStateNormal];
    [btn  setTitleColor:ssRGBHex(0x0080ff) forState:UIControlStateNormal];
    [self.titleView  addSubview:btn];
    [btn  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.bottom.mas_equalTo(self.titleView);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(80);
    }];
    [[btn  rac_signalForControlEvents:UIControlEventTouchUpInside]  subscribeNext:^(__kindof UIControl * _Nullable x) {
        GMLog(".......");
    }];
    [self.searchBarView addSubview:self.searchController.searchBar];
}
- (IBAction)btnClick:(UIButton *)sender {
    
    NSArray  *  btnArray = @[(UIButton*)[self.view  viewWithTag:100],(UIButton*)[self.view  viewWithTag:101],(UIButton*)[self.view  viewWithTag:102]];
    [btnArray  enumerateObjectsUsingBlock:^(UIButton * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([sender  isEqual:obj]) {
            [obj setTitleColor:ssRGBHex(0x0080ff) forState:UIControlStateNormal];
        }else{
            [obj setTitleColor:ssRGBHex(0x999999) forState:UIControlStateNormal];
        }
        [self.view  layoutIfNeeded];
    }];
    dispatch_async(dispatch_get_main_queue(), ^{
             [UIView  animateWithDuration:.25 animations:^{
                self.leadingContraint.constant = (sender.tag-100)*sender.width;
                 [self.view  layoutIfNeeded];
            }];
    });
        GMLog("%f----%f",self.moveLine.centerX,sender.centerX);
    [self  initData:[RACTuple  tupleWithObjects:@"2",@"2",@"",@"2", nil]];
}
#pragma   mark --- UITableView  delegate  method
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  nil;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return   self.dataArray.count;
}
#pragma   amrk -- getter  method
-(UISearchController *)searchController{
    if (!_searchController) {
        _searchController = [[UISearchController  alloc] initWithSearchResultsController:nil];
        _searchController.searchResultsUpdater =  self;
        _searchController.delegate = self;
        _searchController.searchBar.delegate = self;
        [_searchController.searchBar sizeToFit];
        _searchController.searchBar.placeholder = @"搜索";
        _searchController.dimsBackgroundDuringPresentation = YES;
        _searchController.hidesNavigationBarDuringPresentation = false;
    }
    return  _searchController ;
}
-(TJY_SearchViewController *)searchVC{
    if (!_searchVC) {
        _searchVC = [[UIStoryboard  storyboardWithName:@"Customer" bundle:nil] instantiateViewControllerWithIdentifier:@"TJY_SearchViewController"];
    }
    return  _searchVC;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray  array];
    }
    return  _dataArray;
}
-(NSMutableArray *)resultArray{
    if (!_resultArray) {
        _resultArray = [NSMutableArray  array];
    }
    return  _resultArray;
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
#pragma  mark -- UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(nonnull UISearchController *)searchController {

}
#pragma mark --  UISearchBar  delegate
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    GMLog("%@--",searchBar.text);
}
#pragma mark - UISearchControllerDelegate代理
- (void)willPresentSearchController:(UISearchController *)searchController{
    self.topHeightContrsint.constant = 0;
    self.titleView.hidden = YES;
    [self.view  layoutIfNeeded];
}
- (void)didPresentSearchController:(UISearchController *)searchController{
  
}
- (void)willDismissSearchController:(UISearchController *)searchController{

}
- (void)didDismissSearchController:(UISearchController *)searchController{
    self.topHeightContrsint.constant = 44;
    self.titleView.hidden = NO;
    [self.view  layoutIfNeeded];
}

@end
