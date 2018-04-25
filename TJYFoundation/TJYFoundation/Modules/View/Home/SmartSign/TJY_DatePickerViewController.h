//
//  TJY_DatePickerViewController.h
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/25.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJY_DatePickerViewController : UIViewController
@property(nonatomic,copy)void(^dateBlock)(NSString  * dateString);
@end
