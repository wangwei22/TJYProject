//
//  OpenAPIServices.h
//  ZZKong
//
//  Created by wang_wei on 2017/10/17.
//  Copyright © 2017年 zzk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UMSocialCore/UMSocialCore.h>


@protocol OpenAPIServicesDelegate<NSObject>
@optional
-(void)shareSuccess;
- (void)openLoginSucce:(UMSocialUserInfoResponse *)userData snsName:(UMSocialPlatformType)snsName;
//第三方登录失败
- (void)openFailed:(UMSocialUserInfoResponse *)response;
@end


@interface OpenAPIServices : NSObject
@property(nonatomic,weak)id<OpenAPIServicesDelegate>delegate;
+(OpenAPIServices*)shareManager;
#pragma mark -极光推送
-(void)initJPushService:(NSDictionary*)launchOptions;
-(void)registDeviceToken:(NSData*)deviceToken;
- (void)handleRemoteNotification:(NSDictionary *)userInfo appActStatus:(BOOL)appActStatus;
-(void)openJPushService;
-(void)closeJPushService;
-(void)resetBadge;
-(BOOL)isJPushServiceOpen;

# pragma mark -- UM Share
/**
 *  设置友盟分享,统计
 */
-(void)setUmengAppKey;
/**
 *  根据平台名，返回平台对象
 *
 *  @param controller 控制器
 *  @param snsName    社交平台名称
 */
- (void)setPlatformSSO:(UIViewController*)controller platformName:(UMSocialPlatformType)snsName;
/**
 *  判断此平台是否授权，并且token没有过期
 *
 *  @param snsName 社交平台名称
 *
 *  @return 是否过期
 */
//- (BOOL)isOauthAndTokenNotExpired:(NSString*)snsName;
/**
 *  请求解除授权
 *
 *  @param snsName 社交平台名称
 */
//- (void)requestUnOauthWithType:(UMSocialUserInfoResponse *)snsName;
/**
 *  包括各平台的uid和accestoken，各个平台不一样，腾讯微博有openid。得到的数据在回调Block对象形参respone的data属性。
 *
 *  @param snsName 社交平台名称
 */
//- (void)requestSnsInformation:(UMSocialPlatformType)snsName;

/**
 *  信息分享
 *
 *  @param controller   控制器 self
 *  @param _stringURL   分享链接
 *  @param _titleString 分享标题
 *  @param image        分享图片
 *  @param desc         描述
 */
- (void)shareInfo: (UIViewController*)controller string:(NSString*)_stringURL titleString:(NSString *)_titleString titleImage:(NSString *)image desc:(NSString*)desc infoID:(NSString*)infoID;
- (BOOL)handleOpenURL:(NSURL *)url;
- (BOOL)handleOpenURL:(NSURL *)url sourceApplication:sourceApplication annotation:annotation;

/**
 *  快捷分享
 *
 *  @param controller   控制器 self
 *  @param info         分享信息
 *  @param parasparas   方法名称(用于判断相关事件,如:微信,朋友圈,微博)
 */
- (void)shareDetailsInfo: (UIViewController*)controller info:(NSDictionary *)info paras:(NSDictionary *)parasparas infoID:(NSString*)infoID;
@end
