//
//  DataService.m
//  HubeiMobileNews
//
//  Created by sunnysnake on 15/5/22.
//  Copyright (c) 2015年 cnhubei. All rights reserved.
//

#import "DataService.h"
static DataService *_dataService = nil;

@interface DataService (){
    
}

@end

@implementation DataService

+ (DataService*)sharedService{
    @synchronized(self){
        if(!_dataService){
            _dataService = [[DataService alloc] init];
        }
    }
    return _dataService;
}

- (BOOL)isFirstStart{
    
    BOOL isF = [[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"];
    
    if(!isF){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStart"];
    }

    return isF;
}

-(BOOL)isFromAps:(NSDictionary*)launchOptions{
    if (launchOptions) {
        NSDictionary* pushNotificationKey = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (pushNotificationKey) {
            
            if ([pushNotificationKey objectForKey:@"aps"]!=NULL) {
                return YES;
            }else{
                return NO;
            }

            
        }else{
            return NO;
        }
    }else{
        return NO;
    }
    
}
- (NSString*)getUUID{
    return UUID;
}
//清除本地证书
-(void)clearCert{
    
    NSUDSetValueWithKey(@"", @"app_dc");
    GMLog("Cert Clear:%@",NSUDGetValueWithKey(@"app_dc"));
}

+(NSString *)intervalSinceNow: (NSString *) pubString
{
    NSArray *array = [pubString componentsSeparatedByString:@"."];
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSDate* endDate = [NSDate date];
    NSDate* startDate = [dateFormat dateFromString:array[0]];
    
    //读取服务器返回的时间
    double seconds = [NSUDGetValueWithKey(@"app_time") doubleValue];
    NSDate *nowDate = [NSDate dateWithTimeIntervalSince1970:seconds/(double)1000.0];
    //计算第一天0点时间
    NSUInteger flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
    | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *parts = [[NSCalendar currentCalendar] components:flags fromDate:nowDate];
    [parts setHour:0];
    [parts setMinute:0];
    [parts setSecond:0];
    NSDate *beginningDay = [[NSCalendar currentCalendar] dateFromComponents:parts];
    
    
    NSTimeInterval timeInterval = [startDate timeIntervalSince1970];
    NSTimeInterval timeIntervalNow = [beginningDay timeIntervalSince1970];
    
    NSTimeInterval cha = timeInterval - timeIntervalNow;
    
    if (cha >= 0) {
        return @"今日";
    } else {
        NSString *dayString;
        
        if (fabs(cha) <= 86400.0) {
            dayString = @"昨日";
        } else {
            [dateFormat setDateFormat:@"MM-dd"];
            dayString = [dateFormat stringFromDate:startDate];
        }
        return dayString;
    }
}
/**
 *  时间格式转换
 *
 *  @param pubString yyyy-MM-dd HH:mm:ss
 *
 *  @return 昨天，今天，时间
 */
+(NSString *)timeYearMonthDay: (NSString *) pubString
{
    NSString *dayString = [[pubString componentsSeparatedByString:@" "] objectAtIndex:0];
    return dayString;
}

+(NSString *)intervalSinceNowForReview: (NSString *) pubString
{
    NSArray *array = [pubString componentsSeparatedByString:@"."];
    NSDateFormatter *dataFormatter = [[NSDateFormatter alloc] init];
    [dataFormatter setTimeZone:[NSTimeZone localTimeZone]];
        [dataFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dataFormatter dateFromString:array[0]];
    
    //读取服务器返回的时间
    double seconds = [NSUDGetValueWithKey(@"app_time") doubleValue];
    
    const static NSTimeInterval oneDay = 24.0*3600.0;
    const static NSTimeInterval oneHour = 3600.0;
    const static NSTimeInterval oneMinute = 60.0;
    NSTimeInterval sub = fabs([date timeIntervalSince1970] - seconds/1000);
    if (sub < oneMinute) {
        return @"刚刚";
    } else if (sub < oneHour) {
        return [NSString stringWithFormat:@"%d分钟前",(int)(sub/oneMinute)];
    } else if (sub < oneDay) {
        return [NSString stringWithFormat:@"%d小时前",(int)(sub/oneHour)];
    } else {
        return [[pubString componentsSeparatedByString:@" "] objectAtIndex:0];
    }
}

+(NSString *)intervalSinceNowForPhotoLive:(NSString *)pubString
{
    NSArray *array = [pubString componentsSeparatedByString:@"."];
    NSDateFormatter *dataFormatter = [[NSDateFormatter alloc] init];
    [dataFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dataFormatter setDateFormat:@"yy-MM-dd HH:mm:ss"];
    NSDate *date = [dataFormatter dateFromString:array[0]];
    
    
    NSDate *today = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: today];
    NSDate *localeDate = [today  dateByAddingTimeInterval: interval];
    
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[localeDate description] substringToIndex:10];
    NSString * dateString = [[date description] substringToIndex:10];
    
    if ([dateString isEqualToString:todayString]){
        [dataFormatter setDateFormat:@"HH:mm"];
        NSString *  locationString=[dataFormatter stringFromDate:date];
        return locationString;
    }else{
        [dataFormatter setDateFormat:@"yy-MM-dd"];
        NSString *  locationString=[dataFormatter stringFromDate:date];
        return locationString;
    }
    
//    //读取服务器返回的时间
//    double seconds = [NSUDGetValueWithKey(@"app_time") doubleValue];
//    
//    const static NSTimeInterval oneDay = 24.0*3600.0;
//    NSTimeInterval sub = fabs([date timeIntervalSince1970] - seconds/1000);
//    if (sub < oneDay) {
//        [dataFormatter setDateFormat:@"HH:mm"];
//        NSString *  locationString=[dataFormatter stringFromDate:date];
//        return locationString;
//    } else {
//        return [[pubString componentsSeparatedByString:@" "] objectAtIndex:0];
//    }
  
}

