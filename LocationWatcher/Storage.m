//
//  Storage.m
//  LocationWatcher
//
//  Created by EMM on 26/07/16.
//  Copyright © 2016 EMM. All rights reserved.
//

#import "Storage.h"

@interface Storage()

@property NSString *filePath;

@end
@implementation Storage

- (instancetype)init
{
    self = [super init];
    
        _filePath =  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]stringByAppendingPathComponent:@"Data.txt"];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:_filePath]){
        
        NSLog(@"File exists");
    }
    else{
        
        [self createFile];
    }
    
    return self;
}

-(void) createFile{
    
    NSError *error;
    NSString *stringToWrite = @"";
    [stringToWrite writeToFile:_filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if(error){
        NSLog(@"%@",[error description]);
    }

}

-(NSMutableArray *) getData{
    NSMutableArray* myArray =[NSKeyedUnarchiver unarchiveObjectWithFile:_filePath];
    return myArray;
    
}

-(void) saveData:(NSMutableArray *)myArray{
    
    if([NSKeyedArchiver archiveRootObject:myArray toFile:_filePath])
        NSLog(@"File save done");
    else
        NSLog(@"File didnt save");
}

@end
