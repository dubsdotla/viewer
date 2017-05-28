//
//  PlaceholderView.m
//  Viewer
//
//  Created by Derek Scott on 5/14/17.
//  Copyright © 2017 Derek Scott. All rights reserved.
//

#import "PlaceholderView.h"

@implementation PlaceholderView

- (void) awakeFromNib {
    
    self.material = NSVisualEffectMaterialDark;
    self.blendingMode = NSVisualEffectBlendingModeBehindWindow;
    self.state = NSVisualEffectStateFollowsWindowActiveState;
    
    [self registerForDraggedTypes:@[NSFilenamesPboardType]];
}

- (NSDragOperation)draggingUpdated:(id <NSDraggingInfo>)sender {
    return [self draggingEntered:sender];
}

- (BOOL)performDragOperation:(id < NSDraggingInfo >)sender {
    
    NSPasteboard *pboard = [sender draggingPasteboard];
    NSArray *filenames = [pboard propertyListForType:NSFilenamesPboardType];
    
    if([filenames count] > 0)
    {        
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

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end
