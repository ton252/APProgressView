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
    
    self.stepper.value = (float)self.progressView.sectionCount;

    self.slider.value = self.progressView.progress;
    self.switchButton.on = self.progressView.showButtons;
    self.segmentControl.selectedSegmentIndex = self.progressView.step;
    self.active.on = self.progressView.active;
    
    self.cirBoarder.value = self.progressView.circleBorderWidth;
    self.prBoarder.value = self.progressView.progressBorderWidth;
    self.prWidth.value  = self.progressView.progressWidth;

    
    self.progressView.delegate = self;
    
}

//-(void)setupButton:(UIButton *)button atIndex:(NSUInteger)index{
//    
//    [button setTitle:@"S" forState:UIControlStateHighlighted];
//    [button setTitle:@"S" forState:UIControlStateSelected];
//    [button setTitle:@"K" forState:UIControlStateNormal];
//    
//}

- (void)buttonDidSelected:(UIButton *) button atIndex:(NSUInteger) index{
    NSLog(@"Selected");
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