//
//  HHAHViewController.m
//  WebViewJavaScriptBridge.swift
//
//  Created by Wong Zigii on 15/10/30.
//  Copyright © 2015年 Wong Zigii. All rights reserved.
//

#import "HHAHViewController.h"
#import "WebViewJavascriptBridge.h"

@interface HHAHViewController ()

@end

@implementation HHAHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [WebViewJavascriptBridge bridgeForWebView:nil webViewDelegate:nil handler:^(id data, WVJBResponseCallback responseCallback) {
        responseCallback();
    }];
    
    UIWebView
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
