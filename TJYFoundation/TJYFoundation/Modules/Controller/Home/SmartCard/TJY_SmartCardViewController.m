//
//  TJY_SmartCardViewController.m
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/18.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import "TJY_SmartCardViewController.h"
#import "TJY_HomePageViewModel.h"
#import "TJY_ConfigInfo.h"
#import "TJY_SignMapViewController.h"
@interface TJY_SmartCardViewController ()
{
    TJY_ConfigInfo  * _config;
}
@property (weak, nonatomic) IBOutlet UILabel *stateLbl;
@property (weak, nonatomic) IBOutlet UILabel *stateClosed;
@property (weak, nonatomic) IBOutlet UIView *addressLbl;
@property (weak, nonatomic) IBOutlet UIView *addressClosed;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *signImgConstraintHeight;
@property (weak, nonatomic) IBOutlet UIImageView *signImg;
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UILabel *startTime;
@property (weak, nonatomic) IBOutlet UILabel *signState;
@property (weak, nonatomic) IBOutlet UILabel *endTime;
@property (weak, nonatomic) IBOutlet UILabel *endSignState;
@property(nonatomic,strong) TJY_ConfigInfo  * config;

@end

@implementation TJY_SmartCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
      self.title = @"company";
     [self  labelBorderColorWithLabel:self.stateLbl];
     [self  labelBorderColorWithLabel:self.stateClosed];
     [self  configUI];
     [self  initData];
}
-(void)initData{
    TJY_HomePageViewModel  *  model = [TJY_HomePageViewModel  new];
    RACSignal  *  source =  [model.signConfigCommand  execute:nil];
    @weakify(self);
    [source  subscribeNext:^(TJY_ConfigInfo* x) {
        @strongify(self);
        self.config = x;
    } error:^(NSError * _Nullable error) {
    } ];
    [RACObserve(_config, endWorkTime) subscribeNext:^(id  _Nullable x) {
             @strongify(self);
        self.endTime.text = [NSString  stringWithFormat:@"下班时间%@",[self  dateWithTimeIntervalString:self.config.endWorkTime]];
    }];
    [RACObserve(_config, startWorkTime) subscribeNext:^(id  _Nullable x) {
         @strongify(self);
        self.startTime.text = [NSString  stringWithFormat:@"上班时间%@",[self  dateWithTimeIntervalString:self.config.startWorkTime]];
        //    RACChannelTo(self.startTime, text)= RACChannelTo(_config, startWorkTime);双向绑定
    }];
}
-(void)configUI{
    NSDateFormatter  *  formatter = [[NSDateFormatter  alloc] init];
    [formatter  setDateFormat:@"yyyy-MM-dd"];
    NSString  *  currentDateString = [formatter  stringFromDate:[NSDate  date]];
    self.timeLbl.text = currentDateString;
      UserInfo  * user = [TJY_UserApplication  shareManager].loginUser;
    self.nameLbl.text =  user.perName;
    
    YYLabel  * morningLbl = [[YYLabel  alloc] init];
    YYLabel *eveningLbl = [[YYLabel  alloc] init];
    [self.view addSubview:morningLbl];
    [self.view  addSubview:eveningLbl];
    [morningLbl  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.addressLbl);
    }];
    [eveningLbl  mas_makeConstraints:^(MASConstraintMaker *make) {
         make.edges.mas_equalTo(self.addressClosed);
    }];
    [self configLabel:morningLbl];
    [self  configLabel:eveningLbl];
    self.signImg.userInteractionEnabled = YES;
    UITapGestureRecognizer  * tap = [[UITapGestureRecognizer  alloc]  init];
    @weakify(self);
    [tap  setNumberOfTapsRequired:1];
    [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        @strongify(self);
        TJY_SignMapViewController *  vc = [TJY_SignMapViewController new];
        [self.navigationController  pushViewController:vc animated:YES];
    }];
    [self.signImg  addGestureRecognizer:tap];
    [self.view  bringSubviewToFront:self.signImg];
}
-(void)labelBorderColorWithLabel:(UILabel*)label{
    label.layer.borderWidth = 1;
    label.layer.borderColor = ssRGBHex(0xff6a4c).CGColor;
}
-(void)configLabel:(YYLabel *)label{
    NSDictionary  *  attributeDict = [NSDictionary  dictionaryWithObjectsAndKeys:[UIFont  systemFontOfSize:16],NSFontAttributeName, nil];
    label.lineBreakMode = 0;
    label.numberOfLines = NSLineBreakByWordWrapping;
    label.displaysAsynchronously = YES;
    label.preferredMaxLayoutWidth =  SCREEN_W -122;
    label.textAlignment = YYTextVerticalAlignmentTop;
    YYAnimatedImageView * imageView = [[YYAnimatedImageView  alloc] initWithImage:[UIImage  imageNamed:@"location"]];
    imageView.frame =  CGRectMake(0, 0, 16, 16);
    NSMutableAttributedString *attachText1= [NSMutableAttributedString attachmentStringWithContent:imageView contentMode:UIViewContentModeScaleAspectFit attachmentSize:imageView.frame.size alignToFont:[UIFont systemFontOfSize:16] alignment:YYTextVerticalAlignmentCenter];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:@" "];
    attri.headIndent = 10;
    [attri  addAttributes:attributeDict range:NSMakeRange(0, attri.length)];
    [attri insertAttributedString:attachText1 atIndex:0];
    label.attributedText =  attri;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
