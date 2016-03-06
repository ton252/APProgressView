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
@property(assign,nonatomic) IBInspectable BOOL showButtons;
@property(assign, nonatomic) IBInspectable BOOL disableDeselectedButtons;
@property(assign, nonatomic) BOOL generateBackgroundImagesAutomaticly;

@property(assign,nonatomic) IBInspectable NSUInteger sectionCount;
@property(assign,nonatomic) IBInspectable NSUInteger step;
@property(assign,nonatomic) NSUInteger lap;
@property(assign,nonatomic) IBInspectable float progress;

@property(assign,nonatomic) IBInspectable CGFloat circleBorderWidth; //Update
@property(assign,nonatomic) IBInspectable CGFloat progressBorderWidth;
@property(assign,nonatomic) IBInspectable CGFloat progressWidth;

@property(strong,nonatomic) IBInspectable UIColor *borderColor;  //Update
@property(strong,nonatomic) IBInspectable UIColor *progressColor;  //Update
@property(strong,nonatomic) IBInspectable UIColor *progressBackgroundColor;  //Update



@property(assign,nonatomic,readonly) float progressLength;

@property(weak,nonatomic) id<APProgressViewDelegate> delegate;

@end


@protocol APProgressViewDelegate<NSObject>

@optional
- (void)setupButton:(UIButton *) button atIndex:(NSUInteger) index;
- (void)buttonDidSelected:(UIButton *) button atIndex:(NSUInteger) index;

@end

