//
//  TJY_UserApplication.m
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/16.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import "TJY_UserApplication.h"

const double pi = 3.14159265358979324;
const double a = 6378245.0;
const double ee = 0.00669342162296594323;
const  double x_pi = 3.14159265358979324 * 3000.0 / 180.0;


@implementation TJY_UserApplication
@synthesize gLatitude;
@synthesize gLongitude;
@synthesize gLocationCity;
@synthesize gStreet;
@synthesize gPlmark;

+(instancetype)shareManager{
    static  TJY_UserApplication  * _manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_manager) {
            _manager = [[TJY_UserApplication  alloc] init];
        }
    });
    return  _manager;
}
-(instancetype)init{
    if (self = [super init]) {
        [self startGetLocation];
        
        self.gLocationCity = @"";
        
        NSString  * docmentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *filePath = [docmentPath  stringByAppendingPathComponent:kArchiveUserInfo];
        //解档, 读取缓存数据
        _loginUser = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        _isLogined = YES;
        if(!_loginUser) {
            _isLogined = NO;
        }
    }
    return   self;
}
//开启位置定位
- (void)startGetLocation
{
    _locManager = [[CLLocationManager alloc] init];
    if ([CLLocationManager locationServicesEnabled]) {
        CLAuthorizationStatus locStatus = [CLLocationManager authorizationStatus];
        if (locStatus == kCLAuthorizationStatusNotDetermined && [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            [_locManager requestWhenInUseAuthorization];
        }
        _locManager.delegate = self;
        _locManager.desiredAccuracy  = kCLLocationAccuracyBestForNavigation;
        //_locManager.distanceFilter = kCLDistanceFilterNone;
        _locManager.distanceFilter  = 1000;
        [_locManager startUpdatingLocation];
    }else{
        NSLog(@"location server error!");
    }
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    //取出地球坐标
    CLLocation *loc = [locations objectAtIndex:0];
    self.gLatitude = loc.coordinate.latitude;
    self.gLongitude = loc.coordinate.longitude;
    
    //iOS9以上，不需要转火星坐标了
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0) {
        //将地球坐标转化为火星坐标
        double wgLat = self.gLatitude;
        double wgLon = self.gLongitude;
        double marsLat = 0;
        double marsLon = 0;
        if (!outOfChina(wgLat, wgLon))
        {
            double dLat = transformLat(wgLon - 105.0, wgLat - 35.0);
            double dLon = transformLon(wgLon - 105.0, wgLat - 35.0);
            double radLat = wgLat / 180.0 * pi;
            double magic = sin(radLat);
            magic = 1 - ee * magic * magic;
            double sqrtMagic = sqrt(magic);
            dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * pi);
            dLon = (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * pi);
            marsLat = wgLat + dLat;
            marsLon = wgLon + dLon;
            
            loc = nil;
            loc = [[CLLocation alloc] initWithLatitude:marsLat longitude:marsLon];
        }
    }
    
    //NSLog(@"纬度：%f, 经度：%f", latitude, longitude);
    // 使用CLGeocoder的做法，其实是因为ios5开始，iphone推荐的做法。而MKReverseGeocoder在ios5之后，就不再推荐使用了，因为这个类需要实现两个委托方法。而使用CLGeocodre，则可以使用直接的方法。
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray* placemarks,NSError *error) {
        if (placemarks.count >0   ) {
            CLPlacemark * plmark = [placemarks objectAtIndex:0];
            
            NSString *subLocality=plmark.subLocality; // neighborhood, common name, eg. Mission District

            self.gLocationCity = [plmark.locality copy];
            self.gStreet = plmark.thoroughfare;
            self.gPlmark = plmark;
            //当没有手动选择城市 并且 定位城市发生改变的时候 写入城市和城市编码
            if (!NSUDGetUserCityIsManually && ![NSUDGetUserCityName isEqualToString:subLocality]) {
                NSUDSetUserCityName(self.gLocationCity);
                //NSUDSetUserCityCode([DataService city2code:subLocality]);
                NSUDSetUserCityCode([DataService convertNameToCode:plmark.administrativeArea city:plmark.locality district:subLocality]);
            }
            
        }
    }];
}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"定位失败：%@",error);
}

bool outOfChina(double lat, double lon)
{
    if (lon < 72.004 || lon > 137.8347)
        return true;
    if (lat < 0.8293 || lat > 55.8271)
        return true;
    return false;
}

double transformLat(double x, double y)
{
    double ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(fabs(x));
    ret += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0;
    ret += (20.0 * sin(y * pi) + 40.0 * sin(y / 3.0 * pi)) * 2.0 / 3.0;
    ret += (160.0 * sin(y / 12.0 * pi) + 320 * sin(y * pi / 30.0)) * 2.0 / 3.0;
    return ret;
}

double transformLon(double x, double y)
{
    double ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x));
    ret += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0;
    ret += (20.0 * sin(x * pi) + 40.0 * sin(x / 3.0 * pi)) * 2.0 / 3.0;
    ret += (150.0 * sin(x / 12.0 * pi) + 300.0 * sin(x / 30.0 * pi)) * 2.0 / 3.0;
    return ret;
}



-(void)setLoginUser:(UserInfo *)loginUser{
    //用户信息缓存到本地
    _loginUser = loginUser;
    
    NSString  * docmentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [docmentPath  stringByAppendingPathComponent:kArchiveUserInfo];
    
    //归档
    if (_loginUser) {
        
        //归档, 将用户信息缓存起来
        
        [NSKeyedArchiver archiveRootObject:_loginUser toFile:filePath];
        _isLogined = YES;
        
    }else{
        //删除归档文件
        NSFileManager *defaultManager = [NSFileManager defaultManager];
        if ([defaultManager isDeletableFileAtPath:filePath]) {
            [defaultManager removeItemAtPath:filePath error:nil];
        }
        _isLogined = NO ;
        
    }
}
-(void)logout{
    NSString  * docmentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [docmentPath  stringByAppendingPathComponent:kArchiveUserInfo];
    //删除归档文件
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    if ([defaultManager isDeletableFileAtPath:filePath]) {
        [defaultManager removeItemAtPath:filePath error:nil];
    }
    KPostNotification(KNotificationLoginStateChange, @NO);
    _isLogined = NO ;
    _loginUser = nil;
}

// 计算两个经纬度点的距离
- (double)distanceBetweenCenterLatitude:(double)centerLatitude centerLongitude:(double)centerLongitude userLatitude:(double)userLatitude  userLongitude:(double)userLongitude{
    
    double dd = M_PI/180;
    double x1=centerLatitude*dd,x2=userLatitude*dd;
    double y1=centerLongitude*dd,y2=userLongitude*dd;
    double R = 6371004;
    double distance = (2*R*asin(sqrt(2-2*cos(x1)*cos(x2)*cos(y1-y2) - 2*sin(x1)*sin(x2))/2));
    //返回 m
    return  distance;
}
@end
