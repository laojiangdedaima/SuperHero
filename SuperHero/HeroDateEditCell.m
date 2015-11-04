//
//  HeroDateEditCell.m
//  SuperHero
//
//  Created by soft on 15/9/15.
//  Copyright (c) 2015年 soft. All rights reserved.
//

#import "HeroDateEditCell.h"

static NSDateFormatter *__dateFormartter = nil;

@interface HeroDateEditCell ()

//时间
@property (strong, nonatomic) UIDatePicker *datePicker;

@end

@implementation HeroDateEditCell
//当类加载时自动调用此方法
+ (void)initialize{
    __dateFormartter = [[NSDateFormatter alloc] init];
    [__dateFormartter setDateStyle:NSDateFormatterMediumStyle];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textField.clearButtonMode = UITextFieldViewModeNever;
        self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];//大小给0，应该是自动适应的
        //设置成年月日
        self.datePicker.datePickerMode = UIDatePickerModeDate;
        [self.datePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
        //把键盘设置成UIDatePicker格式
        //也可以自定义一个键盘
        //设置TextFeild的输入视图
        self.textField.inputView = self.datePicker;
    }
    return self;
}

-(void)datePickerChanged:(UIDatePicker *)Picker{
    NSDate *date = self.datePicker.date;
//    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
//    //设置一个日期风格
//    [formater setDateStyle:NSDateFormatterMediumStyle];
    self.textField.text = [__dateFormartter stringFromDate:date];
}

- (id)value{
    if (self.textField.text == nil || self.textField.text.length) {
        return nil;
    }
    return self.datePicker.date;
}

- (void)setValue:(id)value{
    if (value != nil && [value isKindOfClass:[NSDate class]]) {
        [self.datePicker setDate:value];
        self.textField.text = [__dateFormartter stringFromDate:value];
    }else{
        self.textField.text = nil;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
