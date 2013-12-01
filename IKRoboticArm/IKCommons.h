//
//  IKCommons.h
//  IKRoboticArm
//
//  Created by Dominik Grygiel on 01.12.2013.
//  Copyright (c) 2013 Dominik Grygiel. All rights reserved.
//

#ifndef IKRoboticArm_IKCommons_h
#define IKRoboticArm_IKCommons_h

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

// Uniform index.
enum
{
    UNIFORM_MODELVIEWPROJECTION_MATRIX,
    UNIFORM_NORMAL_MATRIX,
    UNIFORM_LIGHT0_POSITION,
    UNIFORM_LIGHT1_POSITION,
    UNIFORM_DIFFUSE_COLOR,
    NUM_UNIFORMS
};
GLint uniforms[NUM_UNIFORMS];

#endif
