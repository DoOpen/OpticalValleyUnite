//
//  SJPhotpView.h
//  SJPeopleSecurity
//
//  Created by 贺思佳 on 16/5/9.
//  Copyright © 2016年 贺思佳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SJPhotpView : UIView

@property (nonatomic, strong ,readonly) UIImage *image;
+ (instancetype)photoViewWithImage:(UIImage *)image DeletBtnClickBlock:(void(^)(void))deletBtnClickBlock;


@end
