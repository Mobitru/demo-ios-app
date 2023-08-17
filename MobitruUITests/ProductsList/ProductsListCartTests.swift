//
//  ProductsListCartTests.swift
//  MobitruUITests
//
//  Created by Siarhei Dubovik on 15.03.23.
//

import XCTest

final class ProductsListCartTests: BaseUiTest {
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        enterVaildCreds()
        addFirstAvailableProductToCart()        
    }
    
    func testAddToCart() throws{
        XCTAssertEqual(app.buttons["cartButton"].label, "Cart: 1 items in the cart", "incorrect cart button title")
    }
    
    func testAddSeveralProductsToCart() throws{
        addFirstAvailableProductToCart()
        XCTAssertEqual(app.buttons["cartButton"].label, "Cart: 2 items in the cart", "incorrect cart button title")
        app.buttons["Added to cart"].firstMatch.tap()
        XCTAssertEqual(app.buttons["cartButton"].label, "Cart: 1 items in the cart", "incorrect cart button title")
    }
    
    
    func testRemoveFromCart() throws{
        app.buttons["Added to cart"].tap()
        XCTAssertEqual(app.buttons["cartButton"].label, "Cart: 0 items in the cart", "incorrect cart button title")
    }
    
    func testOpenCartAfterAddProduct() throws{
        app.buttons["cartButton"].tap()
        XCTAssert(app.staticTexts["cartProductTitle"].exists)
        XCTAssert(app.staticTexts["cartProductPrice"].exists)
        XCTAssert(app.staticTexts["Continue to checkout"].exists)
        
    }
    
    func testOpenCartAfterRemoveSingleProduct() throws{
        try testRemoveFromCart()
        app.buttons["cartButton"].tap()
        XCTAssertEqual(app.staticTexts["emptyCartLabel"].label, "Cart is empty", "empty cart label is not correct")
        XCTAssertFalse(app.staticTexts["cartProductTitle"].exists)
        XCTAssertFalse(app.staticTexts["cartProductPrice"].exists)
        XCTAssertFalse(app.staticTexts["Continue to checkout"].exists)
    }
    
}
