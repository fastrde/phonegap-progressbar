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
    NSString* html = @"<html><head><style>*{padding:0px;margin:0px;} #progress {width: 100%;position: relative;padding: 0px;} #bar {height: 2px;background-color: green;}</style></head><body><div id=\"progress\"><div id=\"bar\" style=\"width:5%%\"></div></div><script type=\"text/javascript\">var IntervalId = null;function tick(){var p = document.getElementById('bar').style.width; p=parseInt(p.replace(/%/,\"\"));if (p > 90) return;p=(p+2)+\"%\"; document.getElementById('bar').style.width=p;};function resetBar(){document.getElementById('bar').style.width = \"5%\";};function finishBar(){document.getElementById('bar').style.width = \"100%\";};function runTick(){IntervalId = setInterval(tick, 20);}</script></body></html>";
    [self.progressBar loadHTMLString:html baseURL:nil];
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
