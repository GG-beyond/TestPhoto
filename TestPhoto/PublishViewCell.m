//
//  PublishViewCell.m
//  TestPhoto
//
//  Created by anxindeli on 16/9/6.
//  Copyright © 2016年 anxindeli. All rights reserved.
//

#import "PublishViewCell.h"

@implementation PublishViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self creatSubViews];
    }
    return self;
}
- (void)creatSubViews{
    
    UIImageView *itemImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    [self.contentView addSubview:itemImageView];
    self.itemImageView = itemImageView;
    itemImageView.layer.borderColor = RGBCOLOR(183, 183, 183).CGColor;
    itemImageView.layer.borderWidth = 1.0f;

}
@end
