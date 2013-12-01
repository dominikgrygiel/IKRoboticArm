//
//  IKShaderLoader.h
//  IKRoboticArm
//
//  Created by Dominik Grygiel on 01.12.2013.
//  Copyright (c) 2013 Dominik Grygiel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IKShaderLoader : NSObject

+ (id)sharedLoader;
- (BOOL)loadShadersProgram:(GLuint *)program vertexShader:(NSString *)vertShaderPathname fragmentShader:(NSString *)fragShaderPathname;

@end
