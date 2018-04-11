//
//  OpenAPIServices.m
//  ZZKong
//
//  Created by wang_wei on 2017/10/17.
//  Copyright © 2017年 zzk. All rights reserved.
//

#import "OpenAPIServices.h"
#import "JPUSHService.h"
#import "PushInfo.h"
#import <UMSocialCore/UMSocialCore.h>
#import <UMSocialQQHandler.h>
#import <UMSocialCore/UMSocialResponse.h>
#import <UShareUI/UShareUI.h>
#import <UMSocialWechatHandler.h>
#import <UMMobClick/MobClick.h>
#import "DataService.h"
#import "UIViewController+SLHUD.h"

@interface OpenAPIServices()
{
    PushInfo * pInfo;
    NSMutableArray * pInfoArr;
}
@property(nonatomic,strong)UIViewController * viewController;
@end
@implementation OpenAPIServices
+(OpenAPIServices*)shareManager{
    
    static OpenAPIServices *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[OpenAPIServices alloc] init];
    });
    return  _manager;
}
#pragma mark --重写 AppDelegate 的 handleOpenURL 和 openURL 方法
-(BOOL)handleOpenURL:(NSURL *)url sourceApplication:(id)sourceApplication annotation:(id)annotation{
    if (url) {
        NSString * path = [[url absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        GMLog("%@",path);
        NSRange range = [path rangeOfString:@"tencent"];//判断字符串是否包含
        if (range.length >0) {
            NSRange range = [path rangeOfString:@"error=0"];
            NSRange range0 = [path rangeOfString:@"result=complete"];
            if (range.length>0 || range0.length>0) {
                //业务处理
            }
        }
    }
    
 /*   if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    if([url.host isEqualToString:@"pay"]) {
        //调用微信支付sdk
        [WXApi handleOpenURL:url delegate:self];
    }*/
    BOOL  result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        //其他如支付等SDK的回调
    }
    return result;
}
-(BOOL)handleOpenURL:(NSURL *)url{
    if (url) {
        NSString* path =[[url absoluteString] stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        GMLog("%@",path);
        NSRange range = [path rangeOfString:@"tencent"];//判断字符串是否包含
        if (range.length >0){ //包含
            NSRange range = [path rangeOfString:@"error=0"];
            NSRange range1 = [path rangeOfString:@"result=complete"];
            //NSLog(@"1111");
            if (range.length>0 || range1.length>0) {
            }
        }
    }
 /*   if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    if([url.host isEqualToString:@"pay"]) {
        //调用微信支付sdk
        [WXApi handleOpenURL:url delegate:self];
    }*/
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (result == NO) {
        //调用其他SDK，例如新浪微博SDK等
    }
    return result;
    
}
/****************************************************************************************************************
 ****************************************************************************************************************
 ****************************************************************************************************************
                                         ***************  =  ***************
                                         *************** JPUSH ***************
                                         ***************  =  ***************
 ****************************************************************************************************************
 ****************************************************************************************************************
 ****************************************************************************************************************/
#pragma mark-- 极光推送
-(void)initJPushService:(NSDictionary*)launchOptions{
    //判断当前是否能推送
    if (![self isJPushServiceOpen]) {
        return;
    }
    NSNotificationCenter  * defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidSetup:) name:kJPFNetworkDidSetupNotification object:nil];                    //建立链接
    [defaultCenter addObserver:self selector:@selector(networkDidClose:) name:kJPFNetworkDidCloseNotification object:nil];                    //关闭连接
    [defaultCenter addObserver:self selector:@selector(networkDidRegister:) name:kJPFNetworkDidRegisterNotification object:nil];              //注册成功
    [defaultCenter addObserver:self selector:@selector(networkDidLogin:) name:kJPFNetworkDidLoginNotification object:nil];                    //登录成功
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];  //收到自定义消息
    
    [self openJPushService];
    [JPUSHService setupWithOption:launchOptions appKey:APPKEY_JPUSH channel:@"Publish channel" apsForProduction:isPro_JPUSH];
    pInfoArr = [NSMutableArray array];
    //判断程序是不是由推送服务启动的
    if ([[DataService sharedService] isFromAps:launchOptions]) {
        NSDictionary * pushNotificationKey = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        pInfo = [[PushInfo alloc]init];
        pInfo.titleStr = [[pushNotificationKey valueForKey:@"aps"] valueForKey:@"alert"];
        pInfo.t = [pushNotificationKey valueForKey:@"t"];
        pInfo.i = [pushNotificationKey valueForKey:@"i"];
        [self pushAction:NO];
    }
}
#pragma  mark-- close JPush
-(void)closeJPushService{
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    NSUDSetValueWithKey(@"0", @"PushSwitch");
}
#pragma mark -- open JPush
-(void)openJPushService{
    
   [ JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                      UIUserNotificationTypeSound |
                                                      UIUserNotificationTypeAlert )
                                          categories:nil];
    NSUDSetValueWithKey(@"1", @"PushSwitch");
}
#pragma mark -- 获取推送开关状态
-(BOOL)isJPushServiceOpen{
    NSString * string = NSUDGetValueWithKey(@"PushSwitch");
    if ([string isEqualToString:@"0"]) {
        return NO;
    }else{
        return YES;
    }
}
#pragma mark -- 清楚角标缓存
-(void)resetBadge{
    [JPUSHService resetBadge];
}
#pragma mark --   获取token
-(void)registDeviceToken:(NSData*)deviceToken{
    if (deviceToken) {
        [JPUSHService registerDeviceToken:deviceToken];
    }
}
#pragma mark-- 接收到推送消息的处理
-(void)handleRemoteNotification:(NSDictionary*)userInfo appActStatus:(BOOL)appActStatus{
    
    [JPUSHService handleRemoteNotification:userInfo];
    GMLog("Push userInfo:%@",userInfo);
    pInfo = [[PushInfo alloc] init];
    pInfo.titleStr = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
    pInfo.t = [userInfo valueForKey:@"t"];
    pInfo.i  = [userInfo valueForKey:@"i"];
    GMLog("Push Pinfo:%@",pInfo);
    [self pushAction:appActStatus];
}
-(void)pushAction:(BOOL)isShowAlert{
    
    NSString * cancelBtnStr = nil;
    NSString * otherBtnStr = @"知道了";
    if (isShowAlert) {
//        UINavigationController *nav = [(AppDelegate*)[UIApplication sharedApplication].delegate nav];
//        [nav.visibleViewController.view endEditing:YES];
        [pInfoArr addObject:pInfo];
        GMLog("PinfoArr:%@",pInfoArr);
        if (![pInfo.t isEqualToString:@"0"]&&pInfo.t!=nil) {
            cancelBtnStr = @"取消";
            otherBtnStr = @"去看看";
        }
     /*   UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"%@",pInfo.titleStr] preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:cancelBtnStr style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:otherBtnStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        alert.view.tintColor = [UIColor darkTextColor];
        [self presentViewController:alert animated:YES completion:nil];*/
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"湖北日报"
                                                        message:[NSString stringWithFormat:@"%@",pInfo.titleStr]
                                                       delegate:self
                                              cancelButtonTitle:cancelBtnStr
                                              otherButtonTitles:otherBtnStr,nil];
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        alert.tag = 1 ;
        [alert performSelector:@selector(show) withObject:nil afterDelay:0.7];//为了解决某种情况下弹窗不会被点击到

    }else{
        
        [self actionWithInfo];
    }
}
-(void)actionWithInfo{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"closeCamera" object:nil];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
//    UINavigationController *nav = [(AppDelegate*)[UIApplication sharedApplication].delegate nav];
    PushInfo *info = [[PushInfo alloc] init];
    if (pInfoArr.count>0) {
        info = [pInfoArr lastObject];
        
        [pInfoArr removeLastObject];
    }else{
        info = pInfo;
    }
    
    
    
    switch ([info.t integerValue]) {
        case 0:
        {
            //仅仅打开客户端,不做任何处理
            break;
        }
       
        default:
        {
           
            break;
        }
    }
    
}
- (void)networkDidSetup:(NSNotification *)notification {
    GMLog("已连接");
}

