//
//  LTSignUpViewController.m
//  LettuceGetHealthy
//
//  Created by Kimberly Hsiao on 8/30/15.
//  Copyright (c) 2015 hsiao. All rights reserved.
//

#import "LTSignUpViewController.h"
#import "LTAppDelegate.h"

@interface LTSignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UIButton *joinButton;

@end

@implementation LTSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.joinButton.layer.cornerRadius = 4.0;
    self.joinButton.layer.masksToBounds = YES;
}

- (IBAction)tappedJoinButton:(id)sender {
    NSString *firstNameText = self.firstNameTextField.text;
    NSString *lastNameText = self.lastNameTextField.text;
    
    PFQuery *query = [PFQuery queryWithClassName:@"User"];
    [query whereKey:@"firstName" equalTo:firstNameText];
    [query whereKey:@"lastName" equalTo:lastNameText];

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects.count > 0) {
            PFObject *user = [objects objectAtIndex:0];
            [self saveCurrentUser:user];
            [self transitionToHomeViewController];
        } else {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"User Not Found" message:@"We couldn't find your account! Please try again." preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alertVC animated:YES completion:nil];
        }
    }];
}

- (void)saveCurrentUser:(PFObject*)user {
    NSDictionary *dict = @{@"userID" : user.objectId,
                           @"firstName" : [user objectForKey:@"firstName"],
                           @"lastName" : [user objectForKey:@"lastName"],
                           @"photoURL" : [user objectForKey:@"photoURL"]
                           };
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:dict forKey:LTCurrentUserDefaultsKey];
    [defaults synchronize];
}

- (void)transitionToHomeViewController {
    UIStoryboard *mainStoryboard = [UIStoryboard mainStoryboard];
    UINavigationController *homeVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"LTTabBarController"];
    
    LTAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate setRootViewController:homeVC];
}

@end
