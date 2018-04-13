//
//  TJY_ADLaunchVC.h
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/11.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import "TJY_BaseViewController.h"
@protocol  TJY_ADLaunchVCDelegate<NSObject>
@optional
-(void)nextController;
@end
@interface TJY_ADLaunchVC : UIViewController
@property(nonatomic,assign)id<TJY_ADLaunchVCDelegate>delegate;
-(void)setDelegate:(id<TJY_ADLaunchVCDelegate>)delegate;
@end
