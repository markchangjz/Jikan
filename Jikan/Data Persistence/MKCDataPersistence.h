#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const MKCCollectedMoviesKey;

@interface MKCDataPersistence : NSObject

#pragma mark - movie

+ (void)collectMovieWithTrackId:(nonnull NSString *)trackId info:(nonnull NSDictionary *)info;
+ (void)removeCollectedMovieWithTrackId:(nonnull NSString *)trackId;
+ (BOOL)hasCollectdMovieWithTrackId:(nonnull NSString *)trackId;

@end

NS_ASSUME_NONNULL_END
