//
//  XZFPhotoStore.m
//  TestPhoto
//
//  Created by anxindeli on 16/8/30.
//  Copyright © 2016年 anxindeli. All rights reserved.
//

#import "XZFPhotoStore.h"

@implementation XZFPhotoStore
-(instancetype)init{
    self = [super init];
    if (self) {
        _config = [[XZFPhotoStoreConfiguraion alloc]init];
    }
    return self;
}
- (void)fetchDefaultAllPhotosGroupPickingType:(NSInteger)pickingType :(void (^)(NSArray<XZFAlbumModel *> *array))completion{

    self.pickingType = pickingType;

    __weak typeof(self) weakSelf = self;

    if (iOS8Later) {
        //智能分组
        __block NSMutableArray <XZFAlbumModel *> * defaultAllGroups = [NSMutableArray arrayWithCapacity:0];

        [self fetchDefaultPhotosGroup:^(NSArray<PHAssetCollection *> *array) {
            
            PHFetchOptions *option = [[PHFetchOptions alloc] init];
            if (weakSelf.pickingType == 1) {
                option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
            }else if (weakSelf.pickingType == 2){
                option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeVideo];
            }

            for (PHAssetCollection *assetCollection in array){
                XZFAlbumModel *albumModel = [[XZFAlbumModel alloc]init];
                albumModel.name = assetCollection.localizedTitle;
                PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:assetCollection options:option];
                if (result.count < 1) continue;//去除空文件夹
                albumModel.count = result.count;
                albumModel.result = result;
                [defaultAllGroups addObject:albumModel];
            }
            
            __weak typeof(option) weakOption = option;

            [weakSelf fetchTopLevelUserCollection:^(NSArray<PHAssetCollection *> * _Nonnull array) {
                
                for (PHAssetCollection *assetCollection in array){
                    XZFAlbumModel *albumModel = [[XZFAlbumModel alloc]init];
                    albumModel.name = assetCollection.localizedTitle;
                    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:assetCollection options:weakOption];
                    if (result.count < 1) continue;//去除空文件夹
                    albumModel.count = result.count;
                    albumModel.result = result;
                    [defaultAllGroups addObject:albumModel];

                }
                completion([NSArray arrayWithArray:defaultAllGroups]);
                defaultAllGroups = nil;

            }];
            
            
        }];
        
    }else{
        
       __block NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:0];
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
        [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            if (group) {
                
                if (weakSelf.pickingType == 1) {
                    [group setAssetsFilter:[ALAssetsFilter allPhotos]];
                }else if (weakSelf.pickingType == 2){
                    [group setAssetsFilter:[ALAssetsFilter allVideos]];
                }else{
                    [group setAssetsFilter:[ALAssetsFilter allAssets]];
                }
                if (group.numberOfAssets > 0) {
                    //
                    [tempArray addObject:group];
                }
            }else{
                [self handleALAsset:tempArray completion:^(NSArray<XZFAssetModel *> *models) {
                    
                    completion([NSArray arrayWithArray:models]);
                    tempArray = nil;
                }];
            }
            
        } failureBlock:^(NSError *error) {
            NSLog(@"Asset group not found!\n");
        }];
        
    }
    
}
//@brief 获取系统相册，并过滤config类型，并排序（将相册交卷放到第一位）
-(void)fetchDefaultPhotosGroup:(void (^)(NSArray * array))groups
{
    __weak typeof(self) weakSelf = self;
    
    [self fetchBasePhotosGroup:^(PHFetchResult * _Nullable result) {
        
        if (result == nil) return;
        
        [weakSelf preparationWithFetchResult:result complete:^(NSArray<PHAssetCollection *> * _Nonnull defalutGroup) {
            groups([weakSelf handleAssetCollection:defalutGroup]);
        
        }];
        
    }];
}
/** 获取最基本的智能分组 */
-(void)fetchBasePhotosGroup:(void(^)( PHFetchResult * result))completeBlock
{


    PHFetchResult * smartGroups = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    //进行检测
    [self storeCheckAuthorizationStatusAllow:^{//获得准许
        
        completeBlock(smartGroups);
        
    } denied:^{}];//无操作
}
- (void)fetchTopLevelUserCollection:(void (^)(NSArray<PHAssetCollection *> * _Nonnull array))groups{
    

    NSMutableArray <PHAssetCollection *> * preparationCollections = [NSMutableArray arrayWithCapacity:0];

    PHFetchResult *customAlbums = [PHAssetCollection fetchTopLevelUserCollectionsWithOptions:nil];
    if (customAlbums.count == 0) {
        groups(preparationCollections);
    }
    [customAlbums enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull collection, NSUInteger idx, BOOL *stop) {
        
        [preparationCollections addObject:collection];
        
        if (idx == customAlbums.count - 1)
        {
            groups([NSArray arrayWithArray:preparationCollections]);
        }
    }];

}

