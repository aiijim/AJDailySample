//
//  AJWKWebViewController.m
//  AJDailySample
//
//  Created by aiijim on 2019/3/23.
//  Copyright © 2019年 aiijim. All rights reserved.
//

#import "AJWKWebViewController.h"
#import <WebKit/WebKit.h>

@interface MYTextField : UITextField

@end

@implementation MYTextField

// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 6, 2);
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 6, 2);
}

@end

@interface AJWKWebViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) WKWebView* webView;

@end

@implementation AJWKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.title = @"WKWebView Sample";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.extendedLayoutIncludesOpaqueBars = NO;
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    CGRect frame = self.navigationController.navigationBar.frame;
    MYTextField* textField = [[MYTextField alloc] initWithFrame:CGRectMake(48, 4, frame.size.width - 96, frame.size.height - 8)];
    textField.layer.cornerRadius = 4.0f;
    textField.layer.borderWidth = 1.0f;
    textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textField.backgroundColor = [UIColor whiteColor];
    textField.clearsOnBeginEditing = YES;
    textField.keyboardType = UIKeyboardTypeURL;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.delegate = self;
    textField.returnKeyType = UIReturnKeyGo;
//    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithCustomView:textField];
    self.navigationItem.titleView = textField;
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.webView];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:textField.text]];
    [self.webView loadRequest:request];
    return YES;
}

@end
