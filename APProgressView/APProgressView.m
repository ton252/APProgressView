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

@property(strong, nonatomic) NSMutableArray *buttonsArray;

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
        NSLog(@"init with coder");

    }
    
    return self;
    
}


- (void)initialization{
    
    NSLog(@"initialization");
    self.buttonsArray = [[NSMutableArray alloc] init];

}

#pragma mark Default settings

- (void)defaultSettings{
    
    NSLog(@"defaultSettings");

    _progressWidth = 4.f;
    _progressBorderWidth = 2.f;
    _circleBorderWidth = 2.f;
    _generateBackgroundImagesAutomaticly = YES;
    _showButtons = YES;
    _active = YES;
    _disableDeselectedButtons= YES;
    
    self.backgroundColor =[UIColor clearColor];
    
    _progressBackgroundColor = [UIColor whiteColor];
    _progressColor = [UIColor redColor];
    _borderColor = [UIColor greenColor];

}

#pragma mark Setters

-(void)setProgressBorderWidth:(CGFloat)progressBorderWidth{
    _progressBorderWidth = progressBorderWidth;
    [self setNeedsDisplay];
}

-(void)setProgressWidth:(CGFloat)progressWidth{
    _progressWidth = progressWidth;
    [self setNeedsDisplay];
}


// Set border to segments circles
- (void)setCircleBorderWidth:(CGFloat)circleBorderWidth{
    _circleBorderWidth = circleBorderWidth;
    [self refreshButtonBoarderWidth:circleBorderWidth];
    [self setNeedsDisplay];
}

// Set progress background color
- (void)setProgressBackgroundColor:(UIColor *)progressBackgroundColor{
    
    _progressBackgroundColor = progressBackgroundColor;
    [self refreshButtonNormalColor:progressBackgroundColor];
    [self setNeedsDisplay];
}

// Set progress color in active state
- (void)setProgressColor:(UIColor *)progressColor{
    
    _progressColor = progressColor;
    [self refreshButtonHighlightColor:progressColor];
    [self setNeedsDisplay];
    
}

// Set border color
- (void)setBorderColor:(UIColor *)borderColor{
    
    _borderColor = borderColor;
    [self refreshButtonBoarderColor:borderColor];
}

//Set progress
- (void)setProgress:(float)progress{
    _progress = progress;
    [self setNeedsDisplay];
}

//Set step
- (void)setStep:(NSUInteger)step{
    if (self.isActive) {
        _step = step;
        [self updateButtonState];
        [self setNeedsDisplay];
    }
}

//Set lap
- (void)setLap:(NSUInteger)lap{
    _lap = lap;
    self.progress = 0.f;
    self.step = 0;
}


//Set section count
- (void)setSectionCount:(NSUInteger)sectionCount{
    
    NSUInteger perviousValue = _sectionCount;
    _sectionCount = sectionCount;
    [self createButonsFromIndex:perviousValue toIndex:_sectionCount];
    [self updateButtonState];
    
    [self setNeedsDisplay];
}


//Set show buttons
- (void)setShowButtons:(BOOL)showButtons{
    
    if (_showButtons != showButtons) {
        for(UIButton *button in self.buttonsArray)
            button.hidden = !showButtons;
    }
    
    _showButtons = showButtons;
}

//Set active
- (void)setActive:(BOOL)active{
    
    if (active) {
        [self updateButtonState];
    }else{
        for (UIButton *button in self.buttonsArray) {
            button.selected = NO;
            button.userInteractionEnabled = NO;
            [self unhighlightBorder:button];
        }
    }
    
    _active = active;
    
    [self setNeedsDisplay];
    
}

//Set Delegate

- (void)setDelegate:(id<APProgressViewDelegate>)delegate{
    
    _delegate = delegate;
    //Delegate method for setup Buttons
    if ([self.delegate respondsToSelector:@selector(setupButton:atIndex:)]){
        for (int i = 0; i < self.sectionCount; i++) {
            UIButton * button = self.buttonsArray[i];
            [self.delegate setupButton:button atIndex:i];
        }
        
        [self updateButtonState];
    }
}



#pragma mark Refresh button methods

// Refresh buttons borders
-(void)refreshButtonBoarderWidth:(CGFloat) width{
    
    if (self.generateBackgroundImagesAutomaticly) {
        for (UIButton *button in self.buttonsArray) {
            button.layer.borderWidth = width;
        }
    }
}


