//
//  TJY_VisitInfo.h
//  TJYFoundation
//
//  Created by wang_wei on 2018/5/4.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJY_VisitInfo : NSObject
@property(nonatomic,copy)NSString  *noSignSum;
@property(nonatomic,copy)NSString  *personnelSum;
@property(nonatomic,strong)NSArray  *signList;
@property(nonatomic,copy)NSString  *signSum;
@property(nonatomic,strong)NSArray  *noSignList;
@end
@interface NoSign:NSObject
@property(nonatomic,copy)NSString  *Id;
@property(nonatomic,copy)NSString  *perName;
@end
@interface   Sign:NSObject
@property(nonatomic,copy)NSString  *addTime;
@property(nonatomic,copy)NSString  *Id;
@property(nonatomic,copy)NSString  *perId;
@property(nonatomic,copy)NSString  *perName;
@property(nonatomic,copy)NSString  *signAddress;
@end
