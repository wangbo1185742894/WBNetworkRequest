//
//  BaseWebView.m
//  CommunityPeople
//
//  Created by 彭睿 on 2019/7/30.
//  Copyright © 2019 彭睿. All rights reserved.
//

#import "BaseWebView.h"

#define DEF_IOS8_LKWEBVIEW [[[UIDevice currentDevice] systemVersion] floatValue]>=8.0

static void *KINWebBrowserContext = &KINWebBrowserContext;


@interface BaseWebView ()<UIAlertViewDelegate>
{
    LKWebViewMode _mode;
    BOOL _canGoBack;
    BOOL _canGoForward;
    BOOL _loading;
}

@property (nonatomic, strong) NSTimer *fakeProgressTimer;
@property (nonatomic, assign) BOOL uiWebViewIsLoading;
@property (nonatomic, strong) NSURL *uiWebViewCurrentURL;
@property (nonatomic, strong) NSURL *URLToLaunchWithPermission;


@end


@implementation BaseWebView

#pragma mark --Initializers

- (instancetype)initWithFrame:(CGRect)frame withMode:(LKWebViewMode)mode
{
    self = [super initWithFrame:frame];
    if (self) {
        _mode = mode;
        switch (mode) {
                
            case LKWebViewModeAutomatic:
                if(DEF_IOS8_LKWEBVIEW) {
                    self.wkWebView = [[WKWebView alloc] init];
                }
                else {
                    self.uiWebView = [[UIWebView alloc] init];
                }
                break;
            case LKWebViewModeUIWebView:
                self.uiWebView = [[UIWebView alloc] init];
                break;
            case LKWebViewModeWKWebView:
                self.wkWebView = [[WKWebView alloc] init];
                break;
            default:
                break;
        }
        
        self.backgroundColor = [UIColor whiteColor];
        
        if(self.wkWebView) {
            [self.wkWebView setFrame:frame];
            [self.wkWebView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
            [self.wkWebView setNavigationDelegate:self];
            [self.wkWebView setUIDelegate:self];
            [self.wkWebView setMultipleTouchEnabled:YES];
            [self.wkWebView setAutoresizesSubviews:YES];
            [self.wkWebView.scrollView setAlwaysBounceVertical:YES];
            [self addSubview:self.wkWebView];
            self.wkWebView.scrollView.bounces = NO;
            [self.wkWebView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:0 context:
             KINWebBrowserContext];
            [self.wkWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
        }
        else  {
            [self.uiWebView setFrame:frame];
            [self.uiWebView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
            [self.uiWebView setDelegate:self];
            [self.uiWebView setMultipleTouchEnabled:YES];
            [self.uiWebView setAutoresizesSubviews:YES];
            [self.uiWebView setScalesPageToFit:YES];
            [self.uiWebView.scrollView setAlwaysBounceVertical:YES];
            self.uiWebView.scrollView.bounces = NO;
            [self addSubview:self.uiWebView];
        }
        
        self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        [self.progressView setTrackTintColor:[UIColor colorWithWhite:1.0f alpha:0.0f]];
        [self.progressView setFrame:CGRectMake(0, 0, self.frame.size.width, self.progressView.frame.size.height)];
        [self.progressView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
        
        //设置进度条颜色
        [self setProgressTintColor:[UIColor colorWithRed:0.400 green:0.863 blue:0.133 alpha:1.000]];
        [self addSubview:self.progressView];
        
    }
    return self;
}


- (LKWebViewMode)webViewMode {
    return _mode;
}

- (LKWebViewMode)currentWebView {
    return _mode;
}

- (BOOL)canGoBack {
    if(self.wkWebView) {
        _canGoBack = self.wkWebView.canGoBack;
    }
    else  {
        _canGoBack = self.uiWebView.canGoBack;
    }
    return _canGoBack;
}

- (BOOL)canGoForward {
    if(self.wkWebView) {
        _canGoForward = self.wkWebView.canGoForward;
    }
    else  {
        _canGoBack = self.uiWebView.canGoForward;
    }
    return _canGoForward;
}

- (BOOL)isLoading {
    if(self.wkWebView) {
        _loading = self.wkWebView.loading;
    }
    else  {
        _loading = self.uiWebView.loading;
    }
    return _loading;
}


#pragma mark - Public Interface
- (void)loadRequest:(NSURLRequest *)request {
    if(self.wkWebView) {
        [self.wkWebView loadRequest:request];
    }
    else  {
        [self.uiWebView loadRequest:request];
    }
}

- (void)loadURL:(NSURL *)URL {
    [self loadRequest:[NSURLRequest requestWithURL:URL]];
}

- (void)loadURLString:(NSString *)URLString {
    NSURL *URL = [NSURL URLWithString:URLString];
    [self loadURL:URL];
}

- (void)loadHTMLString:(NSString *)HTMLString {
    if(self.wkWebView) {
        [self.wkWebView loadHTMLString:HTMLString baseURL:nil];
    }
    else if(self.uiWebView) {
        [self.uiWebView loadHTMLString:HTMLString baseURL:nil];
    }
}

- (void)setProgressTintColor:(UIColor *)progressTintColor {
    _progressTintColor = progressTintColor;
    [self.progressView setTintColor:progressTintColor];
}



#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if(webView == self.uiWebView) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(lkWebViewDidStartLoad:)]) {
            [self.delegate lkWebViewDidStartLoad:self];
        }
    }
}


//监视请求
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if(webView == self.uiWebView) {
        
        if(![self externalAppRequiredToOpenURL:request.URL]) {
            self.uiWebViewCurrentURL = request.URL;
            self.uiWebViewIsLoading = YES;
            if(!self.isOut){
                [self fakeProgressViewStartLoading];
            }
            
            //back delegate
            if (self.delegate && [self.delegate respondsToSelector:@selector(lkWebView:shouldStartLoadWithRequest:)]) {
                [self.delegate lkWebView:self shouldStartLoadWithRequest:request];
            }
            
            return YES;
        }
        else {
            [self launchExternalAppWithURL:request.URL];
            return NO;
        }
    }
    return NO;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    _mode = LKWebViewModeUIWebView;
    if ([self viewController] && self.showsPageTitleInNavigationBar) {
        [self viewController].title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
    if(webView == self.uiWebView) {
        
        self.uiWebViewIsLoading = NO;
        if(!self.isOut){
            [self fakeProgressBarStopLoading];
        }
        
        //back delegate
        if (self.delegate && [self.delegate respondsToSelector:@selector(lkWebView:didFinishLoadingURL:)]) {
            [self.delegate lkWebView:self didFinishLoadingURL:self.uiWebView.request.URL];
        }
        
    }
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    if(webView == self.uiWebView) {
        if(!self.uiWebView.isLoading) {
            self.uiWebViewIsLoading = NO;
            if(!self.isOut){
                [self fakeProgressBarStopLoading];
            }
        }
        
        //back delegate
        if (self.delegate && [self.delegate respondsToSelector:@selector(lkWebView:didFailToLoadURL:error:)]) {
            [self.delegate lkWebView:self didFailToLoadURL:self.uiWebView.request.URL error:error];
        }
    }
}


#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    if(webView == self.wkWebView) {
        //back delegate
        if (self.delegate && [self.delegate respondsToSelector:@selector(lkWebViewDidStartLoad:)]) {
            [self.delegate lkWebViewDidStartLoad:self];
        }
    }
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    _mode = LKWebViewModeWKWebView;
    
    if(webView == self.wkWebView) {
        
        //back delegate
        if (self.delegate && [self.delegate respondsToSelector:@selector(lkWebView:didFinishLoadingURL:)]) {
            [self.delegate lkWebView:self didFinishLoadingURL:self.wkWebView.URL];
        }
    }
}


- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
      withError:(NSError *)error {
    if(webView == self.wkWebView) {
        //back delegate
        if (self.delegate && [self.delegate respondsToSelector:@selector(lkWebView:didFailToLoadURL:error:)]) {
            [self.delegate lkWebView:self didFailToLoadURL:self.wkWebView.URL error:error];
        }
    }
}


- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation
      withError:(NSError *)error {
    if(webView == self.wkWebView) {
        //back delegate
        if (self.delegate && [self.delegate respondsToSelector:@selector(lkWebView:didFailToLoadURL:error:)]) {
            [self.delegate lkWebView:self didFailToLoadURL:self.wkWebView.URL error:error];
        }
        
    }
}


- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    if(webView == self.wkWebView) {
        
        NSURL *URL = navigationAction.request.URL;
        if(![self externalAppRequiredToOpenURL:URL]) {
            if(!navigationAction.targetFrame) {
                [self loadURL:URL];
                decisionHandler(WKNavigationActionPolicyCancel);
                return;
            }
            [self callback_webViewShouldStartLoadWithRequest:navigationAction.request navigationType:navigationAction.navigationType];
            
        }
        else if([[UIApplication sharedApplication] canOpenURL:URL]) {
            [self launchExternalAppWithURL:URL];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}


- (BOOL)callback_webViewShouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(NSInteger)navigationType
{
    //back delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(lkWebView:shouldStartLoadWithRequest:)]) {
        [self.delegate lkWebView:self shouldStartLoadWithRequest:request];
    }
    
    return YES;
}


