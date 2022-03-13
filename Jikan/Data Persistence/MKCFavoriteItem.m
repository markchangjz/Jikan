#import "MKCFavoriteItem.h"
#import "Jikan-Swift.h"

@implementation MKCFavoriteItem

- (instancetype)initWithTopItem:(MKCTopEntityModel *)topItem {
    self = [super init];
    if (self) {
        _ID = [NSString stringWithFormat:@"%ld", (long)topItem.id];
        _title = topItem.title;
        _image = topItem.image;
        _url = topItem.url;
    }
    return self;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.ID forKey:@"ID"];
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.image forKey:@"image"];
    [encoder encodeObject:self.url forKey:@"url"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        _ID = [decoder decodeObjectForKey:@"ID"];
        _title = [decoder decodeObjectForKey:@"title"];
        _image = [decoder decodeObjectForKey:@"image"];
        _url = [decoder decodeObjectForKey:@"url"];
    }
    return self;
}

@end
