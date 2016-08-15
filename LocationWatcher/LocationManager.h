//
//  LocationManager.h
//  GeoFenceDemo
//
//  Created by EMM on 26/06/16.
//  Copyright © 2016 EMM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>



@interface LocationManager : NSObject  <CLLocationManagerDelegate>

+(LocationManager *)sharedInstance;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *startLocation;
@property (nonatomic, strong) CLLocation *currentLocation;
@property double *totalDistance;
@end
