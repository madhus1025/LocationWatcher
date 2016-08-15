//
//  MainController.h
//  LocationWatcher
//
//  Created by EMM on 24/07/16.
//  Copyright © 2016 EMM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"

@interface MainController : NSObject

+(MainController *) sharedInstance;

-(BOOL) addLocation:(Location *)newLocation;
-(NSInteger) numberOfCheckPoints;
-(Location *) getACheckPointAtIndex :(NSInteger)index;
-(Location *) getCurrentCellLocation;
-(void) setCurrentCellLocation :(Location *)currentCellLocation :(NSInteger )currentIndex;
-(BOOL) getEditFlag;
-(void) setEditflag:(BOOL) flag;
-(void) updateLocation:(NSUInteger )oldIndex :(Location *)newLocation;
-(NSInteger )getCurrentIndex;
-(void) loadData;
-(void) saveData;
-(void) removeLocation:(NSUInteger )index;
-(void) didIReachAnyLocation;
@end
