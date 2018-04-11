//
//  DataService.h
//  HubeiMobileNews
//
//  Created by sunnysnake on 15/5/22.
//  Copyright (c) 2015年 cnhubei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataService : NSObject


+ (DataService*)sharedService;

//全国省市区信息
@property (nonatomic, retain) NSArray *gProvinceCityDistrictData;

#pragma mark - 数据相关

/**
 *  指定设备兼容数值
 *
 *  @param ip4s
 *  @param ip5
 *  @param ip6
 *  @param ip6p
 *
 *  @return 返回对应设备数值
 */
+(float)deviceCompatibleNums:(float)ip4s ip5:(float)ip5 ip6:(float)ip6 ip6p:(float)ip6p;

/**
 *  根据当前设备与ip6的宽度比例返回值
 *
 *  @param num
 *
 *  @return 等比返回
 */
+(float)deviceCompatibleNumsWithScale:(float)num;
/**
 *  新闻列表字体
 *
 *  @return 新闻列表字体
 */
+ (UIFont *)newsFont;
/**
 *  新闻栏目字体
 *
 *  @return 新闻栏目字体
 */
+ (UIFont *)newsMenuFont;
/**
 *  判断是否第一次运行
 *
 *  @return 是否
 */

#pragma mark - 用户相关


- (BOOL)isFirstStart;

/**
 *  判断程序是不是由推送服务启动的
 *  @param launchOptions
 *  @return 是否
 */
-(BOOL)isFromAps:(NSDictionary*)launchOptions;

/**
 *  获取md5后的uuid（同TID）
 *
 *  @return 获取md5后的uuid
 */
- (NSString*)getUUID;


/**
 *  清除本地证书
 */
-(void)clearCert;
/**
 *  时间格式转换
 *
 *  @param pubString yyyy-MM-dd HH:mm:ss
 *
 *  @return 昨天，今天，时间
 */
+(NSString *)intervalSinceNow: (NSString *) pubString;
/**
 *  时间格式转换:只显示年月日
 *
 *  @param pubString yyyy-MM-dd HH:mm:ss
 *
 *  @return yyyy-MM-dd
 */
+(NSString *)timeYearMonthDay: (NSString *) pubString;
/**
 *  时间格式转换
 *
 *  @param pubString yyyy-MM-dd HH:mm:ss
 *
 *  @return **分钟前，**小时前，时间
 */
+(NSString *)intervalSinceNowForReview: (NSString *) pubString;

/**
 *  图文直播页面时间格式转换
 *
 *  @param pubString yyyy-MM-dd HH:mm:ss
 *
 *  @return HH:MM 或者如果不是当天则统一用YY-MM-DD表示
 */
+(NSString *)intervalSinceNowForPhotoLive: (NSString *) pubString;

/*!
 *  格式化时间
 *
 *  @param pubString yyyy-MM-dd HH:mm:ss
 *
 *  @return MM-dd HH:mm
 */
+(NSString *)formatDate: (NSString *) pubString;
/*!
 *  格式化时间
 *
 *  @param pubString    yyyy-MM-dd HH:mm:ss
 *  @param formatString 格式化样式 (例如:yyyy年MM月dd日 HH;mm:ss = 2015年06月04日 20:00:00)
 *
 *  @return formatString
 */
+(NSString *)formatDate: (NSString *) pubString formatString:(NSString *)formatString;

/*
 *  格式化时间
 *
 *  @param date 当前时间
 *
 *  @return yyyy-MM-dd HH:mm:ss
 */
+ (NSString *)dateToString:(NSDate *)date;

/*
 *  格式化时间
 *
 *  @param number评论数或者点赞数
 *
 *  @return     <10000 显示实际值，例如4876
                >=10000 显示 x.x万，例如评论数为13768，则显示为1.3万
                >=100000 显示 xx万, 最高99万
 */
+ (NSString *)numberToString:(int)number;
/*
 *  格式化数字
 *
 *  @param number爆料评论数或者点赞数
 *
 *  @return     上头条模块中评论和点赞数量显示实际数值，大于等于100000时，显示99999+。
 */
+ (NSString *)formatNumber:(int)number;

/*
 *  视频时间
 *
 *  @param totalTime视频秒数
 *
 *  @return  xx:xx  xx分钟xx秒
 */
+ (NSString *)videoTimeToString:(double)totalTime;
#pragma mark - 缓存相关

/**
 *  清除缓存
 */
+ (void)cleanCache;

/**
 *  计算程序缓存大小
 */
+ (float)calculateCache;

/**
 *  获取缓存中类别
 *
 *  @param categoriesType key
 *
 *  @return 列表
 */
+ (NSArray *)getCategories:(NSString*)categoriesType;

/**
 *  保存类别至缓存
 *
 *  @param categories     categories
 *  @param categoriesType categoriesType
 */
+ (void)saveCategories:(NSArray *)categories categoriesType:(NSString*)categoriesType;

/**
 *  获取新闻
 *
 *  @param catID          catID
 *  @param categoriesType categoriesType
 *
 *  @return return value description
 */
+ (NSDictionary *)getArticles:(long long)catID categoriesType:(NSString*)categoriesType;

/**
 *  保存新闻至缓存
 *
 *  @param articles       articles
 *  @param catID          catID
 *  @param categoriesType categoriesType
 */
+ (void)saveArticlesList:(NSDictionary *)articles catID:(long long)catID categoriesType:(NSString*)categoriesType;
/*!
 *  获取活动缓存
 *
 *  @return 活动数据集合
 */
+ (NSDictionary *)getActivities;
/*!
 *  保存活动至缓存
 *
 *  @param activities 活动数据集合
 */
+ (void)saveActivities:(NSDictionary *)activities;
/*!
 *  获取上头条缓存
 *
 *  @param itemID 上头条分类 1.热点 2.爆料 3.我秀
 *
 *  @return 上头条数据缓存
 */
+ (NSDictionary *)getDisclose:(NSString *)itemID;
/*!
 *  保存上头条至缓存
 *
 *  @param discloses 上头条数据集合
 *  @param itemID    上头条分类 1.热点 2.爆料 3.我秀
 */
+ (void)saveDisclose:(NSDictionary *)discloses itemID:(NSString *)itemID;

#pragma mark - 地理信息相关
//+(NSString*)code2city:(NSString*)codeStr;
//+(NSString*)city2code:(NSString*)cityStr;
//获取区的位置编码
+(NSString*)convertNameToCode:(NSString *)province city:(NSString *)city district:(NSString *)district;
//通过省市区编码获取省市区名称
-(NSString*)convertCodeToName:(NSString *)code;

//手机号码验证
-(BOOL)isValidateMobile:(NSString *)mobile;
//邮政编码验证
- (BOOL)isValidPostcode:(NSString *)postcode;

/*
 *  获取html模板正则表达式
 *
 *  用于进入新闻详情页时，用服务端的数据填充html模板中的数据
 *
 *  @return html模板正则表达式
 */
+ (NSString *)getHtmlRegex;
@end
