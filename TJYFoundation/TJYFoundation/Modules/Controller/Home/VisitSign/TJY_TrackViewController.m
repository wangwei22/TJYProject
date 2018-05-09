//
//  TJY_TrackViewController.m
//  TJYFoundation
//
//  Created by wang_wei on 2018/5/2.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import "TJY_TrackViewController.h"
#import "TJY_VisitTableViewCell.h"
#import "TJY_HomePageViewModel.h"
#import "TJY_DatePickerViewController.h"
#import "TJY_MyVisitViewController.h"
@interface TJY_TrackViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    RACTuple  * _tupe;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *moveLine;
@property (nonatomic,strong)NSArray  *  dataArray;
@end

@implementation TJY_TrackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleView.titleLabel.text = @"足迹";
    [self  initNaviRightBarItem];
    TJY_HomePageViewModel  *  model = [TJY_HomePageViewModel  new];
    @weakify(self);
    [[model.attendanceNewListCommand   execute:nil]  subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self->_tupe = x;
        self.dataArray = self->_tupe.third;
        UIButton  * btn =(  UIButton  *) [self.view  viewWithTag:100];
        [btn  setTitle:[NSString  stringWithFormat:@"最新签到(%@)",self->_tupe.first] forState:UIControlStateNormal];
        UIButton  * btnW =(  UIButton  *) [self.view  viewWithTag:101];
        [btnW  setTitle:[NSString  stringWithFormat:@"未签到(%@)",self->_tupe.second] forState:UIControlStateNormal];
        [self.tableView  reloadData];
    }];
}
-(void)initNaviRightBarItem{
    UIButton  * btn = [UIButton  buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"我的" forState:UIControlStateNormal];
    [btn  setTitleColor:ssRGBHex(0x0080ff) forState:UIControlStateNormal];
    [self.titleView  addSubview:btn];
    [btn  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.trailing.mas_equalTo(self.titleView);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(80);
    }];
    @weakify(self);
    [[btn  rac_signalForControlEvents:UIControlEventTouchUpInside]  subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        TJY_MyVisitViewController  *  vc = [[UIStoryboard  storyboardWithName:@"HomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"TJY_MyVisitViewController"];
        [self.navigationController  pushViewController:vc animated:YES];
    }];
}
- (IBAction)btnClick:(UIButton *)sender {
    NSInteger  index = sender.tag;
    NSArray  *  btnArray =@ [(UIButton*) [self.view  viewWithTag:100],(UIButton*) [self.view  viewWithTag:101]];
    [btnArray  enumerateObjectsUsingBlock:^(UIButton * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([sender  isEqual:obj]) {
            [ obj  setTitleColor:ssRGBHex(0x0080ff) forState:UIControlStateNormal];
        }else{
            [ obj  setTitleColor:ssRGBHex(0x999999) forState:UIControlStateNormal];
        }
         [self.view  layoutIfNeeded];
    }];
    [UIView  animateWithDuration:.25 animations:^{
        self.moveLine.centerX = sender.centerX;
    }];
    if (index ==100) {
        self.dataArray = _tupe.third;
    }else if (index==101){
        self.dataArray = _tupe.fourth;
    }
    [self.tableView  reloadData];
}

#pragma  mark --  UITableView  delegate  dataSource  method

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TJY_VisitTableViewCell  *  cell = [tableView  dequeueReusableCellWithIdentifier:@"TJY_VisitTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([self.dataArray isEqual:_tupe.third]) {
        cell.signModel = self.dataArray[indexPath.row];
    }else{
        cell.model = self.dataArray[indexPath.row];
    }
    return   cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return   self.dataArray.count;
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
    [formater  setDateFormat:@"yyyy.MM.dd"];
    lbl.text = [formater  stringFromDate:[NSDate  date]];
    [sub addSubview:lbl];
    [lbl  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(sub).mas_offset(15);
        make.centerY.mas_equalTo(sub);
    }];
    UIImageView  * img = [[UIImageView  alloc] init];
    img.image = [UIImage  imageNamed:@"undown"];
    [sub  addSubview:img];
    [img  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(lbl.mas_trailing).mas_offset(10);
        make.centerY.mas_equalTo(sub);
    }];
    UILabel  *  detailLbl = [UILabel  new];
    detailLbl.font = [UIFont  systemFontOfSize:12];
    detailLbl.textColor = ssRGBHex(0x222222);
//    detailLbl.text = [NSString  stringWithFormat:@"总%@人数:%ld人",self.text,self.dataArray.count];
    [sub  addSubview:detailLbl];
    [detailLbl  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(sub).mas_offset(-15);
        make.centerY.mas_equalTo(sub);
    }];
    @weakify(self);
    UITapGestureRecognizer  *  tap = [[UITapGestureRecognizer  alloc] initWithActionBlock:^(id  _Nonnull sender) {
        @strongify(self);
        TJY_DatePickerViewController  *  picker = [[UIStoryboard  storyboardWithName:@"HomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"TJY_DatePickerViewController"];
        picker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        picker.dateBlock = ^(NSString *dateString) {
            lbl.text = dateString;
            TJY_HomePageViewModel  *  model = [TJY_HomePageViewModel  new];
            [[model.attendanceNewListCommand  execute:dateString] subscribeNext:^(id  _Nullable x) {
                self->_tupe = x;
                self.dataArray = self->_tupe.third;
                UIButton  * btn =(  UIButton  *) [self.view  viewWithTag:100];
                [btn  setTitle:[NSString  stringWithFormat:@"最新签到(%@)",self->_tupe.first] forState:UIControlStateNormal];
                UIButton  * btnW =(  UIButton  *) [self.view  viewWithTag:101];
                [btnW  setTitle:[NSString  stringWithFormat:@"未签到(%@)",self->_tupe.second] forState:UIControlStateNormal];
                [self.tableView  reloadData];
            }];
        };
        [self.tabBarController presentViewController:picker animated:YES completion:nil];
    }];
    [sub  addGestureRecognizer:tap];
    return   v;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  64;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return  0.001;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView  deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)viewDidLayoutSubviews {
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 75, 0, 15)];
        
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 75, 0, 15)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 75, 0, 15)];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 75, 0, 15)];
    }
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
