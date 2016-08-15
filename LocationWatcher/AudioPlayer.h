//
//  AudioPlayer.h
//  LocationWatcher
//
//  Created by EMM on 24/07/16.
//  Copyright © 2016 EMM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface AudioPlayer : NSObject

+(AudioPlayer *)sharedInstance;

-(void) playAudio;
-(BOOL) isPlaying;
-(void) stopAudio;

@end
