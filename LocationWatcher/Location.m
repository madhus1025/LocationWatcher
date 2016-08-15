//
//  Location.m
//  LocationWatcher
//
//  Created by EMM on 24/07/16.
//  Copyright © 2016 EMM. All rights reserved.
//

#import "Location.h"
#import <CoreLocation/CoreLocation.h>


@interface  Location()

@property CLLocation *requiredLocation;
@property NSString *message;
@property double radius;
@property NSString *name;
@property (nonatomic) NSString *searchedLocation;
@property (nonatomic) BOOL isEnabled;
@property (nonatomic) BOOL isPlaying;


@end

@implementation Location

-(instancetype) initWithLocation:(CLLocation *)location :(double )radius :(NSString *)message :(NSString *)name :(NSString *)searchedLocation{
    
    self = [super init];
    self.requiredLocation = [[CLLocation alloc]init];
    [self setIsPlaying:false];
    self.requiredLocation = location;
    self.radius = radius;
    self.message = message;
    self.name = name;
    self.searchedLocation = searchedLocation;
    self.isEnabled = true;
    return self;
}

-(void) setSearchedLocation:(NSString *)searchedLocation{
    
    _searchedLocation = searchedLocation;
}

-(NSString *) getSearchedLocation{

    return _searchedLocation;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.requiredLocation forKey:@"requiredLocation"];
    [aCoder encodeDouble:self.requiredLocation.coordinate.latitude forKey:@"latitude"];
    [aCoder encodeDouble:self.requiredLocation.coordinate.longitude forKey:@"longitude"];
    [aCoder encodeObject:self.message forKey:@"message"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.searchedLocation forKey:@"searchedLocation"];
    [aCoder encodeDouble:self.radius forKey:@"radius"];
    [aCoder encodeBool:self.isEnabled forKey:@"isEnabled"];
    [aCoder encodeBool:self.isPlaying forKey:@"isPlaying"];
    
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super init]){

        self.requiredLocation = [[CLLocation alloc]initWithLatitude:[aDecoder decodeDoubleForKey:@"latitude"] longitude:[aDecoder decodeDoubleForKey:@"longitude"]];
        
        self.radius = [aDecoder decodeDoubleForKey:@"radius"];
        self.message = [aDecoder decodeObjectForKey:@"message"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.searchedLocation = [aDecoder decodeObjectForKey:@"searchedLocation"];
        self.isEnabled = [aDecoder decodeBoolForKey:@"isEnabled"];
        self.isPlaying = [aDecoder decodeBoolForKey:@"isPlaying"];
    }
    return self;
}

-(instancetype) initWithLocation:(CLLocation *)location :(double )radius{
    return [self initWithLocation:location :radius :NULL:NULL:NULL];
}

-(void) updateLocation:(CLLocation *)newLocation{
    self.requiredLocation = newLocation;
}

-(void) updateRadius:(double)newRadius{
    self.radius = newRadius;
}

-(void) updateMessage:(NSString *)newMessage{
    self.message = newMessage;
}
-(CLLocation *)getLocation{
    return self.requiredLocation;
}
-(double) getRadius{
    return  self.radius;
}
-(NSString *) getName{
    return self.name;
}
-(NSString *) getMessage{
    return self.message;
}
-(BOOL) isEnabled{
    return _isEnabled;
}
-(void) setisEnabled:(BOOL)flag{
    self.isEnabled = flag;
}

-(BOOL) isPlaying{
    return _isPlaying;
}
-(void) setisPlaying:(BOOL)flag{
    _isPlaying = flag;
}

@end
