//
//  IKBone.m
//  IKRoboticArm
//
//  Created by Dominik Grygiel on 01.12.2013.
//  Copyright (c) 2013 Dominik Grygiel. All rights reserved.
//

#import "IKBone.h"
#import "IKCommons.h"

@interface IKBone () {
    GLfloat _width;
    GLfloat _height;
    GLfloat _depth;
    GLfloat _stacks;
}
@end


@implementation IKBone

- (id)initWithWidth:(GLfloat)width height:(GLfloat)height depth:(GLfloat)depth stacks:(GLint)stacks
{
    if ((self = [super init])) {
        _width = width;
        _height = height;
        _depth = depth;
        _stacks = stacks;

        [self createVertexData];
        [self setupGL];
    }

    return self;
}

- (void)createVertexData
{
    _vertexDataSize = 6 * 3 * (8 + 2 * _stacks * 4);
    _vertexData = [[NSMutableData dataWithLength:sizeof(GLfloat) * _vertexDataSize] mutableBytes];

    GLfloat cuboidHeight = _height;
    GLfloat cuboidWidth = _width - cuboidHeight;
    GLfloat halfCuboidHeight = cuboidHeight / 2;
    GLfloat halfCuboidDepth = _depth / 2;
    GLfloat halfCuboidWidth = cuboidWidth / 2;

    size_t GLfloatSize = sizeof(GLfloat) * 6;

    memcpy(&_vertexData[0], (GLfloat[6]){halfCuboidDepth, -halfCuboidHeight, -halfCuboidWidth, 1.0f, 0.0f, 0.0f}, GLfloatSize);
    memcpy(&_vertexData[6], (GLfloat[6]){halfCuboidDepth, halfCuboidHeight, -halfCuboidWidth, 1.0f, 0.0f, 0.0f}, GLfloatSize);
    memcpy(&_vertexData[12], (GLfloat[6]){halfCuboidDepth, -halfCuboidHeight, halfCuboidWidth, 1.0f, 0.0f, 0.0f}, GLfloatSize);
    memcpy(&_vertexData[18], (GLfloat[6]){halfCuboidDepth, -halfCuboidHeight, halfCuboidWidth, 1.0f, 0.0f, 0.0f}, GLfloatSize);
    memcpy(&_vertexData[24], (GLfloat[6]){halfCuboidDepth, halfCuboidHeight, -halfCuboidWidth, 1.0f, 0.0f, 0.0f}, GLfloatSize);
    memcpy(&_vertexData[30], (GLfloat[6]){halfCuboidDepth, halfCuboidHeight, halfCuboidWidth, 1.0f, 0.0f, 0.0f}, GLfloatSize);

    memcpy(&_vertexData[36], (GLfloat[6]){halfCuboidDepth, halfCuboidHeight, halfCuboidWidth, 0.0f, 1.0f, 0.0f}, GLfloatSize);
    memcpy(&_vertexData[42], (GLfloat[6]){-halfCuboidDepth, halfCuboidHeight, halfCuboidWidth, 0.0f, 1.0f, 0.0f}, GLfloatSize);
    memcpy(&_vertexData[48], (GLfloat[6]){halfCuboidDepth, halfCuboidHeight, -halfCuboidWidth, 0.0f, 1.0f, 0.0f}, GLfloatSize);
    memcpy(&_vertexData[54], (GLfloat[6]){halfCuboidDepth, halfCuboidHeight, -halfCuboidWidth, 0.0f, 1.0f, 0.0f}, GLfloatSize);
    memcpy(&_vertexData[60], (GLfloat[6]){-halfCuboidDepth, halfCuboidHeight, halfCuboidWidth, 0.0f, 1.0f, 0.0f}, GLfloatSize);
    memcpy(&_vertexData[66], (GLfloat[6]){-halfCuboidDepth, halfCuboidHeight, -halfCuboidWidth, 0.0f, 1.0f, 0.0f}, GLfloatSize);

    memcpy(&_vertexData[72], (GLfloat[6]){-halfCuboidDepth, halfCuboidHeight, -halfCuboidWidth, -1.0f, 0.0f, 0.0f}, GLfloatSize);
    memcpy(&_vertexData[78], (GLfloat[6]){-halfCuboidDepth, -halfCuboidHeight, -halfCuboidWidth, -1.0f, 0.0f, 0.0f}, GLfloatSize);
    memcpy(&_vertexData[84], (GLfloat[6]){-halfCuboidDepth, halfCuboidHeight, halfCuboidWidth, -1.0f, 0.0f, 0.0f}, GLfloatSize);
    memcpy(&_vertexData[90], (GLfloat[6]){-halfCuboidDepth, halfCuboidHeight, halfCuboidWidth, -1.0f, 0.0f, 0.0f}, GLfloatSize);
    memcpy(&_vertexData[96], (GLfloat[6]){-halfCuboidDepth, -halfCuboidHeight, -halfCuboidWidth, -1.0f, 0.0f, 0.0f}, GLfloatSize);
    memcpy(&_vertexData[102], (GLfloat[6]){-halfCuboidDepth, -halfCuboidHeight, halfCuboidWidth, -1.0f, 0.0f, 0.0f}, GLfloatSize);

    memcpy(&_vertexData[108], (GLfloat[6]){-halfCuboidDepth, -halfCuboidHeight, -halfCuboidWidth, 0.0f, -1.0f, 0.0f}, GLfloatSize);
    memcpy(&_vertexData[114], (GLfloat[6]){halfCuboidDepth, -halfCuboidHeight, -halfCuboidWidth, 0.0f, -1.0f, 0.0f}, GLfloatSize);
    memcpy(&_vertexData[120], (GLfloat[6]){-halfCuboidDepth, -halfCuboidHeight, halfCuboidWidth, 0.0f, -1.0f, 0.0f}, GLfloatSize);
    memcpy(&_vertexData[126], (GLfloat[6]){-halfCuboidDepth, -halfCuboidHeight, halfCuboidWidth, 0.0f, -1.0f, 0.0f}, GLfloatSize);
    memcpy(&_vertexData[132], (GLfloat[6]){halfCuboidDepth, -halfCuboidHeight, -halfCuboidWidth, 0.0f, -1.0f, 0.0f}, GLfloatSize);
    memcpy(&_vertexData[138], (GLfloat[6]){halfCuboidDepth, -halfCuboidHeight, halfCuboidWidth, 0.0f, -1.0f, 0.0f}, GLfloatSize);

    double step = M_PI / _stacks;
    int offset = 144;
    for (int i = 0; i < _stacks; i++) {
        int j = i * 12;
        memcpy(&_vertexData[offset + j * 6], (GLfloat[6]){halfCuboidDepth, cos(M_PI + i * step) * halfCuboidHeight, sin(M_PI + i * step) * -halfCuboidHeight + halfCuboidWidth, 1.0f, 0.0f, 0.0f}, GLfloatSize);
        j++;
        memcpy(&_vertexData[offset + j * 6], (GLfloat[6]){halfCuboidDepth, cos(M_PI + (i + 1) * step) * halfCuboidHeight, sin(M_PI + (i + 1) * step) * -halfCuboidHeight + halfCuboidWidth, 1.0f, 0.0f, 0.0f}, GLfloatSize);
        j++;
        memcpy(&_vertexData[offset + j * 6], (GLfloat[6]){halfCuboidDepth, 0.0f, halfCuboidWidth, 1.0f, 0.0f, 0.0f}, GLfloatSize);
        j++;

        memcpy(&_vertexData[offset + j * 6], (GLfloat[6]){halfCuboidDepth, cos(M_PI + i * step) * halfCuboidHeight, sin(M_PI + i * step) * -halfCuboidHeight + halfCuboidWidth, 0.0f, cos(M_PI + i * step), -sin(M_PI + i * step)}, GLfloatSize);
        j++;
        memcpy(&_vertexData[offset + j * 6], (GLfloat[6]){halfCuboidDepth, cos(M_PI + (i + 1) * step) * halfCuboidHeight, sin(M_PI + (i + 1) * step) * -halfCuboidHeight + halfCuboidWidth, 0.0f, cos(M_PI + (i + 1) * step), -sin(M_PI + (i + 1) * step)}, GLfloatSize);
        j++;
        memcpy(&_vertexData[offset + j * 6], (GLfloat[6]){-halfCuboidDepth, cos(M_PI + (i + 1) * step) * halfCuboidHeight, sin(M_PI + (i + 1) * step) * -halfCuboidHeight + halfCuboidWidth, 0.0f, cos(M_PI + (i + 1) * step), -sin(M_PI + (i + 1) * step)}, GLfloatSize);
        j++;


        memcpy(&_vertexData[offset + j * 6], (GLfloat[6]){-halfCuboidDepth, cos(M_PI + i * step) * halfCuboidHeight, sin(M_PI + i * step) * -halfCuboidHeight + halfCuboidWidth, -1.0f, 0.0f, 0.0f}, GLfloatSize);
        j++;
        memcpy(&_vertexData[offset + j * 6], (GLfloat[6]){-halfCuboidDepth, cos(M_PI + (i + 1) * step) * halfCuboidHeight, sin(M_PI + (i + 1) * step) * -halfCuboidHeight + halfCuboidWidth, -1.0f, 0.0f, 0.0f}, GLfloatSize);
        j++;
        memcpy(&_vertexData[offset + j * 6], (GLfloat[6]){-halfCuboidDepth, 0.0f, halfCuboidWidth, -1.0f, 0.0f, 0.0f}, GLfloatSize);
        j++;

        memcpy(&_vertexData[offset + j * 6], (GLfloat[6]){-halfCuboidDepth, cos(M_PI + i * step) * halfCuboidHeight, sin(M_PI + i * step) * -halfCuboidHeight + halfCuboidWidth, 0.0f, cos(M_PI + i * step), -sin(M_PI + i * step)}, GLfloatSize);
        j++;
        memcpy(&_vertexData[offset + j * 6], (GLfloat[6]){-halfCuboidDepth, cos(M_PI + (i + 1) * step) * halfCuboidHeight, sin(M_PI + (i + 1) * step) * -halfCuboidHeight + halfCuboidWidth, 0.0f, cos(M_PI + (i + 1) * step), -sin(M_PI + (i + 1) * step)}, GLfloatSize);
        j++;
        memcpy(&_vertexData[offset + j * 6], (GLfloat[6]){halfCuboidDepth, cos(M_PI + i * step) * halfCuboidHeight, sin(M_PI + i * step) * -halfCuboidHeight + halfCuboidWidth, 0.0f, cos(M_PI + i * step), -sin(M_PI + i * step)}, GLfloatSize);
        j++;
    }

    offset += 12 * 6 * _stacks;
    for (int i = 0; i < _stacks; i++) {
        int j = i * 12;
        memcpy(&_vertexData[offset + j * 6], (GLfloat[6]){halfCuboidDepth, cos(i * step) * halfCuboidHeight, sin(i * step) * -halfCuboidHeight - halfCuboidWidth, 1.0f, 0.0f, 0.0f}, GLfloatSize);
        j++;
        memcpy(&_vertexData[offset + j * 6], (GLfloat[6]){halfCuboidDepth, cos((i + 1) * step) * halfCuboidHeight, sin((i + 1) * step) * -halfCuboidHeight - halfCuboidWidth, 1.0f, 0.0f, 0.0f}, GLfloatSize);
        j++;
        memcpy(&_vertexData[offset + j * 6], (GLfloat[6]){halfCuboidDepth, 0.0f, -halfCuboidWidth, 1.0f, 0.0f, 0.0f}, GLfloatSize);
        j++;

        memcpy(&_vertexData[offset + j * 6], (GLfloat[6]){halfCuboidDepth, cos(i * step) * halfCuboidHeight, sin(i * step) * -halfCuboidHeight - halfCuboidWidth, 0.0f, cos(i * step), -sin(i * step)}, GLfloatSize);
        j++;
        memcpy(&_vertexData[offset + j * 6], (GLfloat[6]){halfCuboidDepth, cos((i + 1) * step) * halfCuboidHeight, sin((i + 1) * step) * -halfCuboidHeight - halfCuboidWidth, 0.0f, cos((i + 1) * step), -sin((i + 1) * step)}, GLfloatSize);
        j++;
        memcpy(&_vertexData[offset + j * 6], (GLfloat[6]){-halfCuboidDepth, cos((i + 1) * step) * halfCuboidHeight, sin((i + 1) * step) * -halfCuboidHeight - halfCuboidWidth, 0.0f, cos((i + 1) * step), -sin((i + 1) * step)}, GLfloatSize);
        j++;


        memcpy(&_vertexData[offset + j * 6], (GLfloat[6]){-halfCuboidDepth, cos(i * step) * halfCuboidHeight, sin(i * step) * -halfCuboidHeight - halfCuboidWidth, -1.0f, 0.0f, 0.0f}, GLfloatSize);
        j++;
        memcpy(&_vertexData[offset + j * 6], (GLfloat[6]){-halfCuboidDepth, cos((i + 1) * step) * halfCuboidHeight, sin((i + 1) * step) * -halfCuboidHeight - halfCuboidWidth, -1.0f, 0.0f, 0.0f}, GLfloatSize);
        j++;
        memcpy(&_vertexData[offset + j * 6], (GLfloat[6]){-halfCuboidDepth, 0.0f, -halfCuboidWidth, -1.0f, 0.0f, 0.0f}, GLfloatSize);
        j++;

        memcpy(&_vertexData[offset + j * 6], (GLfloat[6]){-halfCuboidDepth, cos(i * step) * halfCuboidHeight, sin(i * step) * -halfCuboidHeight - halfCuboidWidth, 0.0f, cos(i * step), -sin(i * step)}, GLfloatSize);
        j++;
        memcpy(&_vertexData[offset + j * 6], (GLfloat[6]){-halfCuboidDepth, cos((i + 1) * step) * halfCuboidHeight, sin((i + 1) * step) * -halfCuboidHeight - halfCuboidWidth, 0.0f, cos((i + 1) * step), -sin((i + 1) * step)}, GLfloatSize);
        j++;
        memcpy(&_vertexData[offset + j * 6], (GLfloat[6]){halfCuboidDepth, cos(i * step) * halfCuboidHeight, sin(i * step) * -halfCuboidHeight - halfCuboidWidth, 0.0f, cos(i * step), -sin(i * step)}, GLfloatSize);
        j++;
    }
}

@end
