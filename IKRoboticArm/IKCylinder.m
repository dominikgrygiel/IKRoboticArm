//
//  IKCylinder.m
//  IKRoboticArm
//
//  Created by Dominik Grygiel on 01.12.2013.
//  Copyright (c) 2013 Dominik Grygiel. All rights reserved.
//

#import "IKCylinder.h"
#import "IKCommons.h"

@interface IKCylinder () {
    GLfloat _radius;
    GLfloat _height;
    GLfloat _stacks;

    GLfloat *_vertexData;
    GLuint _vertexDataSize;
    GLuint _vertexArray;
    GLuint _vertexBuffer;
}
@end


@implementation IKCylinder

- (id)initWithRadius:(GLfloat)radius height:(GLfloat)height stacks:(GLint)stacks
{
    if ((self = [super init])) {
        _radius = radius;
        _height = height;
        _stacks = stacks;

        [self createVertexData];
        [self setupGL];
    }

    return self;
}

- (void)setupGL
{
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
    GLKMatrix4 modelViewMatrix = GLKMatrix4Multiply(*viewMatrix, modelMatrix);

    GLKMatrix3 normalMatrix = GLKMatrix4GetMatrix3(modelViewMatrix);
    GLKMatrix4 modelViewProjectionMatrix = GLKMatrix4Multiply(*projectionMatrix, modelViewMatrix);

    glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, modelViewProjectionMatrix.m);
    glUniformMatrix3fv(uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, normalMatrix.m);

    glBindVertexArrayOES(_vertexArray);
    glDrawArrays(GL_TRIANGLES, 0, _vertexDataSize / 6);

    return YES;
}

- (void)createVertexData
{
    _vertexDataSize = 6 * 3 * _stacks * 4;
    _vertexData = [[NSMutableData dataWithLength:sizeof(GLfloat) * _vertexDataSize] mutableBytes];

    double halfHeight = _height / 2;
    size_t GLfloatSize = 6 * sizeof(GLfloat);

    double step = 2 * M_PI / _stacks;
    for (int i = 0; i < _stacks; i++) {
        int j = i * 12;
        memcpy(&_vertexData[j * 6], (GLfloat[6]){halfHeight, cos(i * step) * _radius, sin(i * step) * -_radius, 1.0f, 0.0f, 0.0f}, GLfloatSize);
        j++;
        memcpy(&_vertexData[j * 6], (GLfloat[6]){halfHeight, cos((i + 1) * step) * _radius, sin((i + 1) * step) * -_radius, 1.0f, 0.0f, 0.0f}, GLfloatSize);
        j++;
        memcpy(&_vertexData[j * 6], (GLfloat[6]){halfHeight, 0.0f, 0.0, 1.0f, 0.0f, 0.0f}, GLfloatSize);
        j++;

        memcpy(&_vertexData[j * 6], (GLfloat[6]){halfHeight, cos(i * step) * _radius, sin(i * step) * -_radius, 0.0f, cos(i * step), -sin(i * step)}, GLfloatSize);
        j++;
        memcpy(&_vertexData[j * 6], (GLfloat[6]){halfHeight, cos((i + 1) * step) * _radius, sin((i + 1) * step) * -_radius, 0.0f, cos((i + 1) * step), -sin((i + 1) * step)}, GLfloatSize);
        j++;
        memcpy(&_vertexData[j * 6], (GLfloat[6]){-halfHeight, cos((i + 1) * step) * _radius, sin((i + 1) * step) * -_radius, 0.0f, cos((i + 1) * step), -sin((i + 1) * step)}, GLfloatSize);
        j++;


        memcpy(&_vertexData[j * 6], (GLfloat[6]){-halfHeight, cos(i * step) * _radius, sin(i * step) * -_radius, -1.0f, 0.0f, 0.0f}, GLfloatSize);
        j++;
        memcpy(&_vertexData[j * 6], (GLfloat[6]){-halfHeight, cos((i + 1) * step) * _radius, sin((i + 1) * step) * -_radius, -1.0f, 0.0f, 0.0f}, GLfloatSize);
        j++;
        memcpy(&_vertexData[j * 6], (GLfloat[6]){-halfHeight, 0.0f, 0.0, -1.0f, 0.0f, 0.0f}, GLfloatSize);
        j++;

        memcpy(&_vertexData[j * 6], (GLfloat[6]){-halfHeight, cos(i * step) * _radius, sin(i * step) * -_radius, 0.0f, cos(i * step), -sin(i * step)}, GLfloatSize);
        j++;
        memcpy(&_vertexData[j * 6], (GLfloat[6]){-halfHeight, cos((i + 1) * step) * _radius, sin((i + 1) * step) * -_radius, 0.0f, cos((i + 1) * step), -sin((i + 1) * step)}, GLfloatSize);
        j++;
        memcpy(&_vertexData[j * 6], (GLfloat[6]){halfHeight, cos(i * step) * _radius, sin(i * step) * -_radius, 0.0f, cos(i * step), -sin(i * step)}, GLfloatSize);
        j++;
    }
}

@end
