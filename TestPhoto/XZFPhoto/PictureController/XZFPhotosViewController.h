//
//  XZFPhotosViewController.h
//  TestPhoto
//
//  Created by anxindeli on 16/8/29.
//  Copyright © 2016年 anxindeli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZFAssetModel.h"

@interface XZFPhotosViewController : UIViewController
@property (nonatomic, assign) NSUInteger maxNumberOfSelectImages;
@property (nonatomic, strong) id result;
@property (nonatomic, strong) NSString *localizedTitle;

@end