+(NSString *)formatDate:(NSString *)pubString {
    return [DataService formatDate:pubString formatString:@"MM-dd HH:mm"];
}

+(NSString *)formatDate:(NSString *)pubString formatString:(NSString *)formatString {
    NSArray *array = [pubString componentsSeparatedByString:@"."];
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* newDate = [dateFormat dateFromString:array[0]];
    [dateFormat setDateFormat:formatString];
    NSString *dateString =[dateFormat stringFromDate:newDate];
    //NSLog(dateString);
    return dateString;
}

+ (NSString *)dateToString:(NSDate *)date {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}


//评论和点赞数规制
+ (NSString *)numberToString:(int)number {
    if (number < 10000) {
        return [NSString stringWithFormat:@"%d",number];
    } else if (number >= 10000 && number < 100000) {
        double s = (double)number/10000;
        NSString *string = [NSString stringWithFormat:@"%0.1f",s];
        if ([string integerValue] >= 10) {
            return [NSString stringWithFormat:@"%0.0f万",s];
        }
        return [NSString stringWithFormat:@"%0.1f万",s];
    } else {
        double n = (double)number/10000;
        if (n > 99) {
            n = 99;
        }
        return [NSString stringWithFormat:@"%0.0f万",n];
    }
}

+ (NSString *)formatNumber:(int)number {
    if (number < 100000) {
        return [NSString stringWithFormat:@"%d", number];
    } else {
        return @"99999+";
    }
}

//视频时间总长
+ (NSString *)videoTimeToString:(double)totalTime {
    double minutesRemaining = floor(totalTime / 60.0);;
    double secondsRemaining = floor(fmod(totalTime, 60.0));;
    NSString *timeRmainingString = [NSString stringWithFormat:@"%02.0f:%02.0f", minutesRemaining, secondsRemaining];
    return timeRmainingString;
}

#pragma mark - 地理信息相关

