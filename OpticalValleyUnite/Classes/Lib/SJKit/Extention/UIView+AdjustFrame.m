//
//  UIView+AdjustFrame.m
//
//  Created by apple on 14-12-7.
//  Copyright (c) 2014年 Zrocky. All rights reserved.
//

#import "UIView+AdjustFrame.h"

//IB_DESIGNABLE
@implementation UIView (AdjustFrame)

@dynamic viewCenter;
@dynamic borderColor;
@dynamic borderWidth;

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (CGPoint)viewCenter{
     return CGPointMake(self.width * 0.5, self.height * 0.5);
}

- (void)setCenterX:(CGFloat)centerX{
    
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX{
    return self.width * 0.5;
}

- (void)setCenterY:(CGFloat)centerY{
    
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY{
    return self.height * 0.5;
}

- (CGFloat)maxX{
    return self.x + self.width;
}

- (void)setMaxX:(CGFloat)maxX{
    self.x = maxX - self.width;
}

- (CGFloat)maxY{
    return self.y + self.height;
}
- (void)setMaxY:(CGFloat)maxY{
    self.y = maxY - self.height;
}

- (void)setCornerRadius:(CGFloat)cornerRadius{
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = cornerRadius > 0;
}

- (void)setBorderColor:(UIColor *)borderColor{
    self.layer.borderColor = borderColor.CGColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth{
    self.layer.borderWidth = borderWidth;
}

- (CGFloat)cornerRadius{
    return self.layer.cornerRadius;
}

- (CGFloat)inSuperViewCenterX{
    return self.x + self.width * 0.5;
}

- (void)setInSuperViewCenterX:(CGFloat)inSuperViewCenterX{
    
}

- (void)setInSuperViewCenterY:(CGFloat)inSuperViewCenterY{
    
}

- (CGFloat)inSuperViewCenterY{
    return self.y + self.height * 0.5;
}



- (UIImage *)printScreen{
    //    UIGraphicsBeginImageContext(view.bounds.size);
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end


@implementation UILabel (attribut)

@dynamic lineSpacing;

- (void)setLineSpacing:(CGFloat)lineSpacing{
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
//    [paragraphStyle setFirstLineHeadIndent:20];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.text length])];
    [self setAttributedText:attributedString];
    [self sizeToFit];
}

@end

@implementation UIWindow (screen)

-(UIImage *)printScreen{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end