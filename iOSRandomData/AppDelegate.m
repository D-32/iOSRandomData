//
//  AppDelegate.m
//  iOSRandomData
//
//  Created by Dylan Marriott on 13.12.13.
//  Copyright (c) 2013 Dylan Marriott. All rights reserved.
//

#import "AppDelegate.h"
#import "Contacts.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
	
	
	// add 50 random contacts
	[Contacts addRandomContacts:50];
	
	
    return YES;
}

@end
