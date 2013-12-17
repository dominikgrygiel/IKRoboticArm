//
//  IKMainViewController.h
//  IKRoboticArm
//
//  Created by Dominik Grygiel on 01.12.2013.
//  Copyright (c) 2013 Dominik Grygiel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@class IKScene;

@interface IKMainViewController : GLKViewController

@property (nonatomic, strong, readonly) IKScene *scene;

@end
