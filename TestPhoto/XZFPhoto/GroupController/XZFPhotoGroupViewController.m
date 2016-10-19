//
//  XZFPhotoGroupViewController.m
//  TestPhoto
//
//  Created by anxindeli on 16/8/29.
//  Copyright © 2016年 anxindeli. All rights reserved.
//

#import "XZFPhotoGroupViewController.h"
#import "XZFPhotosViewController.h"
#import "PhotoTableViewCell.h"
#import "XZFPhotoManager.h"
#import "XZFPhotoNavViewController.h"

@interface XZFPhotoGroupViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSArray *grops;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation XZFPhotoGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"相册";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemDidTap)];
    
    
    [self creatTableView];
    _grops = [NSArray array];
    __weak typeof(self)weakSelf = self;

    NSInteger pickingType = [(XZFPhotoNavViewController *)self.navigationController pickType];
    //获取默认的相片组
    XZFPhotoManager *photoManager = [XZFPhotoManager manager];
    [photoManager getCameraRollAlbumPickingType:pickingType completion:^(NSArray<XZFAlbumModel *> *array) {
        weakSelf.grops = array;
        [weakSelf.tableView reloadData];
        //跳转，没有动画
        if (array.count >0) {
            [self pushToPhotosViewController:[NSIndexPath indexPathForRow:0 inSection:0] animated:false];
        }

    }];
}

- (void)creatTableView{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.tableFooterView = [UIView new];
    
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.grops.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"cell";
    PhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PhotoTableViewCell" owner:self options:nil] lastObject];
    }
    
    XZFAlbumModel *albumModel = self.grops[indexPath.row];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@(%lu)",albumModel.name,(unsigned long)albumModel.count];
    CGSize newSize = CGSizeMake(50, 50);
    __weak typeof(cell)weakCell = cell;
    if ([albumModel.result isKindOfClass:[PHFetchResult class]]) {
        //获取 相册封面
        PHFetchResult *assetResult = albumModel.result;
        [[PHCachingImageManager defaultManager] requestImageForAsset:assetResult.lastObject targetSize:newSize contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            weakCell.headImageView.image = result;
            
        }];
    }else{
        CGFloat scale = [UIScreen mainScreen].scale;
        ALAssetsGroup *grop = albumModel.result;
        cell.headImageView.image =[UIImage imageWithCGImage:grop.posterImage scale:scale orientation:UIImageOrientationUp];

    }
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self pushToPhotosViewController:indexPath animated:true];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}
#pragma mark - 跳转问题
- (void)pushToPhotosViewController:(NSIndexPath *)indexPath animated:(BOOL)animation{
    XZFAlbumModel *albumModel = self.grops[indexPath.row];
    XZFPhotosViewController *photosVC = [[XZFPhotosViewController alloc] init];
    photosVC.result = albumModel.result;
    photosVC.localizedTitle = albumModel.name;
    photosVC.maxNumberOfSelectImages = self.maxNumberOfSelectImages;
    [self.navigationController pushViewController:photosVC animated:animation];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)rightBarButtonItemDidTap{
    [self dismissViewControllerAnimated:true completion:^{
        
    }];
}
- (void)dealloc{
    NSLog(@"相册列表释放了");
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
