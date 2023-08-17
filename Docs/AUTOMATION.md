# Automation

## Table of contents
1. [Intro](#intro)
1. [Set up test development environment](#set-up-test-development-environment)
1. [Writing tests](#writing-tests)
1. [Running tests on a local machine with an emulator](#running-tests-on-a-local-machine-with-a-emulator)
1. [Running tests in the Mobitru](#running-tests-in-the-mobitru)
    1. [The setup](#the-setup)
    1. [Running tests](#running-tests)


## Intro
Tests are run with:

* [XCTest](https://developer.apple.com/documentation/xctest): The testing framework that is used to organize and execute tests
* XCUI Collection: This is a collection of UI-related classes for interacting with elements and making assertions


## Set up test development environment

- install Xcode: https://developer.apple.com/xcode/
- open it and install iOS SDK
- install simulator(s) for selected SDK: https://developer.apple.com/documentation/xcode/installing-additional-simulator-runtimes

## Writing tests
You can find the current tests in [this](MobitruUITests/) folder to see how the tests are being written. You can find actions and assertions that the XCUI supports [here](https://developer.apple.com/documentation/xctest/user_interface_tests).

### Working with elements
For finding elements, you can use `accessibilityIdentifier`. Every such unique name is usually related to a specific Element.
More information can be found [here](https://developer.apple.com/documentation/swiftui/view/accessibilityidentifier(_:)/).
If necessary, you can change or specify an `accessibilityIdentifier` in a UIView, which are located, for example, [here](Mobitru/Screens/Views) 

### Working with list
To find the first Element inside a List you need to use specific property [firstMatch](https://developer.apple.com/documentation/xctest/xcuielementtypequeryprovider/2902250-firstmatch).
As result, you will receive the first element that matches the query.


## Running test on a local machine in the Simulator
> Make sure you've added a Simulator https://developer.apple.com/documentation/xcode/installing-additional-simulator-runtimes

- select 'Mobitru' build schema in your project window's toolbar.
- select run destination (simulator or real device). 
- open the Test Plan view
- select MobitruUITests Plan
- click run icon for start an Execution

> The App will be assembled and installed on the Device automatically
> Test(s) execution will be started after that

## Running tests in the Mobitru
> Make sure that Development Team in specifed Singing & Capabilities section

### The setup
The setup includes building the App and ipa file with Tests.
Also, it will be necessary to upload them to Mobitru internal storage.

For building the App:

- select 'Mobitru' build schema in the toolbar of your project window.
- select 'Any iOS device' run destination. 
- select 'Product' at the Top Naviation menu. 
- select 'Build For' and then 'Testing'
- wait for build to complete.
- select 'Product' at the Top Naviation menu.
- select 'Archive' and complete the App .ipa file export

For building the app with Tests:

- select 'Mobitru' build schema in the toolbar of your project window.
- select 'Any iOS device' run destination. 
- select 'Product' at the Top Naviation menu. 
- select 'Build For' and then 'Testing'
- Navigate in a Terminal to your Xcode project’s Products directory and find the generated .app archive with tests.
- Finish preparing of an .ipa file
    - Create a Payload directory using: mkdir Payload
    - Move the .app to the created directory: mv <file_name>.app Payload 
    - Compress the Payload directory into an archive (.zip file): zip -r <archive_name>.zip Payload
    - Change the .zip extension to the .ipa in the result file

> As final preparation step you need to upload APKs using the following API - https://app.mobitru.com/wiki/api/#api-InstallApp-UploadFile

### Running tests
To run the XCUI tests in the Mobitru please take an iOS Device (in a browser or via API) and save its UDID.
Then, you can trigger the Espresso tests executing by call [this](https://app.mobitru.com/wiki/api/#api-XCUITest_[experimental]-CreateXCUITestRun) API.

> For more details, see the complete guide - https://docs.mobitru.com/run-xcui-tests/
