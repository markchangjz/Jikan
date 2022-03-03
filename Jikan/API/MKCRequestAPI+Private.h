#import "MKCRequestAPI.h"

@interface MKCRequestAPI (Private)

- (NSMutableURLRequest *)in_requestWithURLString:(NSString *)URLString method:(NSString *)method parameters:(NSDictionary *)parameters;

- (NSURLSessionDataTask *)in_fireAPIWithRequest:(NSURLRequest *)request successHandler:(void (^)(NSURLResponse * response, id responseObject))successHandler failureHandler:(void (^)(NSError *))failureHandler;

@end
