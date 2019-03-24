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

@interface AJWKWebViewController ()<UITextFieldDelegate, WKNavigationDelegate>

@property (nonatomic, strong) WKWebView* webView;
@property (nonatomic, strong) MYTextField* textField;
@property (nonatomic, strong) UIProgressView* progressView;

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
    self.textField = [[MYTextField alloc] initWithFrame:CGRectMake(48, 4, frame.size.width - 96, frame.size.height - 8)];
    self.textField.layer.cornerRadius = 4.0f;
    self.textField.layer.borderWidth = 1.0f;
    self.textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textField.backgroundColor = [UIColor whiteColor];
    self.textField.clearsOnBeginEditing = YES;
    self.textField.keyboardType = UIKeyboardTypeURL;
    self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textField.delegate = self;
    self.textField.returnKeyType = UIReturnKeyGo;
//    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithCustomView:textField];
    self.navigationItem.titleView = self.textField;
    
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 1);
    self.progressView.trackTintColor = [UIColor lightGrayColor];
    self.progressView.progressTintColor = [UIColor blueColor];
    self.progressView.hidden = YES;
    [self.view addSubview:self.progressView];
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    self.webView.navigationDelegate = self;
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view insertSubview:self.webView belowSubview:self.progressView];
    
    [self.webView addObserver:self forKeyPath:@"loading" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)cancelInputUrl
{
    [self.textField resignFirstResponder];
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"loading"])
    {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:self.webView.loading];
        if (self.webView.loading)
        {
            self.textField.text = self.webView.URL.absoluteString;
        }
    }
    else if ([keyPath isEqualToString:@"estimatedProgress"])
    {
        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
        self.progressView.hidden = ((int)self.webView.estimatedProgress == 1);
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelInputUrl)];
    self.navigationItem.rightBarButtonItem = cancelButton;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    self.navigationItem.rightBarButtonItem = nil;
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:textField.text]];
    [self.webView loadRequest:request];
    return YES;
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self showMessage:error.localizedDescription];
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self.progressView setProgress:0.0 animated:NO];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self showMessage:error.localizedDescription];
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * credential))completionHandler
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    completionHandler(NSURLSessionAuthChallengeUseCredential, challenge.proposedCredential);
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

#pragma mark -- private
- (void)showMessage:(NSString*)msg
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:msg
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
