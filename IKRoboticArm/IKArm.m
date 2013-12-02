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

const GLfloat kBaseJointRadius = 0.4f;
const GLfloat kBaseJointHeight = 0.35f;
const GLint kBaseJointStacks = 20;

const GLfloat kBoneHeight = 0.3f;
const GLfloat kBoneDepth = 0.05f;
const GLint kBoneStacks = 20;

const GLfloat kBone0Width = 3.0f;
const GLfloat kBone1Width = 2.0f;
const GLfloat kBone2Width = 1.5f;

@interface IKArm () {
    GLfloat _posX;
    GLfloat _posY;
    GLfloat _posZ;

    GLfloat _rotBone0;
    GLfloat _rotBone1;
    GLfloat _rotBone2;
}

@property (nonatomic, strong) IKCylinder *base;
@property (nonatomic, strong) IKCylinder *baseJoint;

@property (nonatomic, strong) IKBone *bone0;
@property (nonatomic, strong) IKBone *bone1;
@property (nonatomic, strong) IKBone *bone2;

@end


@implementation IKArm

- (id)init {
    if ((self = [super init])) {
        self.base = [[IKCylinder alloc] initWithRadius:1.0f height:0.1f stacks:10];
        self.baseJoint = [[IKCylinder alloc] initWithRadius:kBaseJointRadius height:kBaseJointHeight stacks:kBaseJointStacks];

        self.bone0 = [[IKBone alloc] initWithWidth:kBone0Width height:kBoneHeight depth:kBoneDepth stacks:kBoneStacks];
        self.bone1 = [[IKBone alloc] initWithWidth:kBone1Width height:kBoneHeight depth:kBoneDepth stacks:kBoneStacks];
        self.bone2 = [[IKBone alloc] initWithWidth:kBone2Width height:kBoneHeight depth:kBoneDepth stacks:kBoneStacks];

        [self.base setPositionX:0.1f y:0.0f z:0.0f];

        [self.baseJoint setRotationX:0.0f y:0.0f z:M_PI_2];
        [self.baseJoint setPositionX:0.0f y:-0.3f z:0.0f];
    }
    return  self;
}

- (void)tearDownGL
{
    [self.base tearDownGL];
    [self.base tearDownGL];

    [self.bone0 tearDownGL];
    [self.bone1 tearDownGL];
    [self.bone2 tearDownGL];
}

- (BOOL)executeWithP:(const GLKMatrix4 *)projectionMatrix V:(const GLKMatrix4 *)viewMatrix uniforms:(const GLint *)uniforms
{
    GLKMatrix4 V = GLKMatrix4Translate(*viewMatrix, _posX, _posY, _posZ);
    V = GLKMatrix4Rotate(V, -M_PI_2, 1.0f, 0.0f, 0.0f);

    [self.base executeWithP:projectionMatrix V:&V uniforms:uniforms];
    [self.baseJoint executeWithP:projectionMatrix V:&V uniforms:uniforms];


    GLKMatrix4 modelMatrixBone0_0 = GLKMatrix4MakeRotation(M_PI_2, 0.0f, 0.0f, 1.0f);
    modelMatrixBone0_0 = GLKMatrix4Translate(modelMatrixBone0_0, kBaseJointHeight / 2 + kBoneDepth / 2, -0.5f, 0.0f);
    modelMatrixBone0_0 = GLKMatrix4Rotate(modelMatrixBone0_0, _rotBone0, 1.0f, 0.0f, 0.0f);
    modelMatrixBone0_0 = GLKMatrix4Translate(modelMatrixBone0_0, 0.0f, 0.0f, kBone0Width / 2 - kBoneHeight / 2);
    [self.bone0 executeWithP:projectionMatrix V:&V M:&modelMatrixBone0_0 uniforms:uniforms];

    GLKMatrix4 modelMatrixBone0_1 = GLKMatrix4MakeRotation(M_PI_2, 0.0f, 0.0f, 1.0f);
    modelMatrixBone0_1 = GLKMatrix4Translate(modelMatrixBone0_1, -1 * (kBaseJointHeight / 2 + kBoneDepth / 2), -0.5f, 0.0f);
    modelMatrixBone0_1 = GLKMatrix4Rotate(modelMatrixBone0_1, _rotBone0, 1.0f, 0.0f, 0.0f);
    modelMatrixBone0_1 = GLKMatrix4Translate(modelMatrixBone0_1, 0.0f, 0.0f, kBone0Width / 2 - kBoneHeight / 2);
    [self.bone0 executeWithP:projectionMatrix V:&V M:&modelMatrixBone0_1 uniforms:uniforms];


    GLKMatrix4 modelMatrixBone1_0 = GLKMatrix4Translate(modelMatrixBone0_0, kBoneDepth, 0.0f, kBone0Width / 2 - kBoneHeight / 2);
    modelMatrixBone1_0 = GLKMatrix4Rotate(modelMatrixBone1_0, _rotBone1, 1.0f, 0.0f, 0.0f);
    modelMatrixBone1_0 = GLKMatrix4Translate(modelMatrixBone1_0, 0.0f, 0.0f, kBone1Width / 2 - kBoneHeight / 2);
    [self.bone1 executeWithP:projectionMatrix V:&V M:&modelMatrixBone1_0 uniforms:uniforms];

    GLKMatrix4 modelMatrixBone1_1 = GLKMatrix4Translate(modelMatrixBone0_1, -kBoneDepth, 0.0f, kBone0Width / 2 - kBoneHeight / 2);
    modelMatrixBone1_1 = GLKMatrix4Rotate(modelMatrixBone1_1, _rotBone1, 1.0f, 0.0f, 0.0f);
    modelMatrixBone1_1 = GLKMatrix4Translate(modelMatrixBone1_1, 0.0f, 0.0f, kBone1Width / 2 - kBoneHeight / 2);
    [self.bone1 executeWithP:projectionMatrix V:&V M:&modelMatrixBone1_1 uniforms:uniforms];


    GLKMatrix4 modelMatrixBone2_0 = GLKMatrix4Translate(modelMatrixBone1_0, -kBoneDepth, 0.0f, kBone1Width / 2 - kBoneHeight / 2);
    modelMatrixBone2_0 = GLKMatrix4Rotate(modelMatrixBone2_0, _rotBone2, 1.0f, 0.0f, 0.0f);
    modelMatrixBone2_0 = GLKMatrix4Translate(modelMatrixBone2_0, 0.0f, 0.0f, kBone2Width / 2 - kBoneHeight / 2);
    [self.bone2 executeWithP:projectionMatrix V:&V M:&modelMatrixBone2_0 uniforms:uniforms];

    GLKMatrix4 modelMatrixBone2_1 = GLKMatrix4Translate(modelMatrixBone1_1, kBoneDepth, 0.0f, kBone1Width / 2 - kBoneHeight / 2);
    modelMatrixBone2_1 = GLKMatrix4Rotate(modelMatrixBone2_1, _rotBone2, 1.0f, 0.0f, 0.0f);
    modelMatrixBone2_1 = GLKMatrix4Translate(modelMatrixBone2_1, 0.0f, 0.0f, kBone2Width / 2 - kBoneHeight / 2);
    [self.bone2 executeWithP:projectionMatrix V:&V M:&modelMatrixBone2_1 uniforms:uniforms];

    _rotBone0 = 1.2 * M_PI_4;
    _rotBone1 = -M_PI_2;
    _rotBone2 = -M_PI_4;
    return YES;
}

- (void)setPositionX:(GLfloat)x y:(GLfloat)y z:(GLfloat)z
{
    _posX = x;
    _posY = y;
    _posZ = z;
}

@end