- (void)networkDidClose:(NSNotification *)notification {
    GMLog("未连接。。。");
}

- (void)networkDidRegister:(NSNotification *)notification {
    GMLog("已注册");
    
    
    GMLog("[APService registrationID]:%@",[JPUSHService registrationID]);
}

- (void)networkDidLogin:(NSNotification *)notification {
    GMLog("已登录");
    
    
    GMLog("[APService registrationID]:%@",[JPUSHService registrationID]);
}

- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    NSString *title = [userInfo valueForKey:@"title"];
    NSString *content = [userInfo valueForKey:@"content"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    GMLog("%@",[NSString stringWithFormat:@"收到消息\ndate:%@\ntitle:%@\ncontent:%@", [dateFormatter stringFromDate:[NSDate date]],title,content]);
    
}

- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    GMLog("rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //推送框跳转
    if(alertView.tag==1){
        if (buttonIndex == 1) {
            [self actionWithInfo];
        }else{
            [pInfoArr removeLastObject];
        }
        
    }
    
}
/****************************************************************************************************************
****************************************************************************************************************
****************************************************************************************************************
                                      ***************  UM  ***************
                                      *************** SHARE ***************
                                      ***************  SDK  ***************
****************************************************************************************************************
****************************************************************************************************************
****************************************************************************************************************/
#pragma mark -友盟分享
-(void)setUmengAppKey{
    [[UMSocialManager defaultManager] openLog:YES];
    [[UMSocialManager  defaultManager] setUmSocialAppkey:APPKEY_UM];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:APPKEY_WEIXIN appSecret:APPSecret_WEIXIN redirectURL:@"http://mobile.umeng.com/social"];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:APPID_QQ appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];// 
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:APPKEY_SINA appSecret:APPSecret_SINA redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
        //统计&检查更新
    UMConfigInstance.appKey = APPKEY_UM;
    UMConfigInstance.channelId = nil;
    [MobClick startWithConfigure:UMConfigInstance] ;
}
#pragma mark -- 根据平台名，返回平台对象
- (void)setPlatformSSO:(UIViewController*)controller platformName:(UMSocialPlatformType)snsName{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowMBProgressHUD" object:nil];
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:snsName currentViewController:controller completion:^(id result, NSError *error) {
        UMSocialUserInfoResponse * resp = result;
        NSString * message = nil;
        if (error) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HideMBProgressHUD" object:nil];
            if (_delegate&& [_delegate respondsToSelector:@selector(openFailed:)]) {
                [_delegate openFailed:resp];
            }
        }else{
            if ([result isKindOfClass:[UMSocialUserInfoResponse class]]) {
                UMSocialUserInfoResponse * resp  = result;
                if (_delegate&&[_delegate respondsToSelector:@selector(openLoginSucce:snsName:)]) {
                    [_delegate openLoginSucce:resp snsName:snsName];
                }
            }else{
                message = @"Get info fail";
            }
        }
    }];
}
#pragma mark -- UM share data
-(void)shareInfo:(UIViewController *)controller string:(NSString *)_stringURL titleString:(NSString *)_titleString titleImage:(NSString *)image desc:(NSString *)desc infoID:(NSString *)infoID{
     self.viewController = controller;
    //definePlatforms (share UI) @(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_WechatFavorite),,@(UMSocialPlatformType_Sina),@(UMSocialPlatformType_Sms) UMSocialPlatformType_Qzone
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine)] ];
//    [UMSocialUIManager addCustomPlatformWithoutFilted:UMSocialPlatformType_UserDefine_Begin+2 withPlatformIcon:[UIImage imageNamed:@"UMS_copylink_icon"] withPlatformName:@"复制链接"]; //去掉自定义
    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType =
    UMSocialSharePageGroupViewPositionType_Bottom;
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType =
    UMSocialPlatformItemViewBackgroudType_None;
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        if (platformType == UMSocialPlatformType_UserDefine_Begin+2) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIPasteboard * pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = _stringURL;
                [controller showHint:@"复制到剪贴板"];
            });
        }else{
            // create message objc
            UMSocialMessageObject  * messageObject = [UMSocialMessageObject messageObject];
            switch (platformType) {
                case UMSocialPlatformType_Sms:{
                    UMShareSmsObject * shareObjcSms = [[UMShareSmsObject alloc]init];
                    shareObjcSms.smsContent = [NSString stringWithFormat:@"%@\n%@\n来自于计课宝，与您分享",_titleString,_stringURL];
                    messageObject.shareObject = shareObjcSms;
                    break;
                }
                case UMSocialPlatformType_Sina:{
                    messageObject.text = [NSString stringWithFormat:@"%@%@",_titleString,_stringURL];
                    //创建图片内容对象
                    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
                    
                    if (image) {
                        shareObject.thumbImage = image;
                        shareObject.shareImage = image;
                    }
                    else {
                        shareObject.thumbImage = [UIImage imageNamed:@"AppIcon60x60@3x.png"];
                        shareObject.shareImage = [UIImage imageNamed:@"AppIcon60x60@3x.png"];
                    }
                    messageObject.shareObject = shareObject;
                    break;
                }
                default:{
                    UMShareWebpageObject *shareObject;
                    if (!image) {
                        shareObject = [UMShareWebpageObject shareObjectWithTitle:_titleString descr:desc thumImage:[UIImage imageNamed:@"AppIcon60x60@3x.png"]];
                    }
                    else {
                        shareObject = [UMShareWebpageObject shareObjectWithTitle:_titleString descr:desc thumImage:image];
                    }
                    shareObject.webpageUrl = _stringURL;
                    
                    messageObject.shareObject = shareObject;
                    break;
                }
            }
            [[UMSocialManager  defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:controller completion:^(id result, NSError *error) {
                if (error) {
                    UMSocialLogInfo(@"************Share fail with error %@*********",error);
                }else{
                    if ([result isKindOfClass:[UMSocialShareResponse class]]) {
                        UMSocialShareResponse * resp = result;
                        //分享结果消息
                        UMSocialLogInfo(@"response message is %@",resp.message);
                        //第三方原始返回的数据
                        UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                    }else{
                        UMSocialLogInfo(@"response data is %@",result);
                    }
                    [self alertWithError:error];
                }
            }];
        }
        
    }];
    
}

