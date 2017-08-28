//
//  UILabel+SJColor.m
//  SJHouseShop
//
//  Created by 贺思佳 on 16/2/26.
//  Copyright © 2016年 贺思佳. All rights reserved.
//

#import "UILabel+SJColor.h"

@implementation UILabel (SJColor)

-(void)fuwenbenLabel:(UILabel *)labell FontNumber:(id)font AndRange:(NSRange)range AndColor:(UIColor *)vaColor
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:labell.text];
    
    //设置字号
    [str addAttribute:NSFontAttributeName value:font range:range];
    if (vaColor) {
        //设置文字颜色
        [str addAttribute:NSForegroundColorAttributeName value:vaColor range:range];
    }
    
    
    labell.attributedText = str;
}

- (void)rang:(NSRange)range AndColor:(UIColor *)vaColor{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.text];
    if (vaColor) {
        //设置文字颜色
        [str addAttribute:NSForegroundColorAttributeName value:vaColor range:range];
    }
    
    self.attributedText = str;
}

- (void)rang:(NSRange)range AndColor:(UIColor *)vaColor FontNumber:(CGFloat)fontNumber{
    
     NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.text];
    
    //设置字号
    if (fontNumber) {
         [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontNumber] range:range];
    }
    
   
    if (vaColor) {
        //设置文字颜色
        [str addAttribute:NSForegroundColorAttributeName value:vaColor range:range];
    }
    
    
    self.attributedText = str;
}

- (void)contentString:(NSString *)contentStr AndColor:(UIColor *)vaColor{
    NSRange range = [self.text rangeOfString:contentStr options:NSBackwardsSearch];
    
    [self rang:range AndColor:vaColor];
}

- (void)contentNumber:(NSInteger )contentNumber AndColor:(UIColor *)vaColor{
    NSString *str = [NSString stringWithFormat:@"%@",@(contentNumber)];
    [self contentString:str AndColor:vaColor];
}

- (void)setHeadIndent{
    NSMutableParagraphStyle * paragraph = [[NSMutableParagraphStyle alloc]init];
    
    [paragraph setLineSpacing:8];//设置行间距
    
    [paragraph setAlignment:NSTextAlignmentLeft];//设置对齐方式
    
    [paragraph setFirstLineHeadIndent:28];//设置首行缩进
    
    [paragraph setHeadIndent:2];//设置头缩进
    

    NSMutableAttributedString *attr =  [[NSMutableAttributedString alloc]initWithString:self.text];
    [attr addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, attr.length)];
    self.attributedText = attr;
}


- (void)setLineSpacing:(CGFloat) lineSpacing{
    NSMutableParagraphStyle * paragraph = [[NSMutableParagraphStyle alloc]init];
    
    [paragraph setLineSpacing:lineSpacing];//设置行间距
    
    [paragraph setFirstLineHeadIndent:0.0];//设置首行缩进
    
    [paragraph setHeadIndent:0.0];//设置头缩进
    
    
    
    NSMutableAttributedString *attr =  [[NSMutableAttributedString alloc]initWithString:self.text];
    [attr addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, attr.length)];
    self.attributedText = attr;
}

@end