#pragma mark - WKUIDelegate

- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

#pragma mark - Estimated Progress KVO (WKWebView)

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == self.wkWebView) {
        [self.progressView setAlpha:1.0f];
        BOOL animated = self.wkWebView.estimatedProgress > self.progressView.progress;
        [self.progressView setProgress:self.wkWebView.estimatedProgress animated:animated];
        
        // Once complete, fade out UIProgressView
        if(self.wkWebView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    } else if ([keyPath isEqualToString:@"title"]) {
        if (object == self.wkWebView) {
            if ([self viewController] && self.showsPageTitleInNavigationBar) {
                [self viewController].title = self.wkWebView.title;
            }
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - Fake Progress Bar Control (UIWebView)

- (void)fakeProgressViewStartLoading {
    [self.progressView setProgress:0.0f animated:NO];
    [self.progressView setAlpha:1.0f];
    [self.fakeProgressTimer invalidate];
    
    self.fakeProgressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f/60.0f target:self selector:@selector(fakeProgressTimerDidFire:) userInfo:nil repeats:YES];
    
}

- (void)fakeProgressBarStopLoading {
    if(self.fakeProgressTimer) {
        [self.fakeProgressTimer invalidate];
    }
    
    if(self.progressView) {
        [self.progressView setProgress:1.0f animated:YES];
        [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self.progressView setAlpha:0.0f];
        } completion:^(BOOL finished) {
            [self.progressView setProgress:0.0f animated:NO];
        }];
    }
}


- (void)fakeProgressTimerDidFire:(id)sender {
    CGFloat increment = 0.005/(self.progressView.progress + 0.2);
    if([self.uiWebView isLoading]) {
        CGFloat progress = (self.progressView.progress < 0.75f) ? self.progressView.progress + increment : self.progressView.progress + 0.0005;
        if(self.progressView.progress < 0.95) {
            [self.progressView setProgress:progress animated:YES];
        }
    }
}


#pragma mark - External App Support

- (BOOL)externalAppRequiredToOpenURL:(NSURL *)URL {
    NSSet *validSchemes = [NSSet setWithArray:@[@"http", @"https",@"file"]];
    return ![validSchemes containsObject:URL.scheme];
}

- (void)launchExternalAppWithURL:(NSURL *)URL {
    self.URLToLaunchWithPermission = URL;
}

#pragma mark - WebView Action
- (void)reload {
    if(self.wkWebView) {
        [self.wkWebView reload];
    }
    else if(self.uiWebView) {
        [self.uiWebView reload];
    }
}

- (void)stopLoading {
    if(self.wkWebView) {
        [self.wkWebView stopLoading];
    }
    else if(self.uiWebView) {
        [self.uiWebView stopLoading];
    }
}

- (void)goBack {
    if(self.wkWebView) {
        [self.wkWebView goBack];
    }
    else if(self.uiWebView) {
        [self.uiWebView goBack];
    }
}

- (void)goForward {
    if(self.wkWebView) {
        [self.wkWebView goForward];
    }
    else if(self.uiWebView) {
        [self.uiWebView goForward];
    }
}

- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

#pragma mark - Dealloc

- (void)dealloc {
    [self.uiWebView setDelegate:nil];
    [self.wkWebView setNavigationDelegate:nil];
    [self.wkWebView setUIDelegate:nil];
    [self.wkWebView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    [self.wkWebView removeObserver:self forKeyPath:@"title"];
}

@end
