//
//  TJY_VisitSignHomeViewController.m
//  TJYFoundation
//
//  Created by wang_wei on 2018/5/3.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import "TJY_VisitSignHomeViewController.h"

#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "DPointAnnotation.h"
#import "CustomAnnotationView.h"
// 设置公司经纬度
#define kLatitude 30.480672
#define kLongitude 114.542898

@interface TJY_VisitSignHomeViewController ()<MAMapViewDelegate,AMapSearchDelegate>
{
    BOOL isSelect;
    UIImageView *selectImg;
    CLLocation  *  _currentLocation;
}
// 高德地图
@property (nonatomic, strong)MAMapView *mapView;
// 有多少个打卡范围(可拓展不同地方打卡)
@property (nonatomic, copy)NSArray *circles;
// 经纬度
@property (nonatomic,strong)NSString *userLongitude;
@property (nonatomic,strong)NSString *userLatitude;
// 公司或者nil(在公司或者不在公司字段,无影响)
@property (nonatomic,strong)NSString *location;
// 用户
@property (nonatomic, strong)UserInfo *user;


@property(nonatomic,strong)AMapSearchAPI * search;
@property(nonatomic,strong) DPointAnnotation*  companyP;
@property (weak, nonatomic) IBOutlet UIView *visitBgView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIView *mapBgView;
@property (weak, nonatomic) IBOutlet UIView *titleBgView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation TJY_VisitSignHomeViewController
-(void)viewDidAppear:(BOOL)animated{
    [super  viewDidAppear:animated];
    [self  userPermissionSetting];
    // 进入界面就以定位点为地图中心
    [self.mapView  setCenterCoordinate:CLLocationCoordinate2DMake([self.userLatitude  floatValue], [self.userLongitude floatValue]) animated:NO];
    // 将绘制的图形添加到地图上
    [self.mapView  addOverlays:self.circles];
}
- (void)viewDidLoad {
     [super viewDidLoad];
     // Do any additional setup after loading the view.
     [self  configUI];
    // 初始化地图
    [self initMapView];
    // 初始化 MAUserLocationRepresentation 对象
    [self initUserLocationRepresentation];
    // 创建按钮
    [self initMapButton];
}
-(void)configUI{
    [self textFieldPlaceholderColorWithTextField:self.textField];
    self.visitBgView.layer.borderWidth = 0.5;
    self.visitBgView.layer.borderColor = [UIColor  lightGrayColor].CGColor;
    
    NSDateFormatter  *  formater = [[NSDateFormatter  alloc] init];
    [formater  setDateFormat:@"HH:mm"];
    self.timeLabel.text =[formater  stringFromDate:[NSDate  date]];
}


- (void)initMapView {
    // https配置
    [AMapServices  sharedServices].enableHTTPS = YES;
    // 初始化地图
    [self.view  addSubview:self.mapView];
    self.search.delegate=self;
//    [self.mapView  addAnnotation:self.companyP];
//    [self.mapView  selectAnnotation:self.companyP animated:YES];
}

- (void)initUserLocationRepresentation {
    // 初始化小蓝点
    MAUserLocationRepresentation *r = [[MAUserLocationRepresentation alloc] init];
    r.showsAccuracyRing = YES;// 精度圈是否显示，默认YES
    r.enablePulseAnnimation = YES;// 内部蓝色圆点是否使用律动效果, 默认YES
    r.lineWidth = 2;// 精度圈 边线宽度，默认0
    [self.mapView updateUserLocationRepresentation:r];
}
- (void)initMapButton {
    UIButton *signBtn = [[UIButton alloc ] initWithFrame:CGRectMake(20,SCREEN_H - 80,SCREEN_W - 20*2,44)];
    [signBtn setBackgroundImage:[UIImage imageNamed:@"sign"] forState:UIControlStateNormal];
    [signBtn setBackgroundImage:[UIImage imageNamed:@"sign_select"] forState:UIControlStateHighlighted];
    [signBtn setTitle:@"签 到" forState:UIControlStateNormal];
    [signBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [signBtn addTarget:self action:@selector(signWork) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:signBtn];
    // 定位按钮
    UIButton *searchBtn = [[UIButton alloc ] initWithFrame:CGRectMake(SCREEN_W - 20 - 37, kNavBarHeight+kStatusBarHeight + 20+44, 37, 37)];
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"locationPoint"] forState:UIControlStateNormal];
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"locationPoint_select"] forState:UIControlStateHighlighted];
    [searchBtn addTarget:self action:@selector(locationClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchBtn];
}
- (void)setAddress {
    NSMutableArray *arr = [NSMutableArray array];
    MACircle *circle1 = [MACircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(kLatitude, kLongitude) radius:500];
    [arr addObject:circle1];
    self.circles = [NSArray arrayWithArray:arr];
}

