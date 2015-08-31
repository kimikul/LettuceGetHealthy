//
//  LTHelper.m
//  LettuceGetHealthy
//
//  Created by Kimberly Hsiao on 8/30/15.
//  Copyright (c) 2015 hsiao. All rights reserved.
//

#import "LTHelper.h"

@implementation LTHelper

+ (PFObject*)currentUser {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [defaults objectForKey:LTCurrentUserDefaultsKey];
    
    PFObject *user = [PFObject objectWithClassName:@"User"];
    user.objectId = dict[@"userID"];
    user[@"firstName"] = dict[@"firstName"];
    user[@"lastName"] = dict[@"lastName"];
    user[@"photoURL"] = dict[@"photoURL"];
    
    return user;
}

+ (BOOL)userIsMe:(PFObject*)user {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [defaults objectForKey:LTCurrentUserDefaultsKey];
    return [dict[@"userID"] isEqualToString:user.objectId];
}

@end
