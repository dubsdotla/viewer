//
//  DubsPlayerView.m
//  Viewer
//
//  Created by Derek Scott on 5/15/17.
//  Copyright © 2017 Derek Scott. All rights reserved.
//

#import "DubsPlayerView.h"

@implementation DubsPlayerView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (NSDragOperation)draggingUpdated:(id <NSDraggingInfo>)sender {
    return [self draggingEntered:sender];
}

- (BOOL)performDragOperation:(id < NSDraggingInfo >)sender {
    
    NSPasteboard *pboard = [sender draggingPasteboard];
    NSArray *filenames = [pboard propertyListForType:NSFilenamesPboardType];
    
    if([filenames count] > 0)
    {
        //NSString *filepath = [filenames objectAtIndex:0];
        
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:filenames forKey:@"filePaths"];
        
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

- (BOOL)wantsScrollEventsForSwipeTrackingOnAxis:(NSEventGestureAxis)axis
{
    return (axis == NSEventGestureAxisHorizontal) ? YES : NO;
}

- (void)scrollWheel:(NSEvent *)event
{    
    if ([event phase] == NSEventPhaseNone) return; // Not a gesture scroll event.
    if (fabs([event scrollingDeltaX]) <= fabs([event scrollingDeltaY])) return; // Not horizontal
        
    [event trackSwipeEventWithOptions:0 dampenAmountThresholdMin:-1 max:1 usingHandler:^(CGFloat gestureAmount, NSEventPhase phase, BOOL isComplete, BOOL *stop) {
        if (phase ==  NSEventPhaseBegan)
        {
            if (gestureAmount > 0)
            {
                NSLog(@"SWIPE LEFT");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"DubsLeftArrow" object:nil userInfo:nil];
            }
            
            else
            {
                NSLog(@"SWIPE RIGHT");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"DubsRightArrow" object:nil userInfo:nil];
            }
        }
        *stop = NO;
    }];
    
}

- (BOOL) acceptsFirstResponder
{
    return YES;
}

@end
