//
//  DataTransferServiceTests.swift
//  WeatherAppTests
//
//  Created by Amir on 1/26/21.
//

import XCTest
import WeatherApp

private struct MockModel: Decodable {
    let name: String
}

/// Can have conflicts with fetch weathe use case
/// Better to run independently
class DataTransferServiceTests: XCTestCase {
    
    private enum DataTransferErrorMock: Error {
        case someError
    }
    
    func test_whenReceivedValidJsonInResponse_shouldDecodeResponseToDecodableObject() {
        //given
        let config = NetworkConfigurableMock()
        let expectation = self.expectation(description: "Should decode mock object")
        expectation.assertForOverFulfill = false
        
        let responseData = #"{"name": "Hello"}"#.data(using: .utf8)
        let networkService = DefaultNetworkService(config: config, sessionManager: NetworkSessionManagerMock(response: nil,
                                                                                                             data: responseData,
                                                                                                             error: nil))
        
        let sut = DefaultDataTransferService(with: networkService)
        //when
        _ = sut.request(with: Endpoint<MockModel>(path: "https://google.com", method: .get)) { result in
            do {
                let object = try result.get()
                XCTAssertEqual(object.name, "Hello")
                expectation.fulfill()
            } catch {
                XCTFail("Failed decoding MockObject")
            }
        }
        //then
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_whenInvalidResponse_shouldNotDecodeObject() {
        //given
        let config = NetworkConfigurableMock()
        let expectation = self.expectation(description: "Should not decode mock object")
        expectation.assertForOverFulfill = false
        
        let responseData = #"{"age": 20}"#.data(using: .utf8)
        let networkService = DefaultNetworkService(config: config, sessionManager: NetworkSessionManagerMock(response: nil,
                                                                                                             data: responseData,
                                                                                                             error: nil))
        
        let sut = DefaultDataTransferService(with: networkService)
        //when
        _ = sut.request(with: Endpoint<MockModel>(path: "https://google.com", method: .get)) { result in
            do {
                _ = try result.get()
                XCTFail("Should not happen")
            } catch {
                expectation.fulfill()
            }
        }
        //then
        wait(for: [expectation], timeout: 0.1)
    }
    
    /// For some reasons that I couldn't find out yet it has conflicts with fetch weathe use case
    /// Must be to run independently
    func test_whenBadRequestReceived_shouldRethrowNetworkError() {
        //given
        let config = NetworkConfigurableMock()
        weak var exp = self.expectation(description: "Should throw network error")
        exp?.assertForOverFulfill = true
        
        let responseData = #"{"invalidStructure": "Nothing"}"#.data(using: .utf8)!
        let response = HTTPURLResponse(url: URL(string: "test_url")!,
                                       statusCode: 500,
                                       httpVersion: "1.1",
                                       headerFields: nil)
        let networkService = DefaultNetworkService(config: config, sessionManager: NetworkSessionManagerMock(response: response,
                                                                                                             data: responseData,
                                                                                                             error: DataTransferErrorMock.someError))
        
        let sut = DefaultDataTransferService(with: networkService)
        //when
        _ = sut.request(with: Endpoint<MockModel>(path: "https://google.com", method: .get)) { result in
            switch result {
            case .success(_):
                XCTAssert(true, "Should not happen")
                break
            case .failure(let err):
                let rightError = DataTransferError.networkFailure(NetworkError.error(statusCode: 500, data: responseData))
                XCTAssertEqual(err.localizedDescription, rightError.localizedDescription , "Wrong Error")
                XCTAssertEqual(err, rightError , "Wrong Error")
                break
            }
            exp?.fulfill()
        }
        //then
        waitForExpectations(timeout: 0.1) { (error) in
            XCTAssertNil(error, error?.localizedDescription ?? "")
        }
    }
    
    func test_whenNoDataReceived_shouldThrowNoDataError() {
        //given
        let config = NetworkConfigurableMock()
        let expectation = self.expectation(description: "Should throw no data error")
        expectation.assertForOverFulfill = false
        
        let response = HTTPURLResponse(url: URL(string: "test_url")!,
                                       statusCode: 200,
                                       httpVersion: "1.1",
                                       headerFields: [:])
        let networkService = DefaultNetworkService(config: config, sessionManager: NetworkSessionManagerMock(response: response,
                                                                                                             data: nil,
                                                                                                             error: nil))
        
        let sut = DefaultDataTransferService(with: networkService)
        //when
        _ = sut.request(with: Endpoint<MockModel>(path: "https://google.com", method: .get)) { result in
            do {
                _ = try result.get()
                XCTFail("Should not happen")
            } catch let error {
                if case DataTransferError.noResponse = error {
                    expectation.fulfill()
                } else {
                    XCTFail("Wrong error")
                }
            }
        }
        //then
        wait(for: [expectation], timeout: 0.1)
    }
}
