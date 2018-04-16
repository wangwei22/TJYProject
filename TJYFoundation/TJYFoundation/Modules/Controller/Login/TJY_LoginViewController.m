//
//  TJY_LoginViewController.m
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/13.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import "TJY_LoginViewController.h"
#import "TJY_HomePageViewModel.h"
#import "TJY_UserApplication.h"
@interface TJY_LoginViewController ()
{
        TJY_HomePageViewModel * model;
}
@property (weak, nonatomic) IBOutlet UITextField *telphone;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end

@implementation TJY_LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    GMLog("tabBarHeight %f",self.tabBarController.tabBar.frame.size.height);
    self.titleView.hidden = YES;
    [self textFieldPlaceholderColorWithTextField:self.telphone];
    [self textFieldPlaceholderColorWithTextField:self.password];
}
- (IBAction)submit:(id)sender {
    [self.view  endEditing: YES];
    NSString* wrongMsg = nil;
    if (![NSString  valiMobile:self.telphone.text]){
        wrongMsg = @"手机号码格式不正确";
        [self  showHint:wrongMsg];
        return ;
    } else if ([NSString  isBlankString:self.password.text] ){
        wrongMsg = @"请输入密码";
        [self  showHint:wrongMsg];
        return;
    }
    TJY_HomePageViewModel  * model = [TJY_HomePageViewModel  new];
 //   NSString  * authPwd = [[@"tijianbao" stringByAppendingString:self.password.text] stringFromMD5];
    NSDictionary  * dic = [NSDictionary  dictionaryWithObjectsAndKeys:self.telphone.text,@"per_mobile",
                           self.password.text,@"password",nil];
    RACSignal  * sours = [model.LoginCommand  execute:dic];

    [sours  subscribeNext:^(id  _Nullable x) {
        [[TJY_UserApplication  shareManager] setLoginUser:x];
        KPostNotification(KNotificationLoginStateChange, @YES);
    } error:^(NSError * _Nullable error) {
        [self  showHint: [error.userInfo objectForKey:@"customErrorInfoKey"] ] ;
    }];
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
