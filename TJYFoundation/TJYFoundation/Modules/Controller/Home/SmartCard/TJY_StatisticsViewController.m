//
//  TJY_StatisticsViewController.m
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/25.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import "TJY_StatisticsViewController.h"
#import "TJY_DatePickerViewController.h"
#import "TJY_MonthDetailViewController.h"
#import "TJY_HomePageViewModel.h"
#import "TJY_SignClockInfo.h"
#import "TJY_SignInfoHelper.h"
@interface TJY_StatisticsViewController ()<TJY_SignInfoHelperDelegate>
{
    NSString  *  _numString;
    NSInteger  selectNum;
}
@property (weak, nonatomic) IBOutlet UIButton *dayBtn;
@property (weak, nonatomic) IBOutlet UIButton *monthBtn;
@property (weak, nonatomic) IBOutlet UIButton *myBtn;
@property (weak, nonatomic) IBOutlet UIView *moveLine;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *notClick;
@property (weak, nonatomic) IBOutlet UIView *laterView;
@property (weak, nonatomic) IBOutlet UIView *outWorkView;
@property(nonatomic,strong)CAShapeLayer  * backgroundShapeLayer;
@property (weak, nonatomic) IBOutlet UIView *shapeView;
@property (weak, nonatomic) IBOutlet UILabel *totalNum;
@property(nonatomic,strong)CAShapeLayer * blueShapeLayer;
@property (weak, nonatomic) IBOutlet UILabel *detailList;
@property (weak, nonatomic) IBOutlet UILabel *notClock;
@property (weak, nonatomic) IBOutlet UILabel *laterWork;
@property (weak, nonatomic) IBOutlet UILabel *outWork;
@property(nonatomic,strong)TJY_SignClockInfo * model;

@property (weak, nonatomic) IBOutlet UIView *tableHeaderView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)TJY_SignInfoHelper *  helper;
@property(nonatomic,strong)   RACCommand * selectCommand ;
@end

