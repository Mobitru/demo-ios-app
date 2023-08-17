//
//  ChangeProductNumberTests.swift
//  MobitruUITests
//
//  Created by Siarhei Dubovik on 13.03.23.
//

import XCTest

final class ChangeProductNumberTests: BaseUiTest {
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        enterVaildCreds()
        addFirstAvailableProductToCart()
        openCartWithOneProduct()
    }
    
    func testIncreaseAndDecreaseProductNumber() throws{
        app.buttons["+"].tap()
        XCTAssertFalse(app.buttons["Delete"].exists)
        XCTAssertEqual(app.textFields.firstMatch.value as! String, "2", "cart counter value is not correct")
        app.buttons["-"].tap()
        XCTAssertEqual(app.textFields.firstMatch.value as! String, "1", "cart counter value is not correct")
        XCTAssert(app.buttons["Delete"].exists)
    }
    
    func testRemoveProduct() throws{
        app.buttons["Delete"].tap()
        XCTAssertEqual(app.staticTexts["emptyCartLabel"].label, "Cart is empty", "empty cart label is not correct")
        XCTAssertFalse(app.buttons["Continue to checkout"].exists)
        app.buttons["View products"].tap()
        XCTAssertEqual(app.buttons["cartButton"].label, "Cart: 0 items in the cart", "cart title is not correct")
    }
    
    func testMaxNumberOfProducts() throws{
        for _ in 1...10 {
            app.buttons["+"].tap()
        }
        XCTAssertFalse(app.buttons["+"].isEnabled)
        XCTAssertEqual(app.textFields.firstMatch.value as! String, "10", "cart counter value is not correct")
    }
    
    func testReturnBackToProductList() throws{
        app.buttons["Back"].tap()
        XCTAssertEqual(app.buttons["cartButton"].label, "Cart: 1 items in the cart", "cart title is not correct")
        openCartWithOneProduct()
        XCTAssertEqual(app.textFields.firstMatch.value as! String, "1", "cart counter value is not correct")
    }
    
    
}
