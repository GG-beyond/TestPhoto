//
//  XZFPhotoManager.h
//  TestPhoto
//
//  Created by anxindeli on 16/8/29.
//  Copyright © 2016年 anxindeli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "XZFAssetModel.h"
#import "XZFPhotoStore.h"



@interface XZFPhotoManager : NSObject
@property (nonatomic, strong) ALAssetsLibrary *assetLibrary;
@property (nonatomic, strong) XZFPhotoStore *photoStore;

/**
 *  创建实例Manager
 *
 *  @return manager
 */
+ (instancetype)manager;
/**
 *  获取相册集合
 *
 *  @param pickType   获取类型（0：图片 1：视频 2：所有类型）
 *  @param completion
 */
- (void)getCameraRollAlbumPickingType:(NSInteger)pickType completion:(void (^)(NSArray<XZFAlbumModel *> *array))completion;
/**
 *  获取相片
 *
 *  @param result     类型
 *  @param pickType   获取类型（0：图片 1：视频 2：所有类型）
 *  @param completion completion
 */
- (void)getAssetsFromFetchResult:(id)result withType:(NSInteger)pickType completion:(void (^)(NSArray<XZFAssetModel *> *models))completion;

/**
 *  获取相片
 *
 *  @param assetModels 根据model
 *  @param newSize     尺寸
 *  @param completion  回调块
 */
- (void)getPic:(NSArray<XZFAssetModel *> *)assetModels size:(CGSize)newSize completion:(void(^)(NSArray<UIImage *> *image))completion;
@end