//获取区的位置编码
+(NSString*)convertNameToCode:(NSString *)province city:(NSString *)city district:(NSString *)district
{
    NSString *dataStr = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"city2code.js" ofType:nil] encoding:NSUTF8StringEncoding error:nil];
    NSData *resData = [[NSData alloc] initWithData:[dataStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSArray *jsonAllData = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
    
    NSString *provinceCode = nil;
    NSString *cityCode = nil;
    NSString *districtCode = nil;
    
    //先遍历找到省
    NSArray *provinceArray = [jsonAllData objectAtIndex:0];
    for (NSDictionary *dic in provinceArray) {
        if ([[dic objectForKey:@"name"] isEqualToString:province]) {
            provinceCode = [dic objectForKey:@"code"];
            break;
        }
    }
    if (!provinceCode) {
        return nil;
    }
    //遍历市
    NSDictionary *citysDic = [jsonAllData objectAtIndex:1];
    NSArray *citysArray = [citysDic objectForKey:provinceCode];
    for (NSDictionary *cityDic in citysArray) {
        //手机定位的名字可能是：北京市市辖区
        if ([city rangeOfString:[cityDic objectForKey:@"name"]].length > 0) {
            cityCode = [cityDic objectForKey:@"code"];
            break;
        }
    }
    if (!cityCode) {
        return provinceCode;
    }
    //遍历区
    if (!district) {
        return cityCode;
    }
    NSDictionary *countysDic = [jsonAllData objectAtIndex:2];
    NSArray *countysArray = [countysDic objectForKey:cityCode];
    for (NSDictionary *countyDic in countysArray) {
        if ([[countyDic objectForKey:@"name"] isEqualToString:district]) {
            districtCode = [countyDic objectForKey:@"code"];
            break;
        }
    }
    if (!districtCode) {
        return cityCode;
    }
    return districtCode;
}
//获取全国省市区信息
- (NSArray *)gProvinceCityDistrictData
{
    if (!_gProvinceCityDistrictData) {
        NSString *dataStr = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"city2code.js" ofType:nil] encoding:NSUTF8StringEncoding error:nil];
        NSData *resData = [[NSData alloc] initWithData:[dataStr dataUsingEncoding:NSUTF8StringEncoding]];
        
        _gProvinceCityDistrictData = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
    }
    return _gProvinceCityDistrictData;
}
//通过省市区编码获取省市区名称
- (NSString*)convertCodeToName:(NSString *)code
{
    NSString *provinceCode = nil;
    NSString *cityCode = nil;
//    NSString *districtCode = nil;
    
    NSString *provinceText = @"";
    NSString *cityText = @"";
    NSString *districtText = @"";
    
    //省市区
    NSArray *provinceArray = [self.gProvinceCityDistrictData objectAtIndex:0];
    NSDictionary *citysDic = [self.gProvinceCityDistrictData objectAtIndex:1];
    NSDictionary *countysDic = [self.gProvinceCityDistrictData objectAtIndex:2];
    
    //先遍历区
    BOOL findDestrict = NO;
    NSArray *countysKeys = [countysDic allKeys];
    for (int i = 0; i < countysKeys.count; ++i) {
        NSString *cityKey = [countysKeys objectAtIndex:i];
        NSArray *countysArray = [countysDic objectForKey:cityKey];
        //遍历每个key下的所有区code，区code一致时，城市code就是key
        for (NSDictionary *countyDic in countysArray) {
            if ([[countyDic objectForKey:@"code"] isEqualToString:code]) {
                districtText = [countyDic objectForKey:@"name"];
                cityCode = cityKey;
                findDestrict = YES;
                break;
            }
        }
        if (findDestrict) {
            break;
        }
    }
    //如果没找到区:通过code直接在市里面寻找
    if (!cityCode) {
        cityCode = code;
    }
    BOOL findCity = NO;
    NSArray *citysKeys = [citysDic allKeys];
    for (int i = 0; i < citysKeys.count; ++i) {
        NSString *provinceKey = [citysKeys objectAtIndex:i];
        NSArray *citysArray = [citysDic objectForKey:provinceKey];
        //遍历每个key下的所有市code，市code一致时，省code就是key
        for (NSDictionary *cityDic in citysArray) {
            if ([[cityDic objectForKey:@"code"] isEqualToString:cityCode]) {
                cityText = [cityDic objectForKey:@"name"];
                provinceCode = provinceKey;
                findCity = YES;
                break;
            }
        }
        if (findCity) {
            break;
        }
    }
    //没有找到市：通过code直接在省里面找
    if (!provinceCode) {
        provinceCode = code;
    }
    for (NSDictionary *dic in provinceArray) {
        if ([[dic objectForKey:@"code"] isEqualToString:provinceCode]) {
            provinceText = [dic objectForKey:@"name"];
            break;
        }
    }
    return [NSString stringWithFormat:@"%@%@%@",provinceText,cityText,districtText];
}


