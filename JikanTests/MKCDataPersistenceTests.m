#import <XCTest/XCTest.h>
#import "MKCDataPersistence.h"
#import "MKCFavoriteItem.h"

@interface MKCDataPersistenceTests : XCTestCase

@end

@implementation MKCDataPersistenceTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [MKCDataPersistence resetAllData];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

+ (void)tearDown {
    [MKCDataPersistence resetAllData];
}

- (void)testSavaAndRetrieveItem {
    MKCFavoriteItem *saveItem = [[MKCFavoriteItem alloc] initWithID:@"0000" title:@"item_title" image:@"item_image"];
    
    [MKCDataPersistence collectMovieWithItem:saveItem];
    
    NSArray<MKCFavoriteItem *> *retrieveItems = [MKCDataPersistence collectedMovies];
    XCTAssertEqual(retrieveItems.count, 1);
    XCTAssertEqualObjects(retrieveItems.firstObject.ID, @"0000");
    XCTAssertEqualObjects(retrieveItems.firstObject.title, @"item_title");
    XCTAssertEqualObjects(retrieveItems.firstObject.image, @"item_image");
}

- (void)testSavaAndRetrieveItems {
    MKCFavoriteItem *saveItem1 = [[MKCFavoriteItem alloc] initWithID:@"0000" title:@"item1_title" image:@"item1_image"];
    MKCFavoriteItem *saveItem2 = [[MKCFavoriteItem alloc] initWithID:@"1111" title:@"item2_title" image:@"item2_image"];
    
    [MKCDataPersistence collectMovieWithItem:saveItem1];
    [MKCDataPersistence collectMovieWithItem:saveItem2];
    
    NSArray<MKCFavoriteItem *> *retrieveItems = [MKCDataPersistence collectedMovies];
    XCTAssertEqual(retrieveItems.count, 2);
    XCTAssertEqualObjects(retrieveItems[0].ID, @"0000");
    XCTAssertEqualObjects(retrieveItems[0].title, @"item1_title");
    XCTAssertEqualObjects(retrieveItems[0].image, @"item1_image");
    XCTAssertEqualObjects(retrieveItems[1].ID, @"1111");
    XCTAssertEqualObjects(retrieveItems[1].title, @"item2_title");
    XCTAssertEqualObjects(retrieveItems[1].image, @"item2_image");
}

- (void)testRemoveItem {
    MKCFavoriteItem *item = [[MKCFavoriteItem alloc] initWithID:@"0000" title:@"item_title" image:@"item_image"];
    
    [MKCDataPersistence collectMovieWithItem:item];
    [MKCDataPersistence removeCollectedMovieWithTrackId:@"0000"];
    
    NSArray<MKCFavoriteItem *> *retrieveItems = [MKCDataPersistence collectedMovies];
    XCTAssertEqual(retrieveItems.count, 0);
}

- (void)testRemoveNotExistItem {
    MKCFavoriteItem *item = [[MKCFavoriteItem alloc] initWithID:@"0000" title:@"item_title" image:@"item_image"];

    [MKCDataPersistence collectMovieWithItem:item];
    [MKCDataPersistence removeCollectedMovieWithTrackId:@"1111"];
    
    NSArray<MKCFavoriteItem *> *retrieveItems = [MKCDataPersistence collectedMovies];
    XCTAssertEqual(retrieveItems.count, 1);
    XCTAssertEqualObjects(retrieveItems.firstObject.ID, @"0000");
    XCTAssertEqualObjects(retrieveItems.firstObject.title, @"item_title");
    XCTAssertEqualObjects(retrieveItems.firstObject.image, @"item_image");
}

- (void)testItemIDIsExist {
    MKCFavoriteItem *item1 = [[MKCFavoriteItem alloc] initWithID:@"0000" title:@"item1_title" image:@"item1_image"];
    MKCFavoriteItem *item2 = [[MKCFavoriteItem alloc] initWithID:@"1111" title:@"item2_title" image:@"item2_image"];
    
    [MKCDataPersistence collectMovieWithItem:item1];
    [MKCDataPersistence collectMovieWithItem:item2];
    
    BOOL isExist = [MKCDataPersistence hasCollectdMovieWithTrackId:@"1111"];
    XCTAssertTrue(isExist);
}

- (void)testItemIDIsNotExist {
    MKCFavoriteItem *item1 = [[MKCFavoriteItem alloc] initWithID:@"0000" title:@"item1_title" image:@"item1_image"];
    MKCFavoriteItem *item2 = [[MKCFavoriteItem alloc] initWithID:@"1111" title:@"item2_title" image:@"item2_image"];
    
    [MKCDataPersistence collectMovieWithItem:item1];
    [MKCDataPersistence collectMovieWithItem:item2];
    
    BOOL isExist = [MKCDataPersistence hasCollectdMovieWithTrackId:@"3333"];
    XCTAssertFalse(isExist);
}

@end