// Refresh buttons normal state color
-(void)refreshButtonNormalColor:(UIColor *) color{
 
    if (self.generateBackgroundImagesAutomaticly) {
        
        UIImage *normalColor = [self imageWithColor:color];
        
        for (UIButton* button in self.buttonsArray) {
            if (normalColor) {
                [button setBackgroundImage:normalColor forState:UIControlStateNormal];
                [button setBackgroundImage:normalColor forState:UIControlStateDisabled];

                [button setTitleColor:color forState:UIControlStateHighlighted];
                [button setTitleColor:color forState:UIControlStateSelected];
                //[self unhighlightBorder:button];
            }
        }
    }
}


// Refresh button highlight color
-(void)refreshButtonHighlightColor:(UIColor *) color{
    
    if (self.generateBackgroundImagesAutomaticly) {
        UIImage *selectedColor = [self imageWithColor:color];
        for (UIButton* button in self.buttonsArray) {
            if (selectedColor) {
                [button setBackgroundImage:selectedColor forState:UIControlStateHighlighted];
                [button setBackgroundImage:selectedColor forState:UIControlStateSelected];
                [self unhighlightBorder:button];
            }
        }
    }
}



//Refresh button boarder color for state inactive
- (void)refreshButtonBoarderColor:(UIColor *) color{
    
    if (self.generateBackgroundImagesAutomaticly) {
        for (UIButton* button in self.buttonsArray) {
            button.layer.borderColor = color.CGColor;
            [button setTitleColor:color  forState:UIControlStateNormal];
            [button setTitleColor:color forState:UIControlStateDisabled];
            [self unhighlightBorder:button];
        }
    }
    
}



#pragma mark Cheking methods

-(void)checkValues{
    
    if (_progress < 0.f) {
        self.progress = 0.f;
    }else if(self.progress > 1.f){
        self.progress = 1.f;
    }
    
}



#pragma mark Buttons settings

- (void)createButonsFromIndex:(NSUInteger) previousIndex toIndex:(NSUInteger) newIndex{
    NSLog(@"Create button");
    if (newIndex > previousIndex) {
        //Add
        NSLog(@"Add");
        for (NSUInteger i = previousIndex; i < newIndex; i++) {
    
            //Generating button
            UIButton *button = [self genrateButtonForIndex:i];
            
            //Delegate method for setup Buttons
            if ([self.delegate respondsToSelector:@selector(setupButton:atIndex:)]){
                [self.delegate setupButton:button atIndex:i];
                [self updateButtonState];
            }
            
            //Adding to view
            [self addSubview:button];
            [self.buttonsArray addObject:button];
        }
        
    }else if (newIndex < previousIndex){
        //Remove
        NSLog(@"remove");
        NSUInteger offset = 0;
        for (NSUInteger i = newIndex; i < previousIndex; i++) {
            UIButton *button = self.buttonsArray[i-offset];
            [button removeFromSuperview];
            [self.buttonsArray removeObjectAtIndex:i-offset];
            offset++;
        }
        
    }
    
}


-(UIButton *)genrateButtonForIndex:(NSUInteger) index{

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    NSString *buttonName = [NSString stringWithFormat:@"%ld",(long)index+1];
    
    //Generate background image
    if (self.generateBackgroundImagesAutomaticly)
        [self setBackgroundImageForButton:button];
    
    //Set titles
    [button setTitle:buttonName forState:UIControlStateNormal];
    [button setTitle:buttonName forState:UIControlStateHighlighted];
    [button setTitle:buttonName forState:UIControlStateSelected];
    [button setTitle:buttonName forState:UIControlStateDisabled];
    
    //Set titles color
    [button setTitleColor:self.borderColor  forState:UIControlStateNormal];
    [button setTitleColor:self.progressBackgroundColor forState:UIControlStateHighlighted];
    [button setTitleColor:self.progressBackgroundColor forState:UIControlStateSelected];
    [button setTitleColor:self.borderColor forState:UIControlStateDisabled];

    
    //Set other settings
    button.clipsToBounds = YES;
    button.tag = index;
    button.hidden = !self.showButtons;

    return button;
}


