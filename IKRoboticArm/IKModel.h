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

    GLfloat _rotX;
    GLfloat _rotY;
    GLfloat _rotZ;

    GLfloat *_vertexData;
    GLuint _vertexDataSize;
    GLuint _vertexArray;
    GLuint _vertexBuffer;
}

@property (nonatomic) GLKVector4 diffuseColor;

- (void)setupGL;
- (void)tearDownGL;
- (BOOL)executeWithP:(const GLKMatrix4 *)projectionMatrix V:(const GLKMatrix4 *)viewMatrix uniforms:(const GLint *)uniforms;
- (BOOL)executeWithP:(const GLKMatrix4 *)projectionMatrix V:(const GLKMatrix4 *)viewMatrix M:(const GLKMatrix4 *)modelMatrix uniforms:(const GLint *)uniforms;
- (void)setPositionX:(GLfloat)x y:(GLfloat)y z:(GLfloat)z;
- (void)setRotationX:(GLfloat)x y:(GLfloat)y z:(GLfloat)z;

@end
