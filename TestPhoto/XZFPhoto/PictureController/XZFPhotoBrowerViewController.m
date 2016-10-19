//
//  XZFPhotoBrowerViewController.m
//  TestPhoto
//
//  Created by anxindeli on 16/9/1.
//  Copyright © 2016年 anxindeli. All rights reserved.
//

#import "XZFPhotoBrowerViewController.h"
#import "XZFPhotoBrowerCell.h"
#import "XZFAssetModel.h"
#import "XZFPhotoNavViewController.h"
@interface XZFPhotoBrowerViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIAlertViewDelegate>{
    BOOL isShowNav;

}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIButton *rightItem;
@property (nonatomic, strong) UILabel *numberOfLabel;
@property (nonatomic, strong) UIButton *btComplete;

@property (nonatomic, strong) NSMutableArray *commonPhotos;
@property (nonatomic, strong) XZFAssetModel *currentAssetModel;

@end

@implementation XZFPhotoBrowerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[UIDevice currentDevice] systemVersion].floatValue>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    isShowNav = true;
    
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.bottomView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.navigationController != nil)  self.navigationController.navigationBarHidden = true;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.navigationController != nil) self.navigationController.navigationBarHidden = false;
}
- (UICollectionView *)collectionView{
    
    
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize=CGSizeMake(SCREEN_WIDTH,SCREEN_HEIGHT);
        flowLayout.minimumLineSpacing = 0.0f;
        flowLayout.minimumInteritemSpacing = 0.0f;
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];

        
        _collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:flowLayout];
        [_collectionView registerClass:[XZFPhotoBrowerCell class] forCellWithReuseIdentifier:@"browerCell"];
//        _collectionView.backgroundColor = RGBCOLOR(244, 250, 250);
        _collectionView.backgroundColor = [UIColor blackColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
        
        NSInteger index = [self.commonPhotos indexOfObject:self.currentAssetModel];
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    
    return _collectionView;
    
}
- (UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
        _topView.backgroundColor = RGBCOLOR(62, 200, 142);
        
        UIButton *leftItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftItem setTitleColor:RGBCOLOR(255, 255, 255) forState:UIControlStateNormal];
        leftItem.frame = CGRectMake(0, 20, 60, 40);
        [leftItem setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [leftItem setImageEdgeInsets:UIEdgeInsetsMake(13,17, 13, 33)];
        [leftItem.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [leftItem addTarget:self action:@selector(doCallBack:) forControlEvents:UIControlEventTouchUpInside];
        leftItem.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_topView addSubview:leftItem];
        
        //右边的选中（取消）按钮
        UIButton *rightItem = [UIButton buttonWithType:UIButtonTypeCustom];
        rightItem.frame = CGRectMake(SCREEN_WIDTH - 40 - 10, 22, 40, 40);
        [rightItem setImage:[UIImage imageNamed:@"cowDoc_photoSel.png"] forState:UIControlStateSelected];
        [rightItem setImage:[UIImage imageNamed:@"cowDoc_photoUnSel.png"] forState:UIControlStateNormal];
        self.rightItem = rightItem;
        rightItem.selected = self.currentAssetModel.isSelected;
        rightItem.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [rightItem addTarget:self action:@selector(doRightSender:) forControlEvents:UIControlEventTouchUpInside];
        [rightItem setImageEdgeInsets:UIEdgeInsetsMake(7.5, 7.5, 7.5, 7.5)];
        [_topView addSubview:rightItem];
    }
    
    
    return _topView;
}

- (UIView *)bottomView{
    
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 44, SCREEN_WIDTH, 44)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        topLine.backgroundColor = RGBCOLOR(217, 217, 217);
        [_bottomView addSubview:topLine];
        
        UIButton *btComplete = [UIButton buttonWithType:UIButtonTypeCustom];
        btComplete.frame = CGRectMake(SCREEN_WIDTH - 10 - 40, 2, 40, 40);
        [btComplete setTitle:@"完成" forState:UIControlStateNormal];
        [btComplete setTitleColor:RGBCOLOR(62, 200, 142) forState:UIControlStateNormal];
        self.btComplete = btComplete;
        btComplete.titleLabel.font = [UIFont systemFontOfSize:15];
        [btComplete setTitleColor:[RGBCOLOR(62, 200, 142) colorWithAlphaComponent:0.5] forState:UIControlStateDisabled];
        [btComplete addTarget:self action:@selector(doComplete:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:btComplete];
        btComplete.enabled = NO;
        if (self.allSelectPhotos.count>0) {
            btComplete.enabled = YES;
        }
        
        
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
        [_bottomView addSubview:numberOfLabel];
        
    }
    return _bottomView;
    
}

