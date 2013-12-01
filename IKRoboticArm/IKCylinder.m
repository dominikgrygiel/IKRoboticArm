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
