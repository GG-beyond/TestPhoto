//
//  ViewController.m
//  TestPhoto
//
//  Created by anxindeli on 16/8/15.
//  Copyright © 2016年 anxindeli. All rights reserved.
//

#import "ViewController.h"
#import "PhotoListViewController.h"
#import "XZFPhotoNavViewController.h"
#import "PublishViewCell.h"
#import "UIImage+ScaleImage.h"
@interface ViewController ()<UIActionSheetDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *allImages;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.allImages = [NSMutableArray arrayWithCapacity:0];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn];
    btn.backgroundColor = [UIColor redColor];
    btn.frame = CGRectMake(100, 100, 100, 50);
    [btn addTarget:self action:@selector(doShowPhotos) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.collectionView];
}
- (UICollectionView *)collectionView{
    
    CGFloat picWidth = (SCREEN_WIDTH - 34 - 20)/3.0;

    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize=CGSizeMake(picWidth,picWidth);
        flowLayout.minimumLineSpacing = 10.0f;
        flowLayout.minimumInteritemSpacing = 0.0f;
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        _collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(17, 200, SCREEN_WIDTH-34, picWidth*3+20) collectionViewLayout:flowLayout];
        [_collectionView registerClass:[PublishViewCell class] forCellWithReuseIdentifier:@"publishCell"];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
//        _collectionView.alwaysBounceVertical = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    
    return _collectionView;
    
}
#pragma mark - UICollectionViewdatasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.allImages.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PublishViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"publishCell" forIndexPath:indexPath];
    CGFloat picWidth = (SCREEN_WIDTH - 34 - 20)/3.0;
    
    cell.itemImageView.image = [UIImage imageByScalingAndCroppingForSize:CGSizeMake(picWidth, picWidth) withImage:self.allImages[indexPath.row]];
    return cell;
}
- (void)doShowPhotos{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机图库中选择", nil];
    [actionSheet showInView:self.view];
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    __weak typeof(self) weakSelf = self;
    switch (buttonIndex) {
        case 0:
            //点击的是拍照
            [self openCamera];
            break;
        case 1:
            //点击的是图库选择
        {
            XZFPhotoNavViewController *photoNav = [[XZFPhotoNavViewController alloc] init];
            photoNav.pickType = PickingTypeImage;
            photoNav.maxNumberOfSelectImages = 3;
            photoNav.returnSelectImagesBlock = ^(NSArray<UIImage *> *images){
                for (UIImage *image in images){
                    [weakSelf.allImages addObject:image];
                }
                [weakSelf.collectionView reloadData];
            };
            [self presentViewController:photoNav animated:YES completion:nil];
        }
            break;
        case 2:
            //点击的是取消
            break;
        default:
            break;
    }
    
}
#pragma  mark - 打开相机
- (void)openCamera{
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO) {
        return;
    }
    
    UIImagePickerController *cameraPickerController = [[UIImagePickerController alloc] init];
    cameraPickerController.delegate = self;
    cameraPickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:cameraPickerController animated:YES completion:nil];
}
#pragma mark -
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (image==nil) {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    //调整图片的大小
    [self.allImages addObject:image];
    [self.collectionView reloadData];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
