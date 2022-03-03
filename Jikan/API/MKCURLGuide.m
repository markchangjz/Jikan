#import "MKCURLGuide.h"

@implementation MKCURLGuide

+ (NSString *)jikanHost {
	return @"https://api.jikan.moe/v3";
}

+ (NSString *)top {
	return [NSString stringWithFormat:@"%@/top", self.jikanHost];
}

@end
