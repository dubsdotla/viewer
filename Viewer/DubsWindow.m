//
//  DubsWindow.m
//  Viewer
//
//  Created by Derek Scott on 5/15/17.
//  Copyright © 2017 Derek Scott. All rights reserved.
//

#import "DubsWindow.h"

@implementation DubsWindow

- (void)awakeFromNib
{
    self.titlebarAppearsTransparent = true;
    self.movableByWindowBackground = true;
    self.titleVisibility = NSWindowTitleHidden;
    [self setAppearance:[NSAppearance appearanceNamed:NSAppearanceNameVibrantDark]];
    
    [self updateTrackingAreas];
}

- (void)cancel:(id)sender
{
    NSUInteger masks = [self styleMask];
    
    if ( masks & NSFullScreenWindowMask)
    {
        [self toggleFullScreen:nil];
    }
    
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"fileCanceledNotification" object:nil userInfo:nil];
    }
}

- (void)updateTrackingAreas
{
    NSTrackingArea *const trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect options:(NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways | NSTrackingInVisibleRect) owner:self userInfo:nil];
    [self.contentView addTrackingArea:trackingArea];
}

- (void)mouseEntered:(NSEvent *)event
{
    [super mouseEntered:event];
    
    [[self standardWindowButton:NSWindowCloseButton] setHidden:NO];
    [[self standardWindowButton:NSWindowMiniaturizeButton] setHidden:NO];
    [[self standardWindowButton:NSWindowZoomButton] setHidden:NO];
}

- (void)mouseExited:(NSEvent *)event
{
    [super mouseExited:event];
    
    [[self standardWindowButton:NSWindowCloseButton] setHidden:YES];
    [[self standardWindowButton:NSWindowMiniaturizeButton] setHidden:YES];
    [[self standardWindowButton:NSWindowZoomButton] setHidden:YES];
}

@end
