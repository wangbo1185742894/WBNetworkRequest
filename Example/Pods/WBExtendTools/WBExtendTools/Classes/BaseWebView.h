//
//  BaseWebView.h
//  CommunityPeople
//
//  Created by 彭睿 on 2019/7/30.
//  Copyright © 2019 彭睿. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN



typedef enum {
    LKWebViewModeAutomatic = 0,      // Use UIWebView When the operating system version below iOS8,Use WKWebView When the operating system version below iOS8
    LKWebViewModeUIWebView = 1,        // Use UIWebView
    LKWebViewModeWKWebView = 2        // Use WKWebView
} LKWebViewMode;

@class BaseWebView;

@protocol LKWebViewDelegate <NSObject>

@optional

- (void)lkWebView:(BaseWebView *)webview didFinishLoadingURL:(NSURL *)URL;
- (void)lkWebView:(BaseWebView *)webview didFailToLoadURL:(NSURL *)URL error:(NSError *)error;
- (void)lkWebView:(BaseWebView *)webview shouldStartLoadWithRequest:(NSURLRequest *)request;
- (void)lkWebViewDidStartLoad:(BaseWebView *)webview;

@end



@interface BaseWebView : UIView<WKNavigationDelegate, WKUIDelegate, UIWebViewDelegate>

#pragma mark - Public Properties
//LKWebViewdelegate
@property (nonatomic, weak) id <LKWebViewDelegate> delegate;
@property (nonatomic, readonly) LKWebViewMode webViewMode;
@property (nonatomic, readonly) LKWebViewMode currentWebView;

@property (nonatomic, readonly, getter=canGoBack) BOOL canGoBack;
@property (nonatomic, readonly, getter=canGoForward) BOOL canGoForward;
@property (nonatomic, readonly, getter=isLoading) BOOL loading;

// The main and only UIProgressView
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, assign) BOOL isOut;
// The web views
// Depending on the version of iOS, one of these will be set
@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) UIWebView *uiWebView;
#pragma mark - Static Initializers
@property (nonatomic, strong) UIColor *progressTintColor;
@property (nonatomic, assign) BOOL showsPageTitleInNavigationBar;


#pragma mark - Initializers view
- (instancetype)initWithFrame:(CGRect)frame withMode:(LKWebViewMode)mode;



- (void)reload;
- (void)stopLoading;

- (void)goBack;
- (void)goForward;



#pragma mark - Public Interface


// Load a NSURLURLRequest to web view
// Can be called any time after initialization
- (void)loadRequest:(NSURLRequest *)request;

// Load a NSURL to web view
// Can be called any time after initialization
- (void)loadURL:(NSURL *)URL;

// Loads a URL as NSString to web view
// Can be called any time after initialization
- (void)loadURLString:(NSString *)URLString;

// Loads an string containing HTML to web view
// Can be called any time after initialization
- (void)loadHTMLString:(NSString *)HTMLString;


@end

NS_ASSUME_NONNULL_END
