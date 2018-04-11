//
//  TJY_BaseViewController.m
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/9.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import "TJY_BaseViewController.h"

@interface TJY_BaseViewController ()

@end

@implementation TJY_BaseViewController
@synthesize titleView;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
    
    self.view.backgroundColor = [UIColor colorWithHex:0xf6f6f6];
    titleView = [[NavTitleView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, MyNavHeight+STATUSBAR_H)];
      [titleView.backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addObserver:self forKeyPath:@"title" options:0 context:NULL];
    if ( self.navigationController.viewControllers.count>1) {
        titleView.backBtn.hidden = false;
    }else{
        titleView.backBtn.hidden = YES;
    }
    GMLog("%ld---lk",self.navigationController.viewControllers.count);
    [self.view insertSubview:titleView atIndex:0];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    titleView.titleLabel.text = self.title;
}

- (void)back:(id)sender {
    if (_backClicked != nil) {
        _backClicked();
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super  viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super  viewDidDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

-(void)dealloc{
    [titleView removeObserver:self forKeyPath:@"title"];
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
