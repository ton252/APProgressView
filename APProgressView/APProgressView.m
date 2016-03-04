//
//  APProgressView.m
//  APProgressView
//
//  Created by ton252 on 29.02.16.
//  Copyright © 2016 ton252. All rights reserved.
//

#import "APProgressView.h"


@interface APProgressView()

@property(assign,nonatomic) float progressLength;

@property(strong, nonatomic) UIBezierPath *externalPath;
@property(strong, nonatomic) UIBezierPath *internalPath;

@property(strong, nonatomic) NSArray<NSValue*> *externalCircles;
@property(strong, nonatomic) NSArray<NSValue*> *internalCircles;

@property(strong, nonatomic) UIImage *buttonImageHighLight;
@property(strong, nonatomic) UIImage *buttonImageNormal;
@property(strong, nonatomic) NSMutableArray *buttonsArray;

@property(strong, nonatomic) UIView *buttonsLayer;

@end

@implementation APProgressView

#pragma mark Initialization

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self initialization];
        [self defaultSettings];
        
    }
    
    return self;
    
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self initialization];
        [self defaultSettings];
    }
    
    return self;
    
}


- (void)initialization{
    
    NSLog(@"initialization");
    self.buttonsLayer = [[UIView alloc] initWithFrame:self.bounds];
    self.buttonsLayer.backgroundColor = [UIColor clearColor];
    [self addSubview:self.buttonsLayer];
    
//    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
//    layer.frame = CGRectMake(0, 0, 110, 110);
//    layer.backgroundColor = [UIColor blackColor].CGColor;
//    [self.layer addSublayer:layer];
    
}

#pragma mark Default settings

- (void)defaultSettings{
    
    NSLog(@"defaultSettings");
    
    self.sectionCount = 5;
    self.progressWidth = 4.f;
    self.progressBorderWidth = 2.f;
    self.circleBorderWidth = 2.f;
    
    self.enableButtons = YES;
    
    self.backgroundColor =[UIColor clearColor];
    self.progressBackgroundColor = [UIColor whiteColor];
    self.progressColor = [UIColor redColor];
    self.borderColor = [UIColor grayColor];
    
}

#pragma mark Setters

- (void)setProgress:(float)progress{
    _progress = progress;
    [self setNeedsDisplay];
}

- (void)setStep:(NSUInteger)step{
    _step = step;
    [self setNeedsDisplay];
}

- (void)setSectionCount:(NSUInteger)sectionCount{
   
    _sectionCount = sectionCount;
    if (_enableButtons) {
        [self removeAllButtons];
        [self createButtons];
    }
    [self setNeedsDisplay];
}

-(void)setEnableButtons:(BOOL)enableButtons{

    _enableButtons = enableButtons;
    
    if (!_enableButtons) {
        [self removeAllButtons];
        [self createButtons];
    }
    
    [self setNeedsDisplay];
    
}

- (void)setEnableStepCounting:(BOOL)enableStepCounting{
    
    _enableStepCounting = enableStepCounting;
    [self setNeedsDisplay];
    
}

- (void)setActive:(BOOL)active{
    
    _active = active;
    [self setNeedsDisplay];
    
}

- (void)setLap:(NSUInteger)lap{
    
    _lap = lap;
    self.progress = 0.f;
    self.step = 0;
}

-(void)checkValues{
    
    if (self.progress < 0.f) {
        self.progress = 0.f;
    }else if(self.progress > 1.f){
        self.progress = 1.f;
    }
    
    self.sectionCount = MAX(self.sectionCount,0);
    
}

#pragma mark Buttons settings

-(void)createButtons{
    
        self.buttonsArray = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < self.sectionCount; i++) {
            UIButton *button;
            if (self.delegate) {
                button = [self.delegate setupButtonAtIndex:i];
            }else{
                button = [UIButton buttonWithType:UIButtonTypeCustom];
                NSString *buttonName = [NSString stringWithFormat:@"%d",i+1];
                [button setTitle:buttonName forState:UIControlStateNormal];
                [button setTitle:buttonName forState:UIControlStateHighlighted];
                button.tag = i;
            }
            
            [self addSubview:button];
            [self.buttonsArray addObject:button];
        }
    
}

