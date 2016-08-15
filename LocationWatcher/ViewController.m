//
//  ViewController.m
//  LocationWatcher
//
//  Created by EMM on 22/07/16.
//  Copyright © 2016 EMM. All rights reserved.
//

#import "ViewController.h"
#import "LocationManager.h"
#import "AudioPlayer.h"
#import "MainController.h"
#import "Location.h"
#import "SVProgressHUD.h"


@import UserNotifications;

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addCheckPoint;
@property (weak, nonatomic) IBOutlet UISwitch *isEnabled;
@property (weak, nonatomic) IBOutlet UISwitch *radioButton;
@property (weak, nonatomic) IBOutlet UITabBar *tabularBar;

@property MainController *controller;

@end

@implementation ViewController

- (IBAction)enableFlag:(id)sender {
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];

    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];

    NSLog(@"%ld",(long)indexPath.row);

    [_tabularBar setDelegate:self];
    Location *currentLocation = [_controller getACheckPointAtIndex:indexPath.row];
    
    if([currentLocation isEnabled]){
        [currentLocation setisEnabled:NO];
        [currentLocation setIsPlaying:NO];
    }
    else{
        [currentLocation setisEnabled:YES];
    }
    [_controller updateLocation:indexPath.row :currentLocation];
    
    currentLocation = [_controller getACheckPointAtIndex:indexPath.row];
    
    NSLog(@"%ld",(long)indexPath.row);
    
    [_controller didIReachAnyLocation];
    
}
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if(item.tag==1)
    {
        NSLog(@"gotcha");
    }
    else
    {
        NSLog(@"Pitcha");
    }
}

Boolean value = false;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SVProgressHUD dismiss];
    _tabularBar.delegate = self;

    [self createTabBar];
    
    self.tableView.allowsSelection = true;
    _controller = [MainController sharedInstance];
    self.tableView.delegate = self;
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    [_controller setEditflag:false];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notificationHandler:) name:@"Eezy" object:@"my object"];
    [_controller loadData];
}


-(void) createTabBar{
 
    UITabBarItem *firstItem = [[UITabBarItem alloc] initWithTitle:@"Home" image:[UIImage imageNamed:@"home"] tag:1];
    UITabBarItem *secondItem = [[UITabBarItem alloc] initWithTitle:@"Locate Me" image:[UIImage imageNamed:@"locate"] tag:2];
    UITabBarItem *thirdItem = [[UITabBarItem alloc] initWithTitle:@"Account" image:[UIImage imageNamed:@"account"] tag:3];
    UITabBarItem *fourthItem = [[UITabBarItem alloc] initWithTitle:@"About Us" image:[UIImage imageNamed:@"about"] tag:4];
    
    NSArray *itemsArray = @[firstItem, secondItem, thirdItem,fourthItem];
    
    
    [_tabularBar setItems:itemsArray];
    
}

-(void) notificationHandler :(NSNotification *) notification{

    NSLog(@"validating the distance from the required location");
    
    NSString *title = [notification userInfo][@"title"];
    NSString *message = [notification userInfo][@"message"];

    [self showAlert:title :message];
    
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
    localNotification.alertBody = message;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return YES - we will be able to delete all rows
    return YES;
}





- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        [_controller removeLocation:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        NSLog(@"Delete Clicked");
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath {

    
    Location *currentLocation = [_controller getACheckPointAtIndex:indexPath.row];
    
    [_controller setCurrentCellLocation:currentLocation:indexPath.row];
    
    [_controller setEditflag:true];
    
    [_addCheckPoint sendActionsForControlEvents: UIControlEventTouchUpInside];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_controller numberOfCheckPoints];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return @"Check Points";
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell * reusableCell = [tableView dequeueReusableCellWithIdentifier:@"checkpoint"];
    
    reusableCell.translatesAutoresizingMaskIntoConstraints=NO;
    
    UISwitch *switchControl = [[UISwitch alloc] initWithFrame:CGRectZero];
    reusableCell.accessoryView = switchControl;
    
    [switchControl addTarget: self action: @selector(enableFlag:) forControlEvents:UIControlEventValueChanged];

    
    UIImage *image = [UIImage imageNamed:@"cellImage"];
    
    [reusableCell.imageView setImage:image];

    reusableCell.textLabel.text = [[_controller getACheckPointAtIndex:(indexPath.row)] getName];
    reusableCell.detailTextLabel.text = [[_controller getACheckPointAtIndex:(indexPath.row)] getMessage];
    
    
    NSLog(@"%ld",(long)indexPath.row);
    if([[_controller getACheckPointAtIndex:(indexPath.row)]isEnabled]){
        [switchControl setOn:YES animated:YES];
    }
    else
        [switchControl setOn:NO animated:YES];
        
    
    return reusableCell;
}



-(void) showAlert:(NSString *)title :(NSString *)message{
 
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){

        
    }];
    [alert addAction:defaultAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
