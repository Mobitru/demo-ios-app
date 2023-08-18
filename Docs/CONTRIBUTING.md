# Contributing to the app

You can add new functionality to the app by following the instructions below.

## Table of contents

1. [Set up development environment](#set-up-development-environment)
1. [ElementIdentifiers](#elemen-identifiers)
1. [Building the app in the XCODE](#building-the-app-in-the-xcode)
1. [Building the app from the Terminal](#building-the-app-from-the-terminal)
1. [Running XCUITests on a local machine in the XCODE](#running-xcuitests-on-a-local-machine-in-the-xcode)
1. [Running XCUITests on a local machine in the CLI](#running-xcuitests-on-a-local-machine-in-the-cli)
1. [Running XCUITests tests in the Mobitru](#running-xcuitests-in-the-mobitru)
1. [Libraries used](#libraries-used)
1. [Versioning the app](#versioning-the-app)

## Set up development environment

- install Xcode: https://developer.apple.com/xcode/.
- open it and install iOS SDK.
- install simulator(s) for selected SDK: https://developer.apple.com/documentation/xcode/installing-additional-simulator-runtimes.

## ElementIdentifiers
Almost all elements inside this application have their own `accessibilityIdentifier`, 
which is used for identifying elements in Tests and Accessibility Testing - https://developer.apple.com/documentation/swiftui/view/accessibilityidentifier(_:)/

So, please always add a unique id to every new component in the code that can be used to interact with, or that displays text
For example, with a textField the following code needs to be added

 ```swift
    textField.accessibilityIdentifier = "<id>"
    
    #Example
    textField.accessibilityIdentifier = "Login"
 
 ```

## Building the app in the XCODE
> Make sure that Development Team is selected on the Signing & Capabilities pane of the project editor

> More details can be found [here](https://help.apple.com/xcode/mac/current/#/dev23aab79b4)

- select 'Mobitru' build schema in your project window's toolbar.
- select run destination (simulator or real device). 
- select 'Product' at the Top Naviation menu. 
- select 'Build For' and then 'Testing'.

> The App will be assembled automatically
> In case of 'real device' run destination - you can make the App Archive in order to export .ipa
> More details can be found [here](https://developer.apple.com/documentation/xcode/building-and-running-an-app)

## Building the app from the Terminal
> Make sure that Development Team is selected on the Signing & Capabilities pane of the project editor

> More details can be found [here](https://help.apple.com/xcode/mac/current/#/dev23aab79b4)

- go to the project root directory in CLI.
- perform `xcodebuild -scheme Mobitru build`.
- wait for the build will be finished.

 Path to .app file should be logged before final status:
 
 ```
 
 /usr/bin/touch -c /Users/.../Library/Developer/Xcode/DerivedData/Mobitru-..../Build/Products/Debug-iphoneos/Mobitru.app
** BUILD SUCCEEDED **
 
 ```
 
> More details can be found [here](https://developer.apple.com/library/archive/technotes/tn2339/_index.html)

## Running XCUITests on a local machine in the XCODE
> Make sure that Development Team is selected on the Signing & Capabilities pane of the project editor

> More details can be found [here](https://help.apple.com/xcode/mac/current/#/dev23aab79b4)

- select 'Mobitru' build schema in your project window's toolbar.
- select run destination (simulator or real device). 
- open the Test Plan view.
- select MobitruUITests Plan.
- click run icon for start an Execution.

> The App will be assembled and installed on the Device automatically
> Tests execution will be started after that

> More details can be found [here](https://developer.apple.com/documentation/xcode/running-tests-and-interpreting-results?changes=__3)

## Running XCUITests on a local machine in the Terminal
> Make sure that Development Team is selected on the Signing & Capabilities pane of the project editor

> More details can be found [here](https://help.apple.com/xcode/mac/current/#/dev23aab79b4)

- go to the project root directory in CLI.
- perform `xcodebuild test -scheme Mobitru -destination "name=<device name, for example iPhone 14>"`.
- wait for all dependencies will be downloaded and assembling will be finished.

> The App will be assembled and installed on the Device automatically
> Tests execution will be started after that

> More details can be found [here](https://developer.apple.com/documentation/xcode/running-tests-and-interpreting-results?changes=__3)

## Running XCUITests in the Mobitru

Here is complete instruction on how to run XCUITests in the Mobitru https://docs.mobitru.com/run-xcui-tests/

## Versioning the app
Versioning the app will be done by incrementing **version** on the General App view.
