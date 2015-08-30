//
//  LTTabBarControllerViewController.m
//  LettuceGetHealthy
//
//  Created by Kimberly Hsiao on 8/30/15.
//  Copyright (c) 2015 hsiao. All rights reserved.
//

#import "LTTabBarControllerViewController.h"

@interface LTTabBarControllerViewController ()

@end

@implementation LTTabBarControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
