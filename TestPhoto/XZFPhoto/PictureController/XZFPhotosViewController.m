//
//  XZFPhotosViewController.m
//  TestPhoto
//
//  Created by anxindeli on 16/8/29.
//  Copyright © 2016年 anxindeli. All rights reserved.
//

#import "XZFPhotosViewController.h"
#import "PhotoItemCollectionViewCell.h"
#import <Photos/Photos.h>
#import "XZFPhotoManager.h"
#import "XZFPhotoNavViewController.h"
#import "XZFPhotoBrowerViewController.h"
@interface XZFPhotosViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *allAssetModels;//所有的model
@property (nonatomic, strong) NSMutableArray *allSelectAssetModels;//（预览）选中的model

@property (nonatomic, strong) UIButton *btPreview;//预览
@property (nonatomic, strong) UIButton *btComplete;//完成
@property (nonatomic, strong) UILabel *numberOfLabel;//数量

@end

@implementation XZFPhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[UIDevice currentDevice] systemVersion].floatValue>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = self.localizedTitle;
    self.allAssetModels = [NSMutableArray arrayWithCapacity:0];
    self.allSelectAssetModels = [NSMutableArray arrayWithCapacity:0];

    [self creatCollectionView];
    [self creatBottomView];
    NSInteger pickingType = [(XZFPhotoNavViewController *)self.navigationController pickType];
    __weak typeof(self)weakSelf = self;
    [[XZFPhotoManager manager] getAssetsFromFetchResult:self.result withType:pickingType completion:^(NSArray<XZFAssetModel *> * _Nonnull models) {
        
        if (models.count>0) {
            
            [weakSelf.allAssetModels addObjectsFromArray:models] ;
            [weakSelf.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:models.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
            [weakSelf.collectionView reloadData];

        }
    
    }];
    
    
}