@implementation TJY_StatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self  configUI];
    [self  initData];
    self.titleView.titleLabel.text = @"统计";
    self.tableView.tableFooterView = [[UIView  alloc]initWithFrame:CGRectZero];
}
-(void)initData{
        TJY_HomePageViewModel * model = [TJY_HomePageViewModel  new];
        [[model.dayClockInfoCommand execute:self.timeLabel.text ] subscribeNext:^( TJY_SignClockInfo * x) {
        self.model = x;
        self.notClock.text = self.model.wdkCount;
        self.laterWork.text = self.model.dkCountCd;
        self.outWork.text = self.model.dkCountWq;
        self.totalNum.text = [NSString  stringWithFormat:@"%@/%@",self.model.dkCount,self.model.ydCount];
        CABasicAnimation  * anima = [CABasicAnimation  animationWithKeyPath:@"strokeEnd"];
        anima.fromValue =[NSNumber numberWithFloat:0.0];
        anima.toValue = [NSNumber  numberWithFloat:[self.model.wdkCount floatValue]/[self.model.ydCount floatValue]];
        anima.duration = 1;
        anima.repeatCount = 1;
        anima.removedOnCompletion =false;
        anima.fillMode =  kCAFillModeForwards;
        [self.blueShapeLayer  addAnimation:anima forKey:nil];
    } error:^(NSError * _Nullable error) {
    }];
    self.helper = [[TJY_SignInfoHelper  alloc] initWithTableView:self.tableView sourceSignal:nil selectionCommand:nil customCellClass:nil];
      self.helper.flag = 1;
}
-(void)configUI{
    @weakify(self);
    UITapGestureRecognizer  *  tap = [[UITapGestureRecognizer  alloc] initWithActionBlock:^(id  _Nonnull sender) {
        @strongify(self);
        TJY_DatePickerViewController  *  vc = [[UIStoryboard  storyboardWithName:@"HomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"TJY_DatePickerViewController"];
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        vc.dateBlock = ^(NSString *dateString) {
            self.timeLabel.text = dateString;
            [self initData];
        };
        [self.tabBarController presentViewController:vc animated:YES completion:nil];
    }];
    [self.timeLabel addGestureRecognizer:tap];
    NSDateFormatter  * formatter = [[NSDateFormatter  alloc] init];
    [formatter setDateFormat:@"yyyy.MM.dd"];
    NSString  * dateStr = [formatter  stringFromDate:[NSDate  date]];
    self.timeLabel.text = dateStr;
    [self  borderCorlorWithView:self.notClick];
    [self borderCorlorWithView:self.laterView];
    [self  borderCorlorWithView:self.outWorkView];
    [self.shapeView.layer  addSublayer:self.backgroundShapeLayer];
    [self.shapeView.layer  addSublayer:self.blueShapeLayer];
}
-(void)borderCorlorWithView:(UIView*)view{
    view.layer.borderWidth = 0.25;
    view.layer.borderColor =[ssRGBAlpha(0, 0, 0, 0.15) CGColor]; //ssRGBHex(0xff6a4c)
}
- (IBAction)btnClick:(UIButton *)sender {
    NSInteger  index = sender.tag;
    NSArray  *  btnArray = @[self.dayBtn,self.monthBtn,self.myBtn];
    [btnArray  enumerateObjectsUsingBlock:^(UIButton * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([sender  isEqual:obj]) {
            [ obj  setTitleColor:ssRGBHex(0x0080ff) forState:UIControlStateNormal];
        }else{
            [ obj  setTitleColor:ssRGBHex(0x999999) forState:UIControlStateNormal];
        }
    }];
    [UIView  animateWithDuration:0.2 animations:^{
        self.moveLine.centerX = sender.centerX;
    }];
    switch (index-100) {
        case 0:{
            NSDateFormatter  * formatter = [[NSDateFormatter  alloc] init];
            [formatter setDateFormat:@"yyyy.MM.dd"];
            NSString  * dateStr = [formatter  stringFromDate:[NSDate  date]];
            self.timeLabel.text = dateStr;
            self.tableHeaderView.height = 560;
            self.tableHeaderView.hidden = false;
            [self  initData];
            break;
        }
        case 1:{
            TJY_HomePageViewModel * model = [TJY_HomePageViewModel  new];
            NSDateFormatter  *  formatter = [[NSDateFormatter  alloc] init];
            [formatter  setDateFormat:@"yyyy.MM"];
            NSString  *  dateStr = [formatter  stringFromDate:[NSDate  date]];
            RACTuple  * tupe = [RACTuple  tupleWithObjects:dateStr, nil];
            self.tableHeaderView.height = 0;
            self.tableHeaderView.hidden = YES;
            RACSignal *  source =  [model.monthClockInfoCommand  execute:tupe];
            self.helper = [[TJY_SignInfoHelper  alloc] initWithTableView:self.tableView sourceSignal:source selectionCommand:self.selectCommand customCellClass:nil];
            self.helper.flag = 2;
            self.helper.delegate = self;
            break;
        }
        default:{
            self.tableHeaderView.height = 0;
            self.tableHeaderView.hidden = YES;
           TJY_HomePageViewModel * model = [TJY_HomePageViewModel  new];
            RACSignal * source =   [model.myMonthClockInfoCommand  execute:nil] ;
            self.helper = [[TJY_SignInfoHelper  alloc] initWithTableView:self.tableView sourceSignal:source selectionCommand:self.selectCommand customCellClass:nil];
            self.helper.delegate = self;
            self.helper.flag = 3;
            break;
        }
    }
}
#pragma  mark  getter  method
-(CAShapeLayer *)backgroundShapeLayer{
    if (!_backgroundShapeLayer) {
        _backgroundShapeLayer = [[CAShapeLayer  alloc] init];
        _backgroundShapeLayer.strokeColor = [ssRGBHex(0xdddddd) CGColor];
        _backgroundShapeLayer.fillColor = [UIColor  clearColor].CGColor;
        _backgroundShapeLayer.lineWidth = 5;
        CGFloat  r = self.shapeView.frame.size.width/2.0;
        _backgroundShapeLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.shapeView.frame.size.width/2-r, self.shapeView.frame.size.height/2-r, 2*r, 2*r)].CGPath;
        _backgroundShapeLayer.lineCap = kCALineCapRound;
    }
    return  _backgroundShapeLayer;
}
-(CAShapeLayer *)blueShapeLayer{
    if (!_blueShapeLayer) {
        _blueShapeLayer = [[CAShapeLayer  alloc] init];
        _blueShapeLayer.strokeColor = [ssRGBHex(0x0080ff) CGColor];
        _blueShapeLayer.fillColor = [UIColor  clearColor].CGColor;
        _blueShapeLayer.lineWidth = 5;
        CGFloat  r = self.shapeView.frame.size.width/2.0;
        _blueShapeLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.shapeView.frame.size.width/2-r, self.shapeView.frame.size.height/2-r, 2*r, 2*r)].CGPath;
        _blueShapeLayer.lineCap = kCALineCapRound;
        _blueShapeLayer.strokeStart = 0.0;
        _blueShapeLayer.strokeEnd = 0.0;
    }
    return  _blueShapeLayer;
}

-(RACCommand *)selectCommand{
    if (!_selectCommand) {
        _selectCommand =[ [RACCommand  alloc] initWithSignalBlock:^RACSignal  *(RACTuple *turple) {
            
            return [RACSignal  empty];
        }];
    }
    return  _selectCommand;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)pushViewControllersIndexPath:(NSIndexPath *)indexPath flag:(NSInteger)flag titleString:(NSString *)text{
    if (flag==3) {
        TJY_DatePickerViewController  *  vc = [[UIStoryboard  storyboardWithName:@"HomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"TJY_DatePickerViewController"];
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        @weakify(self);
        vc.dateBlock = ^(NSString *dateString) {
            @strongify(self);
            RACSignal  *  single = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [subscriber  sendNext:dateString];
                [subscriber  sendCompleted];
                return  [RACDisposable  disposableWithBlock:^{
                    
                }];
            }];
            self.helper.changeCommand = single;
        };
        [self.tabBarController presentViewController:vc animated:YES completion:nil];
    }else if (flag==2){
        TJY_MonthDetailViewController *  vc  = [[UIStoryboard  storyboardWithName:@"HomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"TJY_MonthDetailViewController"];
        vc.type = [NSString  stringWithFormat:@"%ld", indexPath.row+1];
        vc.text = text;
        [self.navigationController  pushViewController:vc animated:YES];
    }
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UIViewController  *  vc = [segue  destinationViewController];
    if ([segue.identifier  isEqualToString:@"signInfo"]) {
        if ([vc  respondsToSelector:@selector(setInfoModel:)]) {
            [vc  setValue:self.model forKey:@"infoModel"];
        }
        if ([vc  respondsToSelector:@selector(setDayStr:)]) {
            [vc  setValue:self.timeLabel.text forKey:@"dayStr"];
        }
    }
}

@end
