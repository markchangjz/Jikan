#import "MKCTopRatedTableViewCell.h"
#import "Jikan-Swift.h"
#import "UIImageView+WebCache.h"

@interface MKCTopRatedTableViewCell()

@property (nonatomic, strong) UIStackView *mainStackView;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIStackView *contentStackView;
@property (nonatomic, strong) UIButton *collectionButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *rankLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *startDateLabel;
@property (nonatomic, strong) UILabel *endDateLabel;

@end

@implementation MKCTopRatedTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {		
		[self.contentView addSubview:self.mainStackView];
		
		[self layoutMainStackView];
		[self layoutCoverImageView];
		[self layoutCollectionButton];
        [self configureContentStackView];
	}
	return self;
}

- (void)configureWithModel:(MKCTopEntityModel *)model {
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:model.image]];
    self.titleLabel.text = model.title ?: @"unspecified";
    self.rankLabel.text = [NSString stringWithFormat:@"Ranked #%ld", (long)model.rank];
    self.typeLabel.text = [NSString stringWithFormat:@" %@ ", model.type ?: @"unspecified"];
    self.startDateLabel.text = [NSString stringWithFormat:@"Start Date %@", model.startDate ?: @"unspecified"];
    self.endDateLabel.text = [NSString stringWithFormat:@"End Date %@", model.endDate ?: @"unspecified"];
}

#pragma mark - binding

- (void)setIsCollected:(BOOL)isCollected {
	_isCollected = isCollected;
	
	if (isCollected) {
		[self.collectionButton setImage:[UIImage imageNamed:@"collected"] forState:UIControlStateNormal];
	} else {
		[self.collectionButton setImage:[UIImage imageNamed:@"not_collected"] forState:UIControlStateNormal];
	}
}

#pragma mark - IBAction

- (void)collect:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(tableViewCell:collectItemAtIndex:)]) {
        [self.delegate tableViewCell:self collectItemAtIndex:self.tag];
    }
}

#pragma mark - UI Layout

- (void)layoutMainStackView {
	[self.mainStackView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:10.0].active = YES;
	[self.mainStackView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-10.0].active = YES;
	[self.mainStackView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:10.0].active = YES;
	[self.mainStackView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-10.0].active = YES;
}

- (void)layoutCoverImageView {
	[self.coverImageView.widthAnchor constraintEqualToConstant:80.0].active = YES;
    [self.coverImageView.widthAnchor constraintEqualToAnchor:self.coverImageView.heightAnchor multiplier:225.0/318.0].active = YES;
}

- (void)layoutCollectionButton {
	[self.collectionButton.widthAnchor constraintEqualToConstant:30.0].active = YES;
	[self.collectionButton.heightAnchor constraintEqualToConstant:30.0].active = YES;
}

- (void)configureContentStackView {
    [self.contentStackView addArrangedSubview:self.titleLabel];
    [self.contentStackView addArrangedSubview:self.rankLabel];
    [self.contentStackView addArrangedSubview:self.typeLabel];
    [self.contentStackView addArrangedSubview:self.startDateLabel];
    [self.contentStackView addArrangedSubview:self.endDateLabel];
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

- (UIButton *)collectionButton {
	if (!_collectionButton) {
		_collectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
		_collectionButton.translatesAutoresizingMaskIntoConstraints = NO;
		[_collectionButton setImage:[UIImage imageNamed:@"not_collected"] forState:UIControlStateNormal];
        [_collectionButton addTarget:self action:@selector(collect:) forControlEvents:UIControlEventTouchUpInside];
	}
	return _collectionButton;
}

- (UIStackView *)mainStackView {
	if (!_mainStackView) {
		_mainStackView = [[UIStackView alloc] init];
		_mainStackView.translatesAutoresizingMaskIntoConstraints = NO;
		_mainStackView.axis = UILayoutConstraintAxisHorizontal;
		_mainStackView.alignment = UIStackViewAlignmentTop;
		_mainStackView.spacing = 10.0;
        
		[_mainStackView addArrangedSubview:self.coverImageView];
		[_mainStackView addArrangedSubview:self.contentStackView];
		[_mainStackView addArrangedSubview:self.collectionButton];
	}
	return _mainStackView;
}

- (UIStackView *)contentStackView {
	if (!_contentStackView) {
		_contentStackView = [[UIStackView alloc] init];
		_contentStackView.translatesAutoresizingMaskIntoConstraints = NO;
		_contentStackView.axis = UILayoutConstraintAxisVertical;
		_contentStackView.alignment = UIStackViewAlignmentLeading;
		_contentStackView.spacing = 2.0;
	}
	return _contentStackView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

- (UILabel *)rankLabel {
    if (!_rankLabel) {
        _rankLabel = [[UILabel alloc] init];
        _rankLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _rankLabel.font = [UIFont systemFontOfSize:14.0];
        _rankLabel.numberOfLines = 1;
    }
    return _rankLabel;
}

- (UILabel *)typeLabel {
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _typeLabel.font = [UIFont systemFontOfSize:14.0];
        _typeLabel.numberOfLines = 1;
        _typeLabel.layer.borderColor = [UIColor systemGrayColor].CGColor;
        _typeLabel.layer.borderWidth = 0.5;
    }
    return _typeLabel;
}

- (UILabel *)startDateLabel {
    if (!_startDateLabel) {
        _startDateLabel = [[UILabel alloc] init];
        _startDateLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _startDateLabel.font = [UIFont systemFontOfSize:14.0];
        _startDateLabel.numberOfLines = 1;
    }
    return _startDateLabel;
}

- (UILabel *)endDateLabel {
    if (!_endDateLabel) {
        _endDateLabel = [[UILabel alloc] init];
        _endDateLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _endDateLabel.font = [UIFont systemFontOfSize:14.0];
        _endDateLabel.numberOfLines = 1;
    }
    return _endDateLabel;
}

@end
