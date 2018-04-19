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
@property (weak, nonatomic) IBOutlet YYLabel *addressLbl;
@property (weak, nonatomic) IBOutlet YYLabel *addressClosed;

@end

@implementation TJY_SmartCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
      self.title = @"company";
     [self  labelBorderColorWithLabel:self.stateLbl];
     [self  labelBorderColorWithLabel:self.stateClosed];
//    [self  configLabel:self.addressLbl];
}
-(void)labelBorderColorWithLabel:(UILabel*)label{
    label.layer.borderWidth = 1;
    label.layer.borderColor = ssRGBHex(0xff6a4c).CGColor;
}
-(void)configLabel:(YYLabel *)label{
    label.numberOfLines = 0;
    label.preferredMaxLayoutWidth = self.addressLbl.frame.size.width;
    YYAnimatedImageView * imageView = [[YYAnimatedImageView  alloc] initWithImage:[UIImage  imageNamed:@"location"]];
    imageView.frame =  CGRectMake(0, 0, 16, 16);
    NSMutableAttributedString *attachText1= [NSMutableAttributedString attachmentStringWithContent:imageView contentMode:UIViewContentModeScaleAspectFit attachmentSize:imageView.frame.size alignToFont:[UIFont systemFontOfSize:24] alignment:YYTextVerticalAlignmentCenter];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:@"DAKASDASHO"];
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
