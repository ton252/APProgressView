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
@property (weak, nonatomic) IBOutlet UISwitch *active;

@property (weak, nonatomic) IBOutlet UIStepper *cirBoarder;
@property (weak, nonatomic) IBOutlet UIStepper *prBoarder;
@property (weak, nonatomic) IBOutlet UIStepper *prWidth;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"View didload");
    
    self.progressView.sectionCount = 2;
    
    self.stepper.value = (float)self.progressView.sectionCount;

    self.slider.value = self.progressView.progress;
    self.switchButton.on = self.progressView.showButtons;
    self.segmentControl.selectedSegmentIndex = self.progressView.step;
    self.active.on = self.progressView.active;
    
    self.cirBoarder.value = self.progressView.circleBorderWidth;
    self.prBoarder.value = self.progressView.progressBorderWidth;
    self.prWidth.value  = self.progressView.progressWidth;

    
    self.progressView.delegate = self;
    NSLog(@"dsfdf");

    
    //[self drawBezierAnimate:YES];
}


- (IBAction)selectedAction:(UIButton *)sender {
    
    if (sender.selected == NO) {
        sender.selected = YES;
    }else{

    }

}

-(void)setupButton:(UIButton *)button atIndex:(NSUInteger)index{
    
    [button setTitle:@"S" forState:UIControlStateHighlighted];
    [button setTitle:@"S" forState:UIControlStateSelected];
    [button setTitle:@"K" forState:UIControlStateNormal];
    
}

- (void)buttonDidSelected:(UIButton *) button atIndex:(NSUInteger) index{
    NSLog(@"Selected");
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

- (IBAction)changeCircleBoarder:(UIStepper *)sender {
    
    self.progressView.circleBorderWidth = sender.value;
}

- (IBAction)changeProgressBoarder:(UIStepper *)sender {
    
    self.progressView.progressBorderWidth = sender.value;
}

- (IBAction)changeProgressWidth:(UIStepper *)sender {
    
    self.progressView.progressWidth = sender.value;
}


- (IBAction)activeAction:(UISwitch *)sender {
    self.progressView.active = self.active.on;
}

- (IBAction)activeButtons:(UISwitch *)sender {
    self.progressView.showButtons = sender.on;
}

@end