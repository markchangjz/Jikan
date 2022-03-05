#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void (^MKCSuccessHandler)(NSURLResponse *response, id responseObject);
typedef void (^MKCFailureHandler)(NSError *error);

@interface MKCRequestAPI : NSObject

+ (MKCRequestAPI *)sharedAPI;
+ (AFURLSessionManager *)sessionManager;

- (NSURLSessionDataTask *)topWithType:(NSString *)type subtype:(NSString *)subtype page:(NSInteger)page successHandler:(MKCSuccessHandler)successHandler failureHandler:(MKCFailureHandler)failureHandler;

@end
