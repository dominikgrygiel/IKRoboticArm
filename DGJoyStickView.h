//
//  DGJoyStickView.h
//  IKRoboticArm
//
//  Created by Dominik Grygiel on 17.12.2013.
//  Copyright (c) 2013 Dominik Grygiel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DGJoyStickViewDelegate <NSObject>
@optional
- (void)stickDidChangePositionTo:(CGPoint)position;

@end


@interface DGJoyStickView : UIView

@property (nonatomic, assign) id<DGJoyStickViewDelegate> delegate;
@property (nonatomic, readonly) CGPoint currentPosition;

@end