#pragma mark -- 快捷分享
- (void)shareDetailsInfo: (UIViewController*)controller info:(NSDictionary *)info paras:(NSDictionary *)parasparas infoID:(NSString*)infoID {
    
/*    UIImage *shareImage = nil;
    UIImage *sinaShareImage = nil;
    if (info.pics.count == 0) {
        shareImage = [UIImage imageNamed:@"AppIcon60x60@3x.png"];
     }else if (info.pics.count>0) {
        Picture *pic = info.pics[0];
        NSData *shareImgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:pic.u]];
        shareImage = [UIImage imageWithData:shareImgData];
        sinaShareImage = [UIImage imageWithData:shareImgData];
    }
    UMSocialPlatformType platformType;
    if ([parasparas[@"type"] isEqualToString:@"wx"]) {
        platformType = UMSocialPlatformType_WechatSession;
    }
    if ([parasparas[@"type"] isEqualToString:@"pyq"]) {
        platformType = UMSocialPlatformType_WechatTimeLine;
    }
    if ([parasparas[@"type"] isEqualToString:@"wb"]) {
        platformType = UMSocialPlatformType_Sina;
    }
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    if (platformType == UMSocialPlatformType_Sina) {
        
        messageObject.text = [NSString stringWithFormat:@"%@%@",info.title,info.shareurl];
        //创建图片内容对象
        UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
        if (shareImage) {
            shareObject.thumbImage = shareImage;
            shareObject.shareImage = shareImage;
        }
        else {
            shareObject.thumbImage = [UIImage imageNamed:@"AppIcon60x60@3x.png"];
            shareObject.shareImage = [UIImage imageNamed:@"AppIcon60x60@3x.png"];
        }
        messageObject.shareObject = shareObject;
    }
    else
    {
        UMShareWebpageObject *shareObject;
        if (!shareImage) {
            shareObject = [UMShareWebpageObject shareObjectWithTitle:info.title descr:info.desc thumImage:[UIImage imageNamed:@"AppIcon60x60@3x.png"]];
        }
        else {
            shareObject = [UMShareWebpageObject shareObjectWithTitle:info.title descr:info.desc thumImage:shareImage];
        }
        //UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:info.title descr:info.desc thumImage:shareImage];
        shareObject.webpageUrl = info.shareurl;
        messageObject.shareObject = shareObject;
    }
    
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:controller completion:^(id data, NSError *error) {
        
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                [self backCall];
            }
            else {
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        [self alertWithError:error];
    }];*/
}
- (void)alertWithError:(NSError *)error{
    NSString *result = nil;
    if (!error) {
        result = [NSString stringWithFormat:@"分享成功"];
    }else{
        NSMutableString *str = [NSMutableString string];
        if (error.userInfo) {
            for (NSString *key in error.userInfo) {
                [str appendFormat:@"%@ = %@\n", key, error.userInfo[key]];
            }
        }
        if (error) {
            if ((int)error.code == 2009){
                result = [NSString stringWithFormat:@"取消分享"];
            }else{
                result = [NSString stringWithFormat:@"分享失败"];
            }
        }
        else{
            result = [NSString stringWithFormat:@"分享失败"];
        }
    }
    [self.viewController showHint:result];
}
@end













