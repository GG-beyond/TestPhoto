//
//  PhotoListViewController.m
//  TestPhoto
//
//  Created by anxindeli on 16/8/15.
//  Copyright © 2016年 anxindeli. All rights reserved.
//


#import "PhotoListViewController.h"
#import <Photos/Photos.h>
#import "PhotoTableViewCell.h"
#import "PhotoItemsViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
//NSString * ConfigurationCameraRoll = @"Camera Roll";
//NSString * ConfigurationHidden = @"Hidden";
//NSString * ConfigurationSlo_mo = @"Slo-mo";
//NSString * ConfigurationScreenshots = @"Screenshots";
//NSString * ConfigurationVideos = @"Videos";
//NSString * ConfigurationPanoramas = @"Panoramas";
//NSString * ConfigurationTime_lapse = @"Time-lapse";
//NSString * ConfigurationRecentlyAdded = @"Recently Added";
//NSString * ConfigurationRecentlyDeleted = @"Recently Deleted";
//NSString * ConfigurationBursts = @"Bursts";
//NSString * ConfigurationFavorite = @"Favorite";
//NSString * ConfigurationSelfies = @"Selfies";

@interface PhotoListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *photosAttay;;

@end

@implementation PhotoListViewController
{
    NSMutableArray *_albumsArray;
    ALAssetsLibrary *_assetsLibrary;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.photosAttay = [NSMutableArray array];
    
    PhotoItemsViewController *vc = [[PhotoItemsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:NO];

    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:tableView];
    tableView.dataSource = self;
    tableView.delegate = self;
    
    //判断设备是否有图库
    ALAuthorizationStatus authorizationStatus = [ALAssetsLibrary authorizationStatus];

    if (authorizationStatus == ALAuthorizationStatusRestricted || authorizationStatus == ALAuthorizationStatusDenied) {
        return;
    }else{
        
     
        
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
        _albumsArray = [[NSMutableArray alloc] init];
        [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            if (group) {
                [group setAssetsFilter:[ALAssetsFilter allPhotos]];
                if (group.numberOfAssets > 0) {
                    // 把相册储存到数组中，方便后面展示相册时使用
                    [_albumsArray addObject:group];
                }
            } else {
                if ([_albumsArray count] > 0) {
                    // 把所有的相册储存完毕，可以展示相册列表
                } else {
                    // 没有任何有资源的相册，输出提示
                }
            }
            [self.tableView reloadData];

        } failureBlock:^(NSError *error) {
            NSLog(@"Asset group not found!\n");
        }];
        
        /*
        PHFetchOptions *allPhotoOptions = [[PHFetchOptions alloc] init];
        allPhotoOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        
        PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        [smartAlbums enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull collection, NSUInteger idx, BOOL *stop) {
            if ([self.groupNamesConfig containsObject:collection.localizedTitle])
            {
                [self.photosAttay addObject:collection];
            }
        }];
        
        
        //针对部分顺序问题将胶卷相册拍到第一位
        for (NSUInteger i = 0 ;i < self.photosAttay.count; i++)
        {
            //获取当前的相册组
            PHAssetCollection * collection = self.photosAttay[i];
            
            if ([collection.localizedTitle isEqualToString:NSLocalizedString(@"Camera Roll", @"")])
            {
                //移除该相册
                [self.photosAttay removeObject:collection];
                
                //添加至第一位
                [self.photosAttay insertObject:collection atIndex:0];
                
                break;
            }
        }
        
        
        PHFetchResult *smartAlbums2 = [PHAssetCollection fetchTopLevelUserCollectionsWithOptions:nil];
        [smartAlbums2 enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull collection, NSUInteger idx, BOOL *stop) {
            [self.photosAttay addObject:collection];

        }];
        [self.tableView reloadData];
         */
    }
    

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _albumsArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"cell";
    PhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PhotoTableViewCell" owner:self options:nil] lastObject];
    }
    ALAssetsGroup *group = _albumsArray[indexPath.row];
    NSString *name = [group valueForProperty:ALAssetsGroupPropertyName];
    cell.nameLabel.text = name;
    
   /*
    PHAssetCollection *collection = self.photosAttay[indexPath.row];
    //获取照片资源
    PHFetchResult * assetResult = [PHAsset fetchAssetsInAssetCollection:collection options:nil];

    NSUInteger count = [assetResult countOfAssetsWithMediaType:PHAssetMediaTypeImage];
    
    //获取屏幕的点
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize newSize = CGSizeMake(50*scale, 50*scale);
    
    __weak typeof(cell) weakCell = cell;
    //开始截取照片
    [[PHCachingImageManager defaultManager] requestImageForAsset:assetResult.lastObject targetSize:newSize contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        weakCell.headImageView.image = result;
        
        weakCell.nameLabel.text = [NSString stringWithFormat:@"%@(%lu)",collection.localizedTitle,(unsigned long)count];

    }];

    */
    
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PhotoItemsViewController *vc = [[PhotoItemsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (NSArray *)groupNamesConfig{
//    NSArray *groupNames = @[NSLocalizedString(ConfigurationCameraRoll, @""),
//                   NSLocalizedString(ConfigurationSlo_mo, @""),
//                   NSLocalizedString(ConfigurationScreenshots, @""),
//                   NSLocalizedString(ConfigurationVideos, @""),
//                   NSLocalizedString(ConfigurationPanoramas, @""),
//                   NSLocalizedString(ConfigurationRecentlyAdded, @""),
//                   NSLocalizedString(ConfigurationSelfies, @"")];
//    return groupNames;
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
