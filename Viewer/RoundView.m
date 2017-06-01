//
//  RoundView.m
//  Viewer
//
//  Created by Derek Scott on 5/29/17.
//  Copyright © 2017 Derek Scott. All rights reserved.
//
/// RoundView *roundy = [[RoundView alloc] initWithFrame:NSInsetRect(NSMakeRect(0,0,105,25), 5, 5)];
//  [dwindow.contentView addSubview:roundy];

#import "RoundView.h"

@implementation RoundView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    NSBezierPath * path;
    path = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:10 yRadius:10];
    [[NSColor colorWithCalibratedRed:0 green:0 blue:0 alpha:0.3] set];
    [path fill];
}

@end
