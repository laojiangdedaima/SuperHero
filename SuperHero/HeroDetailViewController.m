//
//  HeroDetailViewController.m
//  SuperHero
//
//  Created by soft on 15/9/14.
//  Copyright (c) 2015年 soft. All rights reserved.
//

#import "HeroDetailViewController.h"
#import "HeroEditCell.h"
#import "HeroDateEditCell.h"

@interface HeroDetailViewController ()
//所有分区信息
@property (nonatomic, strong) NSArray *sections;

//保存按钮
@property (nonatomic, strong) UIBarButtonItem *saveButton;
//返回按钮
@property (nonatomic, strong) UIBarButtonItem *backButton;
//取消按钮
@property (nonatomic, strong) UIBarButtonItem *cancelButton;

@end

@implementation HeroDetailViewController

//保存按钮
- (UIBarButtonItem *)saveButton{
    if (!_saveButton) {
        _saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
    }
    return _saveButton;
}

- (UIBarButtonItem *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    }
    return _cancelButton;
}

- (void)cancel{
    [self setEditing:NO animated:YES];
}
//保存当前数据
- (void)save{
    [self setEditing:NO animated:YES];
    for (HeroEditCell *cell in [self.tableView visibleCells]) {
        //value是字符串,保存时间需要
        [self.hero setValue:cell.value forKey:cell.key];
    }
    //拿上下文
    NSError *error = nil;
    if(![self.hero.managedObjectContext save:&error]){
        NSLog(@"保存数据失败:%@", error.userInfo);
    }
    [self.tableView reloadData];
}
//重写父类方法（打开或关闭编辑状态）
- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    self.navigationItem.rightBarButtonItem = editing?self.saveButton : self.editButtonItem;
    self.navigationItem.leftBarButtonItem = editing?self.cancelButton : self.backButton;
}
   
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.backButton = self.navigationItem.leftBarButtonItem;
    
    //加载plist配置文件
    NSURL *plistURL = [[NSBundle mainBundle] URLForResource:@"HeroDetailConfiguration" withExtension:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfURL:plistURL];
    NSArray *sections = dict[@"sections"];
    self.sections = sections;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //拿一个分区
    NSDictionary *section = self.sections[indexPath.section];//代表一个分区
    NSArray *rows = section[@"rows"];
   //拿当前行
    NSDictionary *row = rows[indexPath.row];
    //获取要创建Cell的类名
    NSString *cellClassName = row[@"class"];
    ////获取要创建Cell的类对象
    Class cellClass = NSClassFromString(cellClassName);
    //创建Cell对象
    HeroEditCell *cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:nil];
    //拿当前行的标题
    cell.label.text = row[@"label"];
    //为了让日期和字符串都能出现
    cell.value = [self.hero valueForKey:row[@"key"]];
    cell.key = row[@"key"];
    NSArray *values = row[@"values"];
    if (values != nil) {
        //当values不为空的时候 给Cell.values赋值
        //但是父类里面没有values属性
        //所以要动态的执行一个方法，这是NSObject中的方法，用这个方法（setValues:）给cell赋值（values）
        [cell performSelector:@selector(setValues:) withObject:values];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
    
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
