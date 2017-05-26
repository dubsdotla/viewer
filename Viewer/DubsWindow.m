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

@end
