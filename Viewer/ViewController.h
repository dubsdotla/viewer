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

@interface ViewController : NSViewController <BFPageControlDelegate>
{
    IBOutlet DubsImageView *imageView;
    IBOutlet AVPlayerView *player;
    IBOutlet PlaceholderView *placeholderView;
    IBOutlet NSTextField *placeholderField;
    IBOutlet DubsWindow *dwindow;
    NSArray *fileArray;
    id eventMonitor;
}

@property (nonatomic, retain)  BFPageControl *pageControl;

- (void)updatePageControlForPage:(NSInteger)pageNumber;

@end

