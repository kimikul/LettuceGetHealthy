//
//  LTTabBarController.m
//  LettuceGetHealthy
//
//  Created by Kimberly Hsiao on 8/30/15.
//  Copyright (c) 2015 hsiao. All rights reserved.
//

#import "LTTabBarController.h"

@interface LTTabBarController ()

@end

@implementation LTTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self stylizeTabBar];
}

- (void)stylizeTabBar {
    UITabBarItem *tabBarItem = [self.tabBar.items objectAtIndex:0];
    
    UIImage *unselectedImage = [UIImage imageNamed:@"icon-today"];
    UIImage *selectedImage = [UIImage imageNamed:@"icon-today"];
    
    [tabBarItem setImage: [unselectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [tabBarItem setSelectedImage:selectedImage];
    
    UITabBarItem *tabBarItem2 = [self.tabBar.items objectAtIndex:1];
    UIImage *unselectedImage2 = [UIImage imageNamed:@"icon-chart"];
    UIImage *selectedImage2 = [UIImage imageNamed:@"icon-chart"];
    
    [tabBarItem2 setImage: [unselectedImage2 imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [tabBarItem2 setSelectedImage:selectedImage2];
}

@end