- (void)removeAllButtons{
    
    for (UIButton *button in self.buttonsArray) {
        [button removeFromSuperview];
    }
    
}

- (void)setupImagesToButton:(UIButton *) button atIndex:(NSUInteger) index{
    
    if (self.enableStepCounting) {
        if (index <= self.step && self.isActive) {
            NSString *titleNormal = [button titleForState:UIControlStateNormal];
            NSString *titleHighlighted = [button titleForState:UIControlStateHighlighted];
            [button setTitle:titleNormal forState:UIControlStateHighlighted];
            [button setTitle:titleHighlighted forState:UIControlStateNormal];
            [button setBackgroundImage:self.buttonImageNormal forState:UIControlStateHighlighted];
            [button setBackgroundImage:self.buttonImageHighLight forState:UIControlStateNormal];
            [button setTitleColor:self.borderColor forState:UIControlStateHighlighted];
            [button setTitleColor:self.progressBackgroundColor forState:UIControlStateNormal];
        }else {
            NSString *titleNormal = [button titleForState:UIControlStateNormal];
            NSString *titleHighlighted = [button titleForState:UIControlStateHighlighted];
            [button setTitle:titleNormal forState:UIControlStateNormal];
            [button setTitle:titleHighlighted forState:UIControlStateHighlighted];
            [button setBackgroundImage:self.buttonImageNormal forState:UIControlStateNormal];
            [button setBackgroundImage:self.buttonImageHighLight forState:UIControlStateHighlighted];
            [button setTitleColor:self.borderColor forState:UIControlStateNormal];
            [button setTitleColor:self.progressBackgroundColor forState:UIControlStateHighlighted];
        }
    }else{
        CGFloat positionX = button.frame.origin.x;
        if (positionX >= self.progressLength || !self.isActive) {
            NSString *titleNormal = [button titleForState:UIControlStateNormal];
            NSString *titleHighlighted = [button titleForState:UIControlStateHighlighted];
            [button setTitle:titleNormal forState:UIControlStateNormal];
            [button setTitle:titleHighlighted forState:UIControlStateHighlighted];
            [button setBackgroundImage:self.buttonImageNormal forState:UIControlStateNormal];
            [button setBackgroundImage:self.buttonImageHighLight forState:UIControlStateHighlighted];
            [button setTitleColor:self.borderColor forState:UIControlStateNormal];
            [button setTitleColor:self.progressBackgroundColor forState:UIControlStateHighlighted];
        }else{
            
            NSString *titleNormal = [button titleForState:UIControlStateNormal];
            NSString *titleHighlighted = [button titleForState:UIControlStateHighlighted];
            [button setTitle:titleNormal forState:UIControlStateHighlighted];
            [button setTitle:titleHighlighted forState:UIControlStateNormal];
            [button setBackgroundImage:self.buttonImageNormal forState:UIControlStateHighlighted];
            [button setBackgroundImage:self.buttonImageHighLight forState:UIControlStateNormal];
            [button setTitleColor:self.borderColor forState:UIControlStateHighlighted];
            [button setTitleColor:self.progressBackgroundColor forState:UIControlStateNormal];
        }
    }

}


-(void)reverseButton:(UIButton *) button{
    
//    if (button.selected == YES) {
//        <#statements#>
//    }
    NSString *titleNormal = [button titleForState:UIControlStateNormal];
    NSString *titleHighlighted = [button titleForState:UIControlStateHighlighted];
    
    UIImage *imageNormal = [button imageForState:UIControlStateNormal];
    UIImage *imageHighlighted = [button imageForState:UIControlStateHighlighted];
    
    UIColor *colorNormal = [button titleColorForState:UIControlStateNormal];
    UIColor *colorHighlighted = [button titleColorForState:UIControlStateHighlighted];
    
    [button setTitle:titleNormal forState:UIControlStateHighlighted];
    [button setTitle:titleHighlighted forState:UIControlStateNormal];
    [button setBackgroundImage:imageNormal forState:UIControlStateHighlighted];
    [button setBackgroundImage:imageHighlighted forState:UIControlStateNormal];
    [button setTitleColor:colorNormal forState:UIControlStateHighlighted];
    [button setTitleColor:colorHighlighted forState:UIControlStateNormal];
    
}


