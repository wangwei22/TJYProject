//
//  TJY_SmartCardViewController.m
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/18.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import "TJY_SmartCardViewController.h"

@interface TJY_SmartCardViewController ()
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

@end

@implementation TJY_SmartCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
      self.title = @"company";
     [self  labelBorderColorWithLabel:self.stateLbl];
     [self  labelBorderColorWithLabel:self.stateClosed];
     [self  configUI];
}
-(void)configUI{
    NSDateFormatter  *  formatter = [[NSDateFormatter  alloc] init];
    [formatter  setDateFormat:@"yyyy-MM-dd"];
    NSString  *  currentDateString = [formatter  stringFromDate:[NSDate  date]];
    self.timeLbl.text = currentDateString;
      UserInfo  * user = [TJY_UserApplication  shareManager].loginUser;
    self.nameLbl.text =  user.perName;
    
    YYLabel  * morningLbl = [[YYLabel  alloc] init];
//    morningLbl.backgroundColor = [UIColor  yellowColor];
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
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:@" YYLabel  为什么设置对齐方式不起作用，YYLabel  为什么设置对齐方式不起作用YYLabel  为什么设置对齐方式不起作用"];
    attri.headIndent = 10;
    [attri  addAttributes:attributeDict range:NSMakeRange(0, attri.length)];
    [attri insertAttributedString:attachText1 atIndex:0];
    label.attributedText =  attri;
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
