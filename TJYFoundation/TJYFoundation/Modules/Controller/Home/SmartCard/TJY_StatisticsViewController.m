//
//  TJY_StatisticsViewController.m
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/25.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import "TJY_StatisticsViewController.h"
#import "TJY_DatePickerViewController.h"
@interface TJY_StatisticsViewController ()
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
@end

@implementation TJY_StatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    @weakify(self);
    UITapGestureRecognizer  *  tap = [[UITapGestureRecognizer  alloc] initWithActionBlock:^(id  _Nonnull sender) {
         @strongify(self);
        TJY_DatePickerViewController  *  vc = [[UIStoryboard  storyboardWithName:@"HomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"TJY_DatePickerViewController"];
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        vc.dateBlock = ^(NSString *dateString) {
            self.timeLabel.text = dateString;
        };
        [self.tabBarController presentViewController:vc animated:YES completion:nil];
    }];
    [self.timeLabel addGestureRecognizer:tap];
    [self  configUI];
}
-(void)configUI{
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
    switch (index-100) {
        case 0:{
            [UIView  animateWithDuration:0.2 animations:^{
                self.moveLine.centerX = self.dayBtn.centerX;
            }];
            [self.dayBtn setTitleColor:ssRGBHex(0x0080ff) forState:UIControlStateNormal];
            [self.monthBtn setTitleColor:ssRGBHex(0x999999) forState:UIControlStateNormal];
            [self.myBtn setTitleColor:ssRGBHex(0x999999) forState:UIControlStateNormal];
            break;
        }
        case 1:{
            [UIView  animateWithDuration:0.2 animations:^{
                self.moveLine.centerX = self.monthBtn.centerX;
            }];
            [self.dayBtn setTitleColor:ssRGBHex(0x999999) forState:UIControlStateNormal];
            [self.monthBtn setTitleColor:ssRGBHex(0x0080ff) forState:UIControlStateNormal];
            [self.myBtn setTitleColor:ssRGBHex(0x999999) forState:UIControlStateNormal];
            break;
        }
        default:{
            [UIView  animateWithDuration:0.2 animations:^{
                self.moveLine.centerX = self.myBtn.centerX;
            }];
            [self.dayBtn setTitleColor:ssRGBHex(0x999999) forState:UIControlStateNormal];
            [self.monthBtn setTitleColor:ssRGBHex(0x999999) forState:UIControlStateNormal];
            [self.myBtn setTitleColor:ssRGBHex(0x0080ff) forState:UIControlStateNormal];
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
         _blueShapeLayer.strokeStart = 0;
        CGFloat endf = 20/22.0;
         _blueShapeLayer.strokeEnd = endf;
    }
    return  _blueShapeLayer;
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
