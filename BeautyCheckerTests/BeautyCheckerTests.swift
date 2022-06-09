//
//  BeautyCheckerTests.swift
//  BeautyCheckerTests
//
//  Created by Gleb Martynov on 07.05.22.
//

import XCTest
@testable import BeautyChecker

class BeautyCheckerTests: XCTestCase {
    var sut: CheckViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = CheckViewModel()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
        
    }

    
    func testImageIsLoadingAfterSelection() {
        // given
        let input = UIImage(systemName: "square.and.arrow.up")
        
        //when
        sut.inputImage = input
        sut.loadImage()
        
        //then
        XCTAssertNotNil(sut.image, "Processed Image is visible in UI")
        
    }
    


}
