//
//  TJY_CustomerViewModel.m
//  TJYFoundation
//
//  Created by wang_wei on 2018/5/8.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import "TJY_CustomerViewModel.h"
#import "HomePageHeader.h"
@interface  TJY_CustomerViewModel()
@property(nonatomic,strong)RACCommand * customerListCommand;
@end
@implementation TJY_CustomerViewModel
-(RACCommand *)customerListCommand{
    if (!_customerListCommand) {
        _customerListCommand = [[RACCommand  alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            [MBProgressHUD   showActivityMessageInWindow:@""];
            UserInfo  *  user = [TJY_UserApplication  shareManager].loginUser;
            //buy_state 1潜在 2意向 3洽谈 4成交 5流失
            /*type 1我负责的
             2没有人负责的
             3全公司的
             4部门的  */
            NSDictionary  *  dic = [NSDictionary  dictionaryWithObjectsAndKeys:user.userId,@"user_id",user.token,@"token",@"",@"page",@"seach",@"buy_state",@"type", nil];
            return  [[AFNetWorkUtils  racPOSTWthURL:CUSTOMER_LIST_URL params:dic] map:^id _Nullable(id  _Nullable value) {
                return  value;
            }];
        }];
    }
    return  _customerListCommand;
}
@end
