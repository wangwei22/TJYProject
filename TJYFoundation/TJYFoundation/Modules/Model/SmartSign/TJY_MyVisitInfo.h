//
//  TJY_MyVisitInfo.h
//  TJYFoundation
//
//  Created by wang_wei on 2018/5/4.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJY_MyVisitInfo : NSObject
@property(nonatomic,copy)NSString  *  signSum;
@property(nonatomic,strong)NSArray  * signList;
@end
@interface ListInfo:NSObject
@property(nonatomic,copy)NSString  *  addD;
@property(nonatomic,copy)NSString  * addM;
@property(nonatomic,copy)NSString  * addTime;
@property(nonatomic,copy)NSString  *addY;
@property(nonatomic,copy)NSString  *cusId;
@property(nonatomic,copy)NSString  *cusName;
@property(nonatomic,copy)NSString  *Id;
@property(nonatomic,strong)NSArray  *images;
@property(nonatomic,copy)NSString  *isNew;
@property(nonatomic,copy)NSString  *lat;
@property(nonatomic,copy)NSString  *lng;
@property(nonatomic,copy)NSString  *note;
@property(nonatomic,copy)NSString  *perId;
@property(nonatomic,copy)NSString  *signAddress;
@end

@interface  Pictures:NSObject
@property (nonatomic,copy) NSString  *  imageUrl;
@end
