//
//  IKSphere.h
//  IKRoboticArm
//
//  Created by Dominik Grygiel on 01.12.2013.
//  Copyright (c) 2013 Dominik Grygiel. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface IKSphere : NSObject

- (id)initWithRadius:(GLfloat)radius stacks:(GLint)stacks;
- (void)tearDownGL;
- (BOOL)executeWithP:(const GLKMatrix4 *)projectionMatrix V:(const GLKMatrix4 *)viewMatrix uniforms:(const GLint *)uniforms;

@end
