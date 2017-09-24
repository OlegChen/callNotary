//
//  UIImage+XH.m
//  新浪微博
//
//  Created by mac on 14-10-26.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "UIImage+XH.h"

@implementation UIImage (XH)

+ (UIImage *)imageWithName:(NSString *)imageName{

    //定义返回结果
    UIImage *image = nil;
//    if (iOS7) {
//        NSString *newImageName = [imageName stringByAppendingString:@"_os7"];
//        image = [UIImage imageNamed:newImageName];
//    }
    
    //解决并不是所有的图片都是以——os7结尾的问题
    if (image == nil) {
        image = [UIImage imageNamed:imageName];
    }
    
    return image;

}


//根据图片名称创建一张拉伸不变形的tupian
+ (instancetype)resizableImageWithName:(NSString *)imageName{

  return [self resizableImageWithName:imageName leftRatio:0.5 topRatio:0.5];
}
//创建拉伸不变形的图片
// leftRatio  左边不拉伸比例
//  @param rigthRatio 顶部不拉伸比例

+ (instancetype)resizableImageWithName:(NSString *)imageName leftRatio:(CGFloat)leftRatio topRatio:(CGFloat)topRatio{

    // 1.创建图片
    UIImage *image = [UIImage imageWithName:imageName];
    // 2.处理图片
    CGFloat left = image.size.width * leftRatio;
    CGFloat top = image.size.height * topRatio;
    
    image =  [image stretchableImageWithLeftCapWidth:left topCapHeight:top];
    // 3.返回图片
    return image;


}


@end
