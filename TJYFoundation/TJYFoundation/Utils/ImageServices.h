//
//  ImageServices.h
//  HubeiMobileNews
//
//  Created by sunnysnake on 15/5/22.
//  Copyright (c) 2015年 cnhubei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageServices : NSObject


+(UIImage *)imageInRect:(UIImage *)image inRect:(CGRect)rect;

+(UIImage *)imageScale:(UIImage *)image toScale:(float)scaleSize;

+(UIImage *)imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;

+(UIImage *)imageReSize:(UIImage *)image toSize:(CGSize)reSize;

//截取图片中心最大正方形
+(UIImage *)imageInSquare:(UIImage *)image;

+(CGRect)ssCGRectMake:(float)x y:(float)y width:(float)width height:(float)height;

////旋转图片
//+ (UIImage*)rotateImage:(UIImage *)photoimage Orientation:(UIImageOrientation)orient;
//图片缩放旋转
+ (UIImage *)scaleAndRotateImage:(UIImage *)photoimage width:(CGFloat)bounds_width height:(CGFloat)bounds_height Orientation:(UIImageOrientation)orient;
/**
 *  获取裁剪图片远程地址
 *
 *  @param url    原始图片url
 *  @param width  处理宽度
 *  @param height 处理高度
 *
 *  @return 处理后的图片远程地址
 */
+(NSString*)imageUrlFromServer:(NSString*)url width:(CGFloat)width height:(CGFloat)height;

/**
 *  普通页面获取裁剪图片远程地址(宽高乘以2)
 *
 *  @param url     原始图片url
 *  @param width   处理宽度
 *  @param height  处理高度
 *  @param quality 图片质量
 *  @param l       是否压缩     0不压缩  1压缩
 *  @param m       是否加水印   0无水印  1有水印
 *
 *  @return 处理后的图片远程地址
 */
+ (NSString *)imageUrlFromServer:(NSString *)url width:(CGFloat)width height:(CGFloat)height quality:(CGFloat)quality l:(CGFloat)l;

/**
 *  图文直播页面获取裁剪图片远程地址(宽高不乘以2)
 *
 *  @param url     原始图片url
 *  @param width   处理宽度
 *  @param height  处理高度
 *  @param quality 图片质量
 *  @param l       是否压缩     0不压缩  1压缩
 *
 *  @return 处理后的图片远程地址
 */
+ (NSString *)PhotoLiveimageUrlFromServer:(NSString *)url width:(CGFloat)width height:(CGFloat)height quality:(CGFloat)quality l:(CGFloat)l;

/**
 *  uiview转换成uiimage
 *
 *  @param v uiview
 *
 *  @return image
 */
+(UIImage*)imageFromview:(UIView*)v;
@end