#pragma mark - 缓存相关
+ (void)cleanCache
{
    //NSString *extension = @"plist";
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        
        if (([[filename pathExtension] isEqualToString:@"plist"] && [filename rangeOfString:@"cheer.plist"].length == 0 && [filename rangeOfString:@"ReviewZanId"].length == 0) || [filename isEqualToString:@"com.hackemist.SDWebImageCache.default"] || [filename isEqualToString:@"default"] || [filename isEqualToString:@"com.cnhubei.mobileNewsDev"]) {
            
            [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filename] error:NULL];
        }
    }
}
//计算程序缓存大小
+ (float)calculateCache
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:NULL];
    long long cacheSize = 0;
    
    //只计算.plist文件和SDImageCache
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        
        if (([[filename pathExtension] isEqualToString:@"plist"] && [filename rangeOfString:@"cheer.plist"].length == 0 && [filename rangeOfString:@"ReviewZanId"].length == 0) || [filename isEqualToString:@"com.hackemist.SDWebImageCache.default"] || [filename isEqualToString:@"default"] || [filename isEqualToString:@"com.cnhubei.mobileNewsDev"]) {
            NSString *fileAllName = [documentsDirectory stringByAppendingPathComponent:filename];
            cacheSize += [fileManager attributesOfItemAtPath:fileAllName error:nil].fileSize;
            
            //图片缓存文件夹
            if ([filename isEqualToString:@"com.hackemist.SDWebImageCache.default"]) {
                NSString *dirfile;
                NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:fileAllName];
                while ((dirfile = [dirEnum nextObject]))
                {
                    BOOL isDir;
                    NSString *fileNameInDir = [fileAllName stringByAppendingPathComponent:dirfile];
                    [[NSFileManager defaultManager] fileExistsAtPath:fileNameInDir isDirectory: &isDir];
                    if (!isDir) {
                        cacheSize += [fileManager attributesOfItemAtPath:fileNameInDir error:nil].fileSize;
                    }
                }
            }
            //读取default文件夹
            if ([filename isEqualToString:@"default"] || [filename isEqualToString:@"com.cnhubei.mobileNewsDev"]) {
                long long allSize = 0;
                
                [DataService fileSizeForDir:fileAllName allSize:&allSize];
                cacheSize += allSize;
            }
        }
    }
    
    return (float)cacheSize/(1024.0*1024.0);
}
//计算文件夹size
+(void)fileSizeForDir:(NSString*)path allSize:(long long *)allSize
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    NSArray* array = [fileManager contentsOfDirectoryAtPath:path error:nil];
    for(int i = 0; i<[array count]; i++)
    {
        NSString *fullPath = [path stringByAppendingPathComponent:[array objectAtIndex:i]];
        
        BOOL isDir;
        if ( !([fileManager fileExistsAtPath:fullPath isDirectory:&isDir] && isDir) )
        {
            NSDictionary *fileAttributeDic=[fileManager attributesOfItemAtPath:fullPath error:nil];
            //size+= fileAttributeDic.fileSize;
            *allSize += fileAttributeDic.fileSize;
        }
        else
        {
            [self fileSizeForDir:fullPath allSize:allSize];
        }
    }
    //return size;
}

+ (float)fileSizeAtPath:(NSString *)path
{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        
        long long size = [fileManager attributesOfItemAtPath:path error:nil].fileSize;
        // 返回值是字节 B K M
        return size/(1024.0*1024.0);
    }
    return 0;
}
//计算目录大小
+ (float)folderSizeAtPath:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    float folderSize;
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            // 计算单个文件大小
            folderSize += [DataService fileSizeAtPath:absolutePath];
        }
        //SDWebImage框架自身计算缓存的实现
        // folderSize+=[[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
        return folderSize;
    }
    return 0;
}

