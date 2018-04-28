//
//  TJY_MonthDetailViewController.m
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/28.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import "TJY_MonthDetailViewController.h"
#import "TJY_MonthTableViewCell.h"
#import "TJY_HomePageViewModel.h"
#import "TJY_MyStatisticsViewController.h"
#import "TJY_Clock.h"
@interface TJY_MonthDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSArray  *  dataArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TJY_MonthDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    self.titleView.titleLabel.text = self.text;
}
-(void)initData{
        TJY_HomePageViewModel * model = [TJY_HomePageViewModel  new];
    @weakify(self);
    [[model.monthClockDetailCommand  execute:self.type] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.dataArray = x;
        [self.tableView  reloadData];
    }];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TJY_MonthTableViewCell  *  cell = [tableView  dequeueReusableCellWithIdentifier:@"TJY_MonthTableViewCell"];
    cell.model =  self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return   cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return   self.dataArray.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView  deselectRowAtIndexPath:indexPath animated:YES];
    TJY_Clock  *model = self.dataArray[indexPath.row];
    TJY_MyStatisticsViewController * vc = [[UIStoryboard  storyboardWithName:@"HomePage" bundle:nil]  instantiateViewControllerWithIdentifier:@"TJY_MyStatisticsViewController"];
    vc.perId = model.perId;
    vc.titleString =  model.perName;
    [self.navigationController  pushViewController:vc animated:YES];
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView  * v = [[UIView  alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 64)];
    UIView  *sub = [[UIView  alloc] init];
    [v addSubview: sub];
    [sub  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.leading.trailing.mas_equalTo(v);
        make.height.mas_equalTo(44);
    }];
    sub.backgroundColor = [UIColor  whiteColor];
    v.backgroundColor = ssRGBHex(0xeaeaea);
    UILabel  *  lbl = [[UILabel  alloc] init];
    lbl.textColor = ssRGBHex(0x222222);
    lbl.font = [UIFont  systemFontOfSize:14];
    NSDateFormatter  *  formater = [[NSDateFormatter  alloc] init];
    [formater  setDateFormat:@"yyyy.MM"];
    lbl.text = [formater  stringFromDate:[NSDate  date]];
    [sub addSubview:lbl];
    [lbl  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(sub).mas_offset(15);
        make.centerY.mas_equalTo(sub);
    }];
    UILabel  *  detailLbl = [UILabel  new];
    detailLbl.font = [UIFont  systemFontOfSize:12];
    detailLbl.textColor = ssRGBHex(0x222222);
    detailLbl.text = [NSString  stringWithFormat:@"总%@人数:%ld人",self.text,self.dataArray.count];
    [sub  addSubview:detailLbl];
    [detailLbl  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(sub).mas_offset(-15);
        make.centerY.mas_equalTo(sub);
    }];
    return   v;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return   64;
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
#pragma   mark --  getter  method
-(NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSArray  array];
    }
    return  _dataArray;
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
