#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void (^MKCSuccessHandler)(NSURLResponse *response, id responseObject) NS_SWIFT_NAME(SuccessHandler);
typedef void (^MKCFailureHandler)(NSError *error) NS_SWIFT_NAME(FailureHandler);

NS_SWIFT_NAME(RequestAPI)
@interface MKCRequestAPI : NSObject

+ (MKCRequestAPI *)sharedAPI;
+ (AFURLSessionManager *)sessionManager;

- (NSURLSessionDataTask *)topWithType:(NSString *)type subtype:(NSString *)subtype page:(NSInteger)page successHandler:(MKCSuccessHandler)successHandler failureHandler:(MKCFailureHandler)failureHandler;

@end
