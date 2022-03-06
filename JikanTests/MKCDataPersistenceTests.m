#import <XCTest/XCTest.h>
#import "MKCDataPersistence.h"
#import "MKCFavoriteItem.h"
#import "Jikan-Swift.h"

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
    MKCTopEntityModel *item = [[MKCTopEntityModel alloc] initWithId:11111
                                                              image:@"item_image"
                                                              title:@"item_title"
                                                               rank:5
                                                          startDate:@"item_startDate"
                                                            endDate:@"item_endDate"
                                                               type:@"item_type"
                                                                url:@"item_url"];
    MKCFavoriteItem *saveItem = [[MKCFavoriteItem alloc] initWithTopItem:item];
    
    [MKCDataPersistence collectMovieWithItem:saveItem];
    
    NSArray<MKCFavoriteItem *> *retrieveItems = [MKCDataPersistence collectedMovies];
    XCTAssertEqual(retrieveItems.count, 1);
    XCTAssertEqualObjects(retrieveItems.firstObject.ID, @"11111");
    XCTAssertEqualObjects(retrieveItems.firstObject.image, @"item_image");
    XCTAssertEqualObjects(retrieveItems.firstObject.title, @"item_title");
    XCTAssertEqualObjects(retrieveItems.firstObject.url, @"item_url");
}

- (void)testSavaAndRetrieveItems {
    MKCTopEntityModel *item1 = [[MKCTopEntityModel alloc] initWithId:11111
                                                              image:@"item_image"
                                                              title:@"item_title"
                                                               rank:5
                                                          startDate:@"item_startDate"
                                                            endDate:@"item_endDate"
                                                               type:@"item_type"
                                                                url:@"item_url"];
    MKCFavoriteItem *saveItem1 = [[MKCFavoriteItem alloc] initWithTopItem:item1];
    
    MKCTopEntityModel *item2 = [[MKCTopEntityModel alloc] initWithId:22222
                                                              image:@"item_image_2"
                                                              title:@"item_title_2"
                                                               rank:4
                                                          startDate:@"item_startDate_2"
                                                            endDate:@"item_endDate_2"
                                                               type:@"item_type_2"
                                                                url:@"item_url_2"];
    MKCFavoriteItem *saveItem2 = [[MKCFavoriteItem alloc] initWithTopItem:item2];
    
    [MKCDataPersistence collectMovieWithItem:saveItem1];
    [MKCDataPersistence collectMovieWithItem:saveItem2];
    
    NSArray<MKCFavoriteItem *> *retrieveItems = [MKCDataPersistence collectedMovies];
    XCTAssertEqual(retrieveItems.count, 2);
    
    XCTAssertEqualObjects(retrieveItems[0].ID, @"11111");
    XCTAssertEqualObjects(retrieveItems[0].title, @"item_title");
    XCTAssertEqualObjects(retrieveItems[0].image, @"item_image");
    XCTAssertEqualObjects(retrieveItems[0].url, @"item_url");
    
    XCTAssertEqualObjects(retrieveItems[1].ID, @"22222");
    XCTAssertEqualObjects(retrieveItems[1].title, @"item_title_2");
    XCTAssertEqualObjects(retrieveItems[1].image, @"item_image_2");
    XCTAssertEqualObjects(retrieveItems[1].url, @"item_url_2");
}

- (void)testRemoveItem {
    MKCTopEntityModel *item = [[MKCTopEntityModel alloc] initWithId:11111
                                                              image:@"item_image"
                                                              title:@"item_title"
                                                               rank:5
                                                          startDate:@"item_startDate"
                                                            endDate:@"item_endDate"
                                                               type:@"item_type"
                                                                url:@"item_url"];
    MKCFavoriteItem *saveItem = [[MKCFavoriteItem alloc] initWithTopItem:item];
    
    [MKCDataPersistence collectMovieWithItem:saveItem];
    [MKCDataPersistence removeCollectedMovieWithTrackId:@"11111"];

    NSArray<MKCFavoriteItem *> *retrieveItems = [MKCDataPersistence collectedMovies];
    XCTAssertEqual(retrieveItems.count, 0);
}

