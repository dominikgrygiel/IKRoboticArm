//
//  IKArm.m
//  IKRoboticArm
//
//  Created by Dominik Grygiel on 01.12.2013.
//  Copyright (c) 2013 Dominik Grygiel. All rights reserved.
//

#import "IKArm.h"
#import "IKBone.h"
#import "IKCylinder.h"

@interface IKArm () {
    GLfloat _posX;
    GLfloat _posY;
    GLfloat _posZ;
}

@property (nonatomic, strong) IKCylinder *base;
@property (nonatomic, strong) IKCylinder *baseJoint;
@property (nonatomic, strong) IKBone *bone1_0;
@property (nonatomic, strong) IKBone *bone1_1;

@end


@implementation IKArm

- (id)init {
    if ((self = [super init])) {
        self.base = [[IKCylinder alloc] initWithRadius:1.0f height:0.1f stacks:10];
        self.baseJoint = [[IKCylinder alloc] initWithRadius:0.2f height:0.4f stacks:20];

        self.bone1_0 = [[IKBone alloc] initWithWidth:3.0f height:0.3f depth:0.05f stacks:20];
        self.bone1_1 = [[IKBone alloc] initWithWidth:3.0f height:0.3f depth:0.05f stacks:20];

        [self.base setPositionX:0.1f y:0.0f z:0.0f];
        [self.baseJoint setPositionX:0.3f y:0.0f z:0.0f];

        [self.bone1_0 setRotationX:0.0f y:M_PI_4 z:M_PI_2];
        [self.bone1_0 setPositionX:0.205f y:-0.2f z:1.7f];

        [self.bone1_1 setRotationX:0.0f y:M_PI_4 z:M_PI_2];
        [self.bone1_1 setPositionX:-0.205f y:-0.2f z:1.7f];
    }
    return  self;
}

- (void)tearDownGL
{
    [self.base tearDownGL];
    [self.base tearDownGL];

    [self.bone1_0 tearDownGL];
    [self.bone1_1 tearDownGL];
}

- (BOOL)executeWithP:(const GLKMatrix4 *)projectionMatrix V:(const GLKMatrix4 *)viewMatrix uniforms:(const GLint *)uniforms
{
    GLKMatrix4 V = GLKMatrix4Translate(*viewMatrix, _posX, _posY, _posZ);
    V = GLKMatrix4Rotate(V, -M_PI_2, 1.0f, 0.0f, 0.0f);

    [self.base executeWithP:projectionMatrix V:&V uniforms:uniforms];
    [self.baseJoint executeWithP:projectionMatrix V:&V uniforms:uniforms];

    [self.bone1_0 executeWithP:projectionMatrix V:&V uniforms:uniforms];
    [self.bone1_1 executeWithP:projectionMatrix V:&V uniforms:uniforms];

    return YES;
}

- (void)setPositionX:(GLfloat)x y:(GLfloat)y z:(GLfloat)z
{
    _posX = x;
    _posY = y;
    _posZ = z;
}

@end
