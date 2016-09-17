//
//  LoginScreenViewController.m
//  LocationWatcher
//
//  Created by EMM on 11/08/16.
//  Copyright © 2016 EMM. All rights reserved.
//

#import "LoginScreenViewController.h"
#import "SVProgressHUD.h"
#import <Google/SignIn.h>


@interface LoginScreenViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginFacebook;
@property (weak, nonatomic) IBOutlet UIButton *segueButton;
@property (weak, nonatomic) IBOutlet GIDSignInButton *googleSignIn;
@property (weak, nonatomic) IBOutlet UIButton *googleSign;

@end

@implementation LoginScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[_segueButton setHiden:YES];
    [_loginFacebook setHidden:YES];
    [GIDSignIn sharedInstance].uiDelegate = self;
    [GIDSignIn sharedInstance].delegate = self;
    
}
- (IBAction)googleSignIn:(id)sender {
    [[GIDSignIn sharedInstance] signIn];
}


- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
    NSLog(@"came here 4");
}

// Present a view that prompts the user to sign in with Google
- (void)signIn:(GIDSignIn *)signIn
presentViewController:(UIViewController *)viewController {
    [self presentViewController:viewController animated:YES completion:nil];
    
    NSLog(@"came here2");

}

// Dismiss the "Sign in with Google" view
- (void)signIn:(GIDSignIn *)signIn
dismissViewController:(UIViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"came here 3");
    
}

-(void)viewDidAppear:(BOOL)animated{
   
    NSLog(@"came ag ain");
    GIDSignInButton *signIn = [[GIDSignInButton alloc]init];
    [signIn setHidden:NO];
    if ([FBSDKAccessToken currentAccessToken] || [GIDSignIn sharedInstance].hasAuthInKeychain)
        [self performSegueWithIdentifier: @"mainIdentifier" sender: self];
    
    if([[GIDSignIn sharedInstance]hasAuthInKeychain]){
         [self performSegueWithIdentifier: @"mainIdentifier" sender: self];
    }
    
    [signIn setColorScheme:kGIDSignInButtonColorSchemeDark];
    [_loginFacebook setHidden:NO];
    
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.center = self.view.center;
    loginButton.readPermissions =
    @[@"public_profile", @"email",@"user_posts"];
    loginButton.publishPermissions = @[@"publish_actions"];
    
    
    [loginButton setReadPermissions:@[@"user_posts"]];
    
    [self.view addSubview:loginButton];
    
    [loginButton setDelegate:self];
    
    [loginButton setHidden:YES];
}

- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations on signed in user here.
    if([GIDSignIn sharedInstance].hasAuthInKeychain){
    [SVProgressHUD showWithStatus:@"Fetching User Details"];
    }
    NSString *userId = user.userID;                  // For client-side use only!
    NSString *idToken = user.authentication.idToken; // Safe to send to the server
    NSString *fullName = user.profile.name;
    NSString *givenName = user.profile.givenName;
    NSString *familyName = user.profile.familyName;
    NSString *email = user.profile.email;
    [self performSegueWithIdentifier: @"mainIdentifier" sender: self];

    // ...
}

- (IBAction)buttonClick:(id)sender {
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: @[@"public_profile"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             UIViewController *viewController ;
             NSLog(@"Logged in");
             [SVProgressHUD showWithStatus:@"Fetching User Details"];
             UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
             viewController = [storyboard instantiateViewControllerWithIdentifier:@"mainScreen"];
             
         }
     }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void) loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error
{
    NSLog(@"came here");
    
}

-(void) loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
    
    NSLog(@"User clicked on logout");
    
}

-(BOOL) loginButtonWillLogin:(FBSDKLoginButton *)loginButton{
    
    NSLog(@"validating for login");
    return true;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
