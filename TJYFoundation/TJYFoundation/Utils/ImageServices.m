//
//  ImageServices.m
//  HubeiMobileNews
//
//  Created by sunnysnake on 15/5/22.
//  Copyright (c) 2015年 cnhubei. All rights reserved.
//

#import "ImageServices.h"

@implementation ImageServices


//截取图片指定rect
+(UIImage *)imageInRect:(UIImage *)image inRect:(CGRect)rect
{
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    return newImage;
    
    
}

//截取图片中心的指定size
+(UIImage *)imageInSquare:(UIImage *)image
{
    //先按要显示的大小去比例缩放图片

    float drawX = 0.0;
    float drawY = 0.0;
    float drawLength = 0.0;
    float image_w = image.size.width;
    float image_h = image.size.height;
    
    
    if (image_w==image_h) {//方图直接返回
        return image;
    }else{
        if (image_w>image_h) {//横图
            drawLength = image_h;
            drawX  = (image_w - drawLength)/2;
        }else if(image_w < image_h){//竖图
            drawLength = image_w;
            drawY = (image_h - drawLength)/2;
        }
        
        CGRect squareImageRect = CGRectMake(drawX, drawY, drawLength, drawLength);
        UIImage *squareImage = [self imageInRect:image inRect:squareImageRect];
        return squareImage;
    }

    
}

+(UIImage *)imageScale:(UIImage *)image toScale:(float)scaleSize

{
    
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
    
}


+(UIImage *)imageReSize:(UIImage *)image toSize:(CGSize)reSize

{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reSizeImage;
    
}
//等比例压缩
+(UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    
    return newImage;
    
}


+(CGRect)ssCGRectMake:(float)x y:(float)y width:(float)width height:(float)height{
    
    if(SCREEN_H > 480){
        return CGRectMake(x*SCREEN_W/320, y*SCREEN_H/568, width*SCREEN_W/320, height*SCREEN_H/480);
        
    }else{
        return CGRectMake(x, y, width, height);
    }
    
    
}
//图片拉伸旋转
+ (UIImage*) scaleAndRotateImage:(UIImage *)photoimage width:(CGFloat)bounds_width height:(CGFloat)bounds_height Orientation:(UIImageOrientation)orient
{
    //int kMaxResolution = 300;
    CGImageRef imgRef =photoimage.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    
    bounds.size.width = bounds_width;
    bounds.size.height = bounds_height;
    CGFloat scaleRatio = bounds.size.width / width;
    CGFloat scaleRatioheight = bounds.size.height / height;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    switch(orient)
    {
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
        case UIImageOrientationUpMirrored: //EXIF = 2  //水平翻转
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
        case UIImageOrientationDown: //EXIF = 3 顺时针180度
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationDownMirrored: //EXIF = 4  //锤子翻转
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid?image?orientation"];
            break;
    }
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft)
    {
        CGContextScaleCTM(context, -scaleRatio, scaleRatioheight);
        CGContextTranslateCTM(context, -height, 0);
    }
    else
    {
        CGContextScaleCTM(context, scaleRatio, -scaleRatioheight);
        CGContextTranslateCTM(context, 0, -height);
    }
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageCopy;
}

+(NSString*)imageUrlFromServer:(NSString *)url width:(CGFloat)width height:(CGFloat)height{
    NSString *returnUrl = [NSString stringWithFormat:@"%@cutter/cnv?w=%d&h=%d&q=100&l=1&url=%@",CNHB_SERVER,(int)width*2,(int)height*2,url];
    return returnUrl;
}

//图片剪裁 宽高 参数
+(NSString *)imageUrlFromServer:(NSString *)url width:(CGFloat)width height:(CGFloat)height quality:(CGFloat)quality l:(CGFloat)l
{
    NSString *returnUrl = [NSString stringWithFormat:@"%@cutter/cnv?w=%d&h=%d&q=%d&l=%d&url=%@",CNHB_SERVER,(int)width*2,(int)height*2,(int)quality,(int)l,url];
    return returnUrl;
}

+(NSString *)PhotoLiveimageUrlFromServer:(NSString *)url width:(CGFloat)width height:(CGFloat)height quality:(CGFloat)quality l:(CGFloat)l
{
    NSString *returnUrl = [NSString stringWithFormat:@"%@cutter/cnv?w=%d&h=%d&q=%d&l=%d&url=%@",CNHB_SERVER,(int)width,(int)height,(int)quality,(int)l,url];
    return returnUrl;
}

+(UIImage*)imageFromview:(UIView*)v{
    UIGraphicsBeginImageContext(v.bounds.size);
    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
