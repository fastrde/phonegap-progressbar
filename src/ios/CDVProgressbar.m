#import "CDVProgressbar.h"
#import <Cordova/CDV.h>

@implementation CDVProgressbar

- (void)pluginInitialize
{
    NSLog(@"PluginInitialize");
    [self initProgressBarFrame];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onWebViewDidFinishLoad:)name:@"InjectWebViewDidFinishLoad" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onWebViewDidStartLoad:)name:@"InjectWebViewDidStartLoad" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDidFailLoadWithError:)name:@"InjectDidFailLoadWithError" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onViewDidLayoutSubviews:)name:@"InjectViewDidLayoutSubviews" object:nil];
    
}

- (void)initProgressBarFrame
{
    self.progressBar=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"progressbar" ofType:@"html" inDirectory:@"www"]]];
    [self.progressBar loadRequest:urlRequest];
}

- (void)onViewDidLayoutSubviews:(NSNotification *)notification{
    NSLog(@"onViewDidLayoutSubviews");
    UIViewController *rootViewController = [[[[UIApplication sharedApplication] delegate] window]rootViewController];
    self.progressBar.frame = CGRectMake(0, 0, rootViewController.view.frame.size.width, 2);
}

- (void)onWebViewDidFinishLoad:(NSNotification *)notification
{
    NSLog(@"onWebViewDidFinishLoad");
    //UIWebView* theWebView = notification.userInfo[@"webView"];
    [self.progressBar stringByEvaluatingJavaScriptFromString:@"finishBar();clearInterval(IntervalId);"];
    [self.progressBar performSelector:@selector(removeFromSuperview) withObject:self afterDelay:0.5];
    
}
- (void)onWebViewDidStartLoad:(NSNotification *)notification
{
    UIViewController *rootViewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    NSLog(@"onWebViewDidStartLoad");
    //UIWebView* theWebView = notification.userInfo[@"webView"];
    [rootViewController.view addSubview:self.progressBar];
    [self.progressBar stringByEvaluatingJavaScriptFromString:@"resetBar();runTick();"];
}


- (void)onDidFailLoadWithError:(NSNotification *)notification
{
    NSLog(@"onDidFailLoadWithError");
    //NSError* error = notification.userInfo[@"error"];
    [self.progressBar performSelector:@selector(removeFromSuperview) withObject:self afterDelay:0.0];
}

@end
