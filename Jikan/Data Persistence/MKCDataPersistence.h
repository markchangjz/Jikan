#import <Foundation/Foundation.h>
#import "MKCFavoriteItem.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString *const MKCCollectedMoviesKey;
extern NSString *const MKCCollectedMovieDidChangeNotification;

@interface MKCDataPersistence : NSObject

+ (void)resetAllData;

+ (void)collectMovieWithItem:(MKCFavoriteItem *)item;
+ (void)removeCollectedMovieWithTrackId:(nonnull NSString *)trackId;
+ (BOOL)hasCollectdMovieWithTrackId:(nonnull NSString *)trackId;
+ (NSArray<MKCFavoriteItem *> *)collectedMovies;

@end

NS_ASSUME_NONNULL_END
