//
//  TJY_LoginViewController.m
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/13.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import "TJY_LoginViewController.h"
#import "TJY_HomePageViewModel.h"
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
