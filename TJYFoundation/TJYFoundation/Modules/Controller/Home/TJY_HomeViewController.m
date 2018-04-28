//
//  TJY_HomeViewController.m
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/9.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import "TJY_HomeViewController.h"
#import "TJY_ADLaunchVC.h"
#import "TJY_RootWebViewController.h"
#import "TJY_HomeCollectionViewCell.h"
#import "TJY_HomePageHelper.h"
#import "TJY_AdInfomation.h"
#import "TJY_HomePageViewModel.h"
#import "TJY_SmartCardViewController.h"
#import "TJY_SignMapViewController.h"
#import "TJY_SignTabBarViewControllerConfig.h"
@interface TJY_HomeViewController ()<UITabBarControllerDelegate>
{
    NSMutableDictionary  *  _dic;
}
@property (strong, nonatomic)  UICollectionView *collectionView;
@property(nonatomic,strong)TJY_HomePageHelper  * heleper;
@end

@implementation TJY_HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
        // Do any additional setup after loading the view from its nib.
    self.collectionView.backgroundColor = [UIColor  whiteColor];
    [kNotificationCenter  addObserver:self selector:@selector(pushToAd:) name:@"pushToAd" object:nil];
    UINib  * nib =  [UINib   nibWithNibName:NSStringFromClass([TJY_HomeCollectionViewCell  class]) bundle:nil];
    RACCommand *selectCommand=[[RACCommand  alloc] initWithSignalBlock:^RACSignal * _Nonnull(RACTuple  * input) {
         GMLog("%@",input);
        [self  pushViewControllerWithIndexPath:input.first];
         return [RACSignal  empty];
    }];
    TJY_HomePageViewModel * model = [TJY_HomePageViewModel  new];
    NSDictionary  * dic = [NSDictionary  dictionaryWithObjectsAndKeys:@"1",@"id", nil];
    RACSignal  * source =[model.sourceCommand  execute:dic] ;
    self.heleper = [[TJY_HomePageHelper  alloc] initWithCollectionView:self.collectionView dataSource:source selectionCommand:selectCommand templateCell:nib];
//     self.heleper.dic = _dic;
}
-(void)pushToAd:(NSNotification*)notify{
    TJY_RootWebViewController  * vc = [[TJY_RootWebViewController  alloc] initWithUrl:notify.object];
    vc.isShowCloseBtn = YES;
    [self.navigationController  pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --  HomePageVC  Page jump
-(void)pushViewControllerWithIndexPath:(NSIndexPath*)indexPath{
  //  UIStoryboard  *  sb = [UIStoryboard  storyboardWithName:@"HomePage" bundle:nil];
    switch (indexPath.section) {
        case 0:{
            TJY_SignTabBarViewControllerConfig  *  config = [TJY_SignTabBarViewControllerConfig  new];
            CYLTabBarController  * tabBar = config.tabBarController;
            tabBar.delegate =  self;
            [self.navigationController  pushViewController:tabBar animated:YES];
            break;
        }
        case 1:{
            TJY_SignMapViewController * vc = [TJY_SignMapViewController  new];
              [self.navigationController  pushViewController:vc animated:YES];
            break;
        }
        case 2:{
            
            break;
        }
        default:{
            break;
        }
    }
}
#pragma   mark --- create CollectionView
-(UICollectionView *)collectionView{
    if (!_collectionView) {
         UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView  alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        //设置headerView的尺寸大小
        _collectionView.showsVerticalScrollIndicator =  false;
//        layout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 40);
        [self.view  addSubview:self.collectionView];
        [self.collectionView  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view).mas_offset(kNavBarHeight+kStatusBarHeight);
            make.leading.trailing.bottom.mas_equalTo(self.view);
        }];
    }
    return  _collectionView;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    UIViewController *viewController_ = [viewController   cyl_getViewControllerInsteadIOfNavigationController];
    [[viewController_ cyl_tabBarController] updateSelectionStatusIfNeededForTabBarController:tabBarController shouldSelectViewController:viewController];
    return YES;
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
