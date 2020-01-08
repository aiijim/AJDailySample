//
//  AJMVPPatternViewController.m
//  AJDailySample
//
//  Created by BruceAi on 2020/1/8.
//  Copyright © 2020 aiijim. All rights reserved.
//

#import "AJMVPPatternViewController.h"

@interface AJMVPPatternViewController ()

@property (nonatomic, strong) AJGreetingPresenter* greetingPresenter;
@property (nonatomic, strong) UILabel* greetingLabel;
@property (nonatomic, strong) UIButton* greetingBtn;

@end

@implementation AJMVPPatternViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"MVP Pattern Sample";
    self.view.backgroundColor = [UIColor whiteColor];
    
    Person* model = [Person new];
    model.firstName = @"David";
    model.lastName = @"Blaine";
    self.greetingPresenter = [[AJGreetingPresenter alloc] initWithGreetingView:self person:model];
    
    self.greetingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.greetingBtn setTitle:@"ShowGreeting" forState:UIControlStateNormal];
    [self.greetingBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.greetingBtn.layer.borderColor = [UIColor orangeColor].CGColor;
    self.greetingBtn.layer.borderWidth = 2.0f;
    self.greetingBtn.layer.cornerRadius = 4.0f;
    self.greetingBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [self.greetingBtn addTarget:self action:@selector(greetingBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.greetingBtn];
    
    NSLayoutConstraint* layoutContraintCenterX = [NSLayoutConstraint constraintWithItem:self.greetingBtn
                                                                              attribute:NSLayoutAttributeCenterX
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.view
                                                                              attribute:NSLayoutAttributeCenterX
                                                                             multiplier:1.0
                                                                               constant:0.0];
    NSLayoutConstraint* layoutContraintCenterY = [NSLayoutConstraint constraintWithItem:self.greetingBtn
                                                                              attribute:NSLayoutAttributeCenterY
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.view
                                                                              attribute:NSLayoutAttributeCenterY
                                                                             multiplier:1.0
                                                                               constant:-20.0];
    NSLayoutConstraint* layoutContraintWidth = [NSLayoutConstraint constraintWithItem:self.greetingBtn
                                                                            attribute:NSLayoutAttributeWidth
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:nil
                                                                            attribute:NSLayoutAttributeWidth
                                                                           multiplier:1.0
                                                                             constant:140];
    NSLayoutConstraint* layoutContraintHeight = [NSLayoutConstraint constraintWithItem:self.greetingBtn
                                                                             attribute:NSLayoutAttributeHeight
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:nil
                                                                             attribute:NSLayoutAttributeHeight
                                                                            multiplier:1.0
                                                                              constant:80];
    
    [self.view addConstraints:@[layoutContraintCenterX,layoutContraintCenterY]];
    [self.greetingBtn addConstraints:@[layoutContraintWidth, layoutContraintHeight]];
    
    self.greetingLabel = [[UILabel alloc] init];
    self.greetingLabel.textAlignment = NSTextAlignmentCenter;
    self.greetingLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.greetingLabel];
    
    NSArray* lableHContraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[lbl]-20-|"
                                                                        options:0
                                                                        metrics:0
                                                                          views:@{@"lbl": self.greetingLabel}];
    NSArray* lableVContraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[lbl(==60)]-20-[greetingbtn]"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:@{@"lbl":self.greetingLabel, @"greetingbtn":self.greetingBtn}];
    [self.view addConstraints:[lableHContraints arrayByAddingObjectsFromArray:lableVContraints]];
}

- (void)greetingBtnTapped
{
    [self.greetingPresenter showGreeting];
}

- (void)setGreeting:(nonnull NSString *)greeting
{
    self.greetingLabel.text = greeting;
    self.greetingLabel.hidden = NO;
    self.greetingBtn.hidden = YES;
}

@end
