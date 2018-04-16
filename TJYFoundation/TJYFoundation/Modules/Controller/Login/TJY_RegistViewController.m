//
//  TJY_RegistViewController.m
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/13.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import "TJY_RegistViewController.h"
#import "TJY_HomePageViewModel.h"
#import "TJY_InfoListViewController.h"
#import "TJY_HomeRequestService.h"
@interface TJY_RegistViewController ()<TJY_InfoListViewControllerDelegate,TJY_RequestServiceManagerDelegate>
{
    NSString  * _departmentStr;
    NSString  * _departmentId;
    NSString *  _professionStr;
     NSString *  _professionId;
}
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *telphone;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *code;
@property (weak, nonatomic) IBOutlet UILabel *department;
@property (weak, nonatomic) IBOutlet UILabel *duty;
@property (weak, nonatomic) IBOutlet YYLabel *lbl;
@end

@implementation TJY_RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleView.titleLabel.text = @"注册";
    [self  textFieldPlaceholderColorWithTextField:self.name];
     [self  textFieldPlaceholderColorWithTextField:self.telphone];
     [self  textFieldPlaceholderColorWithTextField:self.password];
     [self  textFieldPlaceholderColorWithTextField:self.code];
}
- (IBAction)submit:(UIButton *)sender {
       [self.view  endEditing: YES];
        NSString* wrongMsg = nil;
        if ([NSString  isBlankString:self.name.text]) {
              wrongMsg = @"请输入姓名";
            [self  showHint:wrongMsg];
            return ;
        }else if (![NSString  valiMobile:self.telphone.text]){
              wrongMsg = @"手机号码格式不正确";
            [self  showHint:wrongMsg];
            return ;
        }  else if ([NSString  isBlankString:self.password.text] ){
            wrongMsg = @"请输入密码";
            [self  showHint:wrongMsg];
            return;
        }else if (![self.password.text checkPassword] ){
            wrongMsg = @"密码格式不正确";
             [self  showHint:wrongMsg];
            return;
        }else if ([NSString  isBlankString:self.code.text]){
            wrongMsg = @"请输入激活码";
            [self  showHint:wrongMsg];
            return;
        }else if ([NSString  isBlankString:_departmentStr]){
            wrongMsg = @"请输入部门";
            [self  showHint:wrongMsg];
            return;
        }else if ([NSString  isBlankString:_professionStr]){
            wrongMsg = @"请输入职位";
            [self  showHint:wrongMsg];
            return;
        }
    TJY_HomePageViewModel  * viewModel = [[TJY_HomePageViewModel  alloc] init];
    NSDictionary  * dic = [NSDictionary  dictionaryWithObjectsAndKeys:self.name.text,@"per_name",
                           self.password.text,@"password",
                           self.telphone.text,@"per_mobile",
                           _departmentId,@"division_id",
                           _professionId,@"duties_id",
                           self.code.text,@"key",nil];
     [viewModel.registCommand execute:dic] ;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UIViewController  * vc = segue.destinationViewController;
    [vc  setValue:self forKey:@"delegate"];
    if ([segue.identifier isEqualToString:@"department"]) {
        if ([vc  respondsToSelector:@selector(setIsdepartment:)]) {
            [vc  setValue:[NSNumber numberWithBool:YES] forKey:@"isdepartment"];
        }
    }else if ([segue.identifier  isEqualToString:@"profession"]){
        if ([vc  respondsToSelector:@selector(setIsdepartment:)]) {
            [vc  setValue:[NSNumber numberWithBool:false] forKey:@"isdepartment"];
        }
    }
}

- (void)popViewControllerWithTitel:(NSString *)title Id:(NSString *)Id  isdepartment:(BOOL)isdepartment{
    if (isdepartment) {
        self.department.text = title;
        self.department.textColor = [UIColor  darkTextColor];
        _departmentStr = title;
        _departmentId = Id;
    }else{
        self.duty.text = title;
         self.duty.textColor = [UIColor  darkTextColor];
        _professionStr = title;
        _professionId = Id;
    }
}

@end
