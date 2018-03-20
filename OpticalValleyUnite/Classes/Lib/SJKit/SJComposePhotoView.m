//
//  SJComposePhotoView.m
//  微博
//
//  Created by Mac on 15-3-14.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#import "SJComposePhotoView.h"
#import "SJPhotpView.h"
#import "UIView+AdjustFrame.h"
#import "SJTakePhotoHandle.h"

@interface SJComposePhotoView ()

@property (nonatomic, strong) UIButton *addPhotoBtn;

@property (nonatomic, strong) UIButton *movieBtn;

@end

@implementation SJComposePhotoView

-(void)dealloc{
    //移除所有通知监控
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {

        [self addSubview:self.addPhotoBtn];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self addSubview:self.addPhotoBtn];
  
    }
    return self;
}

- (void)setPhoto:(UIImage *)photo{
    _photo = photo;
    if (self.subviews.count >=self.maxCount) {
        [self.addPhotoBtn removeFromSuperview];
    }
    SJPhotpView *imageView = [SJPhotpView photoViewWithImage:photo DeletBtnClickBlock:^{
        
        [self setNeedsLayout];
    }];
    [self insertSubview:imageView belowSubview:self.addPhotoBtn];
}


- (void)setPhotos:(NSArray *)photos{
    _photos = photos;
    
    for (UIImage *photo in photos) {
        self.photo = photo;
    }
}

#pragma mark - PublicMethod
- (NSArray *)imagesForLoad{
    NSMutableArray *temp = [NSMutableArray arrayWithArray:self.subviews];
    //最后一个是按钮按钮
    [temp removeLastObject];
    
    NSMutableArray *images = [NSMutableArray array];
    for (SJPhotpView *photoView in temp) {
        [images addObject:photoView.image];
    }
    
    return images;
}

- (NSArray<UIImage *> *)images{
    
    NSMutableArray *temp = [NSMutableArray array];
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[SJPhotpView class]]) {
            [temp addObject:[(SJPhotpView *)view image]];
        }
    }
    
    return temp;
}


#pragma mark - Event respose


/**
 *  添加(选择)图片
 */
- (void)addPhotoBtnClick{
    UIWindow *SJKeyWindow = [UIApplication sharedApplication].keyWindow;
    UIViewController *vc = [(UITabBarController *)SJKeyWindow.rootViewController selectedViewController];
    
    [SJTakePhotoHandle takePhotoWithImageBlock:^(UIImage *image) {
        
        self.photo = image;
        
    } ViewController:vc selectIndex:1];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    NSInteger cloms = 4;
    
    CGFloat margin = 10;
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat wh = self.height - 2*margin;
    NSInteger col = 0;
    NSInteger row = 0;
    NSInteger i = 0;
    
    for (UIImageView *imgV in self.subviews) {
        col = i % cloms;
        row = i / cloms;
        
        x = col * (wh + margin) + margin;
        y = row * (wh + margin) + margin;
        imgV.frame = CGRectMake(x, y, wh, wh);
        i ++;
    }
    
    if (self.subviews.count < self.maxCount) {
        [self addSubview:self.addPhotoBtn];
    }
    
}

- (NSInteger)maxCount{
    if (_maxCount == 0) {
        _maxCount = 3;
    }
    return _maxCount;
}

#pragma mark - Getter and Setter
- (UIButton *)addPhotoBtn{
    if (!_addPhotoBtn) {
        _addPhotoBtn = [UIButton buttonWithType:0];
        [_addPhotoBtn setBackgroundImage:[UIImage imageNamed:@"btn_addphoto"] forState:UIControlStateNormal];
        [_addPhotoBtn addTarget:self action:@selector(addPhotoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addPhotoBtn;
}

@end

