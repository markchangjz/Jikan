#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const MKCCollectedMoviesKey;
extern NSString *const MKCCollectedMovieDidChangeNotification;

@interface MKCDataPersistence : NSObject

#pragma mark - movie

+ (void)collectMovieWithTrackId:(nonnull NSString *)trackId info:(nonnull NSDictionary *)info;
+ (void)removeCollectedMovieWithTrackId:(nonnull NSString *)trackId;
+ (BOOL)hasCollectdMovieWithTrackId:(nonnull NSString *)trackId;
+ (NSDictionary<NSString *, NSDictionary<NSString *, NSString *> *> *)collectedMovies;

@end

NS_ASSUME_NONNULL_END
