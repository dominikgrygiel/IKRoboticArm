//
//  IKModel.m
//  IKRoboticArm
//
//  Created by Dominik Grygiel on 01.12.2013.
//  Copyright (c) 2013 Dominik Grygiel. All rights reserved.
//

#import "IKModel.h"
#import "IKCommons.h"

@implementation IKModel

- (void)setupGL
{
    self.diffuseColor = GLKVector4Make(0.4, 0.4, 1.0, 1.0);

    glGenVertexArraysOES(1, &_vertexArray);
    glBindVertexArrayOES(_vertexArray);

    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat) * _vertexDataSize, _vertexData, GL_STATIC_DRAW);

    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 24, BUFFER_OFFSET(0));
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 24, BUFFER_OFFSET(12));

    glBindVertexArrayOES(0);
}

- (void)tearDownGL
{
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteVertexArraysOES(1, &_vertexArray);
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
    glDrawArrays(GL_TRIANGLES, 0, _vertexDataSize / 6);
    
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
    glDrawArrays(GL_TRIANGLES, 0, _vertexDataSize / 6);

    return YES;
}

- (void)setPositionX:(GLfloat)x y:(GLfloat)y z:(GLfloat)z
{
    _posX = x;
    _posY = y;
    _poxZ = z;
}

- (void)setRotationX:(GLfloat)x y:(GLfloat)y z:(GLfloat)z
{
    _rotX = x;
    _rotY = y;
    _rotZ = z;
}

@end
