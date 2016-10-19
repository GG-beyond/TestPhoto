//
//  PhotoItemsViewController.m
//  TestPhoto
//
//  Created by anxindeli on 16/8/16.
//  Copyright © 2016年 anxindeli. All rights reserved.
//



#import "PhotoItemsViewController.h"
#import "PhotoItemCollectionViewCell.h"

@interface PhotoItemsViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation PhotoItemsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat itemWidth = (SCREEN_WIDTH-5.0)/4.0;

    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize=CGSizeMake(itemWidth,itemWidth);
    flowLayout.minimumLineSpacing = 0.0f;
    flowLayout.minimumInteritemSpacing = 0.0f;
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    UICollectionView *collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 5.0, SCREEN_HEIGHT) collectionViewLayout:flowLayout];
    self.collectionView = collectionView;
    [collectionView registerClass:[PhotoItemCollectionViewCell class] forCellWithReuseIdentifier:@"photoItemCell"];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.bounces = YES;
    collectionView.showsVerticalScrollIndicator = YES;
    [self.view addSubview:collectionView];
    [collectionView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
    
}
#pragma mark - UICollectionViewdatasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoItemCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"photoItemCell" forIndexPath:indexPath];

    return cell;
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
