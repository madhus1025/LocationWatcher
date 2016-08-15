//
//  Storage.h
//  LocationWatcher
//
//  Created by EMM on 26/07/16.
//  Copyright © 2016 EMM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Storage : NSObject

-(void) saveData:(NSMutableArray *)myArray;
-(NSMutableArray *) getData;
- (instancetype)init;

@end
