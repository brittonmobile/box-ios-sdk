//
//  UIApplication+ExtensionSafeAdditions.m
//
//  Copyright © 2016 Box. All rights reserved.
//

#import "UIApplication+ExtensionSafeAdditions.h"

@implementation UIApplication (ExtensionSafeAdditions)

+ (BOOL)box_isRunningExtension
{
    return [[[NSBundle mainBundle] executablePath] containsString:@".appex/"];
}

+ (UIApplication *)box_sharedApplication
{
    UIApplication *application = nil;
    if ([UIApplication box_isRunningExtension] == NO) {
        // If we are compiling from a non-extension target, use the regular sharedApplication.
        application = [UIApplication performSelector:@selector(sharedApplication)];
    }
    
    return application;
}
         
- (BOOL)box_canOpenURL:(NSURL *)url
{
    BOOL result = NO;
    if ([UIApplication box_isRunningExtension] == NO) {
        // If we are compiling from a non-extension target, use the regular sharedApplication.
        UIApplication *application = [[self class] box_sharedApplication];
        if ([application respondsToSelector:@selector(canOpenURL:)]) {
            result = [(NSNumber *) [application performSelector:@selector(canOpenURL:) withObject:url] boolValue];
        }
    }
    
    return result;
}

- (BOOL)box_openURL:(NSURL*)url
{
    BOOL result = NO;
    if ([UIApplication box_isRunningExtension] == NO) {
        // If we are compiling from a non-extension target, use the regular sharedApplication.
        UIApplication *application = [[self class] box_sharedApplication];
        if ([application respondsToSelector:@selector(openURL:)]) {
            result = [(NSNumber *) [application performSelector:@selector(openURL:) withObject:url] boolValue];
        }
    }
    
    return result;
}

- (UIWindow *)box_window
{
    UIWindow *window = nil;
    if ([UIApplication box_isRunningExtension] == NO) {
        // If we are compiling from a non-extension target, use the regular sharedApplication.
        UIApplication *application = [[self class] box_sharedApplication];
        if ([application respondsToSelector:@selector(delegate)]) {
            id <UIApplicationDelegate> delegate = [application performSelector:@selector(delegate)];
            if ([delegate respondsToSelector:@selector(window)]) {
                window = [delegate performSelector:@selector(window)];
            }
        }
    }
    
    return window;
}

@end