-(void)setupButtons{
    
    for (int i = 0; i < self.buttonsArray.count; i++) {
        UIButton *button = self.buttonsArray[i];
        CGRect buttonRect = self.externalCircles[i].CGRectValue;
        button.frame = buttonRect;
        [self setupImagesToButton:button atIndex:i];
    }
}


#pragma mark Drawing

-(void)drawRect:(CGRect)rect{
    //NSLog(@"Draw");
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextBeginTransparencyLayer(context, NULL);
    
    //Cheking values
    [self checkValues];
    
    //Creating conturs
    [self createConturs:rect];
    
    //Creating images for buttons
    if (self.enableButtons && self.sectionCount != 0) {
        BOOL autoGenerateImages = YES;
        if ([self.delegate respondsToSelector:@selector(generateImagesAutomaticly)]) {
            autoGenerateImages = [self.delegate generateImagesAutomaticly];
        }
        if (autoGenerateImages) {
            [self createButtonImages];
        }

        [self setupButtons];
    }
    
    //Filling conturs
    [self.externalPath addClip];
    [self.borderColor setFill];
    [self.externalPath fill];
    
    //Filling background progress
    [self.progressBackgroundColor setFill];
    [self.internalPath fill];
    
    //Filling progress line
    if (self.isActive) {
        [self progressFill:rect];
    }

    CGContextEndTransparencyLayer(context);
    CGContextRestoreGState(context);
    
}

- (void)createConturs:(CGRect)rect{
    
    UIBezierPath *externalPath = [UIBezierPath bezierPath];
    UIBezierPath *internalPath = [UIBezierPath bezierPath];
    NSMutableArray *externalCircles = [[NSMutableArray alloc] init];
    NSMutableArray *internalCircles = [[NSMutableArray alloc] init];
    
    CGRect rectangleExteranl = CGRectPosition(self.progressWidth, self.sectionCount,rect);
    CGRect rectangleInternal = CGReduceRect(rectangleExteranl,self.progressBorderWidth);
    
    UIBezierPath *rectangleExternalPath = [UIBezierPath bezierPathWithRect:rectangleExteranl];
    UIBezierPath *rectangleInternalPath = [UIBezierPath bezierPathWithRect:rectangleInternal];
    
    [externalPath appendPath:rectangleExternalPath];
    [internalPath appendPath:rectangleInternalPath];
    
    for (int i = 0; i < self.sectionCount; i++) {
        CGRect circleExternalRect =  CGCirclesPosition(i+1,  self.sectionCount, self.progressWidth, rect);
        CGRect circleInternalRect = CGReduceRect(circleExternalRect,self.circleBorderWidth);
        
        //UIBezierPath* circleExternalPath = [UIBezierPath bezierPathWithOvalInRect:circleExternalRect];
        UIBezierPath* circleInternalPath = [UIBezierPath bezierPathWithOvalInRect:circleInternalRect];
        
        [externalCircles addObject: [NSValue valueWithCGRect:circleExternalRect]];
        [internalCircles addObject: [NSValue valueWithCGRect:circleInternalRect]];
        
        //------------------
        CGRect circleOffset = CGReduceRect(circleExternalRect,0.3f);
        UIBezierPath *circleOffsetPath = [UIBezierPath bezierPathWithOvalInRect:circleOffset];
        [externalPath appendPath:circleOffsetPath];
        //------------------
        
        //[externalPath appendPath:circleExternalPath];
        [internalPath appendPath:circleInternalPath];
    }
    
    self.externalPath = externalPath;
    self.internalPath = internalPath;
    
    self.externalCircles = [NSArray arrayWithArray:externalCircles];
    self.internalCircles = [NSArray arrayWithArray:internalCircles];
}

