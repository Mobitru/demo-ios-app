//
//  MyAccountViewTests.swift
//  MobitruUITests
//
//  Created by Siarhei Dubovik on 10.03.23.
//

import XCTest

final class MyAccountViewTests: BaseUiTest {
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        enterVaildCreds()
        let myAccountNavButton = app.tabBars["bottomTabBar"].buttons["My account"]
        myAccountNavButton.tap()
    }
    
    
    func testMyAccountDetailsExist() throws{
        XCTAssert(app.buttons["edit"].exists)
        XCTAssert(app.staticTexts[validUserName].exists)
    }
    
    func testGeneralViewElements() throws{
        XCTAssert(app.staticTexts["General"].exists)
    }
    
    func testLogoutElement() throws{
        XCTAssert(app.buttons["Logout"].exists)
    }
    
}
