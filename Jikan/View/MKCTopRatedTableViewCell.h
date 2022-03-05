#import <UIKit/UIKit.h>
#import "MKCBasicTableViewCell.h"
@class MKCTopEntityModel;

@interface MKCTopRatedTableViewCell : MKCBasicTableViewCell

@property (nonatomic, assign) BOOL isCollected;

- (void)configureWithModel:(MKCTopEntityModel *)model;

@end
