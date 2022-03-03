#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void (^MKCSuccessHandler)(NSURLResponse *response, id responseObject);
typedef void (^MKCFailureHandler)(NSError *error);

typedef NS_ENUM(NSUInteger, JikanType) {
    JikanTypeAnime,
    JikanTypeManga,
};

typedef NS_ENUM(NSUInteger, JikanAnimeSubtype) {
    JikanAnimeSubtypeAiring,
    JikanAnimeSubtypeUpcoming,
    JikanAnimeSubtypeTv,
    JikanAnimeSubtypeMovie,
    JikanAnimeSubtypeOva,
    JikanAnimeSubtypeSpecial,
    JikanAnimeSubtypeBypopularity,
    JikanAnimeSubtypeFavorite,
};

typedef NS_ENUM(NSUInteger, JikanMangaSubtype) {
    JikanMangaSubtypeManga,
    JikanMangaSubtypeNovels,
    JikanMangaSubtypeOneshots,
    JikanMangaSubtypeDoujin,
    JikanMangaSubtypeManhwa,
    JikanMangaSubtypeManhua,
    JikanMangaSubtypeBypopularity,
    JikanMangaSubtypeFavorite,
};

@interface MKCRequestAPI : NSObject

+ (MKCRequestAPI *)sharedAPI;
+ (AFURLSessionManager *)sessionManager;

- (NSURLSessionDataTask *)topWithType:(NSString *)type subtype:(NSString *)subtype page:(NSInteger)page successHandler:(MKCSuccessHandler)successHandler failureHandler:(MKCFailureHandler)failureHandler;

@end
