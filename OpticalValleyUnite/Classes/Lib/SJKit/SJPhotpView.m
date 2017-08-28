//
//  SJPhotpView.m
//  SJPeopleSecurity
//
//  Created by 贺思佳 on 16/5/9.
//  Copyright © 2016年 贺思佳. All rights reserved.
//

#import "SJPhotpView.h"
#import "UIView+AdjustFrame.h"
static CGFloat kDeletBtnWH = 15;

@interface SJPhotpView ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *deletBtn;
@property (nonatomic, copy) void(^deletBtnClickBlock)(void);
@end

@implementation SJPhotpView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _imageView = [[UIImageView alloc] init];
        _deletBtn = [UIButton buttonWithType:0];
        [_deletBtn setBackgroundImage:[UIImage imageNamed:@"exit"] forState:UIControlStateNormal];
        [_deletBtn addTarget:self action:@selector(deletBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_imageView];
        [self addSubview:_deletBtn];
    }
    return self;
}

+(instancetype)photoViewWithImage:(UIImage *)image DeletBtnClickBlock:(void (^)(void))deletBtnClickBlock{
    SJPhotpView *view = [[self alloc] initWithFrame:CGRectZero];
    
    view.imageView.image = image;
    view.deletBtnClickBlock = deletBtnClickBlock;
//    [view setNeedsLayout];
//    [view layoutIfNeeded];
    return view;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}

- (UIImage *)image{
    return self.imageView.image;
}
- (void)deletBtnClick{
    [self removeFromSuperview];
    if (self.deletBtnClickBlock) {
        self.deletBtnClickBlock();
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.imageView.frame = self.bounds;
    self.deletBtn.frame = CGRectMake(self.width - kDeletBtnWH, 0, kDeletBtnWH, kDeletBtnWH);
}

@end
