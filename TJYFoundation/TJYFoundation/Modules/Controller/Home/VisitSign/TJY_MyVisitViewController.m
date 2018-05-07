//
//  TJY_MyVisitViewController.m
//  TJYFoundation
//
//  Created by wang_wei on 2018/5/4.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import "TJY_MyVisitViewController.h"
#import "TJY_MyVisitTableViewCell.h"
#import "TJY_DatePickerViewController.h"
#import "TJY_HomePageViewModel.h"
@interface TJY_MyVisitViewController () <UITableViewDelegate,UITableViewDataSource>{
    RACTuple  *  tupe;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *signNumLbl;
@property (weak, nonatomic) IBOutlet UILabel *currentDateLbl;
@property(nonatomic,strong)NSArray  *  dataArray;
@end

@implementation TJY_MyVisitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self  configUI];
    [self  initData];
}

-(void)initData{
    TJY_HomePageViewModel  *  model = [TJY_HomePageViewModel  new];
    @weakify(self);
    [[model.attendanceSignListCommand execute:@""]  subscribeNext:^(id  _Nullable x) {
        @strongify(self);
         tupe = x;
        self.dataArray =  tupe.third;
        [self.tableView  reloadData];
    }];
}
-(void)configUI{
    UITapGestureRecognizer  *  tap = [[UITapGestureRecognizer  alloc] init];
    @weakify(self);
    [[tap  rac_gestureSignal]  subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        @strongify(self);
        TJY_DatePickerViewController  *  picker = [[UIStoryboard  storyboardWithName:@"HomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"TJY_DatePickerViewController"];
        picker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        picker.dateBlock = ^(NSString *dateString) {
        };
        [self.tabBarController presentViewController:picker animated:YES completion:nil];
    }];
    [self.headerView addGestureRecognizer:tap];
}
#pragma   mark -- UItableView  delegate  dataSource  method
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TJY_MyVisitTableViewCell *  cell = [tableView  dequeueReusableCellWithIdentifier:@"TJY_MyVisitTableViewCell" forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.section][indexPath.row];
    return   cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return   [self.dataArray[section] count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  self.dataArray.count;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView  * v = [[UIView  alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 44)];
    v.backgroundColor = [UIColor  whiteColor];
    UILabel  *  lbl = [UILabel  new];
    lbl.text =  tupe.fourth[section][0];
    lbl.font = [UIFont  systemFontOfSize:24];
    lbl.textColor =  ssRGBHex(0x222222);
    [v addSubview:lbl];
    [lbl  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(15);
        make.centerY.mas_equalTo(v.mas_centerY);
    }];
    UILabel  *  detailLbl = [UILabel  new];
    detailLbl.text = tupe.fourth[section][1];
    detailLbl.font = [UIFont  systemFontOfSize:12];
    detailLbl.textColor =  ssRGBHex(0x222222);
    [v  addSubview:detailLbl];
    [detailLbl  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(lbl.mas_trailing);
        make.centerY.mas_equalTo(lbl.mas_bottom).mas_offset(-10);
    }];
    return  v;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return  0.01;
}
-(void)viewDidLayoutSubviews {
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 85, 0, 15)];
        
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 85, 0, 15)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 85, 0, 15)];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 85, 0, 15)];
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
