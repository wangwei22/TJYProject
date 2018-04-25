//
//  TJY_SignBaseViewController.h
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/25.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavTitleView.h"
@interface TJY_SignBaseViewController : UIViewController
{
    NavTitleView *titleView;
}
@property(nonatomic,assign) BOOL  navTitleViewIsHidden ;
@property(nonatomic,strong)NavTitleView *titleView;
@property (copy, nonatomic) void (^backClicked)(void);
-(NSString *)dateWithTimeIntervalString:(NSString *)string;
- (int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay;
@end
