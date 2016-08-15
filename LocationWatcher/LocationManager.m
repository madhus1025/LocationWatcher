//
//  LocationManager.m
//  GeoFenceDemo
//
//  Created by EMM on 26/06/16.
//  Copyright © 2016 EMM. All rights reserved.
//

#import "LocationManager.h"
#import "ViewController.h"

@interface LocationManager()


@end

@implementation LocationManager

double totalDistance = 0;
BOOL start = true;

+ (LocationManager *)sharedInstance {
    
    static LocationManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^ {
        instance = [[self alloc]init];
    });
    return instance;
}

- (instancetype)init
{
    
    self = [super init];
    if (self) {

        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(stopUpdating) name:@"stopUpdating" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(startUpdating) name:@"startUpdating" object:nil];
        _locationManager = [[CLLocationManager alloc] init];

        if([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]){
            [_locationManager requestAlwaysAuthorization];
        }else{
            NSLog(@"Nice");
        }
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.delegate = self;
        [_locationManager startUpdatingLocation];
        [_locationManager setAllowsBackgroundLocationUpdates:YES];
        NSLog(@"Location service enabled");
        _startLocation = nil;
    }
    return self;
}

-(void) stopUpdating {
    NSLog(@"Stop Updating locations notification received");
    totalDistance = 0;
    [_locationManager stopUpdatingLocation];
}

-(void) startUpdating {
    NSLog(@"Start Updating locations notification received");
    totalDistance = 0;
    [_locationManager startUpdatingLocation];
}



-(double) getDistance:(CLLocation *)location1 :(CLLocation *)location2{
    
    
    
    CGFloat distance = [location1 distanceFromLocation:location2];
    
    return distance;
    
}


-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation
{
    
    
    NSString *currentLatitude = [[NSString alloc]
                                 initWithFormat:@"%+.3f",
                                 newLocation.coordinate.latitude];
    
    NSString *currentLongitude = [[NSString alloc]
                                  initWithFormat:@"%+.3f",
                                  newLocation.coordinate.longitude];

    
    NSLog(@"Current coordinates %@, %@",currentLatitude,currentLongitude);
    
    newLocation = [[CLLocation alloc] initWithLatitude:[currentLatitude doubleValue] longitude:[currentLongitude doubleValue]];

     currentLatitude = [[NSString alloc]
                                 initWithFormat:@"%+.3f",
                                 oldLocation.coordinate.latitude];
    
    currentLongitude = [[NSString alloc]
                                  initWithFormat:@"%+.3f",
                                  oldLocation.coordinate.longitude];
    
    oldLocation = [[CLLocation alloc] initWithLatitude:[currentLatitude doubleValue] longitude:[currentLongitude doubleValue]];
    
    
    CLLocation *location = newLocation;

    self.currentLocation = location;
    
    NSNumber *myDoubleNumber = [NSNumber numberWithDouble:location.coordinate.latitude];
    
    myDoubleNumber = [NSNumber numberWithDouble:location.coordinate.longitude];
    
    float tempDistance;
    if(!start)
        tempDistance = [self getDistance:newLocation :oldLocation];
    else{
        start = false;
        tempDistance = 0;
    }
    
    if(tempDistance < 0)
        tempDistance *= -1;
    
    totalDistance = totalDistance + ((tempDistance) / 1000);


    
    myDoubleNumber = [NSNumber numberWithFloat:totalDistance];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
       
        [[NSNotificationCenter defaultCenter]postNotificationName:@"userLocationUpdater" object:@"my object" userInfo:@{@"location": location, @"lm": @"true"}];

    });
    
}

-(void)resetDistance:(id)sender
{
    _startLocation = nil;
}


-(void)locationManager:(CLLocationManager *)manager
      didFailWithError:(NSError *)error
{
    NSLog(@"Error %@",error);
    
}



@end
