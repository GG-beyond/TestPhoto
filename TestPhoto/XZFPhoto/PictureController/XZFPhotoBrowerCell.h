//
//  XZFPhotoBrowerCell.h
//  TestPhoto
//
//  Created by anxindeli on 16/9/1.
//  Copyright © 2016年 anxindeli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZFAssetModel.h"
#import <Photos/Photos.h>

@interface XZFPhotoBrowerCell : UICollectionViewCell
@property (strong, nonatomic) UIImageView *imageView;
@property (nonatomic, copy) void (^clickShowBlock)();
- (void)dealWithInfo:(XZFAssetModel *)assetModel;
@end
