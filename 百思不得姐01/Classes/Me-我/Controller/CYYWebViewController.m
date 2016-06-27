//
//  CYYWebViewController.m
//  百思不得姐01
//
//  Created by ma c on 16/5/12.
//  Copyright © 2016年 ma c. All rights reserved.
//

#import "CYYWebViewController.h"
#import "NJKWebViewProgress.h"

@interface CYYWebViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goBackItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goForwardItem;
/**进度代理对象*/
@property (nonatomic, strong) NJKWebViewProgress *progress;

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@end

@implementation CYYWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.progress = [[NJKWebViewProgress alloc] init];
    self.webView.delegate = self.progress;
    
    __weak typeof (self)  weakSelf = self;
    self.progress.progressBlock = ^(float progress){
        weakSelf.progressView.progress = progress;
        
        weakSelf.progressView.hidden = (progress == 1.0);
    };
    
    self.progress.webViewProxyDelegate = self;
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}
- (IBAction)refresh:(id)sender {
    [self.webView reload];
    
}
- (IBAction)goBack:(id)sender {
    [self.webView goBack];
    
}
- (IBAction)goForward:(id)sender {
    
    [self.webView goForward];
}

#pragma mark- UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.goBackItem.enabled = webView.canGoBack;
    self.goForwardItem.enabled = webView.canGoForward;
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
