//
//  ViewController.m
//  WKWebViewWithJS
//
//  Created by CXDAY-32 on 2017/12/22.
//  Copyright © 2017年 play. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
@interface ViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>


@property (weak, nonatomic) IBOutlet WKWebView *wkWebView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 讀取 local 資料時的用法
    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"Calaulator" ofType:@"html"];
    NSURL * filePathUrl = [NSURL fileURLWithPath:filePath];
    // 讀取網頁的用法
    //    NSURL * fileurl = [NSURL URLWithString:@"https://www.google.com"];
    NSURLRequest * fileRequest = [NSURLRequest requestWithURL:filePathUrl];
    
    self.wkWebView.UIDelegate = self;
    self.wkWebView.navigationDelegate = self;
    // js 在要交流的地方加上 window.webkit.messageHandlers.autoLayout.postMessage(參數);
    [self.wkWebView.configuration.userContentController addScriptMessageHandler:self name:@"autoLayout"];
    [self.wkWebView loadRequest:fileRequest];
    
}
-(void)viewDidAppear:(BOOL)animated{
    
}
- (IBAction)xcodeUseJsFunction:(id)sender {
    // 讓 WKWebView 使用 javaScript 語法 影響 JavaScript，也可調用 JavaScript 的方法
    NSString * callJSFunc = @"sayHi()";
    
    [self.wkWebView evaluateJavaScript:callJSFunc completionHandler:^(id _Nullable value, NSError * _Nullable error) {
        if (error) {
            NSLog(@"get javaScript func error");
        }
        NSLog(@"get Value : %@ , error : %@",value,error.localizedDescription);
        
    }];
}
- (IBAction)xcodeUseJsCode:(id)sender {
    // 讓 WKWebView 使用 javaScript 語法 影響 JavaScript，也可調用 JavaScript 的方法
    
    NSString * callJs = @"    document.getElementById('total2').value = 'Xcode';";
    [self.wkWebView evaluateJavaScript:callJs completionHandler:^(id _Nullable value, NSError * _Nullable error) {
        if (error) {
            NSLog(@"get javaScript func error");
        }
        NSLog(@"get Value : %@ , error : %@",value,error.localizedDescription);
        
    }];
}



#pragma mark - Wk WebView Delegate
// 準備Load
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"WKWebView Load 準備");
}
// 開始 Load
-(void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    NSLog(@"WKWebView Load 開始");
}
// 完成 Load
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"WKWebView Load 完畢");
}
// Load 失敗
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"wkWebView 讀取 Web 失敗：%@",error.localizedDescription);
}
-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"wkWebView 讀取 Web 失敗：%@",error.localizedDescription);
}

// 收到請求後跳轉
-(void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 收到請求後，決定是否要跳轉
-(void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    decisionHandler(WKNavigationResponsePolicyAllow);
    NSLog(@"WKWebView 收到請求後，決定是否要跳轉");
}
// 收到請求前是否要跳轉
-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    // 允許跳轉
    decisionHandler(WKNavigationActionPolicyAllow);
    
    NSLog(@"WKWebView 收到請求前，決定是否要跳轉");
}

#pragma mark - WKWebView UIDelegate
// 建立新的 WkWebView
//-(WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
//    if (!navigationAction.targetFrame.isMainFrame) {
//
//    }
//}

/**
 WebView 介面跳出警告視窗時使用
 @param webView 簽Delegate 的 WkWebView
 @param message Alert 的 message
 @param frame 跳出的 Alert Frame 訊息
 @param completionHandler Alert 完成時的動作
 */
-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    
    NSLog(@"WkWebView Alert message : %@",message);
    NSLog(@"WkWebView Alert Frame Info :%@",frame);
    NSLog(@"跳出警告視窗");
    //    completionHandler();
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * ok = [UIAlertAction actionWithTitle:@"OK" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

/**
 顯示有輸入框的Alert
 
 @param webView 簽訂 Delegate 的 WkWebView
 @param prompt Alert Message 訊息
 @param defaultText 文字框輸入的訊息
 @param frame Alert info
 @param completionHandler 完成後要處理的事，一般是傳送輸入的字
 */
-(void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    NSLog(@"Prompt Text : %@",prompt);
    NSLog(@"Default Text : %@",defaultText);
    NSLog(@"Text Input Alert info : %@",frame);
    NSLog(@"跳出輸入框");
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"" message:prompt preferredStyle:(UIAlertControllerStyleAlert)];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
    }];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"Cancel" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(nil);
    }];
    UIAlertAction * ok = [UIAlertAction actionWithTitle:@"OK" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        NSString * text = alert.textFields.firstObject.text;
        completionHandler(text);
    }];
    [alert addAction:cancel];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

/**
 顯示 確認 Alert
 
 @param webView 簽訂 Delegate 的 WkWebView
 @param message Alert Message 訊息
 @param frame Alert info
 @param completionHandler 完成後要處理的事，一般是確認後得處理
 */
-(void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    NSLog(@"panel message : %@",message);
    NSLog(@"panel Frame Info %@",frame);
    completionHandler(YES);
}
#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSLog(@"取得javaScript 的 send name : %@",message.name);
    NSLog(@"取得javaScript 的 Message : %@",message.body);
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:NO];
    // 移除與 javascript 的交互對象，避免 memory leak
    [self.wkWebView.configuration.userContentController removeScriptMessageHandlerForName:@"autoLayout"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
