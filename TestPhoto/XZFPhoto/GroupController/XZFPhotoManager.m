//
//  XZFPhotoManager.m
//  TestPhoto
//
//  Created by anxindeli on 16/8/29.
//  Copyright © 2016年 anxindeli. All rights reserved.
//

#import "XZFPhotoManager.h"
@implementation XZFPhotoManager
+ (instancetype)manager {
    static XZFPhotoManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
        manager.photoStore = [[XZFPhotoStore alloc] init];

    });
    return manager;
}

- (void)getCameraRollAlbumPickingType:(NSInteger)pickType completion:(void (^)(NSArray<XZFAlbumModel *> *array))completion{
    
    [self.photoStore fetchDefaultAllPhotosGroupPickingType:pickType :^(NSArray<XZFAlbumModel *> * _Nonnull array) {
        if (completion) {
            completion(array);
        }
        
    }];
}
- (void)getAssetsFromFetchResult:(id)result withType:(NSInteger)pickType completion:(void (^)(NSArray<XZFAssetModel *> *models))completion{
    
    [self.photoStore getAssetsFromFetchResult:result withType:pickType completion:^(NSArray<XZFAssetModel *> * _Nonnull models) {
        if (completion) {
            completion(models);
        }
    }];
}

- (void)getPic:(NSArray<XZFAssetModel *> *)assetModels size:(CGSize)newSize completion:(void(^)(NSArray<UIImage *> *image))completion{
    [self.photoStore getPic:assetModels size:newSize completion:^(NSArray<UIImage *> * _Nonnull image) {
        if (completion) {
            completion(image);
        }
    }];
}

@end
