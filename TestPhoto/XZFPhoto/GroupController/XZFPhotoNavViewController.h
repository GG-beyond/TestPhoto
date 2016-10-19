//
//  XZFPhotoNavViewController.h
//  TestPhoto
//
//  Created by anxindeli on 16/8/29.
//  Copyright © 2016年 anxindeli. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
typedef NS_ENUM(NSInteger, PickingType) {
    PickingTypeImage = 1,
    PickingTypeVideo,
    PickingTypeAll,
};

@interface XZFPhotoNavViewController : UINavigationController
/**
 *  最大限制数量
 */
@property (nonatomic, assign) NSUInteger maxNumberOfSelectImages;
@property (nonatomic, assign) PickingType pickType;
@property (nonatomic, copy) void (^returnSelectImagesBlock)(NSArray *images);
@property (nonatomic, strong) NSArray *selectAssetModel;
@end
