#import "MKCFavoriteItem.h"

@implementation MKCFavoriteItem

- (instancetype)initWithID:(NSString *)ID title:(NSString *)title image:(NSString *)image {
    self = [super init];
    if (self) {
        self.ID = ID;
        self.title = title;
        self.image = image;
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
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        self.ID = [decoder decodeObjectForKey:@"ID"];
        self.title = [decoder decodeObjectForKey:@"title"];
        self.image = [decoder decodeObjectForKey:@"image"];
    }
    return self;
}

@end
