//
//  CompletedOrdersTest.swift
//  MobitruUITests
//
//  Created by Siarhei Dubovik on 10.03.23.
//

import XCTest

final class CompletedOrdersTest: BaseUiTest {
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        enterVaildCreds()
        let ordersNavButton = app.tabBars["bottomTabBar"].buttons["Orders"]
        ordersNavButton.tap()
    }
    
    func testCompletedOrdersList() throws{
        XCTAssert(app.staticTexts["Completed (7)"].exists)
    }
    
}
