//
//  IKMainViewController.m
//  IKRoboticArm
//
//  Created by Dominik Grygiel on 01.12.2013.
//  Copyright (c) 2013 Dominik Grygiel. All rights reserved.
//

#import "IKMainViewController.h"
#import "IKCommons.h"
#import "IKShaderLoader.h"
#import "IKCylinder.h"
#import "IKScene.h"

#define MIN_CAMERA_SCALE 0.1f

@interface IKMainViewController () {
    GLuint _program;

    GLfloat _cameraScale;
    GLfloat _cameraRotationX;
    GLfloat _cameraRotationY;
}
@property (strong, nonatomic) EAGLContext *context;
@property (nonatomic, strong) IKCylinder *floor;

@property (nonatomic, strong) UIPinchGestureRecognizer *pinchRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;

@end


@implementation IKMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }

    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;

    [self setupGL];
    [self setupGestureRecognizers];

    self.floor = [[IKCylinder alloc] initWithRadius:10.0f height:0.1f stacks:60];
    [self.floor setPositionX:-2.0f y:0.0f z:0.0f];
    self.floor.diffuseColor = GLKVector4Make(0.0f, 0.2f, 0.3f, 1.0f);

    _scene = [[IKScene alloc] init];
}

- (void)dealloc
{
    [self tearDownGL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    if ([self isViewLoaded] && ([[self view] window] == nil)) {
        self.view = nil;

        [self tearDownGL];
    }

    // Dispose of any resources that can be recreated.
}

- (void)setupGL
{
    [EAGLContext setCurrentContext:self.context];

    [self loadShaders];

    glEnable(GL_DEPTH_TEST);
    glDisable(GL_DITHER);
    glDisable(GL_BLEND);
    glDisable(GL_STENCIL_TEST);

    _cameraScale = 0.2;
    _cameraRotationX = -M_PI_2;
    _cameraRotationY = -M_PI_2;
}

- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];

    [self.floor tearDownGL];
    [self.scene tearDownGL];

    if (_program) {
        glDeleteProgram(_program);
        _program = 0;
    }

    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
    self.context = nil;
}

#pragma mark - GLKView and GLKViewController delegate methods
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    float aspect = fabsf(self.view.bounds.size.width / self.view.bounds.size.height);
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 0.01f, 100.0f);

    GLKMatrix4 viewMatrix = GLKMatrix4MakeLookAt(1.0, 0.0, 0.0,
                                                 0.0f, 0.0f, 0.0f,
                                                 0.0f, 0.0f, 1.0f);
    viewMatrix = GLKMatrix4Scale(viewMatrix, _cameraScale, _cameraScale, _cameraScale);
    viewMatrix = GLKMatrix4Rotate(viewMatrix, _cameraRotationY, 0.0f, 1.0f, 0.0f);
    viewMatrix = GLKMatrix4Rotate(viewMatrix, _cameraRotationX, 1.0f, 0.0f, 0.0f);

    glUseProgram(_program);
    glUniform3fv(uniforms[UNIFORM_LIGHT0_POSITION], 1, GLKMatrix4MultiplyAndProjectVector3(viewMatrix, GLKVector3Make(100.0f, -100.0f, 0.0f)).v);
    glUniform3fv(uniforms[UNIFORM_LIGHT1_POSITION], 1, GLKMatrix4MultiplyAndProjectVector3(viewMatrix, GLKVector3Make(100.0f, 100.0f, 0.0f)).v);


    [self.scene executeWithP:&projectionMatrix V:&viewMatrix uniforms:uniforms];
    [self.floor executeWithP:&projectionMatrix V:&viewMatrix uniforms:uniforms];
}

#pragma mark - OpenGL ES 2 shader compilation
- (BOOL)loadShaders
{
    NSString *vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"vsh"];
    NSString *fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"fsh"];

    [[IKShaderLoader sharedLoader] loadShadersProgram:&_program vertexShader:vertShaderPathname fragmentShader:fragShaderPathname];

    // Get uniform locations.
    uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX] = glGetUniformLocation(_program, "modelViewProjectionMatrix");
    uniforms[UNIFORM_NORMAL_MATRIX] = glGetUniformLocation(_program, "normalMatrix");
    uniforms[UNIFORM_LIGHT0_POSITION] = glGetUniformLocation(_program, "light0Position");
    uniforms[UNIFORM_LIGHT1_POSITION] = glGetUniformLocation(_program, "light1Position");
    uniforms[UNIFORM_DIFFUSE_COLOR] = glGetUniformLocation(_program, "diffuseColor");

    return YES;
}

#pragma mark - Gesture recognizers
- (void)setupGestureRecognizers
{
    self.pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(didPinchView:)];
    [self.view addGestureRecognizer:self.pinchRecognizer];

    self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPanView:)];
    self.panRecognizer.minimumNumberOfTouches = 1;
    self.panRecognizer.maximumNumberOfTouches = 1;
    [self.view addGestureRecognizer:self.panRecognizer];
}

- (void)didPinchView:(UIPinchGestureRecognizer *)gesture
{
    _cameraScale += gesture.velocity / 170;

    if (_cameraScale < MIN_CAMERA_SCALE) {
        _cameraScale = MIN_CAMERA_SCALE;
    } else if (_cameraScale > 5.0f) {
        _cameraScale = 5.0f;
    }
}

- (void)didPanView:(UIPanGestureRecognizer *)gesture
{
    CGPoint velocity = [gesture velocityInView:self.view];
    _cameraRotationX += GLKMathDegreesToRadians(velocity.x / 80);
    _cameraRotationY += GLKMathDegreesToRadians(velocity.y / 80);

    if (_cameraRotationY < -M_PI_2) {
        _cameraRotationY = -M_PI_2;
    } else if (_cameraRotationY > 0) {
        _cameraRotationY = 0;
    }
}

@end
