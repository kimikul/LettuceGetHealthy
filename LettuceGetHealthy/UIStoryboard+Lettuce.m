//
//  UIStoryboard+Lettuce.m
//  LettuceGetHealthy
//
//  Created by Kimberly Hsiao on 8/30/15.
//  Copyright (c) 2015 hsiao. All rights reserved.
//

#import "UIStoryboard+Lettuce.h"

@implementation UIStoryboard (Lettuce)

+ (UIStoryboard*)mainStoryboard {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return mainStoryboard;
}

@end