-(void)progressFill:(CGRect) rect{
    
    if (self.enableStepCounting && self.sectionCount != 0) {
        
        CGFloat sectionCount = self.sectionCount;
        CGFloat diameter = rect.size.height;
        CGFloat stepLenght = (rect.size.width - diameter*sectionCount)/(sectionCount-1);
        
        if (self.step == 0){
             self.progressLength =  diameter + self.progress*stepLenght;
        }else if (self.step > 0 && self.step < sectionCount-1){
            self.progressLength = diameter*(self.step+1) + stepLenght*self.step + self.progress*stepLenght;
        }else{
            self.progressLength =rect.size.width;
        }
        
    }else{
        
        self.progressLength = self.progress * rect.size.width;
       
    }
    
    CGRect progressRect = CGRectMake(rect.origin.x, rect.origin.x, self.progressLength, rect.size.height);
    UIBezierPath *progressPath = [UIBezierPath bezierPathWithRect:progressRect];
    [self.progressColor setFill];
    [progressPath fill];
    
}

- (void)createButtonImages{
    NSLog(@"Create image");
    
        if (self.externalCircles && self.internalCircles) {
            
            CGRect rectExternal = [self.externalCircles[0] CGRectValue];
            CGRect rectInternal = [self.internalCircles[0] CGRectValue];
            
            UIBezierPath* circleExternalPath = [UIBezierPath bezierPathWithOvalInRect:rectExternal];
            UIBezierPath* circleInternalPath = [UIBezierPath bezierPathWithOvalInRect:rectInternal];
            
            //UIControlStateHighlighted image
            UIGraphicsBeginImageContextWithOptions(rectExternal.size, NO, 3.0);
            [self.progressColor setFill];
            [circleExternalPath fill];
            UIImage *imageHighlighted  = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            //UIControlStateNormal image
            UIGraphicsBeginImageContextWithOptions(rectExternal.size, NO, 3.0);
            [self.borderColor setFill];
            [circleExternalPath fill];
            [self.progressBackgroundColor setFill];
            [circleInternalPath fill];
            UIImage *imageNormal= UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            
            self.buttonImageNormal = imageNormal;
            self.buttonImageHighLight =imageHighlighted;
            
        }
    
}


CGRect CGCirclesPosition(NSUInteger number, NSUInteger totalCount, CGFloat lineWidth, CGRect frame){
    
    CGFloat radius = frame.size.height/2.f;
    CGPoint center = CGPointZero;
    CGPoint startPoint = CGPointZero;
    
    if (number == 1) {
        center = CGPointMake(radius,radius);
    }else if (number == totalCount){
        center = CGPointMake(frame.size.width - radius, radius);
    }else if (number > 0 && number < totalCount + 1){
        CGFloat step = (frame.size.width - 2.f*radius)/(totalCount - 1.f);
        center = CGPointMake(step * (number - 1.f) + radius, radius);
    }
    
    startPoint = CGPointMake(center.x - radius, center.y - radius);
    
    CGRect rect = CGRectMake(startPoint.x, startPoint.y, frame.size.height, frame.size.height);
    
    return rect;
}


CGRect CGRectPosition(CGFloat lineWidth, NSUInteger totalCount, CGRect frame){
    
    CGPoint startPoint = CGPointZero;
    startPoint = CGPointMake(frame.size.height/2.f, 0.5f*(frame.size.height - lineWidth));
    CGFloat width = frame.size.width - frame.size.height;
    CGRect rect = CGRectMake(startPoint.x, startPoint.y, width, lineWidth);
    
    if (totalCount == 0) {
        return CGRectMake(0, startPoint.y, frame.size.width, lineWidth);
    }
    
    if (totalCount == 1) {
        width = frame.size.width - frame.size.height/2;
        return CGRectMake(startPoint.x, startPoint.y, width, lineWidth);
    }
    
    return rect;
}


CGRect CGReduceRect(CGRect rect, CGFloat value){
    
    CGRect reducedRect = CGRectMake(rect.origin.x+value, rect.origin.y+value, rect.size.width - 2.f*value, rect.size.height - 2.f*value);
    
    return reducedRect;
}

void printRect(CGRect rect){
    
    printf("( %.2f ; %.2f ) W:%.2f H%.2f\n", rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
    
}



@end