- (void)setBrowerDataSourceCurrentAssetModel:(XZFAssetModel *)currentAsset didSelectAssets:(NSMutableArray *)allSelectPhotos allPhotos:(NSMutableArray *)allPhotos maxNumberOfSelectImages:(NSInteger)maxNumberOfSelectImages withType:(NSInteger)type{

    self.currentAssetModel = currentAsset;
    self.allSelectPhotos = allSelectPhotos;
    self.allPhotos = allPhotos;
    self.maxNumberOfSelectImages = maxNumberOfSelectImages;
    if (type == 1) {
        self.commonPhotos = self.allPhotos;
    }else{
        self.commonPhotos = self.allSelectPhotos;
    }
    
}
//-(BOOL)prefersStatusBarHidden
//{
//    return true;
//}
#pragma mark - UICollectionViewdatasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.commonPhotos.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    XZFPhotoBrowerCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"browerCell" forIndexPath:indexPath];
    [cell dealWithInfo:self.commonPhotos[indexPath.row]];
    __weak typeof(self) weakSelf = self;
    cell.clickShowBlock = ^{
        [weakSelf showOrHiddenNav];
    };
    return cell;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    UICollectionView * collectionView = (UICollectionView *)scrollView;
    //获得偏移量
    CGFloat contentOffSet = collectionView.contentOffset.x;
    //计算偏移量的倍数
    NSUInteger indexSet = contentOffSet / (collectionView.bounds.size.width);
    
    self.currentAssetModel = self.commonPhotos[indexSet];
    self.rightItem.selected = self.currentAssetModel.isSelected;
}
#pragma mark 隐藏或展示Nav
- (void)showOrHiddenNav{
    
    __weak typeof(self) weakSelf = self;
    if (isShowNav) {
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.topView.frame = CGRectMake(0, -64, SCREEN_WIDTH, 64);
            weakSelf.bottomView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 44);
            
        } completion:^(BOOL finished) {
            isShowNav = NO;
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
            weakSelf.bottomView.frame = CGRectMake(0, SCREEN_HEIGHT-44, SCREEN_WIDTH, 44);
            
        } completion:^(BOOL finished) {
            isShowNav = YES;
        }];
    }
}
#pragma mark - 完成
- (void)doComplete:(UIButton *)sender{
    
    XZFPhotoNavViewController *nav = (XZFPhotoNavViewController *)self.navigationController;
    nav.selectAssetModel = self.allSelectPhotos;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 返回  选中
- (void)doCallBack:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
    if (self.clickReloadBlock) self.clickReloadBlock();
}
- (void)doRightSender:(UIButton *)sender{
    
    
    if (self.allSelectPhotos.count>=3&&!self.currentAssetModel.isSelected) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"你最多只能选择%@张照片",@(self.maxNumberOfSelectImages)] delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        [alertView show];
        return;

    }
    
    self.currentAssetModel.isSelected = !self.currentAssetModel.isSelected;
    BOOL isSelect = self.currentAssetModel.isSelected;
    sender.selected = isSelect;
    if (isSelect) {
        [self.allSelectPhotos addObject:self.currentAssetModel];
        
        sender.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
        //设置动画
        [UIView animateWithDuration:0.3 animations:^{
            sender.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        }];
        
    }else{
        [self.allSelectPhotos removeObject:self.currentAssetModel];
    }
    
    if (self.allSelectPhotos.count >0) {
        self.btComplete.enabled = true;
    }else{
        self.btComplete.enabled = false;
    }

    
}
- (void)dealloc{
    NSLog(@"图片阅览详情释放");
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
