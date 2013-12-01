//
//  IKBone.h
//  IKRoboticArm
//
//  Created by Dominik Grygiel on 01.12.2013.
//  Copyright (c) 2013 Dominik Grygiel. All rights reserved.
//

#import "IKModel.h"

@interface IKBone : IKModel

- (id)initWithWidth:(GLfloat)width height:(GLfloat)height depth:(GLfloat)depth stacks:(GLint)stacks;

@end
