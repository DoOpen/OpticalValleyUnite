//
//  SJComposePhotoView.h
//  微博
//
//  Created by Mac on 15-3-14.
//  Copyright (c) 2015年 jia. All rights reserved.
//  

#import <UIKit/UIKit.h>

@interface SJComposePhotoView : UIView

/**
 *  再次添加图片的时候 设置这个值
 */
@property (nonatomic,strong) UIImage *photo;

/**
 *  初始化时候添加多张图片
 */
@property (nonatomic, strong) NSArray *photos;

@property (nonatomic, copy) NSString *moviePath;

@property (nonatomic, weak) UIViewController *rootVc;

/**
 *  最多图片数
 */
@property (nonatomic, assign) NSInteger maxCount;

@property (nonatomic, strong , readonly) NSArray<UIImage *> *images;

- (NSArray *)imagesForLoad;


@end
