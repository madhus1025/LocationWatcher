//
//  LoginScreenViewController.h
//  LocationWatcher
//
//  Created by EMM on 11/08/16.
//  Copyright © 2016 EMM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Google/SignIn.h>

@interface LoginScreenViewController : UIViewController <FBSDKLoginButtonDelegate, GIDSignInUIDelegate,GIDSignInDelegate>

@end