#pragma mark - 处理照片
/// @brief 将configuration属性中的类别进行筛选
-(void)preparationWithFetchResult:(PHFetchResult<PHAssetCollection *> *)fetchResult complete:(void (^)(NSArray *array))groups
{
    NSMutableArray <PHAssetCollection *> * preparationCollections = [NSMutableArray arrayWithCapacity:0];
    
    
    [fetchResult enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([_config.groupNamesConfig containsObject:obj.localizedTitle])
        {
            [preparationCollections addObject:obj];
        }
        
        if (idx == fetchResult.count - 1)
        {
            groups([NSArray arrayWithArray:preparationCollections]);
        }
        
    }];
    
}
#pragma mark - private function

/** 将assetCollections 中的胶卷相册排到第一位 */
-(NSArray <PHAssetCollection *> *)handleAssetCollection:(NSArray <PHCollection *> *)assetCollections
{
    NSMutableArray <PHAssetCollection *> * collections = [NSMutableArray arrayWithArray:assetCollections];
    
    //针对部分顺序问题将胶卷相册拍到第一位
    for (NSUInteger i = 0 ;i < collections.count; i++)
    {
        //获取当前的相册组
        PHAssetCollection * collection = collections[i];
        
        if ([collection.localizedTitle isEqualToString:NSLocalizedString(ConfigurationCameraRoll, @"")])
        {
            //移除该相册
            [collections removeObject:collection];
            
            //添加至第一位
            [collections insertObject:collection atIndex:0];
            
            break;
        }
    }
    
    return [collections mutableCopy];
}
//
//



