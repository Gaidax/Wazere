//
//  APPSWebViewController.m
//  Wazere
//
//  Created by Petr Yanenko on 1/21/15.
//  Copyright (c) 2015 iOS Developer. All rights reserved.
//

#import "APPSWebViewController.h"

@interface APPSWebViewController () <UIWebViewDelegate>

@property(weak, NS_NONATOMIC_IOSONLY) IBOutlet UIWebView *webView;

@end

@implementation APPSWebViewController

- (void)dealloc {
  self.webView.delegate = nil;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  if ([self.url isEqualToString:kPolicyAddress]) {
    self.navigationItem.title = NSLocalizedString(kPolicyHeader, nil);
  } else if ([self.url isEqualToString:kTermsAddress]) {
    self.navigationItem.title = NSLocalizedString(kTermsHeader, nil);
  }
  NSURL *url = [NSURL URLWithString:self.url];
  if (url) {
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
  } else {
    NSLog(@"%@", [NSError errorWithDomain:@"APPSWebViewController"
                                     code:0
                                 userInfo:@{
                                   NSLocalizedFailureReasonErrorKey : @"URL is nil"
                                 }]);
  }
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  if ([self.webView isLoading]) {
    [self.webView stopLoading];
  }
  self.webView.delegate = nil;  // disconnect the delegate as the webview is hidden
  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

  // report the error inside the webview
  NSString *errorString =
      [NSString stringWithFormat:@"<html><center><font size=+5 color='red'>"
                                 @"An error occurred:<br>%@</font></center></html>",
                                 error.localizedDescription];
  [self.webView loadHTMLString:errorString baseURL:nil];
}

@end
