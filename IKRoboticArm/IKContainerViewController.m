//
//  IKContainerViewController.m
//  IKRoboticArm
//
//  Created by Dominik Grygiel on 17.12.2013.
//  Copyright (c) 2013 Dominik Grygiel. All rights reserved.
//

#import "IKContainerViewController.h"
#import "IKMainViewController.h"
#import "DGJoyStickView.h"
#import "IKScene.h"

@interface IKContainerViewController ()

@property (nonatomic, strong) IKMainViewController *mainViewController;
@property (nonatomic, strong) DGJoyStickView *joystick;

@end

@implementation IKContainerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.mainViewController = [[IKMainViewController alloc] init];
    [self addChildViewController:self.mainViewController];
    [self.view addSubview:self.mainViewController.view];

    self.joystick = [[DGJoyStickView alloc] initWithFrame:CGRectMake(0, 20, 128, 128)];
    self.mainViewController.scene.joystick = self.joystick;
    [self.view addSubview:self.joystick];
}

@end
