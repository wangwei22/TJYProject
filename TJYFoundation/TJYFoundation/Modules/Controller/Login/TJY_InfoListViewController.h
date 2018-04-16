//
//  TJY_InfoListViewController.h
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/13.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import "TJY_BaseViewController.h"
@protocol  TJY_InfoListViewControllerDelegate<NSObject>
@optional
-(void)popViewControllerWithTitel:(NSString*)title  Id :(NSString*)Id  isdepartment:(BOOL)isdepartment;
@end
@interface TJY_InfoListViewController : TJY_BaseViewController
@property(nonatomic,assign) BOOL  isdepartment;
@property(nonatomic,weak)id<TJY_InfoListViewControllerDelegate>delegate;
@end