- (void)creatCollectionView{
    CGFloat itemWidth = (SCREEN_WIDTH-5.0)/4.0;
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize=CGSizeMake(itemWidth,itemWidth);
    flowLayout.minimumLineSpacing = 0.0f;
    flowLayout.minimumInteritemSpacing = 0.0f;
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    UICollectionView *collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH - 5.0, SCREEN_HEIGHT-64-44) collectionViewLayout:flowLayout];
    self.collectionView = collectionView;
    [collectionView registerClass:[PhotoItemCollectionViewCell class] forCellWithReuseIdentifier:@"photoItemCell"];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.showsVerticalScrollIndicator = YES;
    collectionView.alwaysBounceVertical = YES;//一直可以滑动
    [self.view addSubview:collectionView];
    [collectionView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
}
- (void)creatBottomView{
    //底部view
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT - 44, SCREEN_WIDTH, 44)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    //横线
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    topLine.backgroundColor = RGBCOLOR(217, 217, 217);
    [bottomView addSubview:topLine];
    
    //预览
    UIButton *btPreview = [UIButton buttonWithType:UIButtonTypeCustom];
    btPreview.frame = CGRectMake(10, 2, 40, 40);
    [bottomView addSubview:btPreview];
    [btPreview setTitle:@"预览" forState:UIControlStateNormal];
    [btPreview setTitleColor:RGBCOLOR(34, 34, 34) forState:UIControlStateNormal];
    btPreview.titleLabel.font = [UIFont systemFontOfSize:15];
    [btPreview setTitleColor:[RGBCOLOR(34, 34, 34) colorWithAlphaComponent:0.5] forState:UIControlStateDisabled];
    [btPreview addTarget:self action:@selector(doPreview:) forControlEvents:UIControlEventTouchUpInside];
    btPreview.enabled = false;
    self.btPreview = btPreview;

    //完成
    UIButton *btComplete = [UIButton buttonWithType:UIButtonTypeCustom];
    btComplete.frame = CGRectMake(SCREEN_WIDTH - 10 - 40, 2, 40, 40);
    [btComplete setTitle:@"完成" forState:UIControlStateNormal];
    [btComplete setTitleColor:RGBCOLOR(62, 200, 142) forState:UIControlStateNormal];
    btComplete.titleLabel.font = [UIFont systemFontOfSize:15];
    [btComplete setTitleColor:[RGBCOLOR(62, 200, 142) colorWithAlphaComponent:0.5] forState:UIControlStateDisabled];
    [btComplete addTarget:self action:@selector(doComplete:) forControlEvents:UIControlEventTouchUpInside];
    btComplete.enabled = false;
    self.btComplete = btComplete;
    [bottomView addSubview:btComplete];
    
    //数量
    UILabel *numberOfLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(btComplete.frame) - 5 - 20, 12, 20, 20)];
    numberOfLabel.font = [UIFont systemFontOfSize:15];
    numberOfLabel.text = @"";
    numberOfLabel.backgroundColor = RGBCOLOR(62, 200, 142);
    self.numberOfLabel = numberOfLabel;
    numberOfLabel.hidden = YES;
    numberOfLabel.textColor = [UIColor whiteColor];
    numberOfLabel.textAlignment = NSTextAlignmentCenter;
    numberOfLabel.layer.cornerRadius = 20.0 / 2.0;
    numberOfLabel.layer.masksToBounds = YES;
    [bottomView addSubview:numberOfLabel];

    
}
#pragma mark - UICollectionViewdatasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.allAssetModels.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoItemCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"photoItemCell" forIndexPath:indexPath];
    XZFAssetModel *assetModel = self.allAssetModels[indexPath.row];
    [cell resetColletionInfo:assetModel];
    
    __weak typeof(self) weakSelf = self;
    __weak typeof(XZFAssetModel *) weakAssetModel = assetModel;
    __weak typeof(cell) weakCell = cell;

    cell.clickPhotoSelBlock = ^(){
        
        if (weakSelf.allSelectAssetModels.count >= weakSelf.maxNumberOfSelectImages&&!weakAssetModel.isSelected) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"你最多只能选择%@张照片",@(weakSelf.maxNumberOfSelectImages)] delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
        weakCell.btSelect.selected = !weakCell.btSelect.selected;
        BOOL isSelect = weakCell.btSelect.selected;
        if (isSelect) {
            weakCell.btSelect.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
            //设置动画
            [UIView animateWithDuration:0.3 animations:^{
                weakCell.btSelect.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
            }];

        }
        [weakSelf dealWithModel:weakAssetModel select:isSelect];
        
    };
    return cell;
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    __weak typeof(self) weakSelf = self;
    
    XZFPhotoBrowerViewController *photoBrower = [[XZFPhotoBrowerViewController alloc]init];
    [photoBrower setBrowerDataSourceCurrentAssetModel:self.allAssetModels[indexPath.row] didSelectAssets:weakSelf.allSelectAssetModels allPhotos:self.allAssetModels maxNumberOfSelectImages:self.maxNumberOfSelectImages withType:1];

    photoBrower.clickReloadBlock = ^{
        [weakSelf reloadNewInfo];
        [weakSelf.collectionView reloadData];
    };
    [self.navigationController pushViewController:photoBrower animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 点击选中图片的回调再执行的方法
- (void)dealWithModel:(XZFAssetModel *)assetModel select:(BOOL) isSelect{
    
    assetModel.isSelected = !assetModel.isSelected;
    
    if (isSelect) {
        [self.allSelectAssetModels addObject:assetModel];
    }else{
        [self.allSelectAssetModels removeObject:assetModel];
    }
    [self reloadNewInfo];
    
}
- (void)reloadNewInfo{
    
    
    __weak typeof(self) weakSelf = self;

    if (self.allSelectAssetModels.count >0) {
        
        self.btComplete.enabled = YES;
        self.btPreview.enabled = YES;
        self.numberOfLabel.hidden = NO;
        self.numberOfLabel.text = [NSString stringWithFormat:@"%@",@(self.allSelectAssetModels.count)];
        self.numberOfLabel.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
        //设置动画
        [UIView animateWithDuration:0.3 animations:^{
            
            weakSelf.numberOfLabel.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        }];
        
    }else{
        self.btComplete.enabled = NO;
        self.btPreview.enabled = NO;
        self.numberOfLabel.hidden = YES;
    }

    
}

#pragma mark - 点击预览和完成
- (void)doPreview:(UIButton *)sender{
    
    __weak typeof(self) weakSelf = self;
    
    XZFPhotoBrowerViewController *photoBrower = [[XZFPhotoBrowerViewController alloc]init];
    [photoBrower setBrowerDataSourceCurrentAssetModel:self.allSelectAssetModels[0] didSelectAssets:self.allSelectAssetModels allPhotos:self.allAssetModels maxNumberOfSelectImages:self.maxNumberOfSelectImages withType:0];
    
    photoBrower.clickReloadBlock = ^{
        
        [weakSelf reloadNewInfo];
        [weakSelf.collectionView reloadData];
    };
    [self.navigationController pushViewController:photoBrower animated:YES];
    
}
- (void)doComplete:(UIButton *)sender{
    //选择完成了，可以提交
    XZFPhotoNavViewController *nav = (XZFPhotoNavViewController *)self.navigationController;
    nav.selectAssetModel = self.allSelectAssetModels;
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)dealloc{
    NSLog(@"图片瀑布流释放了");
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
