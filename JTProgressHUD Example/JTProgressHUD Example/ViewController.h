//
//  ViewController.h
//  JTProgressHUD Example
//
//  Created by Jakub Truhlar on 20.06.15.
//  Copyright (c) 2015 Jakub Truhlar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISwitch *bgSwitch;

- (IBAction)CustomBtnPressed:(id)sender;
- (IBAction)BuiltBtnPressed:(id)sender;
- (IBAction)bgSwitch:(id)sender;

@end

