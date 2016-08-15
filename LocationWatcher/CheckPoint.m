//
//  CheckPoint.m
//  LocationWatcher
//
//  Created by EMM on 24/07/16.
//  Copyright © 2016 EMM. All rights reserved.
//

#import "CheckPoint.h"
#import <MapKit/MapKit.h>
#import "MainController.h"
#import "SVProgressHUD.h"

@interface CheckPoint ()
@property MainController *controller;
@property (weak, nonatomic) IBOutlet UITextField *message;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UITextField *checkPointName;
@property (weak, nonatomic) IBOutlet UITextField *radius;
@property (weak, nonatomic) IBOutlet UIButton *createCheckPoint;
@property CLLocation* requiredLocation;
@property NSString* searchedLocation;
@property BOOL validation;
@end

@implementation CheckPoint
bool search = false;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UILongPressGestureRecognizer* lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.5;
    lpgr.delegate = self;
    [self.map addGestureRecognizer:lpgr];
    
    [self becomeFirstResponder];
    self.spinner.hidden = true;
    self.radius.delegate = self;
    self.searchBar.delegate = self;
    self.checkPointName.delegate = self;
    self.validation = false;
    _controller = [MainController sharedInstance];
    search = false;
    if([_controller getEditFlag]){
        
        self.validation = true;
        [_createCheckPoint setTitle:@"Update" forState:UIControlStateNormal];
        
        Location *currentCell = [_controller getCurrentCellLocation];
        search = true;
        self.checkPointName.text = [currentCell getName];
        self.radius.text = [NSString stringWithFormat:@"%.2f", [currentCell getRadius]];
        self.searchBar.text = [[_controller getCurrentCellLocation] getSearchedLocation];
        [self onClick:[currentCell getSearchedLocation]];
        self.message.text = [currentCell getMessage];
        
        
    }

    [self.searchBar setShowsCancelButton:YES animated:YES];
    // Do any additional setup after loading the view.
}


- (void) handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        /*
         Only handle state as the touches began
         set the location of the annotation
         */
        
        CLLocationCoordinate2D coordinate = [self.map convertPoint:[gestureRecognizer locationInView:self.map] toCoordinateFromView:self.map];
        
        [self.map setCenterCoordinate:coordinate animated:YES];
        NSLog(@"%f",coordinate.latitude);
        // Do anything else with the coordinate as you see fit in your application
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [self onClick:[searchBar text]];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    [self.view endEditing:true];
}

-(void) onClick:(NSString *)location{
    
    search = true;
    
    _searchedLocation = location;
    
  //  self.spinner.hidden = false;
    [SVProgressHUD showWithStatus:@"Locating the Check Point"];

    
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    
    request.naturalLanguageQuery = location;
    
    request.region = self.map.region;

    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    
    
    // Start the search and display the results as annotations on the map.
    
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error)
     
     {
         self.spinner.hidden = true;
         [SVProgressHUD dismiss];
         
         [self.view endEditing:YES];
         
         NSMutableArray *placemarks = [NSMutableArray array];
         
         for (MKMapItem *item in response.mapItems) {
             
             
             _requiredLocation = [[CLLocation alloc]initWithLatitude:[[item placemark] coordinate].latitude longitude:[[item placemark] coordinate].longitude];             
             
             [placemarks addObject:item.placemark];
         }
         [self.map removeAnnotations:[self.map annotations]];
         [self.map showAnnotations:placemarks animated:NO];
        
     }];
}

-(void) showAlert:(NSString *)title :(NSString *)message{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        if(_validation){
            
            [_controller saveData];
            [_backButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        }

    }];
    [alert addAction:defaultAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

- (IBAction)createCheckPoint:(id)sender {
    
    NSString *checkPointName = self.checkPointName.text;
    NSString *distance = self.radius.text;
    double distanceOfCheckPoint = [distance doubleValue];
    NSString *message = self.message.text;
    
    if([checkPointName length] == 0){
        self.validation = false;
        [self showAlert:@"Warning" :@"Please Enter CheckPoint Name"];
        return;
    }
    if([distance length] == 0){
        self.validation = false;
        [self showAlert:@"Warning" :@"Please Enter the Distance"];
        return;
    }
    if(search == false){
        self.validation = false;
        [self showAlert:@"Warning" :@"Please Select a Location"];
        return;
    }
    if([message length] == 0){
        self.validation = false;
        [self showAlert:@"Warning" :@"Please Enter reminder for this location"];
        return;
    }
    
    Location *newLocation = [[Location alloc]initWithLocation:_requiredLocation :distanceOfCheckPoint :message:checkPointName:_searchedLocation];
    
    self.validation = true;

    if(![_controller getEditFlag]){
        [_controller addLocation:newLocation];
        [self showAlert:@"Success" :@"Location Added Successfully"];
        

    }
    else{
        [_controller updateLocation:[_controller getCurrentIndex] :newLocation];
        [self showAlert:@"Success" :@"Location Updated Successfully"];
        [_controller setEditflag:false];
    }
    [_controller didIReachAnyLocation];
}



@end
