//
//  LoginUiTests.swift
//  MobitruUITests
//
//  Created by Siarhei Dubovik on 7.03.23.
//

import XCTest

final class LoginUiTests: BaseUiTest {
    
    final let invalidUserName: String = "testuser1@gmail.com"
    final let invalidPassword: String = "password12"
    
    
    
    func testLoginValidCredential() throws{
        enterCreds(username: validUserName, password: validPassword)
        let productHeaderViewLabel = app.staticTexts["productHeaderViewLabel"]
        
        XCTAssertEqual(productHeaderViewLabel.label, "Mobile phones (12)", "phone view is not displayed")
    }
    
    
    func testLoginInValidCredential() throws{
        enterCredsWithError(username: invalidUserName, password: invalidPassword)
    }
    
    
    func testLoginEmptyUsername() throws{
        enterCredsWithError(username: "", password: validPassword)
    }
    
    
    func testLoginEmptyPassword() throws {
        enterCredsWithError(username: validUserName, password: "")
    }
    
    
    func testLoginEmptyPasswordAndUserName() throws {
        enterCredsWithError(username: "", password: "")
    }
    
    
    private func enterCredsWithError(username: String, password: String) {
        enterCreds(username: username, password: password)
        let errorLabel = app.staticTexts["errorMessage"]
        XCTAssertEqual(errorLabel.label , "Incorrect email or password", "error message is not displayed")
    }
    
}
