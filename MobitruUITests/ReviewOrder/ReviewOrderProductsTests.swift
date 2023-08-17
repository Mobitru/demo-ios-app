//
//  ReviewOrderProductsTests.swift
//  MobitruUITests
//
//  Created by Siarhei Dubovik on 17.03.23.
//

import XCTest

final class ReviewOrderProductsTests: BaseUiTest {
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        enterVaildCreds()
        addFirstAvailableProductToCart()
        openCartWithOneProduct()
        app.buttons["Continue to checkout"].tap()
    }
    
    func testProductItemElements() throws{
        enterUserInfoAndSave(firstName: correctFn, lastName: correctLn, address: correctAddress, saveButtonTitle: "Review order")        
        XCTAssert(app.staticTexts["reviewOrderProductTitle"].exists)
        XCTAssert(app.staticTexts["reviewOrderProductPrice"].exists)
        XCTAssert(app.images["reviewOrderProductImage"].exists)
        
        
        XCTAssert(app.staticTexts["Contact details"].exists)
        XCTAssert(app.staticTexts[correctFn + " " + correctLn].exists)
        XCTAssert(app.staticTexts[validUserName].exists)
        XCTAssert(app.staticTexts[correctAddress].exists)
        XCTAssert(app.staticTexts["Payment details"].exists)
        XCTAssert(app.staticTexts["Subtotal"].exists)
        XCTAssert(app.staticTexts["Delivery fee"].exists)
        XCTAssert(app.staticTexts["Discount"].exists)
        XCTAssert(app.staticTexts["Total"].exists)
        XCTAssert(app.staticTexts["Packaging fee"].exists)
        XCTAssert(app.buttons["Confirm & place order"].exists)
        
    }
    
    func testEditAccountElement() throws{
        XCTAssert(app.textFields["First name"].exists)
        XCTAssert(app.textFields["Last name"].exists)
        XCTAssert(app.textFields["Email"].exists)
        XCTAssert(app.textFields["Address"].exists)
        XCTAssert(app.buttons["Review order"].exists)
        
    }
    
    
    
}
