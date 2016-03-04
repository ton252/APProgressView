//
//  ViewController.m
//  APProgressView
//
//  Created by ton252 on 03.03.16.
//  Copyright © 2016 ton252. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet APProgressView *progressView;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UIStepper *stepper;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UISwitch *switchButton;
@property (weak, nonatomic) IBOutlet UISwitch *switchStep;
@property (weak, nonatomic) IBOutlet UISwitch *active;
@property (weak, nonatomic) IBOutlet UIButton *butotn;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.stepper.value = self.progressView.sectionCount;
    self.slider.value = self.progressView.progress;
    self.switchButton.on = self.progressView.enableButtons;
    self.switchStep.on = self.progressView.enableStepCounting;
    self.segmentControl.selectedSegmentIndex = self.progressView.step;
    self.active.on = self.progressView.active;
    
    self.progressView.delegate = self;
    
    double delayInSeconds = 6.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [UIView animateWithDuration:3.f animations:^{
            self.progressView.progress = 0.5;
        }];

    });
    
    [self drawBezierAnimate:YES];
    
    self.butotn.layer.borderColor = [UIColor blueColor].CGColor;
    self.butotn.layer.borderWidth = 6.f;
    self.butotn.layer.cornerRadius = self.butotn.frame.size.height/2.f; // this value vary as per your desire
    self.butotn.clipsToBounds = YES;
    
    NSLog(@"Controller");
}

- (IBAction)selectedAction:(UIButton *)sender {
    
    if (sender.selected == NO) {
        sender.selected = YES;
    }else{

    }

}

- (UIBezierPath *)bezierPath
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(0.0, 0.0)];
    
    [path addLineToPoint:CGPointMake(200.0, 200.0)];
    
    return path;
}

- (void)drawBezierAnimate:(BOOL)animate
{
    UIBezierPath *bezierPath = [self bezierPath];
    
    CAShapeLayer *bezier = [[CAShapeLayer alloc] init];
    
    bezier.path          = bezierPath.CGPath;
    bezier.strokeColor   = [UIColor blueColor].CGColor;
    bezier.fillColor     = [UIColor clearColor].CGColor;
    bezier.lineWidth     = 2.0;
    bezier.strokeStart   = 0.0;
    bezier.strokeEnd     = 0.0;
    [self.view.layer addSublayer:bezier];
    
    if (animate)
    {
        CABasicAnimation *animateStrokeEnd = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animateStrokeEnd.duration  = 0.2;
        animateStrokeEnd.repeatCount = HUGE_VALF;
        animateStrokeEnd.fromValue = [NSNumber numberWithFloat:0.0f];
        animateStrokeEnd.toValue   = [NSNumber numberWithFloat:1.0f];
        [bezier addAnimation:animateStrokeEnd forKey:@"strokeEndAnimation"];
    }
}

-(UIButton *)setupButtonAtIndex:(NSUInteger)index{
    
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:@"S" forState:UIControlStateHighlighted];
    [button setTitle:@"K" forState:UIControlStateNormal];
    
    return button;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)slideAction:(UISlider *)sender {
    self.progressView.progress = sender.value;
    //NSLog(@"%f", self.progressView.progress);
    
    
}
- (IBAction)stepperAction:(UIStepper *)sender {
    self.progressView.sectionCount = (NSUInteger)sender.value;
}
- (IBAction)segmentAction:(UISegmentedControl *)sender {
    self.slider.value = 0.f;
    self.progressView.progress = 0.f;
    self.progressView.step = sender.selectedSegmentIndex;
    
}
- (IBAction)activeAction:(UISwitch *)sender {
    self.progressView.active = self.active.on;
    [self.view setNeedsDisplay];
}
- (IBAction)activeStep:(UISwitch *)sender {
    self.progressView.enableStepCounting = sender.on;
}

- (IBAction)activeButtons:(UISwitch *)sender {
    self.progressView.enableButtons = sender.on;
}

@end