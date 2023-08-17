# Mobitru iOS Demo Application

In this repository, you will find our Mobitru iOS demo App.
You can use it as a demo App for test automation or manual practice on your local machine or on the Real Device Platform.

![mobitru.order](./Docs/Assets/ios_overview.gif)

## Table of contents
1. [Functionalities](#functionalities)
    1. [UI Controls](#ui-controls)
    1. [Biometric authentication](#biometric-authentication)
    1. [UI Layouts](#ui-layouts)
    1. [Event Handling](#event-handling)
    1. [QR code scanner](#qr-code-scanner)
    1. [Accessibility](#accessibility)
1. [Contributing to the App](#contributing-to-the-app)
1. [Test automation](#test-automation)
    1. [XCUITest](#xcuitest)
1. [FAQ](#faq)

## Functionalities

### UI Controls
This app contains variations of the most useful UI controls like:
- UILabel
- UITextField
- UIButton
- ImageButton
- UIImage

More details about iOS UI controls can be found [here](https://developer.apple.com/documentation/uikit/views_and_controls#2864417).

You can find Autotests for all kinds of controls [here](MobitruUITests/), for example:
- [LoginUiTests](MobitruUITests/Login/LoginUiTests.swift) - enter data to EditText, Password Input, and click on Button 
- [MyAccountEditInfoTests](MobitruUITests/MyAccount/MyAccountEditInfoTests.swift) - work with BottomNavigation, replace data in EditText and read info from TextView
- [ProductsListCartTests](MobitruUITests/ProductsList/ProductsListCartTests.swift) - click on ImageButton, verify data in TextView, and check ImageView

### Biometric authentication
This app supports Biometric authentication on the Login Screen.

You only need to enable it on your Device, and then you will be able to log in without entering credentials.

Just open the Login Screen **->** tap the 'Biometric authentication' button **->** complete identity verification.

> More details on how to do this on Mobitru you can find [here](https://docs.mobitru.com/biometric-authentication/).

### UI Layouts
This app also has various UI interface layouts, which are related to significant groups of elements, like
- UIView
- UITableView
- UITableViewCell
- UIImageView

More details about the iOS UI View layout can be found [here](https://developer.apple.com/documentation/uikit/views_and_controls#2937168).

You can find autotests for all kinds of layouts [here](MobitruUITests/), for example:
- [ProductsListViewTest](MobitruUITests/ProductsList/ProductsListViewTest.swift) - check elements in a UITableView
- [MyAccountViewTests](MobitruUITests/MyAccount/MyAccountViewTests.swift) - verify text data on a UITableView
- [ReviewOrderProductsTests](MobitruUITests/ReviewOrder/ReviewOrderProductsTests.swift) - validate elements on a UITableViewCell
- [CompletedOrdersTest](MobitruUITests/Orders/CompletedOrdersTest.swift) - check the presence of a UIImageView

### Event Handling
Different kinds of User Actions are available in the App, for example:
- add or remove from the cart
- change the product number
- validate user info fields
- sort a list of products

All of them are covered by using specific View Controllers.
More details can be found [here](https://developer.apple.com/documentation/uikit/view_controllers).
You can find autotests for all kinds of actions [here](MobitruUITests/), for example:
- [ProductsListCartTests](MobitruUITests/ProductsList/ProductsListCartTests.swift) - add/remove products from the cart and check the total number
- [ProductsListSortingTests](MobitruUITests/ProductsList/ProductsListSortingTests.swift) - change sorting and verify updated Products List
- [CompleteOrderTests](MobitruUITests/ReviewOrder/CompleteOrderTests.swift) - add a product to the cart, enter user info, and complete the Order

### QR code scanner

You can also scan a QR code in the Mobitru demo app.

Just add several items to the cart and activate The QR Code scanning on the Cart screen:
- tap on the 'Apply promo code' button.
- allow the app to use the camera (needed for the first usage only).
- scan a QR code.

As a result, you will see related content (like URL) on the Cart Screen, and a random discount will be applied to any item in the Cart.

You can use the following image to demo this option.

![QR Code](./Docs/Assets/qr.png)

> More details on how to do this on Mobitru you can find [here](https://docs.mobitru.com/qr-barcode-scanning/).

### Accessibility
This App is adopted to demonstrate how Accessibility works on a Device.
You only need to enable the VoiceOver Mode on the Device:
- Go to Accessibility in the Settings. 
- Find a VoiceOver.
- Turn the setting on.

After enabling it, you can go to the Products List screen and try to tap on some elements like Product Title or Image.
Then, you should hear a text, which will be recognized by VoiceOver.

## Contributing to the App

If you want to contribute to the App and add new functionalities, please check the
documentation [here](./Docs/CONTRIBUTING.md).

## Test automation

### XCUITest

[Here](./Docs/AUTOMATION.md) you will find more information about:

- how to write XCUITests
- how to run tests on a local machine
- how to run tests in the cloud

## FAQ
### How to build the Application and start tests?
 - You can build the App from XCODE or console. All details can be found [here](./Docs/CONTRIBUTING.md#building-the-app-in-the-xcode).
 - Tests can be executed on a local machine or on Mobitru.  All details can be found [here](./Docs/CONTRIBUTING.md#running-xcuitests-on-a-local-machine-in-the-xcode).
### Which iOS versions are supported?
This App supports iOS 14.0 and greater.
### Is Dark Theme supported?
Not now, but it's in our plans.
