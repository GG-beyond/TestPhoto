//
//  XZFPhotoStore.h
//  TestPhoto
//
//  Created by anxindeli on 16/8/30.
//  Copyright © 2016年 anxindeli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XZFPhotoStoreConfiguraion.h"
#import <Photos/Photos.h>
#import "XZFAssetModel.h"
#import <AssetsLibrary/AssetsLibrary.h>

//typedef NS_ENUM(NSInteger, PickingType) {
//    PickingTypeImage = 0,
//    PickingTypeVideo,
//    PickingTypeAll,
//};
NS_ASSUME_NONNULL_BEGIN

@interface XZFPhotoStore : NSObject
/// @brief 配置类，用来设置相册的类
@property (nonatomic, assign) NSInteger pickingType;
@property (nonatomic, strong, readonly) XZFPhotoStoreConfiguraion *config;
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;


- (void)fetchDefaultAllPhotosGroupPickingType:(NSInteger)pickingType :(void (^)(NSArray<XZFAlbumModel *> *array))completion;

- (void)getAssetsFromFetchResult:(id)result withType:(NSInteger)pickType completion:(void (^)(NSArray<XZFAssetModel *> *models))completion;
- (void)getPic:(NSArray<XZFAssetModel *> *)assetModels size:(CGSize)newSize completion:(void(^)(NSArray<UIImage *> *image))completion;
@end
NS_ASSUME_NONNULL_END