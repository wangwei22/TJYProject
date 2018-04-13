//
//  TJY_MainViewController.m
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/12.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import "TJY_MainViewController.h"
#import "TJY_HomeViewController.h"

@interface TJY_MainViewController ()
{
     TJY_HomeViewController * homeVC;
      TJY_HomeViewController * homeVC1;
      TJY_HomeViewController * homeVC2;
      TJY_HomeViewController * homeVC3;
     NSInteger                 _temp;
     NSInteger                 _menuIndex;
}
@end

@implementation TJY_MainViewController

-(instancetype)init{
    if (self = [super init]) {
        //需要强行切换Tab页时的通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(switchTab:) name:@"switchTab" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(backHome:) name:@"backHome" object:nil];
    }
    return  self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = COLOR_NAV_BG;
    self.view.frame = CGRectMake(0,0, SCREEN_W, SCREEN_H);
    
    [self classButton];
}


//需要强行切换Tab页
- (void)switchTab:(NSNotification *)notify{
    int  tabIndex = [[notify object] intValue];
    if (tabIndex !=0) {
    }
      [_mainMenuView setTabSelected:tabIndex];
}
- (void)backHome:(NSNotification *)notify{
    [_mainMenuView setTabSelected:0];
//    [theNewsVC backToTheFirstTopic];
}
#pragma mark -下菜单栏
- (void)classButton{
    _mainMenuView = [[MainMenuView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-MENU_H, self.view.frame.size.width, MENU_H) delegate:self];
    _mainMenuView.backgroundColor = ssRGBHex(0xf6f6f6);
    [self.view addSubview:_mainMenuView];
    
    
    NSLog(@"selfv:%f",self.view.frame.size.width);
}
- (void)selectMenu{
    if (_mainMenuView) {
        [_mainMenuView selectorMenuButton];
    }
}

- (NSString*)setMenuTag{
    NSString* _tag=nil;
    if (_mainMenuView) {
        _tag = [_mainMenuView setMenuTag];
    }
    return _tag;
}

- (void)selectorMenu:(NSInteger)idx selected:(BOOL)selected{
    _temp = _menuIndex;
    _menuIndex = idx;
    
    if (idx == 0) {
//        [self initNewsView:selected];
    }
    else if(idx ==1){
        [self initDisclose:selected];
    }
    else if(idx == 2){
//        [self initPoliticsListVC:selected];
    }
    else if(idx == 3){
//        [self initPaper:selected];
        //        _menuIndex = _temp;
    }else if (idx == 4){
//        [self initActivities:selected];
    }
    
    [self.view bringSubviewToFront:_mainMenuView];
}



//上头条
- (void)initDisclose:(BOOL)selected{
    if (!homeVC) {
        homeVC = [[TJY_HomeViewController alloc]init];
    }
    homeVC.view.frame = CGRectMake(0, STATUSBAR_H, SCREEN_W, SCREEN_H-STATUSBAR_H);
    [homeVC1    .view removeFromSuperview];
    [homeVC2.view removeFromSuperview];
    [homeVC3.view removeFromSuperview];

    [self.view addSubview:homeVC.view];
    if (selected) {
//        [disclose refreshTableView];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [self.navigationController.navigationBar setHidden:YES];
    if (_menuIndex == 0) {
        if (homeVC) {
            [homeVC viewDidDisappear:YES];
        }
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_menuIndex == 0) {
        if (homeVC) {
            [homeVC viewDidDisappear:YES];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:NO];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (_menuIndex == 0) {
        if (homeVC) {
            [homeVC viewDidDisappear:YES];
        }
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
