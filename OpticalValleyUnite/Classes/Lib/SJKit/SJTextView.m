//
//  SJTextView.m
//  微博
//
//  Created by Mac on 15-3-14.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#import "SJTextView.h"
#import "UIView+AdjustFrame.h"

@interface SJTextView ()

@property (nonatomic,weak) UILabel *placeHolderLabel;

@end


@implementation SJTextView

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        UILabel *placeHodle = [[UILabel alloc] init];
        _placeHolderLabel = placeHodle;
        _placeHolderLabel.textColor = [UIColor lightGrayColor];
//        [_placeHolderLabel sizeToFit];
        _placeHolderLabel.numberOfLines = 0;
        self.font = [UIFont systemFontOfSize:15];
        [self addSubview:placeHodle];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UILabel *placeHodle = [[UILabel alloc] init];
        _placeHolderLabel = placeHodle;
        _placeHolderLabel.textColor = [UIColor lightGrayColor];
        [_placeHolderLabel sizeToFit];
        _placeHolderLabel.preferredMaxLayoutWidth = self.width;
        _placeHolderLabel.textAlignment = NSTextAlignmentLeft;
        self.font = [UIFont systemFontOfSize:15];
        [self addSubview:placeHodle];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
        
    }
    return self;
}

/*
 设置其代理之后再进行的 调用通知的方法!
 */
- (void)textDidChange{
    
    if (self.text.length != 0) {
        self.placeHolderLabel.hidden = YES;
    }else{
        self.placeHolderLabel.hidden = NO;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _placeHolderLabel.x = 10;
    _placeHolderLabel.y = 8;
    
    _placeHolderLabel.width = self.width;
    _placeHolderLabel.height = self.height;
    
    CGSize size = [_placeHolderLabel.text boundingRectWithSize:CGSizeMake(self.width - 20, self.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil].size;
    
    _placeHolderLabel.size = size;
}

- (void)setPlaceHolder:(NSString *)placeHolder{
    _placeHolder = placeHolder;
    _placeHolderLabel.text = placeHolder;
//    [_placeHolderLabel sizeToFit];
    
}

- (void)setFont:(UIFont *)font{
    [super setFont:font];
    _placeHolderLabel.font = font;
    [_placeHolderLabel sizeToFit];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
