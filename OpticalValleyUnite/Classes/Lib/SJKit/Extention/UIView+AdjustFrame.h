//
//  UIView+AdjustFrame.h
//
//  Created by apple on 14-12-7.
//  Copyright (c) 2014年 Zrocky. All rights reserved.
//
#import <UIKit/UIKit.h>



@interface UIView (AdjustFrame)

@property (assign, nonatomic) CGFloat x;
@property (assign, nonatomic) CGFloat y;
@property (assign, nonatomic) CGFloat width;
@property (assign, nonatomic) CGFloat height;
@property (assign, nonatomic) CGFloat maxX;
@property (assign, nonatomic) CGFloat maxY;
@property (assign, nonatomic) CGSize size;
@property (assign, nonatomic) CGPoint origin;
@property (nonatomic ,assign) CGFloat centerX;
@property (nonatomic ,assign) CGFloat centerY;

@property (nonatomic ,assign) CGFloat inSuperViewCenterX;
@property (nonatomic ,assign) CGFloat inSuperViewCenterY;
/**
 *  自己的中心点
 */
@property (nonatomic, assign) CGPoint viewCenter;

@property (assign, nonatomic) IBInspectable CGFloat cornerRadius;

@property (assign, nonatomic) IBInspectable UIColor* borderColor;

@property (assign, nonatomic) IBInspectable CGFloat borderWidth;

-(UIImage *)printScreen;


@end

@interface UILabel (attribut)
@property (nonatomic, assign) CGFloat lineSpacing;
@end

@interface UIWindow (screen)
-(UIImage *)printScreen;
@end
