# JTProgressHUD

**JTProgressHUD** is the new **HUD** designed to show **YOUR** views (eg. UIImageView animations) in the **HUD style** **with one line of code**. You can see many HUDs with easy implementation, but **the idea** is that you want that **easy implementation** with **HUD style** (background that block views below so the user knows that something is processing), but want to **show YOUR** animations/views (could be your app’s animated logo). *By DEFAULT* one animation is also included/built-in.

<h3 align="center">
  <img src="https://github.com/kubatru/JTProgressHUD/blob/master/Screens/builtin.gif" alt=“Builtin”/>
<img src="https://github.com/kubatru/JTProgressHUD/blob/master/Screens/custom.gif" alt=“Custom”/>
</h3>


## Installation
There are two ways to add the **JTImageButton** library to your project. Add it as a regular library or install it through **CocoaPods**.

`pod 'JTProgressHUD’`

You may also quick try the example project with

`pod try JTProgressHUD`

**Library requires target iOS 7.0 and above**

> **Works in both - Portrait and Landscape modes**


## Usage and Customization

JTProgressHUD is designed as a **singleton** so you don't have to care about it's instances. Just use class methods `- (void)show` and `- (void)hide` or its variations.

### Simple example:
```objective-c
// Your custom view
[JTProgressHUD showWithView:yourAnimationView];

// Built-in view
[JTProgressHUD show];
```

### Methods:

**View** is your custom view (eg. Animated UIImageView or whatever you want). **Style** is the style of the background. Usually it is the dark color between the view and the rest of the app. **Transition** is showing and hiding transitions. **BackgroundAlpha** is the biggest alpha for the background. *All parameters can be setup separately.*

```objective-c
+ (void)showWithView:style:transition:backgroundAlpha:;
+ (void)show;
+ (void)showWithView:;
+ (void)showWithStyle:;
+ (void)showWithTransition:;
+ (void)showWithBackgroundAlpha:;

+ (void)hide;
+ (void)hideWithTransition:;
```


## Changelog

### v1.0.1 - 07.05.15
- [**UPDATE**] Merged with pull request

### v1.0.0 - 06.23.15
- [**NEW**] Initial commit

## Author
This library is open-sourced by [Jakub Truhlar](http://kubatruhlar.cz).
    
## License
The MIT License (MIT)
Copyright © 2015 Jakub Truhlar
