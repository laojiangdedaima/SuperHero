//
//  HeroEditCell.m
//  SuperHero
//
//  Created by soft on 15/9/14.
//  Copyright (c) 2015年 soft. All rights reserved.
//

#import "HeroEditCell.h"

@implementation HeroEditCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(12.0, 15.0, 67.0, 15.0)];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.font = [UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]];
        self.label.textAlignment = NSTextAlignmentNatural;
        self.label.textColor = KLabelTextColor;
        self.label.text = @"Label:";
        [self.contentView addSubview:self.label];
        
        self.textField = [[UITextField alloc] initWithFrame:CGRectMake(93.0, 13.0, 170.0, 19.0)];
        self.textField.backgroundColor = [UIColor clearColor];
        self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;//就是那个输入的时候的叉叉
        self.textField.enabled = NO;//只能看，不能编辑
        self.textField.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
        self.textField.text = @"Title";
        [self.contentView addSubview:self.textField];
    }
    return self;
}

//父类方法，当当前cell进入/退出编辑模式时，调用此方法
- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];//好厉害！
    self.textField.enabled = editing;
}

- (void)setValue:(NSString *)value{
    //当一个属性的setter和getter都是自定义时，编译器不回给次函数生成实例变量
//    _value = value;//ERROR
    self.textField.text = value;
}
- (id)value{
    return self.textField.text;
}


@end
