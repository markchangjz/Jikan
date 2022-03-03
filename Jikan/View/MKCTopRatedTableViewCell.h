#import <UIKit/UIKit.h>
#import "MKCBasicTableViewCell.h"
@class MKCTopEntityModel;

@interface MKCTopRatedTableViewCell : MKCBasicTableViewCell

@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIStackView *contentStackView;
@property (nonatomic, strong) UIButton *collectionButton;
@property (nonatomic, assign) BOOL isCollected;

- (void)configureWithModel:(MKCTopEntityModel *)model;

@end
