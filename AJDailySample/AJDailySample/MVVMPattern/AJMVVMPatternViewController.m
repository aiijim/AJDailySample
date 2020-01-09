//
//  AJMVVMPatternViewController.m
//  AJDailySample
//
//  Created by BruceAi on 2020/1/9.
//  Copyright © 2020 aiijim. All rights reserved.
//

#import "AJMVVMPatternViewController.h"
#import "AJMVVMPatternViewModel.h"

@interface AJMVVMPatternViewController ()

@property (nonatomic, strong) AJMVVMPatternViewModel* viewModel;
@property (nonatomic, strong) UILabel* textLabel;

@end

@implementation AJMVVMPatternViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"MVVM Pattern Sample";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.viewModel = [AJMVVMPatternViewModel new];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Refresh"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(updateViewModel)];
    
    [self configureSubViews];
    [self bindViewAndViewModel];
}

- (void)configureSubViews
{
    self.textLabel = [UILabel new];
    self.textLabel.font = [UIFont boldSystemFontOfSize:36];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.textLabel];
    
    
    NSArray* hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[lbl]-20-|" options:0 metrics:nil views:@{@"lbl":self.textLabel}];
    NSArray* vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[lbl(==80)]" options:0 metrics:nil views:@{@"lbl":self.textLabel}];
    NSLayoutConstraint* centerConstraint = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:-20];
    [self.view addConstraints:hConstraints];
    [self.view addConstraints:vConstraints];
    [self.view addConstraint:centerConstraint];
}

- (void)bindViewAndViewModel
{
    [self.viewModel addObserver:self forKeyPath:@"helloText" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)updateViewModel
{
    [self.viewModel refreshMMVMPatternModel];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"helloText"]) {
        self.textLabel.text = change[NSKeyValueChangeNewKey];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
