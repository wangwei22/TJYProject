//
//  TJY_NationViewController.m
//  TJYFoundation
//
//  Created by wang_wei on 2018/5/11.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import "TJY_NationViewController.h"
#import "TJY_CustomerViewModel.h"
#import "TJY_Nation.h"
@interface TJY_NationViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    RACTuple  *  tupe;
    NSDictionary  *  dic;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSArray  *  dataArray;
@end

@implementation TJY_NationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    TJY_CustomerViewModel  *  model = [[TJY_CustomerViewModel  alloc] init];
    @weakify(self);
    [[model.nationCommand  execute:nil] subscribeNext:^( RACTuple  *  x) {
        @strongify(self);
        self->tupe = x;
        self->dic = self->tupe.first;
        self.dataArray =  self->tupe.second;
        [self.tableView  reloadData];
    }];
    self.tableView.tableFooterView = [[UIView  alloc] initWithFrame:CGRectZero];
    self.titleView.titleLabel.text = @"民族选择";
}
#pragma mark --  UITableView  dataSource  delegate  method
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  [dic[self.dataArray[section]] count] ;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static  NSString  *  myCell = @"cellId";
    UITableViewCell  *  cell = [tableView  dequeueReusableCellWithIdentifier:myCell];
    if (!cell) {
        cell = [[UITableViewCell  alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:myCell];
    }
    TJY_Nation  *  model =dic [self.dataArray[indexPath.section]][indexPath.row];
    cell.textLabel.text = model.nation;
    return   cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView  deselectRowAtIndexPath:indexPath animated:YES];
    TJY_Nation  *  model =dic [self.dataArray[indexPath.section]][indexPath.row];
    if (self.backValueBlock) {
        self.backValueBlock(model);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return   self.dataArray[section];
}
#pragma mark --  getter  setter  method
-(NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSArray  array];
    }
    return _dataArray;
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
