//
//  ViewController.h
//  Viewer
//
//  Created by Derek Scott on 5/13/17.
//  Copyright © 2017 Derek Scott. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "PlaceholderView.h"
#import "DubsImageView.h"
#import "DubsWindow.h"
#import "BFPageControl.h"
#import "RoundView.h"
#import "NSView+Fade.m"

@interface ViewController : NSViewController <BFPageControlDelegate, NSWindowDelegate>
{
    IBOutlet DubsImageView *imageView;
    IBOutlet AVPlayerView *player;
    IBOutlet NSTextField *placeholderField;
    NSMutableArray *fileArray;
    id eventMonitor;
}

@property (nonatomic, retain)  BFPageControl *pageControl;

- (void)updatePageControlForPage:(NSInteger)pageNumber;
- (void)addRoundyFieldHeaderWithText:(NSString*)text forView:(NSView*)view;
- (void)addRoundyFieldFooterWithText:(NSString*)text forView:(NSView*)view;

@end

