#import "MKCDataPersistence.h"

NSString *const MKCCollectedMoviesKey = @"MKCCollectedMoviesKey";
NSString *const MKCCollectedMovieDidChangeNotification = @"MKCCollectedMovieDidChangeNotification";

@implementation MKCDataPersistence

+ (NSUserDefaults *)userDefaults {
	return [NSUserDefaults standardUserDefaults];
}

#pragma mark - movie

+ (void)collectMovieWithItem:(MKCFavoriteItem *)item {
    NSMutableArray *collectedMovies = [[NSMutableArray alloc] initWithArray:[self collectedMovies]];
    [collectedMovies addObject:item];
    
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:collectedMovies requiringSecureCoding:YES error:nil];
    [self.userDefaults setObject:encodedObject forKey:MKCCollectedMoviesKey];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MKCCollectedMovieDidChangeNotification object:nil];
}

+ (void)removeCollectedMovieWithTrackId:(NSString *)trackId {
    NSMutableArray<MKCFavoriteItem *> *collectedMovies = [[NSMutableArray alloc] initWithArray:[self collectedMovies]];
    
    NSIndexSet *indexSet = [collectedMovies indexesOfObjectsPassingTest:^BOOL(MKCFavoriteItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [obj.ID isEqualToString:trackId];
    }];
    [collectedMovies removeObjectsAtIndexes:indexSet];
    
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:collectedMovies requiringSecureCoding:YES error:nil];
    [self.userDefaults setObject:encodedObject forKey:MKCCollectedMoviesKey];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MKCCollectedMovieDidChangeNotification object:nil];
}

+ (BOOL)hasCollectdMovieWithTrackId:(NSString *)trackId {
    NSMutableArray<MKCFavoriteItem *> *collectedMovies = [[NSMutableArray alloc] initWithArray:[self collectedMovies]];
 
    NSIndexSet *indexSet = [collectedMovies indexesOfObjectsPassingTest:^BOOL(MKCFavoriteItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [obj.ID isEqualToString:trackId];
    }];
    
    return indexSet.count == 1;
}

+ (NSArray<MKCFavoriteItem *> *)collectedMovies {
    NSData *encodedObject = [self.userDefaults objectForKey:MKCCollectedMoviesKey];
    NSArray *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return object;
}

@end
