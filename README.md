TYAlertView
===

[![CI Status](http://img.shields.io/travis/luckytianyiyan/TYAlertView.svg?style=flat)](https://travis-ci.org/luckytianyiyan/TYAlertView)
[![Version](https://img.shields.io/cocoapods/v/TYAlertView.svg?style=flat)](http://cocoapods.org/pods/TYAlertView)
[![Platform](https://img.shields.io/cocoapods/p/TYAlertView.svg?style=flat)](http://cocoapods.org/pods/TYAlertView)
[![License](https://img.shields.io/badge/license-MIT%20License-blue.svg)](http://cocoapods.org/pods/TYAlertView)

Feature
---
- UIAppearance Support
- Block Syntax

Usage
---
<details open=1>
<summary>Simply</summary>

```objective-c
TYAlertView *alertView = [[TYAlertView alloc] initWithTitle:@"title" message:@"message"];
[alertView addAction:[TYAlertAction actionWithTitle:@"Ok"
                                              style:TYAlertActionStyleDefault
                                            handler:^(TYAlertAction * _Nonnull action) {
    NSLog(@"Ok button clicked");
}]];
[alertView show];
```

</details>

<details>
<summary>Custom TYAlertView Theme</summary>
```objective-c
[TYAlertView appearance].titleColor = [UIColor redColor];
[TYAlertView appearance].messageColor = [UIColor redColor];
[TYAlertView appearance].separatorColor = [UIColor grayColor];
[TYAlertView appearance].shadowRadius = 4.0f;
[TYAlertView appearance].popupViewBackgroundColor = [UIColor blueColor];
// Button Title Color
[[TYAlertView appearance] setButtonTitleColor:[UIColor yellowColor]
                               forActionStyle:TYAlertActionStyleDefault
                                     forState:UIControlStateNormal];
```
</details>

Example
---

To run the example project, clone the repo, and run `pod install` from the Example directory first.

Installation
---

TYAlertView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "TYAlertView"
```

License
---

`TYAlertView` is available under the `MIT` license. See the LICENSE file for more info.
