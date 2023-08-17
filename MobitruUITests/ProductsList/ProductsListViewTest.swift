//
//  ProductListViewTest.swift
//  MobitruUITests
//
//  Created by Siarhei Dubovik on 15.03.23.
//

import XCTest

final class ProductsListViewTest: BaseUiTest {
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        enterVaildCreds()      
    }
    
    
    func testProductItemElements() throws{
        XCTAssert(app.images["productImage"].exists)
        XCTAssert(app.staticTexts["productPrice"].exists)
        XCTAssert(app.staticTexts["oldProductPrice"].exists)
        XCTAssert(app.staticTexts["discountPrice"].exists)
        XCTAssert(app.staticTexts["productTitle"].exists)
    }
}
