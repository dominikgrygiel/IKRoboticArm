//
//  IKSphere.m
//  IKRoboticArm
//
//  Created by Dominik Grygiel on 01.12.2013.
//  Copyright (c) 2013 Dominik Grygiel. All rights reserved.
//

#import "IKSphere.h"
#import "IKCommons.h"

@interface IKSphere () {
    GLfloat _radius;
    GLfloat _stacks;
}
@end


@implementation IKSphere

- (id)initWithRadius:(GLfloat)radius stacks:(GLint)stacks
{
    if ((self = [super init])) {
        _radius = radius;
        _stacks = stacks;

        [self createVertexData];
        [self setupGL];
    }

    return self;
}

- (BOOL)executeWithP:(const GLKMatrix4 *)projectionMatrix V:(const GLKMatrix4 *)viewMatrix uniforms:(const GLint *)uniforms
{
    GLKMatrix4 modelMatrix = GLKMatrix4Identity;
    if (_rotX) modelMatrix = GLKMatrix4Rotate(modelMatrix, _rotX, 1.0f, 0.0f, 0.0f);
    if (_rotY) modelMatrix = GLKMatrix4Rotate(modelMatrix, _rotY, 0.0f, 1.0f, 0.0f);
    if (_rotZ) modelMatrix = GLKMatrix4Rotate(modelMatrix, _rotZ, 0.0f, 0.0f, 1.0f);
    modelMatrix = GLKMatrix4Translate(modelMatrix, _posX, _posY, _poxZ);
    GLKMatrix4 modelViewMatrix = GLKMatrix4Multiply(*viewMatrix, modelMatrix);

    GLKMatrix3 normalMatrix = GLKMatrix4GetMatrix3(modelViewMatrix);
    GLKMatrix4 modelViewProjectionMatrix = GLKMatrix4Multiply(*projectionMatrix, modelViewMatrix);

    glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, modelViewProjectionMatrix.m);
    glUniformMatrix3fv(uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, normalMatrix.m);
    glUniform4fv(uniforms[UNIFORM_DIFFUSE_COLOR], 1, self.diffuseColor.v);

    glBindVertexArrayOES(_vertexArray);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, _vertexDataSize / 6);

    return YES;
}

- (BOOL)executeWithP:(const GLKMatrix4 *)projectionMatrix V:(const GLKMatrix4 *)viewMatrix M:(const GLKMatrix4 *)modelMatrix uniforms:(const GLint *)uniforms
{
    GLKMatrix4 modelViewMatrix = GLKMatrix4Multiply(*viewMatrix, *modelMatrix);

    GLKMatrix3 normalMatrix = GLKMatrix4GetMatrix3(modelViewMatrix);
    GLKMatrix4 modelViewProjectionMatrix = GLKMatrix4Multiply(*projectionMatrix, modelViewMatrix);

    glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, modelViewProjectionMatrix.m);
    glUniformMatrix3fv(uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, normalMatrix.m);
    glUniform4fv(uniforms[UNIFORM_DIFFUSE_COLOR], 1, self.diffuseColor.v);

    glBindVertexArrayOES(_vertexArray);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, _vertexDataSize / 6);

    return YES;
}

- (void)createVertexData
{
    _vertexDataSize = 6 * 2 * _stacks * _stacks;
    GLfloat *vd =_vertexData = [[NSMutableData dataWithLength:sizeof(GLfloat) * _vertexDataSize] mutableBytes];

    for(int phiIdx = 0; phiIdx < _stacks; phiIdx++)
    {
        float phi0 = M_PI * ((float)(phiIdx+0) * (1.0/(float)(_stacks)) - 0.5);
        float phi1 = M_PI * ((float)(phiIdx+1) * (1.0/(float)(_stacks)) - 0.5);

        float cosPhi0 = cos(phi0);
        float sinPhi0 = sin(phi0);
        float cosPhi1 = cos(phi1);
        float sinPhi1 = sin(phi1);

        float cosTheta, sinTheta;

        for(int thetaIdx = 0; thetaIdx < _stacks; thetaIdx++)
        {
            float theta = 2.0*M_PI * ((float)thetaIdx) * (1.0/(float)(_stacks-1));
            cosTheta = cos(theta);
            sinTheta = sin(theta);

            vd[0] = _radius * cosPhi0 * cosTheta;
            vd[1] = _radius * sinPhi0;
            vd[2] = _radius * cosPhi0 * sinTheta;
            vd[3] = cosPhi0 * cosTheta; 	//2
            vd[4] = sinPhi0;
            vd[5] = cosPhi0 * sinTheta;


            vd[6] = _radius * cosPhi1 * cosTheta;
            vd[7] = _radius * sinPhi1;
            vd[8] = _radius * cosPhi1 * sinTheta;
            vd[9] = cosPhi1 * cosTheta; 	//3
            vd[10] = sinPhi1;
            vd[11] = cosPhi1 * sinTheta;

            vd += 12;
        }
    }
}

@end
