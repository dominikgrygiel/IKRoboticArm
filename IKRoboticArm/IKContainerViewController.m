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

@property (nonatomic, strong) UIButton *target0Button;
@property (nonatomic, strong) UIButton *target1Button;
@property (nonatomic, strong) UIButton *target2Button;

@end


@implementation IKContainerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.mainViewController = [[IKMainViewController alloc] init];
    [self addChildViewController:self.mainViewController];
    [self.view addSubview:self.mainViewController.view];

    CGSize viewSize = self.view.frame.size;
    GLfloat y = MIN(viewSize.width, viewSize.height) - 128;
    self.joystick = [[DGJoyStickView alloc] initWithFrame:CGRectMake(0, y, 128, 128)];
    self.mainViewController.scene.joystick = self.joystick;
    [self.view addSubview:self.joystick];

    self.target0Button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.target0Button.backgroundColor = [UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:0.6f];
    self.target0Button.layer.cornerRadius = 15;
    self.target0Button.frame = CGRectMake(140, y + 80, 30, 30);
    self.target0Button.tag = 1;
    [self.view addSubview:self.target0Button];
    [self.target0Button addTarget:self action:@selector(didSelectTarget:) forControlEvents:UIControlEventTouchUpInside];

    self.target1Button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.target1Button.backgroundColor = [UIColor colorWithRed:0.0f green:1.0f blue:0.0f alpha:0.6f];
    self.target1Button.layer.cornerRadius = 15;
    self.target1Button.frame = CGRectMake(180, y + 80, 30, 30);
    self.target1Button.tag = 2;
    [self.view addSubview:self.target1Button];
    [self.target1Button addTarget:self action:@selector(didSelectTarget:) forControlEvents:UIControlEventTouchUpInside];

    self.target2Button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.target2Button.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:0.0f alpha:0.6f];
    self.target2Button.layer.cornerRadius = 15;
    self.target2Button.frame = CGRectMake(220, y + 80, 30, 30);
    self.target2Button.tag = 3;
    [self.view addSubview:self.target2Button];
    [self.target2Button addTarget:self action:@selector(didSelectTarget:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didSelectTarget:(UIButton *)sender
{
    [self.mainViewController.scene didSelectTarget:sender.tag - 1];

    GLint target = [self.mainViewController.scene currentTarget];
    self.target0Button.backgroundColor = [UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:(target == 0 ? 1.0f : 0.6f)];
    self.target1Button.backgroundColor = [UIColor colorWithRed:0.0f green:1.0f blue:0.0f alpha:(target == 1 ? 1.0f : 0.6f)];
    self.target2Button.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:0.0f alpha:(target == 2 ? 1.0f : 0.6f)];
}

@end
