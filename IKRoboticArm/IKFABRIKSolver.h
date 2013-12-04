//
//  IKFABRIKSolver.h
//  IKRoboticArm
//
//  Created by Dominik Grygiel on 04.12.2013.
//  Copyright (c) 2013 Dominik Grygiel. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface IKFABRIKSolver : NSObject

+ (void)findNewAngles:(GLfloat *)newAngles forJoints:(GLuint)joints angles:(GLfloat *)angles lenghts:(GLfloat *)lenghts target:(GLKVector2)target;

@end
