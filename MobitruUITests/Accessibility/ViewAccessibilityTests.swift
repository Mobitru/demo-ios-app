//
//  ViewAccessibilityTests.swift
//  MobitruUITests
//
//  Created by Siarhei Dubovik on 15.02.24.
//

import XCTest

@available(iOS 17.0, *)
final class ViewAccessibilityTests: BaseUiTest {
    
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = true
    }
    
    func testLoginView() throws{
        enterVaildCredsWithoutSignIn()
            try app.performAccessibilityAudit() { issue in
                //skip dynamicType verifications
                var ignore = false
                if issue.auditType == .dynamicType {
                    ignore = true
                }
                return ignore
            }
    }
    
    func testProductsView() throws{
        enterVaildCreds()
        XCTAssert(app.staticTexts["productPrice"].exists)
        var baseProductsViewChecks = XCUIAccessibilityAuditType.all
        baseProductsViewChecks.remove(XCUIAccessibilityAuditType.contrast)
        baseProductsViewChecks.remove(XCUIAccessibilityAuditType.dynamicType)
        try app.performAccessibilityAudit(for: baseProductsViewChecks) {issue in
            //skip hit area verification for sort icon
            var ignore = false
            if let element = issue.element,
               element.label.contains("Price"),
               issue.auditType == .hitRegion {
                ignore = true
            }
            return ignore
            
        }
    }
    
    func testOrdersView() throws{
        enterVaildCreds()
        app.tabBars["bottomTabBar"].buttons["Orders"].tap()
        var baseOrderViewChecks = XCUIAccessibilityAuditType.all
        baseOrderViewChecks.remove(.dynamicType)
//        uncomment for making test passed
//        baseOrderViewChecks.remove(.textClipped)
        try app.performAccessibilityAudit(for: baseOrderViewChecks)
    }
    
    func testMyAccountView() throws{
        enterVaildCreds()
        app.tabBars["bottomTabBar"].buttons["My account"].tap()
        var baseOrderViewChecks = XCUIAccessibilityAuditType.all
        baseOrderViewChecks.remove(.dynamicType)
        try app.performAccessibilityAudit(for: baseOrderViewChecks)
    }
}
