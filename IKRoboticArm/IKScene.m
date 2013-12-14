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

const GLfloat kArmOffset = -2.0f;

@interface IKScene () {
    GLfloat _currY;
}

@property (nonatomic, strong) IKArm *arm;
@property (nonatomic, strong) IKSphere *ball0;
@end

@implementation IKScene

- (id)init {
    if ((self = [super init])) {
        self.arm = [[IKArm alloc] init];
        [self.arm setPositionX:kArmOffset y:0.0f z:0.0f];

        CGFloat kBallRadius = [IKArm ballRadius];
        _currY = kBallRadius + 0.1f;
        self.ball0 = [[IKSphere alloc] initWithRadius:kBallRadius stacks:60];
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
    if (_currY < 3.0f) {
        _currY += 0.02;
    }

    [self.ball0 setPositionX:_currY + kArmOffset y:0.0f z:6.0f - _currY];
    [self.ball0 executeWithP:projectionMatrix V:viewMatrix uniforms:uniforms];

        self.arm.target = GLKVector2Make(6.0 - _currY, _currY);
    [self.arm executeWithP:projectionMatrix V:viewMatrix uniforms:uniforms];

    return YES;
}

@end
