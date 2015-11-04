//
//  ViewController.m
//  SuperHero
//
//  Created by soft on 15/9/14.
//  Copyright (c) 2015年 soft. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "HeroDetailViewController.h"

@import CoreData;

@interface ViewController ()<NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (NSManagedObjectContext *)managedObjectContext{
    if (!_managedObjectContext) {
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        _managedObjectContext = delegate.managedObjectContext;
    }
    return _managedObjectContext;
}

- (NSFetchedResultsController *)fetchedResultsController{
    if (_fetchedResultsController) {
        return _fetchedResultsController;
    }
    //1.准备NSFetchRequest
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Hero" inManagedObjectContext:self.managedObjectContext];
    
    fetchRequest.entity =entity;
    NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    fetchRequest.sortDescriptors = @[sortDesc];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Hero"];
    
    _fetchedResultsController.delegate = self;
    return _fetchedResultsController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSError *error = nil;
    if(![self.fetchedResultsController performFetch:&error]){
        NSLog(@"Fetch失败:%@", error.userInfo);
    }
    [self.tableView reloadData];
        
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NSFetchedResultsControllerDelegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller{
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationBottom];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
            break;
        default:
            break;
    }
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    id<NSFetchedResultsSectionInfo>sectionInfo = self.fetchedResultsController.sections[section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HeroCell" forIndexPath:indexPath];
    NSManagedObject *obj = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [obj valueForKey:@"name"];
    cell.detailTextLabel.text = [obj valueForKey:@"secretIdentity"];
    return cell;
}

#pragma mark - UITableViewDelegate 
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    //添加删除效果
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObject *removeObj = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self.managedObjectContext deleteObject:removeObj];
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"删除出错:%@", error.userInfo);
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSManagedObject *obj = [self.fetchedResultsController objectAtIndexPath:indexPath];
    //Segue的新的使用方式
    [self performSegueWithIdentifier:@"HeroDetailSegue" sender:obj];
}

#pragma mark - 用户事件方法
- (IBAction)addHero:(id)sender {
     NSEntityDescription *entity = self.fetchedResultsController.fetchRequest.entity;
    NSManagedObject *Newobj = [NSEntityDescription insertNewObjectForEntityForName:entity.name inManagedObjectContext:self.managedObjectContext];
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"添加出错:%@", error.userInfo);
    }
    //跳转到详细信息界面
    [self performSegueWithIdentifier:@"HeroDetailSegue" sender:Newobj];
}
- (IBAction)editTap:(id)sender {
    [self.tableView setEditing:!self.tableView.editing animated:YES];//添加编辑按钮

}

#pragma mark - Segue
//当使用Segue跳转时，自动调用
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"HeroDetailSegue"]) {
        HeroDetailViewController *vc = segue.destinationViewController;
        vc.hero = sender;
    }
}
@end
