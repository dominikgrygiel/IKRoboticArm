//
//  Shader.vsh
//  IKRoboticArm
//
//  Created by Dominik Grygiel on 01.12.2013.
//  Copyright (c) 2013 Dominik Grygiel. All rights reserved.
//

attribute vec4 position;
attribute vec3 normal;

varying lowp vec4 colorVarying;

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;
uniform vec3 light0Position;
uniform vec3 light1Position;
uniform vec4 diffuseColor;

void main()
{
    vec3 eyeNormal = normalize(normalMatrix * normal);

    float nDotVP0 = max(0.15, dot(eyeNormal, normalize(light0Position)));
    float nDotVP1 = max(0.15, dot(eyeNormal, normalize(light1Position)));

    colorVarying = diffuseColor * nDotVP0 + diffuseColor * nDotVP1;

    gl_Position = modelViewProjectionMatrix * position;
}
