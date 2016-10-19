//
//  UIImage+ScaleImage.h
//  TestPhoto
//
//  Created by anxindeli on 16/8/31.
//  Copyright © 2016年 anxindeli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ScaleImage)
+ (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize withImage:(UIImage *)image;

@end
