//
//  BaseUiTest.swift
//  MobitruUITests
//
//  Created by Siarhei Dubovik on 9.03.23.
//

import XCTest

class BaseUiTest: XCTestCase {
    
    var app: XCUIApplication!
    
    final let validUserName: String = "testuser@mobitru.com"
    final let validPassword: String = "password1"
    
    
    final let correctLn: String = "Grieg"
    final let correctFn: String = "Edvard"
    final let correctAddress: String = "Oslo, Norway"
    
    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        false
    }
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    public func addFirstAvailableProductToCart() {
        let addToCartButton = app.buttons["Add to cart"].firstMatch
        addToCartButton.tap()
    }
    public func openCartWithOneProduct() {
        let cartButton = app.buttons["cartButton"]
        cartButton.tap()
    }
    
    
    public func enterVaildCreds() {
        enterCreds(username: validUserName, password: validPassword)
    }
    
    public func enterVaildCredsWithoutSignIn() {
        enterCredsWithoutSignIn(username: validUserName, password: validPassword)
    }
    
    public func enterUserInfoAndSave(firstName: String, lastName: String, address: String) {
        enterUserInfoAndSave(firstName: firstName, lastName: lastName, address: address, saveButtonTitle: "Save")
    }
    
    public func enterUserInfoAndSave(firstName: String, lastName: String, address: String, saveButtonTitle: String) {
        typeText(inputId: "First name", text: firstName)
        typeText(inputId: "Last name", text: lastName)
        typeText(inputId: "Address", text: address+"\n")
        app.buttons[saveButtonTitle].tap()
    }
    
    
    public func enterCreds(username: String, password: String) {
        
        enterCredsWithoutSignIn(username: username, password: password)
        
        let signInButton = app.buttons["Sign in"]
        signInButton.tap()
    }
    
    private func enterCredsWithoutSignIn(username: String, password: String) {
        
        let loginTextField = app.textFields["Login"]
        loginTextField.tap()
        loginTextField.typeText(username)
        
        let passwordTextField = app.secureTextFields["Password"]
        passwordTextField.tap()
        passwordTextField.typeText(password)
    }
    
    private func typeText(inputId: String, text: String){
        let loginTextField = app.textFields[inputId]
        loginTextField.tap()
        loginTextField.typeText(text)
        hideKeyboard()
    }
    
    
    private func hideKeyboard(){
        if app.keyboards.buttons["Hide keyboard"].exists {
            app.keyboards.buttons["Hide keyboard"].tap()
        }
        if app.keyboards.buttons["Dismiss"].exists {
            app.keyboards.buttons["Dismiss"].tap()
        }
    }
}
