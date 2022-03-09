#import <Foundation/Foundation.h>
@class MKCTopEntityModel;

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(FavoriteItem)
@interface MKCFavoriteItem : NSObject <NSCoding, NSSecureCoding>

- (instancetype)initWithTopItem:(MKCTopEntityModel *)topItem;

@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) NSString *url;

@end

NS_ASSUME_NONNULL_END
