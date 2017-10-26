//
//  SJTakePhotoHandle.h
//  SJWPPY
//
//  Created by 贺思佳 on 16/6/24.
//  Copyright © 2016年 贺思佳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface SJTakePhotoHandle : UIView

+ (void)takePhotoWithImageBlock:(void(^)(UIImage *image)) selectedImageBlock ViewController:(UIViewController *)vc;

@end
