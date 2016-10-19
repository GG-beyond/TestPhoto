//
//  XZFAssetModel.h
//  TestPhoto
//
//  Created by anxindeli on 16/8/30.
//  Copyright © 2016年 anxindeli. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, XZFAssetModelMediaType) {
    XZFAssetModelMediaTypePhoto = 0,
    XZFAssetModelMediaTypeLivePhoto,
    XZFAssetModelMediaTypeVideo,
    XZFAssetModelMediaTypeAudio,
};

//对应一张图片
@interface XZFAssetModel : NSObject
@property (nonatomic, strong) id asset;             ///< PHAsset or ALAsset
@property (nonatomic, assign) BOOL isSelected;      ///< The select status of a photo, default is No
@property (nonatomic, assign) XZFAssetModelMediaType type;
@property (nonatomic, strong) NSString *timeLength;

@end

//对应一个相册集
@interface XZFAlbumModel : NSObject

@property (nonatomic, strong) NSString *name;        ///< The album name
@property (nonatomic, assign) NSInteger count;       ///< Count of photos the album contain
@property (nonatomic, strong) id result;             ///< PHFetchResult<PHAsset> or ALAssetsGroup<ALAsset>
@end
