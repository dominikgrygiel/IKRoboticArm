//
//  IKScene.m
//  IKRoboticArm
//
//  Created by Dominik Grygiel on 14.12.2013.
//  Copyright (c) 2013 Dominik Grygiel. All rights reserved.
//

#import "IKScene.h"
#import "IKSphere.h"
#import "IKArm.h"
#import "DGJoyStickView.h"

const GLfloat kArmOffset = -2.0f;
const GLint kBallStacks = 40;

@interface IKScene () {
    GLKVector3 _ball0Position;
    GLKVector3 _ball1Position;
    GLKVector3 _ball2Position;

    GLfloat _currY;
    GLfloat _baseRotation;
    CGFloat kBallRadius;
}

@property (nonatomic, strong) IKArm *arm;
@property (nonatomic, strong) IKSphere *ball0;
@property (nonatomic, strong) IKSphere *ball1;
@property (nonatomic, strong) IKSphere *ball2;
@end

@implementation IKScene

- (id)init {
    if ((self = [super init])) {
        self.arm = [[IKArm alloc] init];
        [self.arm setPositionX:kArmOffset y:0.0f z:0.0f];

        kBallRadius = [IKArm ballRadius];
        _currY = kBallRadius + 0.1f;
        self.ball0 = [[IKSphere alloc] initWithRadius:kBallRadius stacks:kBallStacks];
        self.ball0.diffuseColor = GLKVector4Make(1.0, 0.0f, 0.0f, 1.0);

        self.ball1 = [[IKSphere alloc] initWithRadius:kBallRadius stacks:kBallStacks];
        self.ball1.diffuseColor = GLKVector4Make(0.0, 1.0f, 0.0f, 1.0);

        self.ball2 = [[IKSphere alloc] initWithRadius:kBallRadius stacks:kBallStacks];
        self.ball2.diffuseColor = GLKVector4Make(1.0, 1.0f, 0.0f, 1.0);
    }
    return self;
}

- (void)tearDownGL
{
    [self.arm tearDownGL];
    [self.ball0 tearDownGL];
}

- (BOOL)executeWithP:(const GLKMatrix4 *)projectionMatrix V:(const GLKMatrix4 *)viewMatrix uniforms:(const GLint *)uniforms
{
    _baseRotation += self.joystick.currentPosition.x / -30;
    if (_currY < 3.0f) {
        _currY += 0.02;
    }

    _ball0Position.x = _currY;
    _ball0Position.z = 6.0f - _currY;

    _ball1Position.x = kBallRadius;
    _ball1Position.y = -3.0f;
    _ball1Position.z = 0.0f;

    _ball2Position.x = kBallRadius;
    _ball2Position.y = 3.0f;
    _ball2Position.z = -4.0f;

    [self.ball0 setPositionX:_ball0Position.x + kArmOffset y:_ball0Position.y z:_ball0Position.z];
    [self.ball0 executeWithP:projectionMatrix V:viewMatrix uniforms:uniforms];

    [self.ball1 setPositionX:_ball1Position.x + kArmOffset y:_ball1Position.y z:_ball1Position.z];
    [self.ball1 executeWithP:projectionMatrix V:viewMatrix uniforms:uniforms];

    [self.ball2 setPositionX:_ball2Position.x + kArmOffset y:_ball2Position.y z:_ball2Position.z];
    [self.ball2 executeWithP:projectionMatrix V:viewMatrix uniforms:uniforms];

    self.arm.target = GLKVector2Make(6.0 - _currY, _currY);
    self.arm.baseRotation = _baseRotation;
    [self.arm executeWithP:projectionMatrix V:viewMatrix uniforms:uniforms];

    return YES;
}

@end