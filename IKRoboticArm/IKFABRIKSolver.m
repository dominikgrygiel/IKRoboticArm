//
//  IKFABRIKSolver.m
//  IKRoboticArm
//
//  Created by Dominik Grygiel on 04.12.2013.
//  Copyright (c) 2013 Dominik Grygiel. All rights reserved.
//

#import "IKFABRIKSolver.h"

#define TOLERANCE 0.001
#define MAX_ITERATIONS 50

@implementation IKFABRIKSolver

+ (void)findNewAngles:(GLfloat *)newAngles forJoints:(GLuint)joints angles:(GLfloat *)angles lenghts:(GLfloat *)lenghts target:(GLKVector2)target
{
    GLKVector2 positions[joints];
    positions[0] = GLKVector2Make(0.0f, 0.5f);
    GLfloat theta = angles[0];
    for (int i = 1; i <= joints; i++) {
        positions[i] = GLKVector2Add(positions[i-1], GLKVector2Make(cosf(theta) * lenghts[i-1], sinf(theta) * lenghts[i-1]));
        theta += angles[i];
    }

    GLfloat distances[joints];
    for (int i = 0; i < joints; i++) {
        distances[i] = GLKVector2Distance(positions[i], positions[i+1]);
    }

    int iterations = 0;
    GLfloat diff = GLKVector2Distance(positions[joints], target);
    GLKVector2 base = positions[0];
    while ((iterations < MAX_ITERATIONS) && (diff > TOLERANCE)) {
        positions[joints] = target;
        for (int i = joints - 1; i >= 0; i--) {
            GLfloat r = GLKVector2Distance(positions[i], positions[i+1]);
            GLfloat lambda = distances[i] / r;
            positions[i] = GLKVector2Add(GLKVector2MultiplyScalar(positions[i+1], 1-lambda), GLKVector2MultiplyScalar(positions[i], lambda));
        }

        positions[0] = base;
        for (int i = 0; i < joints; i++) {
            GLfloat r = GLKVector2Distance(positions[i], positions[i+1]);
            GLfloat lambda = distances[i] / r;
            positions[i+1] = GLKVector2Add(GLKVector2MultiplyScalar(positions[i], 1-lambda), GLKVector2MultiplyScalar(positions[i+1], lambda));
        }

        diff = GLKVector2Distance(positions[joints], target);
        iterations++;
    }

    theta = 0;
    for (int i = 0; i < joints; i++) {
        GLKVector2 sub = GLKVector2Subtract(positions[i+1], positions[i]);
        newAngles[i] = (i ? - theta : 0) + (theta = atan2f(sub.y, sub.x));
    }
}

@end
