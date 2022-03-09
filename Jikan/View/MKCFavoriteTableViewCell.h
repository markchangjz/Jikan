#import <UIKit/UIKit.h>
#import "MKCBasicTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(FavoriteTableViewCell)
@interface MKCFavoriteTableViewCell : MKCBasicTableViewCell

@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *nameLabel;

@end

NS_ASSUME_NONNULL_END
