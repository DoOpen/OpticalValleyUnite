//
//  SJPickerView.h
//  SJHouseShop
//
//  Created by 贺思佳 on 16/3/4.
//  Copyright © 2016年 贺思佳. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SJHasNameType <NSObject>

@property (nonatomic,readonly, copy) NSString *title;

@end


@interface SJPickerView : UIView
+ (void)showWithDataArry:(NSArray<NSString *> *)data didSlected:(void (^)(NSInteger index))block;

+ (void)showWithDataArry2:(NSArray<id<SJHasNameType>> *)data didSlected:(void (^)(NSInteger index))block;


+ (instancetype)showWithDateType:(UIDatePickerMode)datePickerMode didSelcted:(void (^)(NSDate *selectedDate,NSString *selectedDateString))block;

+ (instancetype)showWithDateType:(UIDatePickerMode)datePickerMode DefaultingDate:(NSDate *)defaultingDate didSelcted:(void (^)(NSDate *selectedDate,NSString *selectedDateString))block;

+ (instancetype)showWithDateType:(UIDatePickerMode)datePickerMode DefaultingDate:(NSDate *)defaultingDate SelctedDateFormot:(NSString *)selctedDateFormotStr didSelcted:(void (^)(NSDate *selectedDate,NSString *selectedDateString))block;
@end

@interface NSDate (SJformat)
/**
 *  根据给定的格式 返回日期字符串
 *
 *  @param formatSting 格式
 *
 *  @return 44
 */
- (NSString *)dateStrWithFormat:(NSString *)formatSting;

+ (NSString *)dateStrWithDateFrom1970:(NSString *)dateFrom1970 UseForMat:(NSString *)formatString;

+ (instancetype)dateWithDateStr:(NSString *)dataStr UseForMat:(NSString *)formatString;
@end

