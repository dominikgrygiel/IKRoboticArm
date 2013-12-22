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

#define NO_TARGET 1000
#define ANIMATION_STEP 0.05
#define HOLDING_Y 1.5f

@interface IKScene () {
    GLKVector3 _ball0Position;
    GLKVector3 _ball1Position;
    GLKVector3 _ball2Position;
    GLKVector2 _targetPosition;

    BOOL _isAnimating;
    BOOL _isHoldingTarget;
    GLint _currTarget;
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
        _targetPosition = GLKVector2Make(1.0f, HOLDING_Y);
        _currTarget = NO_TARGET;
        _isAnimating = NO;
        _isHoldingTarget = NO;

        kBallRadius = [IKArm ballRadius];
        self.ball0 = [[IKSphere alloc] initWithRadius:kBallRadius stacks:kBallStacks];
        self.ball0.diffuseColor = GLKVector4Make(1.0, 0.0f, 0.0f, 1.0);
        _ball0Position.x = kBallRadius;
        _ball0Position.y = 0.0f;
        _ball0Position.z = 6.0f;

        self.ball1 = [[IKSphere alloc] initWithRadius:kBallRadius stacks:kBallStacks];
        self.ball1.diffuseColor = GLKVector4Make(0.0, 1.0f, 0.0f, 1.0);
        _ball1Position.x = kBallRadius;
        _ball1Position.y = -3.0f;
        _ball1Position.z = 0.0f;

        self.ball2 = [[IKSphere alloc] initWithRadius:kBallRadius stacks:kBallStacks];
        self.ball2.diffuseColor = GLKVector4Make(1.0, 1.0f, 0.0f, 1.0);
        _ball2Position.x = kBallRadius;
        _ball2Position.y = 3.0f;
        _ball2Position.z = -4.0f;
    }
    return self;
}

- (void)tearDownGL
{
    [self.arm tearDownGL];
    [self.ball0 tearDownGL];
    [self.ball1 tearDownGL];
    [self.ball2 tearDownGL];
}

- (BOOL)executeWithP:(const GLKMatrix4 *)projectionMatrix V:(const GLKMatrix4 *)viewMatrix uniforms:(const GLint *)uniforms
{
    [self animateToTarget];
    if (!_isAnimating) {
        _baseRotation += self.joystick.currentPosition.x / -30;
        _targetPosition.x += self.joystick.currentPosition.y / -20;
        _targetPosition.x = MAX(MIN(_targetPosition.x, 6.3f), 1.0f);

        if (_isHoldingTarget) {
            [self addjustTargetPosition];
        }
    }

    _baseRotation = fmodl(_baseRotation, 2 * M_PI);
    if (_baseRotation < 0) _baseRotation += 2 * M_PI;

    [self.ball0 setPositionX:_ball0Position.x + kArmOffset y:_ball0Position.y z:_ball0Position.z];
    [self.ball0 executeWithP:projectionMatrix V:viewMatrix uniforms:uniforms];

    [self.ball1 setPositionX:_ball1Position.x + kArmOffset y:_ball1Position.y z:_ball1Position.z];
    [self.ball1 executeWithP:projectionMatrix V:viewMatrix uniforms:uniforms];

    [self.ball2 setPositionX:_ball2Position.x + kArmOffset y:_ball2Position.y z:_ball2Position.z];
    [self.ball2 executeWithP:projectionMatrix V:viewMatrix uniforms:uniforms];

    self.arm.target = _targetPosition;
    self.arm.baseRotation = _baseRotation;
    [self.arm executeWithP:projectionMatrix V:viewMatrix uniforms:uniforms];

    return YES;
}

