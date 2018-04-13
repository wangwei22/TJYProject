//
//  TJY_MainViewController.h
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/12.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainMenuView.h"
#import "TJY_RequestServiceManager.h"
@interface TJY_MainViewController : UIViewController<MainMenuViewDelegate,UIGestureRecognizerDelegate,UINavigationControllerDelegate,TJY_RequestServiceManagerDelegate>
@property (nonatomic, strong) MainMenuView  *mainMenuView;
@property (nonatomic, retain) UIViewController *currentShowVC;
@end
