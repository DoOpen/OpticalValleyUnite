//
//  SJUp.m
//  SJPeopleSecurity
//
//  Created by 贺思佳 on 16/5/6.
//  Copyright © 2016年 贺思佳. All rights reserved.
//

#import "SJUpButton.h"
#import "UIView+AdjustFrame.h"

@implementation SJUpButton

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    // Center image
//    CGPoint center = self.imageView.center;
//    center.x = self.frame.size.width/2;
//    center.y = self.imageView.frame.size.height/2;
    self.imageView.x = 0;
    self.imageView.y = 0;
    self.imageView.height = self.imageView.width;
//    self.imageView.center = center;

    
    //Center text
    [self.titleLabel sizeToFit];
    CGRect newFrame = [self titleLabel].frame;
    newFrame.origin.x = 0;
    ;
//    newFrame.origin.y = self.imageView.frame.size.height + 5;
    newFrame.origin.y = self.height - newFrame.size.height;
    newFrame.size.width = self.frame.size.width;
    
    self.titleLabel.frame = newFrame;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}
@end
