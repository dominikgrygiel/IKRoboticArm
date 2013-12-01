//
//  IKCylinder.h
//  IKRoboticArm
//
//  Created by Dominik Grygiel on 01.12.2013.
//  Copyright (c) 2013 Dominik Grygiel. All rights reserved.
//

#import "IKModel.h"

@interface IKCylinder : IKModel

- (id)initWithRadius:(GLfloat)radius height:(GLfloat)height stacks:(GLint)stacks;

@end
