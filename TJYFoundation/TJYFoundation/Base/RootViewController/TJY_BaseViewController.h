//
//  TJY_BaseViewController.h
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/9.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavTitleView.h"
@interface TJY_BaseViewController : UIViewController
{
    NavTitleView *titleView;
}
@property(nonatomic,assign) BOOL  navTitleViewIsHidden ;
@property(nonatomic,strong)NavTitleView *titleView;
@property (copy, nonatomic) void (^backClicked)(void);

//取消网络请求
- (void)cancelRequest;
// 修改textField 的placeholedColor
-(void)textFieldPlaceholderColorWithTextField:(UITextField*)textField;
@end
