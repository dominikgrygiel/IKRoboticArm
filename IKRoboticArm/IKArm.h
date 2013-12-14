//
//  IKArm.h
//  IKRoboticArm
//
//  Created by Dominik Grygiel on 01.12.2013.
//  Copyright (c) 2013 Dominik Grygiel. All rights reserved.
//

#import <GLKit/GLKit.h>


@interface IKArm : NSObject

@property GLKVector2 target;

+ (GLfloat)ballRadius;

- (void)tearDownGL;
- (BOOL)executeWithP:(const GLKMatrix4 *)projectionMatrix V:(const GLKMatrix4 *)viewMatrix uniforms:(const GLint *)uniforms;
- (void)setPositionX:(GLfloat)x y:(GLfloat)y z:(GLfloat)z;
- (void)setAnglesForBone0:(GLfloat)bone0 bone1:(GLfloat)bone1 bone2:(GLfloat)bone2 bone3:(GLfloat)bone3 baseRotation:(GLfloat)base;

@end
