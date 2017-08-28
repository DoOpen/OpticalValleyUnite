//
//  UILabel+SJColor.h
//  SJHouseShop
//
//  Created by 贺思佳 on 16/2/26.
//  Copyright © 2016年 贺思佳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (SJColor)
-(void)fuwenbenLabel:(UILabel *)labell FontNumber:(id)font AndRange:(NSRange)range AndColor:(UIColor *)vaColor;

- (void)rang:(NSRange)range AndColor:(UIColor *)vaColor;


- (void)rang:(NSRange)range AndColor:(UIColor *)vaColor FontNumber:(CGFloat)fontNumber;
/**
 *  把UILabel的指定的部分文字设置成指定颜色
 *
 *  @param contentStr 要单独设置颜色的字符串
 *  @param vaColor    要设置的颜色
 */
- (void)contentString:(NSString *)contentStr AndColor:(UIColor *)vaColor;

- (void)contentNumber:(NSInteger )contentNumber AndColor:(UIColor *)vaColor;

- (void)setHeadIndent;
- (void)setLineSpacing:(CGFloat) lineSpacing;
@end