#pragma mark - 权限检测
- (void)storeCheckAuthorizationStatusAllow:(void(^)(void))allowBlock denied:(void(^)(void))deniedBlock
{
    //获取权限
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    
    //switch 判定
    switch (status)
    {
            //准许
        case PHAuthorizationStatusAuthorized: allowBlock(); break;
            
            //待获取
        case PHAuthorizationStatusNotDetermined:
        {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                
                if (status == PHAuthorizationStatusAuthorized)//允许，进行回调
                {
                    allowBlock();
                }
                else
                {
                    deniedBlock();
                }
            }];
        }
            break;
            
            //不允许,进行无权限回调
        case PHAuthorizationStatusDenied:
        case PHAuthorizationStatusRestricted: deniedBlock(); break;
    }
}
#pragma mark - 处理ALAsset照片顺序问题
- (void)handleALAsset:(NSArray<ALAssetsGroup *> *)groups completion:(void (^)(NSArray<XZFAssetModel *> *models))completion{
    
    NSMutableArray *allAssets = [NSMutableArray arrayWithCapacity:0];
    for (ALAssetsGroup *group in groups) {
        NSString *name = [group valueForProperty:ALAssetsGroupPropertyName];
        XZFAlbumModel *albumModel = [[XZFAlbumModel alloc]init];
        albumModel.name = name;
        albumModel.count = group.numberOfAssets;
        albumModel.result = group;
        if ([name isEqualToString:NSLocalizedString(ConfigurationCameraRoll, @"")]) {
            [allAssets insertObject:albumModel atIndex:0];
        }else{
            [allAssets addObject:albumModel];
        }

    }
    if (completion)completion(allAssets);
}
#pragma mark - 获取相册里的照片
- (void)getAssetsFromFetchResult:(id)result withType:(NSInteger)pickType completion:(void (^)(NSArray<XZFAssetModel *> *models))completion{
    __block NSMutableArray *photoArr = [[NSMutableArray alloc]initWithCapacity:0];
    if ([result isKindOfClass:[PHFetchResult class]]) {
        
        PHFetchResult *fetchResult = (PHFetchResult *)result;
        __weak typeof(fetchResult) weakFetchResult = fetchResult;
        [fetchResult enumerateObjectsUsingBlock:^(PHAsset  *asset, NSUInteger idx, BOOL * _Nonnull stop) {
            
            
            if (asset.mediaType == pickType) {
                
                XZFAssetModel *model = [[XZFAssetModel alloc] init];
                model.asset = asset;
                model.timeLength = [NSString stringWithFormat:@"%f",asset.duration];
                [photoArr addObject:model];

            }
            if (idx == weakFetchResult.count - 1)
            {
                if (completion) completion([NSArray arrayWithArray:photoArr]);
                photoArr = nil;

            }

            
            
        }];
        
        
    }else{
        ALAssetsGroup *group = (ALAssetsGroup *)result;
        if (pickType==3) {
            [group setAssetsFilter:[ALAssetsFilter allAssets]];
        } else if (pickType==2) {
            [group setAssetsFilter:[ALAssetsFilter allVideos]];
        } else if (pickType==1) {
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        }
        
        [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (result == nil) {
                if (completion) completion(photoArr);
            }
            
            XZFAssetModel *model = [[XZFAssetModel alloc] init];
            model.asset = result;
            if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo]) {
                model.type = XZFAssetModelMediaTypeVideo;
            }
            model.timeLength = [NSString stringWithFormat:@"%@",[result valueForProperty:ALAssetPropertyDuration]];
            [photoArr addObject:model];
            if (*stop) {
                photoArr = nil;
            }

        }];
    }
    
    
}
#pragma mark - 获取照片
- (void)getPic:(NSArray<XZFAssetModel *> *)assetModels size:(CGSize)newSize completion:(void(^)(NSArray<UIImage *> *image))completion{
    
    
    __block NSMutableArray <UIImage *> * images = [NSMutableArray arrayWithCapacity:assetModels.count];
    
    for (XZFAssetModel *model in assetModels) {
        
        
        if ([model.asset isKindOfClass:[PHAsset class]]) {
            
            //获取资源
            PHAsset * asset = model.asset;
            //获取图片类型
            
            PHImageRequestOptions * option = [[PHImageRequestOptions alloc] init];
            option.deliveryMode = 0;
            option.synchronous = true;
            
            //请求图片
            [[PHImageManager defaultManager]requestImageForAsset:asset targetSize:newSize contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                
                [images addObject:result];
                
                if (images.count == assetModels.count)//表示已经添加完毕
                {
                    //回调
                    completion([images mutableCopy]);
                    images = nil;
                }
            }];
            
            
            
        }else{
            ALAsset * alAsset = model.asset;

            ALAssetRepresentation *assetRep = [alAsset defaultRepresentation];
#pragma clang diagnostic pop
            
            dispatch_async(dispatch_get_global_queue(0,0), ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                CGImageRef originalImageRef = [assetRep fullResolutionImage];
#pragma clang diagnostic pop
                UIImage *originalImage = [UIImage imageWithCGImage:originalImageRef scale:1.0 orientation:UIImageOrientationUp];
                [images addObject:originalImage];

                dispatch_async(dispatch_get_main_queue(), ^{
                    if (images.count == assetModels.count)//表示已经添加完毕
                    {
                        completion([images mutableCopy]);
                        images = nil;

                    }
                    
                });
            });

            
        }
        
        
    }
    
        
}
- (void)dealloc{
    
}
@end
