//
//  CartProductItemsTest.swift
//  MobitruUITests
//
//  Created by Siarhei Dubovik on 13.03.23.
//

import XCTest

final class CartProductItemsTest: BaseUiTest {
    
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        enterVaildCreds()
        addFirstAvailableProductToCart()
        openCartWithOneProduct()        
    }
    
    func testProductItemElements() throws{
        XCTAssert(app.buttons["Apply promo code"].exists)
        XCTAssert(app.staticTexts["cartProductTitle"].exists)
        XCTAssert(app.staticTexts["cartProductPrice"].exists)
        XCTAssert(app.images["cartProductImage"].exists)
    }
    
}
