//
//  BeautyCheckerUITests.swift
//  BeautyCheckerUITests
//
//  Created by Gleb Martynov on 07.05.22.
//

import XCTest

class BeautyCheckerUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testAnimationBlocksButtons() {
        
        
    }


}
