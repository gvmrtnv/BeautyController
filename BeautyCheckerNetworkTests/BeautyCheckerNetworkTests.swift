//
//  BeautyCheckerNetworkTests.swift
//  BeautyCheckerNetworkTests
//
//  Created by Gleb Martynov on 07.05.22.
//

import XCTest
import Combine
@testable import BeautyChecker

class BeautyCheckerNetworkTests: XCTestCase {
    var sut: NetworkManager!
    var error: Error?
    var cancellables: Set<AnyCancellable>!
    let networkMonitor = NetworkMonitor.shared

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = NetworkManager()
        cancellables = []
        
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testRecievesComplimentWithNetwork() throws {
        try XCTSkipUnless(
          networkMonitor.isReachable,
          "Network connectivity needed for this test.")
        // given
        let expectation = self.expectation(description: "Recieved compliment")
        var compliment: String?
        let subCompliment1 = "Currently I can only say: it's amazing"
        let subCompliment2 = "Currently I can only say: it's pure beauty"
        
        //when
        NetworkManager.shared
            .fetchCompliment()
            .sink { value in
                compliment = value
                expectation.fulfill()
            }
            .store(in: &cancellables)
        waitForExpectations(timeout: 10)
        
        
        //then
        XCTAssertNotNil(compliment)
        XCTAssertNotEqual(compliment, subCompliment1)
        XCTAssertNotEqual(compliment, subCompliment2)
            
    }
    
    func testRecievesComplimentWithoutNetwork() throws {
        try XCTSkipUnless(
          !networkMonitor.isReachable,
          "Network connectivity have to be disabled for this test.")
        // given
        let expectation = self.expectation(description: "Recieved compliment")
        var compliment: String?
        let subCompliment1 = "Currently I can only say: it's amazing"
        let subCompliment2 = "Currently I can only say: it's pure beauty"
        
        //when
        NetworkManager.shared
            .fetchCompliment()
            .sink { value in
                compliment = value
                expectation.fulfill()
            }
            .store(in: &cancellables)
        waitForExpectations(timeout: 10)
        
        
        //then
        XCTAssertNotNil(compliment)
        XCTAssert(compliment?.isEqual(subCompliment1) ?? false || compliment?.isEqual(subCompliment2) ?? false)
            
    }

}
