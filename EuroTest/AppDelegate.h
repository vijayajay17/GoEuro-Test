//
//  AppDelegate.h
//  EuroTest
//
//  Created by Vijay on 9/25/15.
//  Copyright (c) 2015 Vijay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UIView *loadingView;
    UIActivityIndicatorView	*spinningWheel;
}
@property (strong, nonatomic) UIWindow *window;
- (void)hideLoadingView;
- (void)showLoadingView:(BOOL)withActivityIndicator;
- (void)showLoadingView:(BOOL)withActivityIndicator setFrame: (CGRect)frame;

@end

