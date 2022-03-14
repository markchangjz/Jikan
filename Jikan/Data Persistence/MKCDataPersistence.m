#import "MKCDataPersistence.h"

NSString *const MKCCollectedMoviesKey = @"MKCCollectedMoviesKey";
NSString *const MKCCollectedMovieDidChangeNotification = @"MKCCollectedMovieDidChangeNotification";

@implementation MKCDataPersistence

+ (NSUserDefaults *)userDefaults {
	return [NSUserDefaults standardUserDefaults];
}

+ (void)resetAllData {
    NSDictionary *dict = [self.userDefaults dictionaryRepresentation];
    for (id key in dict) {
        [self.userDefaults removeObjectForKey:key];
    }
}

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
    NSSet *set = [NSSet setWithArray:@[[NSArray class], [MKCFavoriteItem class], [NSString class]]];
    NSArray<MKCFavoriteItem *> *object = [NSKeyedUnarchiver unarchivedObjectOfClasses:set fromData:encodedObject error:nil];
    return object;
}

@end
