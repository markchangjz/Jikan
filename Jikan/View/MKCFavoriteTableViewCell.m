#import "MKCFavoriteTableViewCell.h"

@interface MKCFavoriteTableViewCell()

@property (nonatomic, strong) UIStackView *mainStackView;

@end

@implementation MKCFavoriteTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.mainStackView];
        
        [self layoutViews];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UI Layout

- (void)layoutViews {
    [self.mainStackView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:10.0].active = YES;
    [self.mainStackView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-10.0].active = YES;
    [self.mainStackView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:10.0].active = YES;
    [self.mainStackView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-10.0].active = YES;
    
    [self.coverImageView.widthAnchor constraintEqualToConstant:80.0].active = YES;
    [self.coverImageView.widthAnchor constraintEqualToAnchor:self.coverImageView.heightAnchor multiplier:225.0/318.0].active = YES;
}

#pragma mark - lazy instance

- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.translatesAutoresizingMaskIntoConstraints = NO;
        _coverImageView.backgroundColor = [UIColor lightGrayColor];
    }
    return _coverImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _nameLabel.font = [UIFont boldSystemFontOfSize:18.0];
        _nameLabel.numberOfLines = 2;
    }
    return _nameLabel;
}

- (UIStackView *)mainStackView {
    if (!_mainStackView) {
        _mainStackView = [[UIStackView alloc] init];
        _mainStackView.translatesAutoresizingMaskIntoConstraints = NO;
        _mainStackView.axis = UILayoutConstraintAxisHorizontal;
        _mainStackView.alignment = UIStackViewAlignmentTop;
        _mainStackView.spacing = 10.0;
        
        [_mainStackView addArrangedSubview:self.coverImageView];
        [_mainStackView addArrangedSubview:self.nameLabel];
    }
    return _mainStackView;
}

@end