- (void)testRemoveNotExistItem {
    MKCTopEntityModel *item = [[MKCTopEntityModel alloc] initWithId:11111
                                                              image:@"item_image"
                                                              title:@"item_title"
                                                               rank:5
                                                          startDate:@"item_startDate"
                                                            endDate:@"item_endDate"
                                                               type:@"item_type"
                                                                url:@"item_url"];
    MKCFavoriteItem *saveItem = [[MKCFavoriteItem alloc] initWithTopItem:item];
    
    [MKCDataPersistence collectMovieWithItem:saveItem];
    [MKCDataPersistence removeCollectedMovieWithTrackId:@"22222"];

    NSArray<MKCFavoriteItem *> *retrieveItems = [MKCDataPersistence collectedMovies];
    XCTAssertEqual(retrieveItems.count, 1);
    XCTAssertEqualObjects(retrieveItems.firstObject.ID, @"11111");
    XCTAssertEqualObjects(retrieveItems.firstObject.title, @"item_title");
    XCTAssertEqualObjects(retrieveItems.firstObject.image, @"item_image");
    XCTAssertEqualObjects(retrieveItems.firstObject.url, @"item_url");
}

- (void)testItemIDIsExist {
    MKCTopEntityModel *item1 = [[MKCTopEntityModel alloc] initWithId:11111
                                                              image:@"item_image"
                                                              title:@"item_title"
                                                               rank:5
                                                          startDate:@"item_startDate"
                                                            endDate:@"item_endDate"
                                                               type:@"item_type"
                                                                url:@"item_url"];
    MKCFavoriteItem *saveItem1 = [[MKCFavoriteItem alloc] initWithTopItem:item1];
    
    MKCTopEntityModel *item2 = [[MKCTopEntityModel alloc] initWithId:22222
                                                              image:@"item_image_2"
                                                              title:@"item_title_2"
                                                               rank:4
                                                          startDate:@"item_startDate_2"
                                                            endDate:@"item_endDate_2"
                                                               type:@"item_type_2"
                                                                url:@"item_url_2"];
    MKCFavoriteItem *saveItem2 = [[MKCFavoriteItem alloc] initWithTopItem:item2];
    
    [MKCDataPersistence collectMovieWithItem:saveItem1];
    [MKCDataPersistence collectMovieWithItem:saveItem2];

    BOOL isExist = [MKCDataPersistence hasCollectdMovieWithTrackId:@"11111"];
    XCTAssertTrue(isExist);
}

- (void)testItemIDIsNotExist {
    MKCTopEntityModel *item1 = [[MKCTopEntityModel alloc] initWithId:11111
                                                              image:@"item_image"
                                                              title:@"item_title"
                                                               rank:5
                                                          startDate:@"item_startDate"
                                                            endDate:@"item_endDate"
                                                               type:@"item_type"
                                                                url:@"item_url"];
    MKCFavoriteItem *saveItem1 = [[MKCFavoriteItem alloc] initWithTopItem:item1];
    
    MKCTopEntityModel *item2 = [[MKCTopEntityModel alloc] initWithId:22222
                                                              image:@"item_image_2"
                                                              title:@"item_title_2"
                                                               rank:4
                                                          startDate:@"item_startDate_2"
                                                            endDate:@"item_endDate_2"
                                                               type:@"item_type_2"
                                                                url:@"item_url_2"];
    MKCFavoriteItem *saveItem2 = [[MKCFavoriteItem alloc] initWithTopItem:item2];
    
    [MKCDataPersistence collectMovieWithItem:saveItem1];
    [MKCDataPersistence collectMovieWithItem:saveItem2];

    BOOL isExist = [MKCDataPersistence hasCollectdMovieWithTrackId:@"33333"];
    XCTAssertFalse(isExist);
}

@end
