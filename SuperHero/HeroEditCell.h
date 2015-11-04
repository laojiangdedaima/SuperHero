//
//  HeroEditCell.h
//  SuperHero
//
//  Created by soft on 15/9/14.
//  Copyright (c) 2015年 soft. All rights reserved.
//

#import <UIKit/UIKit.h>
#define KLabelTextColor [UIColor colorWithRed:0.321596f green:0.4f blue:0.568627f alpha:1.0f]
@interface HeroEditCell : UITableViewCell

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UITextField *textField;
//用于修改（或读取）textField中的值的属性
//把value保存成id类型,因为不知道是什么东西传入
@property (nonatomic, strong) id value;
//此Cell展示的对象的属性名
@property (nonatomic, strong) NSString *key;

@end
