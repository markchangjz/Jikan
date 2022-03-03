#import "MKCRequestAPI.h"
#import "MKCRequestAPI+Private.h"
#import "MKCURLGuide.h"

@implementation MKCRequestAPI

+ (MKCRequestAPI *)sharedAPI {
	static MKCRequestAPI *instance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instance = [[MKCRequestAPI alloc] init];
	});
	return instance;
}

+ (AFURLSessionManager *)sessionManager {
	static AFHTTPSessionManager *instance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instance = [AFHTTPSessionManager manager];
	});
	return instance;
}

- (NSURLSessionDataTask *)topWithType:(NSString *)type subtype:(NSString *)subtype page:(NSInteger)page successHandler:(MKCSuccessHandler)successHandler failureHandler:(MKCFailureHandler)failureHandler {
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%ld/%@", MKCURLGuide.top, type, (long)page, subtype];
    NSMutableURLRequest *request = [self in_requestWithURLString:urlString method:@"GET" parameters:nil];
    NSURLSessionDataTask *dataTask = [self in_fireAPIWithRequest:request successHandler:successHandler failureHandler:failureHandler];
    return dataTask;
}

@end
