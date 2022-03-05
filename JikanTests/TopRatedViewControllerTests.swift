import XCTest
@testable import Jikan

class TopRatedViewControllerTests: XCTestCase {
    
    var mockRequestAPI: MockRequestAPI_TopRatedViewController!
    var sut: TopRatedViewController!

    override func setUpWithError() throws {
        mockRequestAPI = MockRequestAPI_TopRatedViewController()
        sut = TopRatedViewController(requestAPI: mockRequestAPI)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLoadingState() throws {
        _ = sut.view
        MKCUnitTestHelper.wait(withInterval: 0.1)
        
        if case .loading = sut.expose_state {
        } else {
            XCTFail()
        }
    }
    
    func testLoadMoreLoadingState() throws {
        _ = sut.view
        MKCUnitTestHelper.wait(withInterval: 0.1)
        
        mockRequestAPI.fetchSuccess()
        sut.expose_fetchData()
        
        if case .loadMoreLoading = sut.expose_state {
        } else {
            XCTFail()
        }
    }
    
    func testPartialLoadedState() throws {
        _ = sut.view
        MKCUnitTestHelper.wait(withInterval: 0.1)
        
        mockRequestAPI.fetchSuccess()
        
        if case .partialLoaded = sut.expose_state {
        } else {
            XCTFail()
        }
    }
    
    func testErrorState() throws {
        _ = sut.view
        MKCUnitTestHelper.wait(withInterval: 0.1)
        
        mockRequestAPI.fetchError()
        
        if case .error = sut.expose_state {
        } else {
            XCTFail()
        }
    }
}

class MockRequestAPI_TopRatedViewController: MKCRequestAPI {
    var successHandler: MKCSuccessHandler?
    var failureHandler: MKCFailureHandler?
    
    override func top(withType type: String!, subtype: String!, page: Int, successHandler: MKCSuccessHandler!, failureHandler: MKCFailureHandler!) -> URLSessionDataTask? {
        self.successHandler = successHandler
        self.failureHandler = failureHandler
        return nil
    }
    
    func fetchSuccess() {
        let responseObject = MKCUnitTestHelper.apiResponseObject(fromJsonFileName: "top-success")
        successHandler?(nil, responseObject)
    }
    
    func fetchError() {
        failureHandler?(APIResponseError.unreachable)
    }
}
