#import "MKCDataPersistence.h"

NSString *const MKCCollectedMoviesKey = @"MKCCollectedMoviesKey";

@implementation MKCDataPersistence

+ (NSUserDefaults *)userDefaults {
	return [NSUserDefaults standardUserDefaults];
}

#pragma mark - movie

+ (void)collectMovieWithTrackId:(nonnull NSString *)trackId info:(nonnull NSDictionary *)info {
    NSMutableDictionary *collectedMovies = [[NSMutableDictionary alloc] initWithDictionary:[self.userDefaults dictionaryForKey:MKCCollectedMoviesKey]];
    collectedMovies[trackId] = info;
    [self.userDefaults setObject:collectedMovies forKey:MKCCollectedMoviesKey];
}

+ (void)removeCollectedMovieWithTrackId:(NSString *)trackId {
    NSMutableDictionary *collectedMovies = [[NSMutableDictionary alloc] initWithDictionary:[self.userDefaults dictionaryForKey:MKCCollectedMoviesKey]];
    [collectedMovies removeObjectForKey:trackId];
    [self.userDefaults setObject:collectedMovies forKey:MKCCollectedMoviesKey];
}

+ (BOOL)hasCollectdMovieWithTrackId:(NSString *)trackId {
    NSMutableDictionary *collectedMovies = [[NSMutableDictionary alloc] initWithDictionary:[self.userDefaults dictionaryForKey:MKCCollectedMoviesKey]];
    return [collectedMovies.allKeys containsObject:trackId];
}

+ (NSDictionary<NSString *, NSDictionary<NSString *, NSString *> *> *)collectedMovies {
    NSDictionary *collectedMovies = [self.userDefaults dictionaryForKey:MKCCollectedMoviesKey];
    return collectedMovies;
}

@end
