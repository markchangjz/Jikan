#import <UIKit/UIKit.h>
@import WebKit;

NS_ASSUME_NONNULL_BEGIN

@interface MKCWebViewController : UIViewController

@property (nonatomic, strong) WKWebView *webView;

- (void)loadURLString:(NSString *)URLString;

@end

NS_ASSUME_NONNULL_END
