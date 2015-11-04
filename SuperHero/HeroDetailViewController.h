//
//  HeroDetailViewController.h
//  SuperHero
//
//  Created by soft on 15/9/14.
//  Copyright (c) 2015年 soft. All rights reserved.
//

#import <UIKit/UIKit.h>

@import CoreData;

@interface HeroDetailViewController : UITableViewController
//公开的属性，接受从外面传入的属性
@property (nonatomic, strong) NSManagedObject *hero;

@end
