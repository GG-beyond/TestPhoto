//
//  XZFPhotoBrowerCell.m
//  TestPhoto
//
//  Created by anxindeli on 16/9/1.
//  Copyright © 2016年 anxindeli. All rights reserved.
//

#import "XZFPhotoBrowerCell.h"
@interface XZFPhotoBrowerCell ()<UIScrollViewDelegate>
/// @brief 是否已经缩放的标志位
@property (nonatomic, assign)BOOL isScale;

/// @brief 底部负责滚动的滚动视图
@property (strong, nonatomic) IBOutlet UIScrollView *bottomScrollView;

//手势
@property (nonatomic, strong) UITapGestureRecognizer * simpleTapGesture;
@property (nonatomic, strong) UITapGestureRecognizer * doubleTapGesture;

/// @brief 缩放比例
@property (nonatomic, assign) CGFloat minScaleZoome;
@property (nonatomic, assign) CGFloat maxScaleZoome;

@end
@implementation XZFPhotoBrowerCell
-(void)dealloc
{
#ifdef YDEBUG
    NSLog(@"YPPhotoBrowerCell Dealloc");
#endif
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self browerCellLoad];
    }
    
    return self;
}

-(void)awakeFromNib
{
    [self browerCellLoad];
}

- (void)browerCellLoad
{
    self.minScaleZoome = 1.0f;
    self.maxScaleZoome = 4.0f;
    
    [self createBottomScrollView];
    [self createImageView];
    [self createDoubleTapGesture];
    [self createSimpleTapGesture];
}


-(void)prepareForReuse
{
    _imageView.image = nil;
    _bottomScrollView.zoomScale = 1.0f;
}


#pragma mark - Action

- (void)simpleTapGestureDidTap:(UITapGestureRecognizer *)sender
{
    NSLog(@"单击了!");
    if (self.clickShowBlock) self.clickShowBlock();
    if (self.bottomScrollView.zoomScale != 1.0f)
    {
        //单击缩小
        [self.bottomScrollView setZoomScale:1.0f animated:true];
    }
}


- (void)doubleTapGestureDidTap:(UITapGestureRecognizer *)touch
{
    NSLog(@"双击了!");
    if (self.bottomScrollView.zoomScale != 1.0f)
    {
        [self.bottomScrollView setZoomScale:1.0f animated:true];
    }
    
    else{
        
        //获得Cell的宽度
        CGFloat width = self.frame.size.width;
        
        //触及范围
        CGFloat scale = width / self.maxScaleZoome;
        
        //获取当前的触摸点
        CGPoint point = [touch locationInView:self.imageView];
        
        //对点进行处理
        CGFloat originX = MAX(0, point.x - width / scale);
        CGFloat originY = MAX(0, point.y - width / scale);
        
        //进行位置的计算
        CGRect rect = CGRectMake(originX, originY, width / scale , width / scale);
        
        //进行缩放
        [self.bottomScrollView zoomToRect:rect animated:true];
        
    }
}


#pragma mark - create Subviews
- (void)createBottomScrollView
{
    if (self.bottomScrollView == nil)
    {
        self.bottomScrollView = [[UIScrollView alloc]init];
        self.bottomScrollView.backgroundColor = [UIColor blackColor];
        self.bottomScrollView.delegate = self;
        self.bottomScrollView.minimumZoomScale = self.minScaleZoome;
        self.bottomScrollView.maximumZoomScale = self.maxScaleZoome;
        [self.contentView addSubview:self.bottomScrollView];
        
        
//        __weak typeof(self) weakSelf = self;
        
        
//        添加约束
        self.bottomScrollView.frame = self.contentView.frame;
//        [self.bottomScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//            
//            make.edges.equalTo(weakSelf.contentView).with.insets(UIEdgeInsetsMake(0, 0, 0, 10));
//            
//        }];
        

    }
}


- (void)createImageView
{
    if (self.imageView == nil)
    {
        self.imageView = [[UIImageView alloc]init];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.bottomScrollView addSubview:self.imageView];
//        __weak typeof(self) weakSelf = self;
        self.imageView.frame = self.contentView.frame;

//        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            
//            make.edges.equalTo(weakSelf.bottomScrollView);
//            make.width.equalTo(weakSelf.bottomScrollView.mas_width);
//            make.height.equalTo(weakSelf.bottomScrollView.mas_height);
//            
//        }];
        

    }
}


- (void)createDoubleTapGesture
{
    if (self.doubleTapGesture == nil)
    {
        self.doubleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapGestureDidTap:)];
        self.doubleTapGesture.numberOfTapsRequired = 2;
        [self.bottomScrollView addGestureRecognizer:self.doubleTapGesture];
    }
}

- (void)createSimpleTapGesture
{
    if (self.simpleTapGesture == nil)
    {
        self.simpleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(simpleTapGestureDidTap:)];
        self.simpleTapGesture.numberOfTapsRequired = 1;
        [self.simpleTapGesture requireGestureRecognizerToFail:self.doubleTapGesture];
        [self.bottomScrollView addGestureRecognizer:self.simpleTapGesture];
    }
}


#pragma mark - <UIScrollViewDelegate>
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}


- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale
{
    [scrollView setZoomScale:scale animated:true];
}
- (void)dealWithInfo:(XZFAssetModel *)assetModel{
    
    __weak typeof(self)weakSelf = self;
    id asset = assetModel.asset;
    if ([asset isKindOfClass:[PHAsset class]]) {
        
        [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:self.imageView.frame.size contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            weakSelf.imageView.image = result;;
            
        }];
        
    }else{
        
    }
}
@end