// 放大
- (void)zoomUp {
    [self.mapView setZoomLevel:(self.mapView.zoomLevel + 1) animated:YES];
}

// 缩小
- (void)zoomDown {
    [self.mapView setZoomLevel:(self.mapView.zoomLevel - 1) animated:YES];
}
// 签到
- (void)signWork {
    // 半径在500米以内就在范围内
    double r = 500;
    double distance = [self distanceBetweenCenterLatitude:kLatitude centerLongitude:kLongitude userLatitude:[self.userLatitude doubleValue]  userLongitude:[self.userLongitude doubleValue]];
    if (distance <= r) {
        // 在范围内的提示
    }else {
        // 不在范围内的提示
    }
}
// 定位按钮
-(void)locationClick {
    // 设置地图中心位置
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake([self.userLatitude floatValue], [self.userLongitude floatValue]) animated:YES];
    [self.mapView setZoomLevel:18 animated:YES];
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    // 获取用户位置的经纬度
    self.userLongitude = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude];
    self.userLatitude = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude];
    _currentLocation = [userLocation.location copy];
    [self  reGeoCoding];
}


#pragma mark 逆地理编码
-(void)reGeoCoding{
    if (_currentLocation) {
        AMapReGeocodeSearchRequest  *  request = [[AMapReGeocodeSearchRequest  alloc]init];
        request.location = [AMapGeoPoint locationWithLatitude:_currentLocation.coordinate.latitude longitude:_currentLocation.coordinate.longitude];
        [_search  AMapReGoecodeSearch:request];
    }
}
#pragma mark 搜索请求发起后的回调
/**失败回调*/
-(void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error{
    
    NSLog(@"request: %@------error:  %@",request,error);
}
/**成功回调*/
-(void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response{
    
    //我们把编码后的地理位置，显示到 大头针的标题和子标题上
    NSString *title =response.regeocode.addressComponent.city;
    if (title.length == 0) {
        title = response.regeocode.addressComponent.province;
        NSLog(@"........%@",title);
    }
    _mapView.userLocation.title = title;
    _mapView.userLocation.subtitle = response.regeocode.formattedAddress;
    NSLog(@".....1111%@",response.regeocode.formattedAddress);
    // 调用创建大头针的方法  一下两种方法必须在此调用
    
}
// 高德地图delegate
#pragma mark - MAMapViewDelegate

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay{
    
    if ([overlay isKindOfClass:[MACircle class]])
    {
        MACircleRenderer *circleRenderer = [[MACircleRenderer alloc] initWithCircle:(MACircle*)overlay];
        circleRenderer.lineWidth    = 1.f;
        circleRenderer.strokeColor = [UIColor blueColor];
        circleRenderer.lineDashType     = NO;
        
        NSInteger index = [self.circles indexOfObject:overlay];
        if(index == 0) {
            circleRenderer.fillColor    = ssRGBHex(0x24b7eb);
        } else if(index == 1) {
            circleRenderer.fillColor   = [[UIColor greenColor] colorWithAlphaComponent:0.3];
        } else if(index == 2) {
            circleRenderer.fillColor   = [[UIColor blueColor] colorWithAlphaComponent:0.3];
        } else {
            circleRenderer.fillColor   = [[UIColor yellowColor] colorWithAlphaComponent:0.3];
        }
        return circleRenderer;
    }
    
    return nil;
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

// 警告弹框
- (void)presentAlertControllerWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma   mark   AMapSearchDelegate   method

-(MAAnnotationView*)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    if ([annotation isKindOfClass:[DPointAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        CustomAnnotationView *annotationView = (CustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
        }
        // 设置为NO，用以调用自定义的calloutView
        annotationView.canShowCallout = NO;   //注意这个地方一定要设置成NO，不然就是Callout出系统的calloutview。
        annotationView.draggable = NO;
        
        DPointAnnotation *ddAnnotation = (DPointAnnotation *)annotation;
        NSLog(@"********* %@ %@",ddAnnotation.title,ddAnnotation.number);
        annotationView.calloutView.title = _mapView.userLocation.title ;//ddAnnotation.title
        annotationView.calloutView.subtitle = _mapView.userLocation.subtitle;//ddAnnotation.subtitle
        annotationView.image = ddAnnotation.image;//设置大头针图片
        // 设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -18);
        annotationView.selected = YES;
        if ([annotation  isKindOfClass:[DPointAnnotation  class]]) {
            return   annotationView;
        }
   /*     else if ([annotation  isEqual:self.companyP]){
            self.companyP.coordinate = CLLocationCoordinate2DMake(30.61785, 114.25547000000006);
            self.companyP.title = @"公司";
            self.companyP.subtitle = @"湖北省武汉市江汉区常青街街道兴城大厦B座";
            self.companyP.image = [UIImage  imageNamed:@"location"];
            annotationView.selected = YES;
            return  annotationView;
        }*/
        return nil;
    }
    return nil;
}
-(void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{
    NSLog(@".....click.....");
}
-(void)viewDidDisappear:(BOOL)animated{
    self.mapView.delegate = nil;
    self.mapView=nil;
    self.search = nil;
    self.search.delegate = nil;
    self.companyP= nil;
}
#pragma   mark --  getter  setter  method
-(MAMapView *)mapView{
    if (!_mapView) {
        _mapView = [[MAMapView  alloc] initWithFrame:CGRectMake(0, kTopHeight+44, SCREEN_W, SCREEN_H-kTopHeight-kTabBarHeight-170-88)];
        _mapView.delegate = self;
        // 显示定位小蓝点
        self.mapView.showsUserLocation = YES;
        self.mapView.showsCompass =  NO;
        // 追踪用户的location更新
        self.mapView.userTrackingMode = MAUserTrackingModeNone;
        // 放大等级
        [self.mapView  setZoomLevel:16 animated:YES];
    }
    return  _mapView;
}
-(AMapSearchAPI *)search{
    if (!_search) {
        _search = [[AMapSearchAPI  alloc] init];
    }
    return  _search;
}
-(DPointAnnotation *)companyP{
    if (!_companyP) {
        _companyP = [[DPointAnnotation  alloc] init];
        _companyP.coordinate = CLLocationCoordinate2DMake(30.61785, 114.25547000000006);
        _companyP.title = @"公司";
        _companyP.subtitle = @"湖北省武汉市江汉区常青街街道兴城大厦B座";
        _companyP.image = [UIImage  imageNamed:@"location"];
    }
    return   _companyP;
}

-(void)userPermissionSetting{
    if ([CLLocationManager authorizationStatus] == AVAuthorizationStatusRestricted ||[CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        UIAlertController  *  alert = [UIAlertController  alertControllerWithTitle:nil message:@"请在iPhone的“设置-隐私-位置”选项中，允许访问你的位置" preferredStyle:UIAlertControllerStyleAlert];
        @weakify(self);
        [alert  addAction:[UIAlertAction  actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self);
            [self.navigationController  popViewControllerAnimated:YES];
        }]];
        [alert  addAction:[UIAlertAction  actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSURL  *  url = [NSURL  URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication  sharedApplication]  canOpenURL:url]) {
                [[UIApplication  sharedApplication] openURL:url];
            }
        }]];
        [self  presentViewController:alert animated:YES completion:nil];
    }
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
