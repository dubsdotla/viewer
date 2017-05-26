//
//  DubsPlayerView.m
//  Viewer
//
//  Created by Derek Scott on 5/15/17.
//  Copyright © 2017 Derek Scott. All rights reserved.
//

#import "DubsPlayerView.h"

@implementation DubsPlayerView

- (NSDragOperation)draggingUpdated:(id <NSDraggingInfo>)sender {
    return [self draggingEntered:sender];
}

- (BOOL)performDragOperation:(id < NSDraggingInfo >)sender {
    
    NSPasteboard *pboard = [sender draggingPasteboard];
    NSArray *filenames = [pboard propertyListForType:NSFilenamesPboardType];
    
    if([filenames count] > 0)
    {
        NSString *filepath = [filenames objectAtIndex:0];
        
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:filepath forKey:@"filePath"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"fileDroppedNotification" object:nil userInfo:userInfo];
    }
        
    return YES;
}


- (BOOL)prepareForDragOperation:(id)sender {
    return YES;
}


- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{
    return NSDragOperationCopy;
}

- (void)draggingExited:(id)sender
{
    
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end
