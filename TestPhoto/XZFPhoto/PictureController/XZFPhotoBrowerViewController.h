//
//  XZFPhotoBrowerViewController.h
//  TestPhoto
//
//  Created by anxindeli on 16/9/1.
//  Copyright © 2016年 anxindeli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZFAssetModel.h"
@interface XZFPhotoBrowerViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *allPhotos;
@property (nonatomic, strong) NSMutableArray *allSelectPhotos;
@property (nonatomic, assign) NSUInteger maxNumberOfSelectImages;
@property (nonatomic, copy) void (^clickReloadBlock)();

- (void)setBrowerDataSourceCurrentAssetModel:(XZFAssetModel *)currentAsset didSelectAssets:(NSMutableArray *)allSelectPhotos allPhotos:(NSMutableArray *)allPhotos maxNumberOfSelectImages:(NSInteger)maxNumberOfSelectImages withType:(NSInteger)type;

@end
