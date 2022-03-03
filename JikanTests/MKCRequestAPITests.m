#import <XCTest/XCTest.h>
#import "MKCRequestAPI.h"

@interface MKCRequestAPITests : XCTestCase

@end

@implementation MKCRequestAPITests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testFireTopAPI {
    XCTestExpectation *expectation = [self expectationWithDescription:@"wait"];
    
    [[MKCRequestAPI sharedAPI] topWithType:@"anime" subtype:@"upcoming" page:1 successHandler:^(NSURLResponse *response, id responseObject) {
        [expectation fulfill];
        
        XCTAssertNotNil(responseObject);
    } failureHandler:^(NSError *error) {
        XCTFail(@"error %@", error);
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}



@end
