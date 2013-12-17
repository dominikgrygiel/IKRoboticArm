//
//  IKScene.h
//  IKRoboticArm
//
//  Created by Dominik Grygiel on 14.12.2013.
//  Copyright (c) 2013 Dominik Grygiel. All rights reserved.
//

#import <GLKit/GLKit.h>

@class DGJoyStickView;

@interface IKScene : NSObject

@property (nonatomic, weak) DGJoyStickView *joystick;

- (void)tearDownGL;
- (BOOL)executeWithP:(const GLKMatrix4 *)projectionMatrix V:(const GLKMatrix4 *)viewMatrix uniforms:(const GLint *)uniforms;

@end
