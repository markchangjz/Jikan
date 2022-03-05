#import "MKCUnitTestHelper.h"

@implementation MKCUnitTestHelper

+ (id)apiResponseObjectFromJsonFileName:(NSString *)fileName {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *filePath = [bundle pathForResource:fileName ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    id responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    return responseObject;
}

+ (void)waitWithInterval:(NSTimeInterval)interval {
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
}

@end
