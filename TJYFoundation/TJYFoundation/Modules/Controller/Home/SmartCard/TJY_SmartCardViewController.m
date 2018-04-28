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
#import "TJY_SignInfo.h"
#import "TJY_AlertViewController.h"
#import "TJY_DatePickerViewController.h"
@interface TJY_SmartCardViewController ()
{
    TJY_ConfigInfo  * _config;
    YYTimer  *_timer;
    UserInfo  * _user;
    NSString  *  _flag;
    YYLabel  * morningLbl ;
    YYLabel *eveningLbl ;
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
@property (weak, nonatomic) IBOutlet UILabel *startTime;
@property (weak, nonatomic) IBOutlet UILabel *signState;
@property (weak, nonatomic) IBOutlet UILabel *endTime;
@property (weak, nonatomic) IBOutlet UILabel *endSignState;
@property(nonatomic,strong) TJY_ConfigInfo  * config;
@property (weak, nonatomic) IBOutlet UILabel *signFlag;
@property (weak, nonatomic) IBOutlet UILabel *currentTime;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *amLabelConstraintHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stateLeadingConstraintWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stateClosedConstraintWidth;
@end

@implementation TJY_SmartCardViewController
-(void)viewDidAppear:(BOOL)animated{
    [super  viewDidAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
      self.titleView.titleLabel.text = @"company";
    [self  bindData];
    [self  configUI];
    [self  initData];
    _timer = [[YYTimer  alloc ] initWithFireTime:1.0 interval:1.0 target:self selector:@selector(timeFunc)  repeats:YES];
    [_timer  fire];
}
-(void)initData{
    TJY_HomePageViewModel  *  model = [TJY_HomePageViewModel  new];
        @weakify(self);
    RACSignal  *  source =  [model.signConfigCommand  execute:nil];
    [source  subscribeNext:^(RACTuple* x) {
        @strongify(self);
        self.config = x.first;
        self.signFlag.text = x.second;
    } error:^(NSError * _Nullable error) {
    } ];
   [RACObserve(self.config, endWorkTime) subscribeNext:^(id  _Nullable x) {
             @strongify(self);
        self.endTime.text = [NSString  stringWithFormat:@"下班时间%@",[self  dateWithTimeIntervalString:self.config.endWorkTime]];
    }];
    [RACObserve(self.config, startWorkTime) subscribeNext:^(id  _Nullable x) {
         @strongify(self);
        self.startTime.text = [NSString  stringWithFormat:@"上班时间%@",[self  dateWithTimeIntervalString:self.config.startWorkTime]];
    }];
}
-(void)configUI{
    NSDateFormatter  *  formatter = [[NSDateFormatter  alloc] init];
    [formatter  setDateFormat:@"yyyy.MM.dd"];
    NSString  *  currentDateString = [formatter  stringFromDate:[NSDate  date]];
    self.timeLbl.text = currentDateString;
      _user= [TJY_UserApplication  shareManager].loginUser;
    self.nameLbl.text =  _user.perName;
    
    UITapGestureRecognizer  *  tapClick = [[UITapGestureRecognizer  alloc] initWithTarget:self action:@selector(tapClick)];
    [self.timeLbl addGestureRecognizer:tapClick];
    
     morningLbl = [[YYLabel  alloc] init];
     eveningLbl = [[YYLabel  alloc] init];
    [self.view addSubview:morningLbl];
    [self.view  addSubview:eveningLbl];
    [morningLbl  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.addressLbl);
    }];
    [eveningLbl  mas_makeConstraints:^(MASConstraintMaker *make) {
         make.edges.mas_equalTo(self.addressClosed);
    }];
    self.signImg.userInteractionEnabled = YES;
    UITapGestureRecognizer  * tap = [[UITapGestureRecognizer  alloc]  init];
    [tap  setNumberOfTapsRequired:1];
    [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        [self  handleSignData];
    }];
    [self.signImg  addGestureRecognizer:tap];
    [self.view  bringSubviewToFront:self.signImg];
    [self.view bringSubviewToFront:self.signFlag];
    [self.view bringSubviewToFront:self.currentTime];
}
-(void)timeFunc{
    NSDateFormatter  *  formatter = [[NSDateFormatter  alloc] init];
    formatter.AMSymbol = @"上午";
    formatter.PMSymbol = @"下午";
    [formatter  setDateFormat:@"HH:mm:ss aaa"];
    NSString  *  timetamp = [formatter  stringFromDate:[NSDate  date]];
    if ([timetamp  rangeOfString:@"上午"].location !=NSNotFound) {
        _flag = @"1";
    }else{
        _flag = @"2";
    }
    [self.currentTime  setText:[timetamp substringToIndex:timetamp.length-2]];
}
-(void)handleMorning:(TJY_SignInfo*)infoAm{
    if (infoAm.clockTime) {
        if ([infoAm.outType isEqualToString:@"1"]) {
            self.stateLbl.text = @"正常";
         [self  labelBorderColorWithLabel:self.stateLbl color:ssRGBHex(0x0080ff)];
        }else if ([infoAm.outType  isEqualToString:@"2"]){
            self.stateLbl.text = @"迟到";
            [self  labelBorderColorWithLabel:self.stateLbl color:ssRGBHex(0xff6a4c)];
        }else{
            self.stateLbl.text = @"早退";
            [self  labelBorderColorWithLabel:self.stateLbl color:ssRGBHex(0xff6a4c)];
        }
       [self  configLabel:morningLbl withText:infoAm.address];
        self.signState.text = [infoAm clockTime]?[NSString  stringWithFormat:@"打卡时间%@",[infoAm clockTime]] :@"";
        self.signImgConstraintHeight.constant = 180;
        self.stateLeadingConstraintWidth.constant = 10;
        [self.view  layoutIfNeeded];
    }else{
        if ([_flag isEqualToString:@"2"]) {
            self.stateLbl.text = @"缺勤";
             [self  labelBorderColorWithLabel:self.stateLbl color:ssRGBHex(0xff6a4c)];
             [self  configLabel:morningLbl withText:@""];
             self.signImgConstraintHeight.constant = 180;
            self.stateLeadingConstraintWidth.constant = 0;
            [self.view  layoutIfNeeded];
        }else{
            self.stateLbl.text = @"";
        }
    }
}
-(void)handleEvening:(TJY_SignInfo*)inffoPm{
    if (inffoPm.clockTime) {
        self.endSignState.hidden = false;
        self.endSignState.text = [inffoPm clockTime]?[NSString  stringWithFormat:@"打卡时间%@",[inffoPm clockTime]]:@"";
        self.signImg.hidden = YES;
        self.signFlag.hidden = YES;
        self.currentTime.hidden = YES;
        [_timer  invalidate];
        [self  configLabel:eveningLbl withText:inffoPm.address];
        if ([inffoPm.outType isEqualToString:@"1"]) {
            self.stateClosed.text = @"正常";
            [self  labelBorderColorWithLabel:self.stateClosed color:ssRGBHex(0x0080ff)];
        }else if ([inffoPm.outType  isEqualToString:@"2"]){
            self.stateClosed.text = @"迟到";
            [self  labelBorderColorWithLabel:self.stateClosed color:ssRGBHex(0xff6a4c)];
        }else{
            self.stateClosed.text = @"早退";
              [self  labelBorderColorWithLabel:self.stateClosed color:ssRGBHex(0xff6a4c)];
        }
    }else{
        self.stateClosed.text = @"";
        self.stateClosedConstraintWidth.constant = 0;
        [self.view  layoutIfNeeded];
    }
 
}
-(void)handleSignData{
    if(  [TJY_UserApplication  shareManager].gPlmark !=nil){
        NSDateFormatter  *  formattter = [[NSDateFormatter  alloc] init];
        [formattter  setDateFormat:@"HH:mm"];
        NSString  * dateString = [formattter  stringFromDate:[NSDate  date]];
        NSDate  * currentDate = [formattter dateFromString:dateString];
        NSDate  * futerDate = [formattter  dateFromString:self.config.endWorkTime];
        int  result = [self  compareOneDay:currentDate withAnotherDay:futerDate];
        GMLog("%d",result);
        if(result==-1){
            TJY_AlertViewController * vc = [[UIStoryboard  storyboardWithName:@"HomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"TJY_AlertViewController"];
             vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            vc.dissAppearBlock = ^{
                TJY_HomePageViewModel  *  model = [TJY_HomePageViewModel  new];
                [[model.signClickCommand  execute:  [NSString  stringWithFormat:@"%@",[[TJY_UserApplication  shareManager].gPlmark.addressDictionary objectForKey:@"FormattedAddressLines"][0]]? [NSString  stringWithFormat:@"%@",[[TJY_UserApplication  shareManager].gPlmark.addressDictionary objectForKey:@"FormattedAddressLines"][0]]:@""] subscribeNext:^(id  _Nullable x) {
                } error:^(NSError * _Nullable error) {
                    [MBProgressHUD  showTopTipMessage: [error.userInfo objectForKey:@"customErrorInfoKey"]  isWindow:YES];
                }];
            };
            [self.tabBarController presentViewController:vc animated:YES completion:nil];
        }else{
            NSString  *  address =  [NSString  stringWithFormat:@"%@",[[TJY_UserApplication  shareManager].gPlmark.addressDictionary objectForKey:@"FormattedAddressLines"][0]] ;
            TJY_HomePageViewModel  *  model = [TJY_HomePageViewModel  new];
            [[model.signClickCommand  execute: address] subscribeNext:^(id  _Nullable x) {
                [self  bindData];
            } error:^(NSError * _Nullable error) {
                 [MBProgressHUD  showTopTipMessage: [error.userInfo objectForKey:@"customErrorInfoKey"]  isWindow:YES];
            }];
        }
    }else{
        [self  showHint:@"定位失败"];
    }
}
-(void)bindData{
    TJY_HomePageViewModel  *  model = [TJY_HomePageViewModel  new];
    @weakify(self);
    [[model.userSignInfoCommand execute:nil] subscribeNext:^(NSArray * x) {
        @strongify(self);
        if ([self->_flag isEqualToString:@"1"]) {
                [self  handleMorning:(TJY_SignInfo *) x.firstObject];
        }else{
               [self  handleMorning:(TJY_SignInfo *) x.firstObject];
               [self  handleEvening: (TJY_SignInfo *)x.lastObject];
        }
    } error:^(NSError * _Nullable error) {
        [MBProgressHUD   showTopTipMessage:[error.userInfo  objectForKey:@"customErrorInfoKey"] isWindow:YES];
    }];
}
-(void)configLabel:(YYLabel *)label withText:(NSString*)text{
    NSDictionary  *  attributeDict = [NSDictionary  dictionaryWithObjectsAndKeys:[UIFont  systemFontOfSize:16],NSFontAttributeName,  ssRGBHex(0x222222), NSForegroundColorAttributeName,nil];
    label.lineBreakMode = 0;
    label.numberOfLines = NSLineBreakByWordWrapping;
    label.displaysAsynchronously = YES;
    label.userInteractionEnabled = YES;
    label.preferredMaxLayoutWidth =  SCREEN_W -122;
    label.textAlignment = YYTextVerticalAlignmentTop;
    YYAnimatedImageView * imageView = [[YYAnimatedImageView  alloc] initWithImage:[UIImage  imageNamed:@"location"]];
    imageView.frame =  CGRectMake(0, 0, 16, 16);
    NSMutableAttributedString *attachText1= [NSMutableAttributedString attachmentStringWithContent:imageView contentMode:UIViewContentModeScaleAspectFit attachmentSize:imageView.frame.size alignToFont:[UIFont systemFontOfSize:16] alignment:YYTextVerticalAlignmentCenter];
    NSString  * yy_text = @"申请补卡>";
    NSString *  string = [NSString  stringWithFormat:@"%@\n%@",text,yy_text];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:string];
    if (text.length >0) {
         [attri insertAttributedString:attachText1 atIndex:0];
    }
    [attri  setTextHighlightRange:NSMakeRange(attri.length-5, 5) color:ssRGBHex(0x0080ff) backgroundColor:ssRGBHex(0x0080ff) tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        GMLog("....click");
    }];
    attri.headIndent = 10;
    [attri  addAttributes:attributeDict range:NSMakeRange(0, attri.length-5)];
    label.attributedText =  attri;
}
-(void)labelBorderColorWithLabel:(UILabel*)label color:(UIColor*)color{
    label.layer.borderWidth = 1;
    label.textColor = color;
    label.layer.borderColor = [color   CGColor]; //ssRGBHex(0xff6a4c)
}
-(void)tapClick{
    TJY_DatePickerViewController  *  picker = [[UIStoryboard  storyboardWithName:@"HomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"TJY_DatePickerViewController"];
      picker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    @weakify(self);
     picker.dateBlock = ^(NSString *dateString) {
         @strongify(self);
        self.timeLbl.text = dateString;
     };
    [self.tabBarController presentViewController:picker animated:YES completion:nil];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super  viewDidDisappear:animated];
    [_timer  invalidate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma   mark setter  getter  method
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
