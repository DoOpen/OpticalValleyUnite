//
//  SJTakePhotoHandle.m
//  SJWPPY
//
//  Created by 贺思佳 on 16/6/24.
//  Copyright © 2016年 贺思佳. All rights reserved.
//

#import "SJTakePhotoHandle.h"
#import "BoPhotoPickerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface SJTakePhotoHandle ()

<BoPhotoPickerProtocol,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate
>

@property (nonatomic, copy) void(^selecteImageBlock)(UIImage *image);

@property (nonatomic, weak) UIViewController *rootVc;

@end

@implementation SJTakePhotoHandle

- (void)dealloc{
    NSLog(@"%s",__func__);
}

+ (void)takePhotoWithImageBlock:(void (^)(UIImage *))selectedImageBlock ViewController:(UIViewController *)vc{
    
    //不让自己被释放了
    UIWindow *SJKeyWindow = [UIApplication sharedApplication].keyWindow;
    SJTakePhotoHandle *view = [self new];
    [SJKeyWindow addSubview:view];
    view.selecteImageBlock = selectedImageBlock;
    view.rootVc = vc;
    
    BoPhotoPickerViewController *picker = [[BoPhotoPickerViewController alloc] init];
    //最多选择的图片张数
    picker.maximumNumberOfSelection = 3;
    //picker.minimumNumberOfSelection = 1;
    picker.multipleSelection = YES;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups = YES;
    picker.delegate = view;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return YES;
    }];
    
    [view.rootVc presentViewController:picker animated:YES completion:nil];
    
}


#pragma mark BoPhotoPickerViewDelegate
#pragma mark - BoPhotoPickerProtocol
- (void)photoPickerDidCancel:(BoPhotoPickerViewController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 选择的照片在这里找
- (void)photoPicker:(BoPhotoPickerViewController *)picker didSelectAssets:(NSArray *)assets {
    
    //        tempImg = [self squareImageFromImage:tempImg scaledToSize:1000];
    NSMutableArray *tempArry = [NSMutableArray array];
    for (ALAsset *asset in assets) {
        UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        NSLog(@"%@",tempImg);
        [tempArry addObject:tempImg];
        
        if (self.selecteImageBlock) {
            self.selecteImageBlock(tempImg);
            [self removeFromSuperview];
        }
       
    }
    
    [picker dismissViewControllerAnimated:NO completion:nil];
    self.selecteImageBlock = nil;
    
}



/**
 *  获取照相相片
 *
 *  @param picker <#picker description#>
 */
- (void)photoPickerTapAction:(BoPhotoPickerViewController *)picker {

    [picker dismissViewControllerAnimated:NO completion:nil];
    UIImagePickerController *cameraUI = [UIImagePickerController new];
    cameraUI.allowsEditing = NO;
    cameraUI.delegate = self;
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    cameraUI.cameraFlashMode=UIImagePickerControllerCameraFlashModeAuto;
    
    [_rootVc presentViewController: cameraUI animated: YES completion:nil];
}


#pragma mark - UIImagePickerDelegate
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - 相机拍摄的图片在这里找
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage;
    if (CFStringCompare((CFStringRef) mediaType,kUTTypeImage, 0)== kCFCompareEqualTo) {
        originalImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    originalImage = [self imageByScalingAndCroppingForSize:CGSizeMake(1000, 1000 * originalImage.size.height / originalImage.size.width) withSourceImage:originalImage];
    
    if (self.selecteImageBlock) {
        self.selecteImageBlock(originalImage);
        self.selecteImageBlock = nil;
        [self removeFromSuperview];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize withSourceImage:(UIImage *)sourceImage
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    return newImage;
}


@end
