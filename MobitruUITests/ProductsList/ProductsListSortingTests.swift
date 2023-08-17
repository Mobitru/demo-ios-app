//
//  ProductsListSortingTests.swift
//  MobitruUITests
//
//  Created by Siarhei Dubovik on 16.03.23.
//

import XCTest

final class ProductsListSortingTests: BaseUiTest {
    
    static let DEFAULT_SORTING_OPTION = "Price ascending"
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        enterVaildCreds()
        app.buttons[ProductsListSortingTests.DEFAULT_SORTING_OPTION].tap()        
    }
    
    func testSortPriceDescending() throws{
        app.staticTexts["Price descending"].tap()
        app.buttons["Apply"].tap()
        XCTAssertEqual(app.staticTexts["productTitle"].firstMatch.label , "Google Pixel 6a Dual-SIM",
                       "first item in sorted list is not correct")
        
    }
    
    func testSortPriceAscending() throws{
        try testSortPriceDescending()
        app.buttons["Price descending"].tap()
        app.staticTexts["Price ascending"].tap()
        app.buttons["Apply"].tap()
        XCTAssertEqual(app.staticTexts["productTitle"].firstMatch.label , "Lenovo Legion Duel Dual-Sim 256GB ROM + 12GB RAM",
                       "first item in sorted list is not correct")
    }
    
    func testSortNameAscending() throws{
        app.staticTexts["Product name A–Z"].tap()
        app.buttons["Apply"].tap()
        XCTAssertEqual(app.staticTexts["productTitle"].firstMatch.label , "Asus ROG",
                       "first item in sorted list is not correct")
    }
    
    func testSortNameDescending() throws{
        app.staticTexts["Product name Z–A"].tap()
        app.buttons["Apply"].tap()
        XCTAssertEqual(app.staticTexts["productTitle"].firstMatch.label , "Xiaomi Redmi Note 11",
                       "first item in sorted list is not correct")
    }
    
    
    
}
