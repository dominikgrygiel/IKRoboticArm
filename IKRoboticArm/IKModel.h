//
//  IKModel.h
//  IKRoboticArm
//
//  Created by Dominik Grygiel on 01.12.2013.
//  Copyright (c) 2013 Dominik Grygiel. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface IKModel : NSObject {
    GLfloat _posX;
    GLfloat _posY;
    GLfloat _poxZ;

    GLfloat *_vertexData;
    GLuint _vertexDataSize;
    GLuint _vertexArray;
    GLuint _vertexBuffer;
}

- (void)setupGL;
- (void)tearDownGL;
- (BOOL)executeWithP:(const GLKMatrix4 *)projectionMatrix V:(const GLKMatrix4 *)viewMatrix uniforms:(const GLint *)uniforms;
- (void)setPositionX:(GLfloat)x y:(GLfloat)y z:(GLfloat)z;

@end
