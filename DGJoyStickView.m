//
//  DGJoyStickView.m
//  IKRoboticArm
//
//  Created by Dominik Grygiel on 17.12.2013.
//  Based on code by Zhang Xiang (https://github.com/pyzhangxiang/joystick-ios)
//

#import "DGJoyStickView.h"

#define STICK_CENTER_TARGET_POS_LEN 20.0f

@interface DGJoyStickView () {
    CGPoint _mCenter;
}

@property (nonatomic, strong) UIImageView *stickViewBase;
@property (nonatomic, strong) UIImageView *stickView;

@property (nonatomic, strong) UIImage *imgStickNormal;
@property (nonatomic, strong) UIImage *imgStickHold;

@end


@implementation DGJoyStickView

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.imgStickNormal = [UIImage imageNamed:@"stick_normal.png"];
        self.imgStickHold = [UIImage imageNamed:@"stick_hold.png"];

        self.stickViewBase = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"stick_base.png"]];
        self.stickViewBase.frame = self.bounds;
        [self addSubview:self.stickViewBase];

        self.stickView = [[UIImageView alloc] initWithImage:self.imgStickNormal];
        self.stickView.frame = self.bounds;
        [self addSubview:self.stickView];

        _mCenter.x = 64;
        _mCenter.y = 64;
    }
    return self;
}

- (void)notifyDir:(CGPoint)dir
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(stickDidChangePositionTo:)]) {
        [self.delegate stickDidChangePositionTo:dir];
    } else {
        _currentPosition = dir;
    }
}

- (void)stickMoveTo:(CGPoint)deltaToCenter
{
    CGRect fr = self.stickView.frame;
    fr.origin.x = deltaToCenter.x;
    fr.origin.y = deltaToCenter.y;
    self.stickView.frame = fr;
}

- (void)touchEvent:(NSSet *)touches
{
    if([touches count] != 1)
        return;

    UITouch *touch = [touches anyObject];
    UIView *view = [touch view];
    if(view != self)
        return;

    CGPoint touchPoint = [touch locationInView:view];
    CGPoint dtarget, dir;
    dir.x = touchPoint.x - _mCenter.x;
    dir.y = touchPoint.y - _mCenter.y;
    double len = sqrt(dir.x * dir.x + dir.y * dir.y);

    if(len < 10.0 && len > -10.0) {
        // center pos
        dtarget.x = 0.0;
        dtarget.y = 0.0;
        dir.x = 0;
        dir.y = 0;
    } else {
        double len_inv = (1.0 / len);
        dir.x *= len_inv;
        dir.y *= len_inv;
        dtarget.x = dir.x * STICK_CENTER_TARGET_POS_LEN;
        dtarget.y = dir.y * STICK_CENTER_TARGET_POS_LEN;
    }
    [self stickMoveTo:dtarget];
    [self notifyDir:dir];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.stickView.image = self.imgStickHold;
    [self touchEvent:touches];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchEvent:touches];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.stickView.image = self.imgStickNormal;
    CGPoint dtarget, dir;
    dir.x = dtarget.x = 0.0;
    dir.y = dtarget.y = 0.0;
    [self stickMoveTo:dtarget];

    [self notifyDir:dir];
}

@end
