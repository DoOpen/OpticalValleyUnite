//
//  SJPickerView.m
//  SJHouseShop
//
//  Created by 贺思佳 on 16/3/4.
//  Copyright © 2016年 贺思佳. All rights reserved.
//

#import "SJPickerView.h"
#import "UIView+AdjustFrame.h"

typedef NS_ENUM(NSUInteger, SJPickerViewType) {
    SJPickerViewTypeText,
    SJPickerViewTypeDate,
};

static CGFloat const SJPickerViewBtnW = 50;
static CGFloat const SJPickerViewBtnH = 30;


@interface SJPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *pickerViewText;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, assign) NSInteger selectedIndex;


@property (nonatomic, strong) UIDatePicker *dataPicker;
@property (nonatomic, assign) UIDatePickerMode datePickerMode;
@property (nonatomic, strong) NSDate *defaultingDate;
@property (nonatomic, strong) NSString *dateFormotStr;

@property (nonatomic, strong) UIView *optionView;
@property (nonatomic, strong) UIView *pickerView;
@property (nonatomic, copy) id block;
@property (nonatomic, assign) SJPickerViewType pickerViewType;
@end

@implementation SJPickerView

- (void)dealloc{
    NSLog(@"%s",__func__);
}

+ (void)showWithDataArry:(NSArray *)data didSlected:(void (^)(NSInteger index))block{
   
    
    SJPickerView *vv = [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
    vv.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    vv.block = block;
    vv.data = data;
    
    [vv addSubview:vv.optionView];
    
    [[UIApplication sharedApplication].keyWindow addSubview:vv];
    return ;
}

+ (void)showWithDataArry2:(NSArray<id<SJHasNameType>> *)data didSlected:(void (^)(NSInteger index))block{
    
    NSMutableArray *temp = [NSMutableArray array];
    for (id<SJHasNameType> model in data) {
        [temp addObject:model.title];
    }
    
    [self showWithDataArry:temp didSlected:block];
    
}

+ (instancetype)showWithDateType:(UIDatePickerMode)datePickerMode didSelcted:(void (^)(NSDate *, NSString *))block{
    
    

    return [self showWithDateType:datePickerMode DefaultingDate:nil didSelcted:block];
}

+ (instancetype)showWithDateType:(UIDatePickerMode)datePickerMode DefaultingDate:(NSDate *)defaultingDate didSelcted:(void (^)(NSDate *, NSString *))block{
    
    return [self showWithDateType:datePickerMode DefaultingDate:defaultingDate SelctedDateFormot:nil didSelcted:block];
}

+ (instancetype)showWithDateType:(UIDatePickerMode)datePickerMode DefaultingDate:(NSDate *)defaultingDate SelctedDateFormot:(NSString *)selctedDateFormotStr didSelcted:(void (^)(NSDate *, NSString *))block{
    SJPickerView *vv = [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
    vv.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    vv.block = block;
    vv.pickerViewType = SJPickerViewTypeDate;
    vv.datePickerMode = datePickerMode;
    
    if(defaultingDate){
        vv.defaultingDate = defaultingDate;
    }
    if (selctedDateFormotStr) {
        vv.dateFormotStr = selctedDateFormotStr;
    }else{
        vv.dateFormotStr = @"yyyy/MM/dd";
    }
    
    [vv addSubview:vv.optionView];
    [[UIApplication sharedApplication].keyWindow addSubview:vv];
    return vv;
}

- (void)cancelBtnClik{
    [self removeFromSuperview];
   [self removeFromSuperview];
}
- (void)downBtnDidClick{
    
    if (self.pickerViewType == SJPickerViewTypeDate) {
        NSString *selectedDateStr;
        if (self.datePickerMode == UIDatePickerModeDate || self.datePickerMode == UIDatePickerModeDateAndTime) {
            selectedDateStr = [self.dataPicker.date dateStrWithFormat:_dateFormotStr];
        }else if (self.datePickerMode == UIDatePickerModeTime){
            selectedDateStr = [self.dataPicker.date dateStrWithFormat:@"HH:mm"];
        }
        void (^selectd)( NSDate *,NSString *) = self.block;
        if (selectd) {
            selectd(self.dataPicker.date,selectedDateStr);
        }
        
    }else if (self.pickerViewType == SJPickerViewTypeText){
        void (^selectd)(NSInteger) = self.block;
        if (selectd) {
            selectd(_selectedIndex);
        }

    }
    
    [self cancelBtnClik];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self removeFromSuperview];
}

#pragma mark- UIPickerViewDelegate&&SourceData
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _data.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return _data[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.selectedIndex = row;
}


#pragma mark - Getter and Setter
- (UIView *)optionView{
    if (!_optionView) {
        

        
        _optionView = [[UIView alloc] init];
        
        [_optionView addSubview:self.pickerView];
        CGSize size = self.pickerView.bounds.size;
        
        _optionView.frame = CGRectMake(0, 0, size.width, size.height + SJPickerViewBtnH);
        _pickerView.frame = CGRectMake(0, SJPickerViewBtnH, [UIScreen mainScreen].bounds.size.width, size.height);

        UIButton *cancelBtn = [UIButton buttonWithType:1];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [cancelBtn sizeToFit];
        [cancelBtn addTarget:self action:@selector(cancelBtnClik) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *downBtn = [UIButton buttonWithType:1];
        [downBtn setTitle:@"确定" forState:UIControlStateNormal];
        [downBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [downBtn sizeToFit];
        [downBtn addTarget:self action:@selector(downBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
        

        cancelBtn.frame = CGRectMake(_pickerView.x, _pickerView.y - SJPickerViewBtnH, SJPickerViewBtnW, SJPickerViewBtnH);
        downBtn.frame = CGRectMake(_pickerView.maxX - SJPickerViewBtnW, _pickerView.y - SJPickerViewBtnH, SJPickerViewBtnW, SJPickerViewBtnH);
        [_optionView addSubview:cancelBtn];
        [_optionView addSubview:downBtn];
        _optionView.backgroundColor = [UIColor whiteColor];
        _optionView.center = [UIApplication sharedApplication].keyWindow.center;
        _optionView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - size.height - SJPickerViewBtnH, [UIScreen mainScreen].bounds.size.width, size.height + SJPickerViewBtnH);
    }
    return _optionView;
}

- (UIView *)pickerView{
    if (!_pickerView) {
        if (self.pickerViewType == SJPickerViewTypeDate) {
            _pickerView = self.dataPicker;
        }else if(self.pickerViewType == SJPickerViewTypeText) {
            _pickerView = self.pickerViewText;
        }
    }
    return _pickerView;
}

- (UIPickerView *)pickerViewText{
    if (!_pickerViewText) {
        UIPickerView *pickerView = [[UIPickerView alloc] init];
        pickerView.dataSource = self;
        pickerView.delegate = self;
        _pickerViewText = pickerView;
    }
    return _pickerViewText;
}

- (UIDatePicker *)dataPicker{
    if (!_dataPicker) {
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        _dataPicker = datePicker;
        datePicker.datePickerMode = self.datePickerMode;
        
        if (_defaultingDate) {
            _dataPicker.date = _defaultingDate;
        }
        
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中
        datePicker.locale = locale;
        datePicker.y = SJPickerViewBtnW;
        datePicker.backgroundColor = [UIColor whiteColor];
    }
    return _dataPicker;
}
@end


@implementation NSDate (SJformat)


- (NSString *)dateStrWithFormat:(NSString *)formatSting{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = formatSting;
    
    return [df stringFromDate:self];
}

+ (NSString *)dateStrWithDateFrom1970:(NSString *)dateFrom1970 UseForMat:(NSString *)formatString{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = formatString;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:dateFrom1970.longLongValue * 0.001];
    return [df stringFromDate:date];
    
}

+ (instancetype)dateWithDateStr:(NSString *)dataStr UseForMat:(NSString *)formatString{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = formatString;
    return [df dateFromString:dataStr];
}
@end
