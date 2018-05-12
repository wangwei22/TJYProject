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
@property(nonatomic,strong)RACCommand * customerEditCommand;
@property(nonatomic,strong)RACCommand *nationCommand;
@property(nonatomic,strong)RACSignal *validateTFCommand;
@end
@implementation TJY_CustomerViewModel
-(RACCommand *)customerListCommand{
    if (!_customerListCommand) {
        _customerListCommand = [[RACCommand  alloc] initWithSignalBlock:^RACSignal * _Nonnull(RACTuple * input) {
            [MBProgressHUD   showActivityMessageInWindow:@""];
            UserInfo  *  user = [TJY_UserApplication  shareManager].loginUser;
            //buy_state 1潜在 2意向 3洽谈 4成交 5流失
            /*type 1我负责的
             2没有人负责的
             3全公司的
             4部门的  */
            NSDictionary  *  dic = [NSDictionary  dictionaryWithObjectsAndKeys:user.userId,@"user_id",user.token,@"token",input.first,@"type",input.second,@"page",input.third,@"seach",input.fourth,@"buy_state", nil];
            return  [[AFNetWorkUtils  racPOSTWthURL:CUSTOMER_LIST_URL params:dic] map:^id _Nullable(id  _Nullable value) {
                return  value;
            }];
        }];
    }
    return  _customerListCommand;
}
-(RACCommand *)customerEditCommand{
    if (!_customerEditCommand) {
        _customerEditCommand = [[RACCommand  alloc] initWithSignalBlock:^RACSignal * _Nonnull(RACTuple * input) {
            [MBProgressHUD   showActivityMessageInWindow:@""];
            UserInfo  *  user = [TJY_UserApplication  shareManager].loginUser;
            NSDictionary  *  dic = [NSDictionary  dictionaryWithObjectsAndKeys:user.token,@"token",user.userId,@"user_id",self.name,@"cus_name",self.telphone,@"tel",self.sex?self.sex:@"0",@"sex",self.status?self.status:@"1",@"buy_state",self.nation,@"nation_id",self.birthday,@"birthday",self.idCard,@"id_number",self.favourite,@"hobby",self.address,@"addr",self.marryStatus?self.emcStatus:@"1",@"marital_status",self.workStatus?self.workStatus:@"1",@"work_state",self.company,@"work_where",self.position,@"occupation",self.emcStatus?self.emcStatus:@"1",@"money_status",self.vipCard,@"menber_number",self.introduce,@"introducer",self.sourceFrom?self.sourceFrom:@"1",@"come",nil];
            return [[AFNetWorkUtils  racPOSTWthURL:CUSTOMER_ADD_URL params:dic] map:^id _Nullable(id  _Nullable value) {
                return  value;
            }];
        }];
    }
    return  _customerEditCommand;
}
#pragma   mark --  有效性判断

-(RACSignal *)validateTFCommand{
    if (!_validateTFCommand) {
        _validateTFCommand = [RACSignal  combineLatest:@[RACObserve(self, name),RACObserve(self, telphone),RACObserve(self, idCard),RACObserve(self, favourite),RACObserve(self, address),RACObserve(self, company),RACObserve(self, position),RACObserve(self, vipCard),RACObserve(self, introduce),RACObserve(self, conect),RACObserve(self, buyStatus)] reduce:^id(NSString  *  name ,NSString  * telphone,NSString* idCard,NSString *favourite,NSString *address,NSString *company,NSString *position,NSString *vipCard,NSString *introduce,NSString *conect,NSString *buyStatus){
            int  i =  (name.length>0&&telphone.length>0&&idCard.length>0&&favourite.length>0&&address.length>0&&company.length>0&&position.length>0&&vipCard.length>0&&introduce.length>0&&conect.length>0) ;
            return  [NSNumber  numberWithInt:i] ;
        }];
    }
    return  _validateTFCommand;
}
-(RACCommand *)nationCommand{
    if (!_nationCommand) {
        _nationCommand = [[RACCommand  alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return[ [AFNetWorkUtils  racPOSTWthURL:CUSTOMER_NATION_URL params:nil] map:^id _Nullable(id  _Nullable value) {
                NSArray  *  array = [TJY_Nation  mj_objectArrayWithKeyValuesArray:[value  objectForKey:@"result"]];
                NSMutableArray  *  dataArray = [NSMutableArray  array];
                [array  enumerateObjectsUsingBlock:^(TJY_Nation * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    obj.cSpell = [self Charactor:obj.nation getFirstCharactor:NO];
                    [dataArray  addObject:obj];
                }];
                NSMutableDictionary  *  dic = [NSMutableDictionary  dictionary];
                for (NSString *aleph in [NSArray arrayWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil])
                {
                    NSPredicate  * alephPredicate = [NSPredicate  predicateWithFormat:@"%K BEGINSWITH[cd]%@",@"cSpell",aleph];
                    NSArray  *  tempArray = [dataArray  filteredArrayUsingPredicate:alephPredicate];
                    if (tempArray.count>0) {
                        dic[aleph] = tempArray;
                    }
                }
                NSMutableArray  * groupTitleArray  = [NSMutableArray  array];
                [groupTitleArray  addObjectsFromArray:[dic.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]];
                RACTuple  *  tupe = [RACTuple  tupleWithObjects:dic,groupTitleArray, nil];
                return   tupe;
            }];
        }];
    }
    return  _nationCommand;
}

- (NSString *)Charactor:(NSString *)aString getFirstCharactor:(BOOL)isGetFirst
{
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:aString];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    NSString *pinYin = [str capitalizedString];
    //转化为大写拼音
    if(isGetFirst)
    {
        //获取并返回首字母
        return [pinYin substringToIndex:1];
    }
    else
    {
        return pinYin;
    }
}
@end
