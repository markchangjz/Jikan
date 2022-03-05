#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCFavoriteItem : NSObject <NSCoding, NSSecureCoding>

- (instancetype)initWithID:(NSString *)ID title:(NSString *)title image:(NSString *)image;

@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *image;

@end

NS_ASSUME_NONNULL_END
