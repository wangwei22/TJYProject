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
#import <YYLabel.h>
#import <YYTextLine.h>
@interface TJY_RegistViewController ()<TJY_InfoListViewControllerDelegate,TJY_RequestServiceManagerDelegate>
{
    NSString  * _departmentStr;
    NSString  * _departmentId;
    NSString *  _professionStr;
    NSString *  _professionId;
    BOOL  _agreeClick;
}
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *telphone;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *code;
@property (weak, nonatomic) IBOutlet UILabel *department;
@property (weak, nonatomic) IBOutlet UILabel *duty;
@property (weak, nonatomic) IBOutlet UILabel *lbl;
@property (weak, nonatomic) IBOutlet UIButton *submit;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet UIImageView *check;
@end

@implementation TJY_RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"注册";
    [self  textFieldPlaceholderColorWithTextField:self.name];
     [self  textFieldPlaceholderColorWithTextField:self.telphone];
     [self  textFieldPlaceholderColorWithTextField:self.password];
     [self  textFieldPlaceholderColorWithTextField:self.code];
     YYLabel *label = [[YYLabel alloc]init];
    [self.view addSubview:label];
    [label  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.lbl);
    }];
    NSString  * yy_text = @"我已阅读并同意遵守用户协议";
    NSMutableAttributedString  *  text = [[NSMutableAttributedString  alloc] initWithString:@"我已阅读并同意遵守用户协议"];
    text.underlineStyle = NSUnderlineByWord;
    NSRange  ranges = [yy_text  rangeOfString:@"用户协议"];
    [text  setTextUnderline:[YYTextDecoration  decorationWithStyle:YYTextLineStyleSingle] range:ranges];
    [text  setTextHighlightRange:ranges color:ssRGBHex(0x0080ff) backgroundColor:ssRGBHex(0x222222) tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        GMLog("....click");
    }];
    label.attributedText = text;
    @weakify(self);
    [[self.agreeBtn  rac_signalForControlEvents: UIControlEventTouchUpInside]  subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        self->_agreeClick = !self->_agreeClick;
        if (self->_agreeClick) {
            self.check.image = [UIImage imageNamed:@"unchecked"];
        }else{
              self.check.image = [UIImage imageNamed:@"check"];
        }
        GMLog("-----%@",x);
    }];
}
- (IBAction)submit:(UIButton *)sender {
    if (_agreeClick) {
        [self  showHint:@"需要遵守用户协议"];
        return;
    }
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
   RACSignal  * sours =   [viewModel.registCommand execute:dic];
    @weakify(self);
    [sours  subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self  showHint:[x objectForKey:@"msg"]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController  popViewControllerAnimated:YES];
        });
    } error:^(NSError * _Nullable error) {
            [self  showHint: [error.userInfo objectForKey:@"customErrorInfoKey"] ] ;
    }];
    
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