- (void)animateToTarget
{
    if (_currTarget == NO_TARGET) {
        return;
    }

    _isAnimating = YES;
    GLfloat xDelta = 0.0f, yDelta = 0.0f, rotDelta = 0.0f;

    if (_currTarget == 0) {
        if (_isHoldingTarget) {
            yDelta = HOLDING_Y - _targetPosition.y;
            _ball0Position.x = _targetPosition.y;
        } else {
            xDelta = GLKVector2Length(GLKVector2Make(_ball0Position.y, _ball0Position.z)) - _targetPosition.x;
            rotDelta = atan2f(-_ball0Position.y, _ball0Position.z);
            if (rotDelta < 0) rotDelta += 2 * M_PI;
            rotDelta -= _baseRotation;
        }
        if ((rotDelta == 0.0f) && (xDelta == 0.0f) && !_isHoldingTarget) {
            yDelta = _ball0Position.x - _targetPosition.y;
            if (yDelta == 0.0f) _isHoldingTarget = YES;
        }
    } else if (_currTarget == 1) {
        if (_isHoldingTarget) {
            yDelta = HOLDING_Y - _targetPosition.y;
            _ball1Position.x = _targetPosition.y;
        } else {
            xDelta = GLKVector2Length(GLKVector2Make(_ball1Position.y, _ball1Position.z)) - _targetPosition.x;
            rotDelta = atan2f(-_ball1Position.y, _ball1Position.z);
            if (rotDelta < 0) rotDelta += 2 * M_PI;
            rotDelta -= _baseRotation;
        }
        if ((rotDelta == 0.0f) && (xDelta == 0.0f) && !_isHoldingTarget) {
            yDelta = _ball1Position.x - _targetPosition.y;
            if (yDelta == 0.0f) _isHoldingTarget = YES;
        }
    } else if (_currTarget == 2) {
        if (_isHoldingTarget) {
            yDelta = HOLDING_Y - _targetPosition.y;
            _ball2Position.x = _targetPosition.y;
        } else {
            xDelta = GLKVector2Length(GLKVector2Make(_ball2Position.y, _ball2Position.z)) - _targetPosition.x;
            rotDelta = atan2f(-_ball2Position.y, _ball2Position.z);
            if (rotDelta < 0) rotDelta += 2 * M_PI;
            rotDelta -= _baseRotation;
        }
        if ((rotDelta == 0.0f) && (xDelta == 0.0f) && !_isHoldingTarget) {
            yDelta = _ball2Position.x - _targetPosition.y;
            if (yDelta == 0.0f) _isHoldingTarget = YES;
        }
    }


    if (xDelta < 0) {
        _targetPosition.x += MAX(-ANIMATION_STEP, xDelta);
    } else {
        _targetPosition.x += MIN(ANIMATION_STEP, xDelta);
    }
    if (yDelta < 0) {
        _targetPosition.y += MAX(-ANIMATION_STEP, yDelta);
    } else {
        _targetPosition.y += MIN(ANIMATION_STEP, yDelta);
    }
    if (rotDelta < 0) {
        _baseRotation += MAX(-ANIMATION_STEP, rotDelta);
    } else {
        _baseRotation += MIN(ANIMATION_STEP, rotDelta);
    }


    if ((xDelta == 0.0f) && (yDelta == 0.0f) && (rotDelta == 0.0f)) {
        _isAnimating = NO;
    }
}

- (void)addjustTargetPosition
{
    if (_currTarget == 0) {
        _ball0Position.z = cosf(_baseRotation) * _targetPosition.x;
        _ball0Position.y = -sinf(_baseRotation) * _targetPosition.x;
    } else if (_currTarget == 1) {
        _ball1Position.z = cosf(_baseRotation) * _targetPosition.x;
        _ball1Position.y = -sinf(_baseRotation) * _targetPosition.x;
    } else if (_currTarget == 2) {
        _ball2Position.z = cosf(_baseRotation) * _targetPosition.x;
        _ball2Position.y = -sinf(_baseRotation) * _targetPosition.x;
    }
}

- (void)didSelectTarget:(GLint)target
{
    if (_isAnimating) {
        return;
    }

    if (_currTarget == target) {
        _currTarget = NO_TARGET;
    } else {
        _currTarget = target;
    }
}

- (GLint)currentTarget
{
    return _currTarget;
}

@end
