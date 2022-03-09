#import <UIKit/UIKit.h>
#import "MKCBasicTableViewCell.h"
@class MKCTopEntityModel;
@class MKCTopRatedTableViewCell;

NS_SWIFT_NAME(TopRatedTableViewCellDelegate)
@protocol MKCTopRatedTableViewCellDelegate <NSObject>

- (void)tableViewCell:(MKCTopRatedTableViewCell *)topRatedTableViewCell collectItemAtIndex:(NSInteger)index;

@end

NS_SWIFT_NAME(TopRatedTableViewCell)
@interface MKCTopRatedTableViewCell : MKCBasicTableViewCell

@property (nonatomic, weak) id<MKCTopRatedTableViewCellDelegate> delegate;
@property (nonatomic, assign) BOOL isCollected;

- (void)configureWithModel:(MKCTopEntityModel *)model;

@end
