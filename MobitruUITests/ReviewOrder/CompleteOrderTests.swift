//
//  CompleteOrderTests.swift
//  MobitruUITests
//
//  Created by Siarhei Dubovik on 17.03.23.
//

import XCTest

final class CompleteOrderTests: BaseUiTest {
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        enterVaildCreds()
        addFirstAvailableProductToCart()
        openCartWithOneProduct()
        app.buttons["Continue to checkout"].tap()
        enterUserInfoAndSave(firstName: correctFn, lastName: correctLn, address: correctAddress, saveButtonTitle: "Review order")
        
    }
    
    func testCompleteOrder() throws{
        app.buttons["Confirm & place order"].tap()
        XCTAssert(app.staticTexts["Order completed"].exists)
        XCTAssert(app.staticTexts["Order successfully placed. Please check your email."].exists)
        app.buttons["Go back to products"].tap()
        XCTAssert(app.staticTexts["productPrice"].exists)
        XCTAssertEqual(app.buttons["cartButton"].label, "Cart: 0 items in the cart", "cart title is not correct")
    }
    
    func testCompletedOrderCheck() throws{
        app.buttons["Confirm & place order"].tap()
        app.buttons["Go back to products"].tap()
        app.tabBars["bottomTabBar"].buttons["Orders"].tap()
        XCTAssert(app.staticTexts["In progress (1)"].exists)
    }
}
