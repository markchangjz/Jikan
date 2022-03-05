#import "MKCWebViewController.h"

@interface MKCWebViewController ()

@property (nonatomic, strong) UIBarButtonItem *closeBarButtonItem;

@end

@implementation MKCWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self configureView];
	
	// get web view title
	[self.webView addObserver:self forKeyPath:NSStringFromSelector(@selector(title)) options:NSKeyValueObservingOptionNew context:nil];
}

- (void)dealloc {
	[_webView removeObserver:self forKeyPath:NSStringFromSelector(@selector(title)) context:nil];
}

- (void)loadURLString:(NSString *)URLString {
	NSURL *URL = [NSURL URLWithString:URLString];
	NSURLRequest *request = [NSURLRequest requestWithURL:URL];
	[self.webView loadRequest:request];
}

#pragma mark - IBAction

- (void)dismissView:(UIBarButtonItem *)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UI layout

- (void)configureView {
	self.view.backgroundColor = [UIColor systemBackgroundColor];
	
	self.navigationItem.leftBarButtonItem = self.closeBarButtonItem;
	
	[self.view addSubview:self.webView];
	[self layoutWebView];
}

- (void)layoutWebView {
    [self.webView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor].active = YES;
	[self.webView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
	[self.webView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
	[self.webView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
	
	if ([keyPath isEqualToString:@"title"]) {
		self.title = self.webView.title;
	}
}

#pragma mark - lazy instance

- (WKWebView *)webView {
	if (!_webView) {
		WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
		_webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
		_webView.translatesAutoresizingMaskIntoConstraints = NO;
		_webView.opaque = NO;
	}
	return _webView;
}

- (UIBarButtonItem *)closeBarButtonItem {
	if (!_closeBarButtonItem) {
		_closeBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(dismissView:)];
	}
	return _closeBarButtonItem;
}

@end
