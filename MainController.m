//
//  MainController.m
//  LocationWatcher
//
//  Created by EMM on 24/07/16.
//  Copyright © 2016 EMM. All rights reserved.
//

#import "MainController.h"
#import "AudioPlayer.h"
#import "LocationManager.h"
#import "Location.h"
#import "Storage.h"


@interface MainController()

    @property AudioPlayer *audioPlayer;
    @property LocationManager *locationManager;
    @property NSMutableArray *userDefinedLocations;
    @property CLLocation *currentUserLocation;
    @property (nonatomic) Location *currentCellLocation;
    @property NSInteger currentIndex;
    @property BOOL editFlag;
    @property Storage *storage;
    @property BOOL playFlag;

@end

@implementation MainController
    

+ (MainController *)sharedInstance {
    
    static MainController *instance = nil;
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
        _currentCellLocation = [Location alloc];
        _audioPlayer = [AudioPlayer sharedInstance];
        _userDefinedLocations = [[NSMutableArray alloc]initWithCapacity:100];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didIReachAnyLocation:) name:@"userLocationUpdater" object:@"my object"];
        _storage = [[Storage alloc]init];
        _locationManager = [LocationManager sharedInstance];
        _playFlag = false;
        [self loadData];
        
        
    }
    return self;
}

-(NSInteger) numberOfCheckPoints{
  
    return [_userDefinedLocations count];
}


-(BOOL) checkLocation:(CLLocation *) definedLocation :withCurrentLocation : (CLLocation *) currentLocation : ofRadius : (double )radius{
    
    double distance = [currentLocation distanceFromLocation:definedLocation]/1000;
    
    if(distance > radius)
        return true;
    else
        return false;
}



-(Location *) getACheckPointAtIndex :(NSInteger)index{
    
    return [_userDefinedLocations objectAtIndex:index];
}

-(BOOL) didIReachLocation:(Location *) location{
    
    CLLocation *locationOfThePoint = [location getLocation];
    if(_currentUserLocation == nil || locationOfThePoint == nil)
        return false;
    double distanceBetweenTwoPoints = [locationOfThePoint distanceFromLocation:_currentUserLocation]/1000;
    
    NSLog(@" lop %f",locationOfThePoint.coordinate.latitude);
    NSLog(@" lop %f",_currentUserLocation.coordinate.latitude);
    double radius = [location getRadius];
    if(distanceBetweenTwoPoints <= radius){
        NSLog(@"reached Location");
        return true;
    }
    return false;
}

-(void) didIReachAnyLocation:(NSNotification *) notification{
    
    NSUInteger count = 0;
    
    _playFlag = false;
    
    if([_userDefinedLocations count] <= 0){
        [self stopAudio];
        return;
    }
    
    _currentUserLocation = [notification userInfo][@"location"];
    
    for(Location *location in _userDefinedLocations){
        
        if([self didIReachLocation:location]){
            if([location isEnabled] ){
                if(![location isPlaying]) {
                    [location setIsPlaying:true];
                    [self reachedLocation:count];
                }
                _playFlag = true;
            }
    
        }
        count++;
    }
    if(_playFlag)
        [self playAudio];
    else
        [self stopAudio];
}


-(void) didIReachAnyLocation{
    
    NSUInteger count = 0;
    _playFlag = false;
    if([_userDefinedLocations count] <= 0){
        [self stopAudio];
        return;
    }
        
    for(Location *location in _userDefinedLocations){
        
        if([self didIReachLocation:location]){
            if([location isEnabled] ){
                if(![location isPlaying]){
                    
                    [self reachedLocation:count];
                    [location setIsPlaying:true];
                }
                _playFlag = true;
            }
        }
        count++;
    }
    if(_playFlag)
        [self playAudio];
    else
        [self stopAudio];
}

-(void) reachedLocation:(NSUInteger )index{
    
    //[self playAudio];
    NSLog(@"%lu",(unsigned long)index);
    NSLog(@"%@",[[self getACheckPointAtIndex:index] getMessage]);
    [[NSNotificationCenter defaultCenter]postNotificationName:@"Eezy" object:@"my object" userInfo:@{@"message": [[self getACheckPointAtIndex:index] getMessage], @"title": @"Reached a CheckPoint"}];

    
}

-(BOOL ) isPlaying{
    
   return [_audioPlayer isPlaying];
    
}
-(void) stopAudio{
    
    [_audioPlayer stopAudio];
}

-(void) playAudio{
    
    [_audioPlayer playAudio];
    
}

-(void) loadData{
    
    
    if( [_storage getData] != nil)
        _userDefinedLocations = [_storage getData];
    NSLog(@"%@",[_storage getData]);
}

-(void) saveData{
    
    [_storage saveData:_userDefinedLocations];
}

-(Location *) getCurrentCellLocation{
    
    return _currentCellLocation;
}
-(void) setCurrentCellLocation :(Location *) currentCellLocation :(NSInteger )currentIndex{
    
    _currentCellLocation = currentCellLocation;
    _currentIndex = currentIndex;
}

-(BOOL) addLocation:(Location *)newLocation{
    
    if(_userDefinedLocations.count >= 100)
        return false;
    
    
    [_userDefinedLocations addObject:newLocation];
    return true;
}
-(void) removeLocation:(NSUInteger )index{
    
    if([[_userDefinedLocations objectAtIndex:index] isPlaying])
        [[_userDefinedLocations objectAtIndex:index] setIsPlaying:false];
    
    [_userDefinedLocations removeObjectAtIndex:index];
    NSLog(@"%lu",(unsigned long)[_userDefinedLocations count]);
    [self saveData];
    [self didIReachAnyLocation];

    
}
-(void) updateLocation:(NSUInteger )oldIndex :(Location *)newLocation{
    
    if([[_userDefinedLocations objectAtIndex:oldIndex] isPlaying])
        [newLocation setIsPlaying:true];
    else
        [newLocation setIsPlaying:false];
    [_userDefinedLocations removeObjectAtIndex:oldIndex];
    [_userDefinedLocations insertObject:newLocation atIndex:oldIndex];
    //[newLocation setisEnabled:true];
    [self saveData];
    
}

-(NSInteger )getCurrentIndex{
    return _currentIndex;
}

-(void) setEditflag:(BOOL) flag{
    _editFlag = flag;
}

-(BOOL) getEditFlag {
    return _editFlag;
}

@end
