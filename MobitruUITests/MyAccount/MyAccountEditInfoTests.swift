//
//  MyAccountEditInfoTests.swift
//  MobitruUITests
//
//  Created by Siarhei Dubovik on 14.03.23.
//

import XCTest

final class MyAccountEditInfoTests: BaseUiTest {
    
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        enterVaildCreds()
        let myAccountNavButton = app.tabBars["bottomTabBar"].buttons["My account"]
        myAccountNavButton.tap()
        app.buttons["edit"].tap()
    }
    
    
    func testEditMyAccountInfoUsingCorrectValues() throws{
        enterUserInfoAndSave(firstName: correctFn, lastName: correctLn, address: correctAddress)        
        XCTAssert(app.staticTexts[correctFn + " " + correctLn].exists)
        XCTAssert(app.staticTexts[correctAddress].exists)
        XCTAssert(app.staticTexts[validUserName].exists)
    }
    
    func testEditMyAccountInfoEmptyFirstName() throws{
        enterUserInfoAndSave(firstName: "", lastName: correctLn, address: correctAddress)
        XCTAssertEqual(app.staticTexts["Error First name"].label, "Field can’t be empty", "error message is incorrect")
        
    }
    func testEditMyAccountInfoEmptyLastName() throws{
        enterUserInfoAndSave(firstName: correctFn, lastName: "", address: correctAddress)
        XCTAssertEqual(app.staticTexts["Error Last name"].label, "Field can’t be empty", "error message is incorrect")
    }
    func testEditMyAccountInfoEmptyAddressName() throws{
        enterUserInfoAndSave(firstName: correctFn, lastName: correctLn, address: "")
        XCTAssertEqual(app.staticTexts["Error Address"].label, "Field can’t be empty", "error message is incorrect")
    }
    func testEditMyAccountInfoEmptyAll() throws{
        enterUserInfoAndSave(firstName: "", lastName: "", address: "")
        
        for errorLabel in ["Error First name","Error Last name","Error Address"] {
            XCTAssertEqual(app.staticTexts[errorLabel].label, "Field can’t be empty", "error message is incorrect")
        }
    }
    func testCannotEditEmail() throws{
        XCTAssertFalse(app.buttons["Email"].isHittable)
    }
}
