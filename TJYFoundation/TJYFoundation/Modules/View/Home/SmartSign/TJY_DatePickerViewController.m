//
//  TJY_DatePickerViewController.m
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/25.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import "TJY_DatePickerViewController.h"

@interface TJY_DatePickerViewController ()
{
    NSString  *_dateString;
}
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (weak, nonatomic) IBOutlet UIView *backgroudView;
@end

@implementation TJY_DatePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [[UIColor darkTextColor] colorWithAlphaComponent:0.7];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy.MM.dd";
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
   _dateString = [dateFormatter stringFromDate:[NSDate  date]];
    [[self.datePicker  rac_newDateChannelWithNilValue:[NSDate  date]] subscribeNext:^(NSDate * _Nullable x) {
        NSString *dateStr = [dateFormatter stringFromDate:x];
        self->_dateString = dateStr;
    }];
    UITapGestureRecognizer  *  tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(    UITapGestureRecognizer  *  sender) {
        if (!CGRectContainsPoint(self.backgroudView.frame, [sender locationInView:self.view ]) ) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    [self.view  addGestureRecognizer:tap];
}
- (IBAction)btnClick:(UIButton *)sender {
    NSInteger  index = sender.tag;
    if (index == 100) {
        [self  dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self  dismissViewControllerAnimated:YES completion:^{
            if (self.dateBlock) {
                self.dateBlock(self->_dateString);
            }
        }];
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
