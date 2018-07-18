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

+ (void)takePhotoWithImageBlock:(void (^)(UIImage *))selectedImageBlock ViewController:(UIViewController *)vc selectIndex :(int)index {
    
    //不让自己被释放了
    UIWindow *SJKeyWindow = [UIApplication sharedApplication].keyWindow;
    SJTakePhotoHandle *view = [self new];
    [SJKeyWindow addSubview:view];
    view.selecteImageBlock = selectedImageBlock;
    view.rootVc = vc;
    
    BoPhotoPickerViewController *picker = [[BoPhotoPickerViewController alloc] init];
    //最多选择的图片张数
    picker.maximumNumberOfSelection = index;
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
        
        NSDate* pictureDate = [asset valueForProperty:ALAssetPropertyDate];
        NSDateFormatter * matter = [[NSDateFormatter alloc]init];
        [matter setDateFormat:@"YYYY-MM-dd HH:mm"];
        CGRect frame = CGRectMake( tempImg.size.width - 400,  tempImg.size.height - 80, 400, 40);
        
        NSString * str = [matter stringFromDate:pictureDate];
        
        __block  UIImage * newImage =  [self WaterImageWithImage:tempImg text:str textRect:frame];
        
        [tempArry addObject:newImage];
        
        if (self.selecteImageBlock) {
            
            self.selecteImageBlock(newImage);
            [self removeFromSuperview];
            
        }
       
    }
    
    [picker dismissViewControllerAnimated:NO completion:nil];
    self.selecteImageBlock = nil;
    
}



/**
 *  获取照相相片
 *
 *  @param picker 弹窗的pickerView
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
    __block UIImage *originalImage;
    
//    //添加的相册的图片信息
//    //图片的添加新的功能
//    NSURL* imageUrl = [info objectForKey: UIImagePickerControllerImageURL];
//    ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
//    __weak typeof(self) weakself = self;
//
//
//    [library assetForURL:imageUrl resultBlock:^(ALAsset *asset) {
//
//        UIImage * image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage];
//
//         __strong typeof(self) strongself = weakself;
//        NSDate * pictureDate = [asset valueForProperty:ALAssetPropertyDate];
//
//
//
//     } failureBlock:^(NSError *error) {
//
//     }];
    
    if (CFStringCompare((CFStringRef) mediaType,kUTTypeImage, 0)== kCFCompareEqualTo) {
        
        UIImage * image = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];

        if(image)
        {
            
            //下面是我自己的处理函数，我在第一篇中进行了简单介绍的，有性趣去看一下。
            //UIImage* resultImage =[ImageUtility addTimeString:[DateUtility getFormatedDateStringOfDate:pictureDate] toCurrentImage:_image withBoolValue:YES];
            NSDateFormatter * matter = [[NSDateFormatter alloc]init];
            [matter setDateFormat:@"YYYY-MM-dd HH:mm"];
            CGRect frame = CGRectMake( image.size.width - 400,  image.size.height - 80, 400, 40);
            
            NSString * str = [matter stringFromDate: [NSDate date]];
            
            originalImage = [self WaterImageWithImage:image text:str textRect:frame];
            
            originalImage = [self imageByScalingAndCroppingForSize:CGSizeMake(1000, 1000 * originalImage.size.height / originalImage.size.width) withSourceImage:originalImage];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (self.selecteImageBlock) {
                    self.selecteImageBlock(originalImage);
                    self.selecteImageBlock = nil;
                    [self removeFromSuperview];
                }
                
                [picker dismissViewControllerAnimated:YES completion:nil];
                
            });
            
        }
    }
    

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


- (UIImage *)WaterImageWithImage:(UIImage *)image text:(NSString *)text textRect:(CGRect)rect {
    
    NSDictionary * dict = @{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName: [UIFont systemFontOfSize:40]};
    
    //1.开启上下文
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    
    //2.画矩形框
    UIBezierPath * bezierP = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:3];
    [UIColor grayColor ].setFill;
    bezierP.fill;
    
    //添加水印文字
    [text drawInRect:rect withAttributes:dict];
    
    //3.从上下文中获取新图片
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    //4.关闭图形上下文
    UIGraphicsEndImageContext();
    
    //返回图片
    return newImage;
}


@end