- (void)setBackgroundImageForButton:(UIButton *) button{
    
    UIImage *normalColor = [self imageWithColor:self.progressBackgroundColor];
    UIImage *selectedColor = [self imageWithColor:self.progressColor];
    
    if (normalColor) {
        [button setBackgroundImage:normalColor forState:UIControlStateNormal];
        [button setBackgroundImage:normalColor forState:UIControlStateDisabled];
    }
    
    if (selectedColor) {
        [button setBackgroundImage:selectedColor forState:UIControlStateHighlighted];
        [button setBackgroundImage:selectedColor forState:UIControlStateSelected];
    }
    
    [button addTarget:self action:@selector(selectStep:) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(highlightBorder:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(unhighlightBorder:) forControlEvents:UIControlEventTouchUpInside];
    
    button.layer.borderWidth = self.circleBorderWidth;
    button.layer.borderColor = self.borderColor.CGColor;
    
    button.adjustsImageWhenHighlighted = NO;
}

- (void)highlightBorder:(UIButton *) sender
{
    if (sender.isSelected) {
        sender.layer.borderColor = self.borderColor.CGColor;
    }else{
        sender.layer.borderColor = self.progressColor.CGColor;
    }
}

- (void)unhighlightBorder:(UIButton *) sender
{
    if (sender.isSelected) {
        sender.layer.borderColor = self.progressColor.CGColor;
    }else{
        sender.layer.borderColor = self.borderColor.CGColor;
    }
}

- (void)selectStep:(UIButton *) sender{
    
    self.progress = 0.f;
    for (int i = 0; i < self.buttonsArray.count; i++) {
        UIButton *button = self.buttonsArray[i];
        if ([sender isEqual:button]) {
            sender.selected = YES;
            self.step = i;
            if ([self.delegate respondsToSelector:@selector(buttonDidSelected:atIndex:)]) {
                [self.delegate buttonDidSelected:button atIndex:i];
            }
            
            break;
        }
    }

    
}

- (void)removeAllButtons{
    
    for (UIButton *button in self.buttonsArray) {
        [button removeFromSuperview];
    }
    [self.buttonsArray removeAllObjects];
    
}


- (void)updateButtonsFrames{
    
    for (int i = 0; i < self.buttonsArray.count; i++) {
        UIButton *button = self.buttonsArray[i];
        CGRect buttonRect = self.externalCircles[i].CGRectValue;
        button.frame = buttonRect;
        button.layer.cornerRadius = button.frame.size.height/2.f;
    }
    
}
- (void)updateButtonState{

    for (int i =0 ; i< self.buttonsArray.count; i++) {
        UIButton *button = self.buttonsArray[i];
        if (i <= _step) {
            button.selected = YES;
            button.userInteractionEnabled = YES;
        }else{
            button.selected = NO;
            button.userInteractionEnabled = !self.disableDeselectedButtons;
        }

        [self unhighlightBorder:button];

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
    
    [self updateButtonsFrames];

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
        
        UIBezierPath* circleExternalPath = [UIBezierPath bezierPathWithOvalInRect:circleExternalRect];
        UIBezierPath* circleInternalPath = [UIBezierPath bezierPathWithOvalInRect:circleInternalRect];
        
        [externalCircles addObject: [NSValue valueWithCGRect:circleExternalRect]];
        [internalCircles addObject: [NSValue valueWithCGRect:circleInternalRect]];
        
        
        if (self.showButtons) {
            //------------------
            CGRect circleOffset = CGReduceRect(circleExternalRect,0.3f);
            UIBezierPath *circleOffsetPath = [UIBezierPath bezierPathWithOvalInRect:circleOffset];
            [externalPath appendPath:circleOffsetPath];
            //------------------
        }else{
            [externalPath appendPath:circleExternalPath];
        }

        [internalPath appendPath:circleInternalPath];
    }
    
    self.externalPath = externalPath;
    self.internalPath = internalPath;
    
    self.externalCircles = [NSArray arrayWithArray:externalCircles];
    self.internalCircles = [NSArray arrayWithArray:internalCircles];
}

-(void)progressFill:(CGRect) rect{

    if (self.sectionCount > 0) {
      
        CGFloat sectionCount = self.sectionCount;
        CGFloat diameter = rect.size.height;
        
        CGFloat stepLenght = (rect.size.width - diameter*sectionCount)/MAX((sectionCount-1),1);
        CGFloat offset = diameter/2.f - sqrtf(powf(diameter/2.f, 2) - powf((self.progressWidth/2.f),2)) +self.circleBorderWidth;
        

        if (self.step == 0){
             self.progressLength =  diameter + self.progress*(stepLenght+2.f*offset) - offset;
        }else if (self.step > 0 && self.step < sectionCount-1){
            self.progressLength = diameter*(self.step+1) + stepLenght*self.step + self.progress*(stepLenght + 2.f*offset)  - offset;
        }else{
            self.progressLength =rect.size.width;
        }

    }else if (self.sectionCount == 0){
        
        self.progressLength = self.progress*rect.size.width;

    }

    CGRect progressRect = CGRectMake(rect.origin.x, rect.origin.x, self.progressLength, rect.size.height);
    UIBezierPath *progressPath = [UIBezierPath bezierPathWithRect:progressRect];
    [self.progressColor setFill];
    [progressPath fill];
    
}

- (UIImage *)imageWithColor:(UIColor *)color {
    
    if (!color) {
        return nil;
    }
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
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

