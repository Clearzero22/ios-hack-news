//
//  ViewController.m
//  testioss
//
//  Created by clearzero22 on 2025/11/1.
//

#import "ViewController.h"
#import "HNNewsListViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    HNNewsListViewController *newsListVC = [[HNNewsListViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:newsListVC];
    
    [self addChildViewController:navController];
    [self.view addSubview:navController.view];
    [navController didMoveToParentViewController:self];
    
    navController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [navController.view.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [navController.view.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [navController.view.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [navController.view.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
}

@end
