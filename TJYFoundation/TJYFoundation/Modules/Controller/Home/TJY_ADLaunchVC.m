//
//  TJY_ADLaunchVC.m
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/11.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import "TJY_ADLaunchVC.h"
#import "Picture.h"
#import "ButtonView.h"
#import "LadderView.h"
#import <SDWebImageManager.h>
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
    NSDictionary *dic = NSUDGetUserStartAd;
    NSError *err = nil;
//    _adResInfo = [[ResInformation alloc] initWithDictionary:dic error:&err];
//    _url = _adResInfo.args.url;
//    Picture *pic = (Picture*)_adResInfo.pics[0];
    _picurl = [[[Picture  alloc] init] u];
    
    if(_picurl){
        
        float bottomHeight = [ImageServices ssCGRectMake:0 y:0 width:10 height:ADBSPACE_H].size.height;
        //NSLog(@"iamgeSize:%f-%f",loadImage.size.width,loadImage.size.height);
        CGRect imageViewRect = CGRectMake(0, 0, SCREEN_W, SCREEN_H-bottomHeight);
        
        UIImageView *loadingView = [[UIImageView alloc] initWithFrame:imageViewRect];
        loadingView.contentMode = UIViewContentModeScaleAspectFill;
        loadingView.userInteractionEnabled = YES;
        loadingView.clipsToBounds  = YES;
        loadingView.alpha = 0.f;
        
        ButtonView *btnView = [[ButtonView alloc]init];
        btnView.frame = CGRectMake(loadingView.frame.size.width - 74 - 15, 20, 74, 27);
        btnView.backgroundColor = [UIColor colorWithRed:((float)((0x000000 & 0xff0000) >> 16))/255.0 green:((float)((0x000000 & 0x00ff00) >> 8))/255.0 blue:((float)(0x000000 & 0x0000ff))/255.0 alpha:0.8];
        btnView.layer.cornerRadius = 13.5;
        btnView.layer.borderColor = [UIColor colorWithRed:((float)((0xcccccc & 0xff0000) >> 16))/255.0 green:((float)((0xcccccc & 0x00ff00) >> 8))/255.0 blue:((float)(0xcccccc & 0x0000ff))/255.0 alpha:0.3].CGColor;
        btnView.layer.borderWidth = 1.0f;
        btnView.layer.masksToBounds = YES;
        [loadingView addSubview:btnView];
        [btnView overBlock:^{
            NSLog(@"倒计时完毕");
            [self timerFired];
        }];
        
        NSDate *startDate = [NSDate date];
        NSURL *imgUrl = [NSURL URLWithString:[ImageServices imageUrlFromServer:_picurl width:loadingView.width height:loadingView.height]];
        NSLog(@"loadAD Str:%@",imgUrl.description);
        __block  BOOL  _isInCache;
        [[SDWebImageManager  sharedManager] diskImageExistsForURL:imgUrl completion:^(BOOL isInCache) {
            _isInCache = isInCache;
        }];
        if (!_isInCache && onlyLocal) {
            [self timerFired];
        }else{
            @weakify(self);
            [loadingView sd_setImageWithURL:imgUrl placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                @strongify(self);
                NSTimeInterval starTimeInterval = [startDate timeIntervalSinceDate:[NSDate date]];
                NSLog(@"Loading AD_Sec:%f--%@--%@",fabs(starTimeInterval),self->_url,error);
                if (!error) {
                    [self->loadTimer invalidate];
                    if (self->_url && self->_url.length > 0) {
                        
                        LadderView *ladderView = [[LadderView alloc]init];
                        ladderView.backgroundColor = [UIColor clearColor];
                        ladderView.frame = CGRectMake(loadingView.frame.size.width - 68, loadingView.frame.size.height - 19, 69, 19);
                        [loadingView addSubview:ladderView];
                        
                        UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(adBtnAction:)];
                        [loadingView addGestureRecognizer:singleTap1];
                    }
                    
                    [self.view addSubview:loadingView];
                    [UIView animateWithDuration:.3f animations:^{
                        loadingView.alpha = 1.f;
                        
                    } completion:^(BOOL finished) {
                        NSTimer *showTimer = [NSTimer scheduledTimerWithTimeInterval:2.5f target:self selector:@selector(timerFired) userInfo:nil repeats:NO];
                    }];
                }else{
                    [self timerFired];
                }
            }];
        }
    }else{
        [self timerFired];
    }
}
-(void)adBtnAction:(id)sender{
    
    
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
       [[[TJY_RequestServiceManager  alloc] initWithDelegate:self] cancel];
        [self setAdvImage:YES];
    }else{
        NSLog(@"222");
        [self timerFired];
    }
}

- (void)timerFired {
    NSLog(@"timefied");
    [self  dismissViewControllerAnimated:YES completion:nil];
    [[[TJY_RequestServiceManager  alloc] initWithDelegate:self] cancel];
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
