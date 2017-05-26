//
//  AppDelegate.m
//  Viewer
//
//  Created by Derek Scott on 5/13/17.
//  Copyright © 2017 Derek Scott. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}


- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    // Insert code here to tear down your application
}

- (BOOL) applicationShouldTerminateAfterLastWindowClosed: (NSApplication *) theApplication
{
    return YES;
}


- (BOOL)application:(NSApplication *)theApplication openFile:(NSString *)filename
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
        
    BOOL isDir;
    if([fileManager fileExistsAtPath:filename isDirectory:&isDir])
    {
        if(!isDir)
        {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:filename forKey:@"filePath"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"fileDroppedNotification" object:nil userInfo:userInfo];
        }
    }
    
    [NSApp activateIgnoringOtherApps:YES];
    
    return YES;
}

@end
