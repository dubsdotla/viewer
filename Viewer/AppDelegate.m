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

- (void)awakeFromNib
{
    filesToOpen = [[NSMutableArray alloc] init];
}

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

- (void) application:(NSApplication*)sender openFiles:(NSArray*)filenames
{
    // I saw cases in which dragging a bunch of files onto the app
    // actually called application:openFiles several times, resulting
    // in more than one window, with the dragged files split amongst them.
    // This is lame.  So we queue them up and open them all at once later.
    [self queueFilesForOpening:filenames];
    
    [NSApp replyToOpenOrPrint:NSApplicationDelegateReplySuccess];
}


- (void) queueFilesForOpening:(NSArray*)filenames
{
    [filesToOpen addObjectsFromArray:filenames];
    [self performSelector:@selector(openQueuedFiles) withObject:nil afterDelay:0.25];
}


- (void) openQueuedFiles
{
    if( filesToOpen.count == 0 ) return;
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:filesToOpen forKey:@"filePaths"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"fileDroppedNotification" object:nil userInfo:userInfo];

    [filesToOpen removeAllObjects];
    filesToOpen = nil;
    filesToOpen = [[NSMutableArray alloc] init];
}

@end
