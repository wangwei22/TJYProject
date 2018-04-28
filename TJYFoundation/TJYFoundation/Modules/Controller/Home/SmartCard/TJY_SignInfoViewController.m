//
//  TJY_SignInfoViewController.m
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/25.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import "TJY_SignInfoViewController.h"
#import "TJY_SignInfoTableViewCell.h"
#import "TJY_HomePageViewModel.h"
#import "TJY_Clock.h"
@interface TJY_SignInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *moveLine;
@property(nonatomic,strong)TJY_HomePageViewModel  *  viewModel;
@property(nonatomic,strong)ClockDetail *  model;
@property(nonatomic,strong) NSArray  *  datatArray;
@end

@implementation TJY_SignInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.tableFooterView = [[UIView  alloc] initWithFrame:CGRectZero];
    [self  initData];
    self.titleView.titleLabel.text = @"打卡明细";
}
-(void)initData{
    NSArray  *  btnArray =@ [(UILabel*) [self.view  viewWithTag:200],(UILabel*) [self.view  viewWithTag:201], (UILabel*)[self.view  viewWithTag:202],(UILabel*) [self.view  viewWithTag:203],(UILabel*) [self.view  viewWithTag:204]];
    NSArray * titleArray = @[[NSString  stringWithFormat:@"已打卡\n(%@)",self.infoModel.dkCount],[NSString  stringWithFormat:@"迟到\n(%@)",self.infoModel.dkCountCd],[NSString  stringWithFormat:@"早退\n(%@)",self.infoModel.dkCountZt],[NSString  stringWithFormat:@"外勤\n(%@)",self.infoModel.dkCountWq],[NSString  stringWithFormat:@"未打卡\n(%@)",self.infoModel.wdkCount]];
    [btnArray  enumerateObjectsUsingBlock:^(UILabel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.text = titleArray[idx];
    }];
    RACTuple  * tuple = [RACTuple  tupleWithObjects:self.dayStr, @"4",@"2",nil];
    @weakify(self);
    [[self.viewModel.userDayClockInfoCommand  execute:tuple]  subscribeNext:^(ClockDetail * x) {
        @strongify(self);
        self.model = x;
        self.datatArray = self.model.clock;
        [self.tableView  reloadData];
    }];
}

- (IBAction)btnClick:(UIButton *)sender {
    NSInteger  index = sender.tag;
    NSArray  *  btnArray =@ [(UIButton*) [self.view  viewWithTag:100],(UIButton*) [self.view  viewWithTag:101], (UIButton*)[self.view  viewWithTag:102],(UIButton*) [self.view  viewWithTag:103],(UIButton*) [self.view  viewWithTag:104]];
    [btnArray  enumerateObjectsUsingBlock:^(UIButton * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel * lbl = [self.view  viewWithTag:(obj.tag+100)];
        if ([sender  isEqual:obj]) {
            lbl.textColor = ssRGBHex(0x0080ff);
        }else{
              lbl.textColor = ssRGBHex(0x999999);
        }
    }];
    [UIView  animateWithDuration:.25 animations:^{
        self.moveLine.centerX = sender.centerX;
    }];
    NSString  * outType , *isOutworker;
    switch (index-100) {
        case 0:{
            outType = @"4";
            isOutworker = @"2";
            break;
        }
        case 1:{
            outType = @"2";
            isOutworker = @"2";
            break;
        }
        case 2:{
            outType = @"3";
            isOutworker = @"2";
            break;
        }
        case 3:{
            outType = @"4";
            isOutworker = @"1";
            break;
        }
        default:{
            outType = @"";
            isOutworker = @"";
            break;
        }
    }
    RACTuple  * tuple = [RACTuple  tupleWithObjects:self.dayStr, outType,isOutworker,nil];
    @weakify(self);
    [[self.viewModel.userDayClockInfoCommand  execute:tuple]  subscribeNext:^(ClockDetail * x) {
        @strongify(self);
        self.model = x;
        if (sender.tag ==104) {
                self.datatArray = self.model.noClockList;
        }else{
                self.datatArray = self.model.clock;
        }
        [self.tableView  reloadData];
    }];
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

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TJY_SignInfoTableViewCell *  cell = [tableView  dequeueReusableCellWithIdentifier:@"TJY_SignInfoTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([self.datatArray[indexPath.row] isKindOfClass:[ClockList  class]]) {
        cell.list =self.datatArray[indexPath.row];
    }else{
        cell.model = self.datatArray[indexPath.row];
    }
    return   cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.datatArray.count;
}
-(void)viewDidLayoutSubviews {
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 71, 0, 15)];
        
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 71, 0, 15)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 71, 0, 15)];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 71, 0, 15)];
    }
}

#pragma mark --  getter  method
-(TJY_HomePageViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[TJY_HomePageViewModel  alloc] init];
    }
    return _viewModel;
}
-(NSArray *)datatArray{
    if (!_datatArray) {
        _datatArray = [NSArray  array];
    }
    return   _datatArray;
}
@end
