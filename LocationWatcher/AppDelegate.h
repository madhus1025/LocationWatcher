//
//  AppDelegate.h
//  LocationWatcher
//
//  Created by EMM on 22/07/16.
//  Copyright © 2016 EMM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Google/SignIn.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate, GIDSignInDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

