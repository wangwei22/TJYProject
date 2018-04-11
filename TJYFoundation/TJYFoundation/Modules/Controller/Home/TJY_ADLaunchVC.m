//
//  TJY_ADLaunchVC.m
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/11.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import "TJY_ADLaunchVC.h"

@interface TJY_ADLaunchVC ()
{
    NSString* _url;
    NSString* _picurl;
    BOOL isImgUrlDown;
    NSTimer *loadTimer;
}
@end

@implementation TJY_ADLaunchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    isImgUrlDown = NO;
    _url = @"";
    _picurl = @"";
    [self creationLogo];
    // Do any additional setup after loading the view.
}
- (void)setAdvImage:(BOOL)onlyLocal{
    
    
}
//创建默认logo启动页
- (void)creationLogo{
    
    UIImageView *bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    if(ssiPhone5) {
        bgImage.image = [UIImage imageNamed:@"LaunchImage-700-568h"];
    }else if (ssiPhone6) {
        bgImage.image = [UIImage imageNamed:@"LaunchImage-800-667h"];
    }else if (ssiPhone6plus) {
        bgImage.image = [UIImage imageNamed:@"LaunchImage-800-Portrait-736h"];
    }else {
        bgImage.image = [UIImage imageNamed:@"LaunchImage-700"];
    }
    [self.view addSubview:bgImage];
    
    loadTimer = [NSTimer scheduledTimerWithTimeInterval:AD_LOADING_SEC target:self selector:@selector(stoploading) userInfo:nil repeats:NO];
//    _requestServices = [[RequestServices alloc] initWithDelegate:self];
//    [_requestServices getListAdNews:0];
    //[[RequestServices sharedInstance:self] getListAdNews:0];
}
- (void)stoploading {
    NSLog(@"stoploading");
    if (!isImgUrlDown) {
        NSLog(@"111");
//        [_requestServices cancel];
        [self setAdvImage:YES];
    }else{
        NSLog(@"222");
        [self timerFired];
    }
}

- (void)timerFired {
    NSLog(@"timefied");
//    [self skipPanFrom];
//    [_requestServices cancel];
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
