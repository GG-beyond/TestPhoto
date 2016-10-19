//
//  PhotoItemCollectionViewCell.m
//  TestPhoto
//
//  Created by anxindeli on 16/8/16.
//  Copyright © 2016年 anxindeli. All rights reserved.
//

#import "PhotoItemCollectionViewCell.h"
#import "UIImage+ScaleImage.h"

@implementation PhotoItemCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addItemImageView];
    }
    return self;
}
- (void)addItemImageView{
    
    self.backgroundColor = [UIColor whiteColor];
    //当前屏幕的宽度，以及图片的宽度、高度
    CGFloat itemWidth = (SCREEN_WIDTH - 20-5.0)/4.0;
    
    UIImageView *itemImageView  = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, itemWidth, itemWidth)];
    self.itemImageView = itemImageView;
    [self.contentView addSubview:itemImageView];
    
    
    UIButton *btSelect = [UIButton buttonWithType:UIButtonTypeCustom];
    btSelect.frame = CGRectMake(itemWidth-25, 5, 30, 30);
    self.btSelect = btSelect;
    [btSelect setImage:[UIImage imageNamed:@"pic_unSel.png"] forState:UIControlStateNormal];
    [btSelect setImage:[UIImage imageNamed:@"pic_sel.png"] forState:UIControlStateSelected];
    [btSelect addTarget:self action:@selector(doSelPic:) forControlEvents:UIControlEventTouchUpInside];
    btSelect.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    [self.contentView addSubview:btSelect];
    

}
- (void)doSelPic:(UIButton *)sender{
    
    if (self.clickPhotoSelBlock) self.clickPhotoSelBlock();
}
- (void)resetColletionInfo:(XZFAssetModel *)assetModel{
    
    self.assetModel = assetModel;
    
    self.btSelect.selected = assetModel.isSelected;

    
    CGFloat itemWidth = (SCREEN_WIDTH - 20-5.0)/4.0;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize newSize = CGSizeMake(itemWidth * scale, itemWidth * scale);
    id asset = assetModel.asset;
    
    __weak typeof(self)weakSelf = self;
    if ([asset isKindOfClass:[PHAsset class]]) {
        
        [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:newSize contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            
            weakSelf.itemImageView.image = [UIImage imageByScalingAndCroppingForSize:newSize withImage:result];
            
        }];

    }else{
        
        ALAsset *alAsset = assetModel.asset;

        UIImage *image = [UIImage imageWithCGImage:alAsset.aspectRatioThumbnail];
        weakSelf.itemImageView.image = [UIImage imageByScalingAndCroppingForSize:newSize withImage:image];


    }
}
@end
