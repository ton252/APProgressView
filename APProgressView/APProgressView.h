//
//  APProgressView.h
//  APProgressView
//
//  Created by ton252 on 29.02.16.
//  Copyright © 2016 ton252. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol APProgressViewDelegate;

IB_DESIGNABLE
@interface APProgressView : UIView

@property(assign,nonatomic,getter=isActive) IBInspectable BOOL active;
@property(assign,nonatomic) IBInspectable NSUInteger sectionCount;
@property(assign,nonatomic) IBInspectable BOOL enableStepCounting;
@property(assign,nonatomic) IBInspectable NSUInteger step;
@property(assign,nonatomic) NSUInteger lap;
@property(assign,nonatomic) IBInspectable float progress;
@property(assign,nonatomic) IBInspectable BOOL enableButtons;


@property(assign,nonatomic) IBInspectable CGFloat circleBorderWidth;
@property(assign,nonatomic) IBInspectable CGFloat progressBorderWidth;
@property(assign,nonatomic) IBInspectable CGFloat progressWidth;

@property(strong,nonatomic) IBInspectable UIColor *borderColor;
@property(strong,nonatomic) IBInspectable UIColor *progressColor;
@property(strong,nonatomic) IBInspectable UIColor *progressBackgroundColor;

@property(assign,nonatomic,readonly) float progressLength;

@property(weak,nonatomic) id<APProgressViewDelegate> delegate;

@end


@protocol APProgressViewDelegate<NSObject>

@required
- (UIButton *)setupButtonAtIndex:(NSUInteger) index;

@optional
- (BOOL)generateImagesAutomaticly;


@end

