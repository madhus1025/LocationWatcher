//
//  AudioPlayer.m
//  LocationWatcher
//
//  Created by EMM on 24/07/16.
//  Copyright © 2016 EMM. All rights reserved.
//

#import "AudioPlayer.h"

@implementation AudioPlayer{
    
    AVAudioPlayer *audioPlayer;
    
}

+ (AudioPlayer *)sharedInstance {
    
    static AudioPlayer *instance = nil;
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
        
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        
        
        NSString *path = [[NSBundle mainBundle]
                          pathForResource:@"fearless" ofType:@"mp3"];
        
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if ([fileManager fileExistsAtPath:path]){
            
            NSLog(@"File exists");
        }
        
        NSLog(@"The content url is %@",[NSURL fileURLWithPath:path]);
        
        
        NSError *error;
        
        audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:
                       [NSURL fileURLWithPath:path] error:&error];
        
        if(error){
            NSLog(@"Error : %@", [error localizedDescription]);
        }

        
        
    }
    return self;
}

-(void) playAudio{
    [audioPlayer play];
}

-(BOOL) isPlaying{
    return [audioPlayer isPlaying];
}

-(void) stopAudio{
    [audioPlayer stop];
}
@end