+ (NSArray *)getCategories:(NSString*)categoriesType
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *fileName = [NSString stringWithFormat:@"%@/%@_categories.plist",documentsDirectory,categoriesType];
    
    NSArray *categories = [NSArray arrayWithContentsOfFile:fileName];
    
    return categories;
}

+ (void)saveCategories:(NSArray *)categories categoriesType:(NSString*)categoriesType
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *fileName = [NSString stringWithFormat:@"%@/%@_categories.plist",documentsDirectory,categoriesType];
    
    [categories writeToFile:fileName atomically:YES];
}


+ (NSDictionary *)getArticles:(long long)catID categoriesType:(NSString*)categoriesType
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *fileName = [NSString stringWithFormat:@"%@/%@_articles_%lld.plist",documentsDirectory,categoriesType,catID];
//    NSMutableArray *categories = [NSMutableArray arrayWithContentsOfFile:fileName];
    NSDictionary *categories = [NSDictionary dictionaryWithContentsOfFile:fileName];
    return categories;
}

+ (void)saveArticlesList:(NSDictionary *)articles catID:(long long)catID categoriesType:(NSString*)categoriesType;
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *fileName = [NSString stringWithFormat:@"%@/%@_articles_%lld.plist",documentsDirectory, categoriesType,catID];
    
    [articles writeToFile:fileName atomically:YES];
}

+ (NSDictionary *)getActivities {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *fileName = [NSString stringWithFormat:@"%@/activitiesList.plist",documentsDirectory];
    NSDictionary *categories = [NSDictionary dictionaryWithContentsOfFile:fileName];
    if(categories) {
        return categories;
    } else {
        return [[NSDictionary alloc] init];
    }
}

+ (void)saveActivities:(NSDictionary *)activities {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *fileName = [NSString stringWithFormat:@"%@/activitiesList.plist",documentsDirectory];
    
    [activities writeToFile:fileName atomically:YES];
}

+ (NSDictionary *)getDisclose:(NSString *)itemID {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *fileName = [NSString stringWithFormat:@"%@/disclosesList_%@.plist",documentsDirectory, itemID];
    NSDictionary *categories = [NSDictionary dictionaryWithContentsOfFile:fileName];
    if(categories) {
        return categories;
    } else {
        return [[NSDictionary alloc] init];
    }
}

+ (void)saveDisclose:(NSDictionary *)discloses itemID:(NSString *)itemID {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *fileName = [NSString stringWithFormat:@"%@/disclosesList_%@.plist",documentsDirectory, itemID];
    
    [discloses writeToFile:fileName atomically:YES];
}
//手机号码验证
- (BOOL)isValidateMobile:(NSString *)mobile
{
    /*
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(17[0-9])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
     */
    [NSCharacterSet decimalDigitCharacterSet];
    if ([mobile stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]].length > 0) {
        return NO;
    }
    else{
        return YES;
    }
}
//邮政编码验证
- (BOOL)isValidPostcode:(NSString *)postcode
{
    NSString *phoneRegex = @"\\d{6}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:postcode];
}

/*
 *  获取html模板正则表达式
 *
 *  用于进入新闻详情页时，用服务端的数据填充html模板中的数据
 *
 *  @return html模板正则表达式
 */
+ (NSString *)getHtmlRegex
{
    return @"<!--\\$\\{([\\d\\w_]+)\\}-->";
}

- (void)dealloc{
    
}

//新闻字体大小
+ (UIFont *)newsFont {
    return [UIFont systemFontOfSize:[self deviceCompatibleNums:17 ip5:17 ip6:19 ip6p:20]];
}

+ (UIFont *)newsMenuFont {
    
    return [UIFont systemFontOfSize:[self deviceCompatibleNums:17 ip5:17 ip6:18 ip6p:20]];
}

+(float)deviceCompatibleNums:(float)ip4s ip5:(float)ip5 ip6:(float)ip6 ip6p:(float)ip6p{
    if (ssiPhone6) {
        return ip6;
    } else if (ssiPhone6plus) {
        return ip6p;
    } else if (ssiPhone5) {
        return ip5;
    }else{
        return ip4s;
    }

    
}

+(float)deviceCompatibleNumsWithScale:(float)num{
    return num*SCREEN_W/375.0;
}


@end
