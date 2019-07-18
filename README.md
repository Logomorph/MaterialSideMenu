# MaterialSideMenu

[![Version](https://img.shields.io/cocoapods/v/MaterialSideMenu.svg?style=flat)](https://cocoapods.org/pods/MaterialSideMenu)
[![License](https://img.shields.io/cocoapods/l/MaterialSideMenu.svg?style=flat)](https://cocoapods.org/pods/MaterialSideMenu)
![Swift5](https://img.shields.io/badge/Swift-5.0-orange.svg?style=flat%22)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat-square)](https://github.com/Carthage/Carthage)
[![Platform](https://img.shields.io/cocoapods/p/MaterialSideMenu.svg?style=flat)](https://cocoapods.org/pods/MaterialSideMenu)
### If you found MaterialSideMenu helpful and you liked it, give it a ★ at the top right of this page.
## Overview
MaterialSideMenu is a simple Google Material Design-style side menu for iOS
### Preview
![](https://raw.githubusercontent.com/Logomorph/MaterialSideMenu/master/Resources/menu_action.gif)
## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
- [x] Xcode 10.
- [x] Swift 5.
- [x] iOS 11 or higher.

## Installation
### CocoaPods
MaterialSideMenu is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'MaterialSideMenu'
```
After that, run the following command:

```bash
$ pod install
```
### Carthage
To install `MaterialSideMenu` with [Carthage](https://github.com/Carthage/Carthage), add the below line in your `Cartfile`:

```
github "Logomorph/MaterialSideMenu" "master"
```

### Manual
Copy ```MaterialSideMenuViewController.swift``` into your project and build

## Usage
### From code
First:
```swift
import MaterialSideMenu
```
Declare the menu and initialize it with a home controller (the bottom view) and the controller to be used as a side menu:
```swift
let sideMenuViewController = MaterialSideMenuViewController(homeViewController: homeViewController, mainMenuViewController: mainMenuController)
```
The menu is a ```UIViewController``` which can be added either as the ```rootViewController``` or pushed. It has its own ```navigationController``` on which it pushes the new controllers.

Push new view controllers on its stack:
```swift 
sideMenuViewController.pushViewController(newController, animated: false)
```
This will dismiss all view controllers alread on the stack, except the ```homeViewController``` and add the new controller on top.

Go home:
```swift
sideMenuViewController.goHome()
```
Dismisses all view controllers and leaves the home view controller on the stack.
## Known Issues
None, yet. Please report the issues you find some
## License

MaterialSideMenu is available under the MIT license. See the LICENSE file for more info.

