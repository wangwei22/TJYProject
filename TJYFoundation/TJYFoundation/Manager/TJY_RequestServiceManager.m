//
//  TJY_RequestServiceManager.m
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/11.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import "TJY_RequestServiceManager.h"
#import <AFNetworking.h>
#import <JPUSHService.h>
@interface TJY_RequestServiceManager()
@property (nonatomic, weak) id<TJY_RequestServiceManagerDelegate> delegate;
@property(nonatomic,strong) AFHTTPSessionManager *manager;
@end
@implementation TJY_RequestServiceManager
#pragma mark - 初始化

- (id)initWithDelegate:(id)delegate
{
    if ((self = [super init])) {
        _manager = [AFHTTPSessionManager manager];
        self.delegate = delegate;
    }
    return self;
}

-(void)cancel{
    _delegate = nil;
    [_manager.operationQueue cancelAllOperations];
    
}
#pragma mark - 参数签名 & 网络请求
-(void)startHttpRequest:(NSDictionary*)dic target:(NSString*)target tag:(long long)tag
{
    //判断是否有图片类型提交参数
    NSMutableDictionary *pDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
    NSMutableArray *deleteDic = [[NSMutableArray alloc] init];
    NSMutableArray *imgDataArr = [[NSMutableArray alloc] init];
    for(NSString *key in pDic){
        id value = [pDic objectForKey:key];
        if ([value isKindOfClass:[UIImage class]]) {
            NSDictionary *imgObj = @{@"key":key,@"data":UIImageJPEGRepresentation(value, 0.8)};
            [imgDataArr addObject:imgObj];
            [deleteDic addObject:key];
        }
    }
    for (NSString *key in deleteDic) {
        [pDic removeObjectForKey:key];
    }
    
/*   [pDic setObject:NSUDGetPostCityCode forKey:@"hd_cc"];
    [pDic setObject:NSUDGetEntCode forKey:@"hd_ec"];*/
   if ([JPUSHService registrationID]) {
        [pDic setObject:[JPUSHService registrationID] forKey:@"hd_pid"];
    }
//    NSDictionary *dataDic = [PostDataSign dicTrans:pDic secrect:CNHB_APPSECRECT key:CNHB_APPKEY ver:CNHB_VER];
    NSString *urlString =[NSString stringWithFormat:@"%@%@/%@", CNHB_SERVER,CNHB_SERVERPORT,target];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"\r\n----------------服务器请求开始----------------\r\n请求地址:%@\r\n%@\r\n----------------服务器请求结束----------------",urlString,pDic);
    //AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 设置请求格式
    //manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // 设置返回格式
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    _manager.requestSerializer.timeoutInterval = 15;
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    __weak  typeof(self) weakSelf = self;
    [_manager POST:urlString parameters:pDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        if (imgDataArr.count>0) {//上传文件
            for (int i=0; i<imgDataArr.count; i++) {
                [formData appendPartWithFileData:[imgDataArr[i] objectForKey:@"data"] name:[imgDataArr[i] objectForKey:@"key"] fileName:[NSString stringWithFormat:@"img.jpg"] mimeType:@"image/jpeg"];
            }
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"\r\n----------------服务器响应开始----------------\r\n%@\r\n----------------服务器响应结束----------------", responseObject);
        if (responseObject && ((NSString *)[responseObject valueForKey:@"msg"]).length > 0 && ![[responseObject valueForKey:@"msg"] isEqualToString:@""]) {//弹出服务端提示信息
            if ([[responseObject valueForKey:@"code"] integerValue] != 10011) {//不提示收藏已关闭提示框
                GMLog("%@",[responseObject valueForKey:@"msg"]);
            }
        }
        GMLog("%@::::",[responseObject objectForKey:@"status"]);
        if ([[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"status"]] isEqualToString:@"1"]) {//判断业务逻辑是否正常
            NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithDictionary:responseObject];
            if(weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(getFinished:tag:)]){
                [weakSelf.delegate getFinished:dic tag:tag];
            }
            
        }else{
            if(weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(getError:tag:)]){
                NSString *resMsg = @"";
                if ([responseObject valueForKey:@"msg"]) {
                    resMsg = [responseObject valueForKey:@"msg"];
                }
                [weakSelf.delegate getError:[NSError errorWithDomain:resMsg code:[[responseObject valueForKey:@"code"] integerValue] userInfo:nil] tag:tag];
            }
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"\r\n----------------服务器错误开始----------------\r\n%@\r\n----------------服务器错误结束----------------", error);
        if(weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(getError:tag:)]){
            [weakSelf.delegate getError:[NSError errorWithDomain:error.domain code:-1 userInfo:nil] tag:tag];
        }
        
    }];
    
}
@end
