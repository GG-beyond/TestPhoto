//
//  PhotoItemCollectionViewCell.h
//  TestPhoto
//
//  Created by anxindeli on 16/8/16.
//  Copyright © 2016年 anxindeli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZFAssetModel.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface PhotoItemCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *itemImageView;
@property (nonatomic, strong) UIButton *btSelect;
@property (nonatomic, strong) XZFAssetModel *assetModel;
@property (nonatomic, copy) void (^clickPhotoSelBlock)();
- (void)resetColletionInfo:(XZFAssetModel *)assetModel;
@end
