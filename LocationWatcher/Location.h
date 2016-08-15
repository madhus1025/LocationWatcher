//
//  Location.h
//  LocationWatcher
//
//  Created by EMM on 24/07/16.
//  Copyright © 2016 EMM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface Location : NSObject <NSCoding>

-(void)updateLocation:(CLLocation *)newLocation;
-(void)updateRadius:(double)newRadius;
-(void)updateMessage:(NSString *)newMessage;
-(CLLocation *) getLocation;
-(double) getRadius;
-(NSString *) getName;
-(NSString *) getMessage;
-(NSString *) getSearchedLocation;
-(void) setSearchedLocation:(NSString *) searhcedLocation;
-(instancetype) initWithLocation:(CLLocation *)location :(double )radius :(NSString *)message : (NSString *)name : (NSString *) searchedLocation;
-(BOOL) isEnabled;
-(void) setisEnabled:(BOOL)flag;
-(BOOL) isPlaying;
-(void) setIsPlaying:(BOOL)flag;

@end
