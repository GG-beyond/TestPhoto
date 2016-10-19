//
//  XZFPhotoNavViewController.m
//  TestPhoto
//
//  Created by anxindeli on 16/8/29.
//  Copyright © 2016年 anxindeli. All rights reserved.
//

#import "XZFPhotoNavViewController.h"
#import "XZFPhotoGroupViewController.h"
#import "XZFAssetModel.h"
#import "XZFPhotoManager.h"

@interface XZFPhotoNavViewController ()

@end

@implementation XZFPhotoNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewControllers = @[[[XZFPhotoGroupViewController alloc]init]];
    XZFPhotoGroupViewController *rootViewController = self.viewControllers.firstObject;
    rootViewController.maxNumberOfSelectImages = self.maxNumberOfSelectImages;
}
- (void)setSelectAssetModel:(NSArray *)selectAssetModel{
    
    __weak typeof(self)weakSelf = self;
    _selectAssetModel = selectAssetModel;
    XZFPhotoManager *photoManager = [XZFPhotoManager manager];
    [photoManager getPic:selectAssetModel size:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT) completion:^(NSArray<UIImage *> *image) {
        
        if (weakSelf.returnSelectImagesBlock) {
            weakSelf.returnSelectImagesBlock(image);
        }
        
    }];
    
    
}
- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    UIViewController *topVc = self.topViewController;
#ifdef DEBUG
    __weak UIViewController *controller = topVc;
    NSString *className = NSStringFromClass(topVc.class);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (controller) {
            
            NSString *message = [NSString stringWithFormat:@"%@内存泄漏了，请通知工程师",className];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
        }
    });
#endif
    
    return [super popViewControllerAnimated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
