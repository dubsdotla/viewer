//
//  ViewController.m
//  Viewer
//
//  Created by Derek Scott on 5/13/17.
//  Copyright © 2017 Derek Scott. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController


- (void)viewDidLoad
{
    NSLog(@"viewDidLoad");
    [super viewDidLoad];

    //dwindow = (DubsWindow *)self.view.window;
    
    //NSLog(@"dwindow is: %@", dwindow);
    
    fileArray = [[NSMutableArray alloc] init];
    
    _pageControl = [[BFPageControl alloc] init];
    [_pageControl setDelegate: self];
    
    [_pageControl setHidesForSinglePage:YES];
    [_pageControl setNumberOfPages: 1];
    [_pageControl setIndicatorDiameterSize: 15];
    [_pageControl setIndicatorMargin: 10];
    [_pageControl setCurrentPage: 0];
    /*[_pageControl setDrawingBlock: ^(NSRect frame, NSView *aView, BOOL isSelected, BOOL isHighlighted){
     
     frame = NSInsetRect(frame, 2.0, 2.0);
     NSBezierPath *path = [NSBezierPath bezierPathWithOvalInRect: NSMakeRect(frame.origin.x, frame.origin.y + 1.5, frame.size.width, frame.size.height)];
     [[NSColor whiteColor] set];
     [path fill];
     
     path = [NSBezierPath bezierPathWithOvalInRect: frame];
     NSColor *color = isSelected ? [NSColor colorWithCalibratedRed: (115.0 / 255.0) green: (115.0 / 255.0) blue: (115.0 / 255.0) alpha: 1.0] :
     [NSColor colorWithCalibratedRed: (217.0 / 255.0) green: (217.0 / 255.0) blue: (217.0 / 255.0) alpha: 1.0];
     
     if(isHighlighted)
     color = [NSColor colorWithCalibratedRed: (150.0 / 255.0) green: (150.0 / 255.0) blue: (150.0 / 255.0) alpha: 1.0];
     
     [color set];
     [path fill];
     
     frame = NSInsetRect(frame, 0.5, 0.5);
     [[NSColor colorWithCalibratedRed: (25.0 / 255.0) green: (25.0 / 255.0) blue: (25.0 / 255.0) alpha: 0.15] set];
     [NSBezierPath setDefaultLineWidth: 1.0];
     [[NSBezierPath bezierPathWithOvalInRect: frame] stroke];
     }];*/
}

- (void)viewDidAppear
{
    NSLog(@"viewDidAppear");
    [super viewDidAppear];
    
    DubsWindow *dwindow = (DubsWindow *)self.view.window;
    dwindow.delegate = self;
    
    eventMonitor = [NSEvent addLocalMonitorForEventsMatchingMask:
                    (NSLeftMouseDownMask | NSRightMouseDownMask | NSOtherMouseDownMask | NSKeyDownMask | NSScrollWheelMask)
                                                         handler:^(NSEvent *incomingEvent) {
                                                             NSEvent *result = incomingEvent;
                                                             //NSWindow *targetWindowForEvent = [incomingEvent window];
                                                             
                                                             //NSLog(@"targetWindowForEventIs: %@", targetWindowForEvent);
                                                             
                                                             if ([incomingEvent type] == NSKeyDown)
                                                             {
                                                                 if([incomingEvent keyCode] == 123)
                                                                 {
                                                                     result = nil;
                                                                     
                                                                     //NSLog(@"SWIPE LEFT");
                                                                     [[NSNotificationCenter defaultCenter] postNotificationName:@"DubsLeftArrow" object:nil userInfo:nil];
                                                                 }
                                                                 
                                                                 else if([incomingEvent keyCode] == 124)
                                                                 {
                                                                     result = nil;
                                                                     
                                                                     //NSLog(@"SWIPE RIGHT");
                                                                     [[NSNotificationCenter defaultCenter] postNotificationName:@"DubsRightArrow" object:nil userInfo:nil];
                                                                 }
                                                                 
                                                                 //NSLog(@"keyCode is: %d", [incomingEvent keyCode]);
                                                             }
                                                             
                                                             else if(([incomingEvent type] == NSScrollWheel) && ([incomingEvent phase] != NSEventPhaseNone) && !(fabs([incomingEvent scrollingDeltaX]) <= fabs([incomingEvent scrollingDeltaY])))
                                                             {
                                                                 [incomingEvent trackSwipeEventWithOptions:0 dampenAmountThresholdMin:-1 max:1 usingHandler:^(CGFloat gestureAmount, NSEventPhase phase, BOOL isComplete, BOOL *stop) {
                                                                     if (phase ==  NSEventPhaseBegan)
                                                                     {
                                                                         if (gestureAmount > 0)
                                                                         {
                                                                             //NSLog(@"SWIPE LEFT");
                                                                             [[NSNotificationCenter defaultCenter] postNotificationName:@"DubsLeftArrow" object:nil userInfo:nil];
                                                                         }
                                                                         
                                                                         else
                                                                         {
                                                                             //NSLog(@"SWIPE RIGHT");
                                                                             [[NSNotificationCenter defaultCenter] postNotificationName:@"DubsRightArrow" object:nil userInfo:nil];
                                                                         }
                                                                     }
                                                                     *stop = NO;
                                                                 }];
                                                                 
                                                                 result = nil;
                                                             }
                                                             
                                                             return result;
                                                         }];
    
    if(placeholderField.hidden == NO)
    {
        //[dwindow setMaxSize:[[NSScreen mainScreen] frame].size];
        
        CGFloat xPos = NSWidth([[dwindow screen] frame])/2 - NSWidth([dwindow frame])/2;
        CGFloat yPos = NSHeight([[dwindow screen] frame])/2 - NSHeight([dwindow frame])/2;
        [dwindow setFrame:NSMakeRect(xPos, yPos, 480, 270) display:YES];
        
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fileDropped:)
                                                 name:@"fileDroppedNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fileCanceled:)
                                                 name:@"fileCanceledNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                            selector:@selector(previousItem:)
                                                name:@"DubsLeftArrow" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(nextItem:)
                                                 name:@"DubsRightArrow" object:nil];
}

- (void)viewDidDisappear
{
    self.view.window.delegate = nil;
    
    NSLog(@"viewDidDisappear");
    [super viewDidDisappear];
    
    [NSEvent removeMonitor:eventMonitor];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)windowDidEnterFullScreen:(NSNotification *)notification
{
    NSLog(@"windowDidEnterFullScreen");
    
    if([fileArray count] > 0)
    {
        [self pageControl:_pageControl didSelectPageAtIndex:_pageControl.currentPage];
    }
}

- (void)windowDidExitFullScreen:(NSNotification *)notification
{
    NSLog(@"windowDidExitFullScreen");
    
    if([fileArray count] > 0)
    {
        [self pageControl:_pageControl didSelectPageAtIndex:_pageControl.currentPage];
    }
}

- (void)fileDropped:(NSNotification *)notification
{
    [player.player pause];
    [imageView setImage:nil];
    
    NSDictionary *userInfo = notification.userInfo;
    fileArray =  [userInfo objectForKey:@"filePaths"];
    
    if([fileArray count] > 0)
    {
        [NSApp activateIgnoringOtherApps:YES];
        [_pageControl setNumberOfPages:[fileArray count]];
        [_pageControl setCurrentPage:0];

        [self pageControl:_pageControl didSelectPageAtIndex:0];
    }
}

- (void)setMediaForPage:(NSInteger)pageNumber
{
    DubsWindow *dwindow = (DubsWindow *)self.view.window;
    
    NSString *filePath = [fileArray objectAtIndex:pageNumber];
    
    NSLog(@"FILEPATH IS: %@", filePath);
    
    CFStringRef fileExtension = (__bridge CFStringRef) [filePath pathExtension];
    CFStringRef fileUTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExtension, NULL);
    
    NSLog(@"FILEUTI IS: %@", (__bridge NSString*)fileUTI);
    
    [dwindow setMaxSize:NSMakeSize([[dwindow screen] frame].size.width, [[dwindow screen] frame].size.height)];
    
    if (UTTypeConformsTo(fileUTI, kUTTypeImage) || UTTypeConformsTo(fileUTI, kUTTypePDF) || [(__bridge NSString*)fileUTI isEqualToString:@"com.adobe.encapsulated-postscript"])
    {
        NSImage *droppedImage = [[NSImage alloc] initWithContentsOfFile:filePath];
        
        if(droppedImage == NULL)
        {
            NSLog(@"Can't open image \"%@\"", [filePath lastPathComponent]);
            return;
        }
        
        [imageView setImage:droppedImage];
        
        NSSize imageSize = [droppedImage size];
        
        [dwindow setAspectRatio:imageSize];
        [dwindow setContentSize:imageSize];
        
        if(([dwindow styleMask] & NSFullScreenWindowMask) == NSFullScreenWindowMask)
        {
            CGFloat xPos = NSWidth([[NSScreen mainScreen] frame])/2 - NSWidth([[NSScreen mainScreen] frame])/2;
            CGFloat yPos = NSHeight([[NSScreen mainScreen] frame])/2 - NSHeight([[NSScreen mainScreen] frame])/2;
            [dwindow setFrame:NSMakeRect(xPos, yPos, NSWidth([[NSScreen mainScreen] frame]), NSHeight([[NSScreen mainScreen] frame])) display:YES];
        }
        
        else
        {
            CGFloat xPos = NSWidth([[dwindow screen] frame])/2 - NSWidth([dwindow frame])/2;
            CGFloat yPos = NSHeight([[dwindow screen] frame])/2 - NSHeight([dwindow frame])/2;
            [dwindow setFrame:NSMakeRect(xPos, yPos, NSWidth([dwindow frame]), NSHeight([dwindow frame])) display:YES];
        }
        
        if(placeholderField.hidden == NO)
            [placeholderField setHidden:YES];
        
        if(imageView.hidden == YES)
            [imageView setHidden:NO];
        
        if(player.hidden == NO)
            [player setHidden:YES];
        
        [dwindow setTitle:[filePath lastPathComponent]];
        [self addRoundyFieldWithText:[filePath lastPathComponent] forView:imageView];
    }
    
    else if (UTTypeConformsTo(fileUTI, kUTTypeMovie))
    {
        AVAsset *asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:filePath]];
        
        if(asset == NULL)
        {
            NSLog(@"Can't open movie \"%@\"", [filePath lastPathComponent]);
            return;
        }
        
        NSSize assetSize = [[[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] naturalSize];
        
        player.player = [AVPlayer playerWithPlayerItem:[AVPlayerItem playerItemWithAsset:asset]];
        
        [dwindow setAspectRatio:assetSize];
        [dwindow setContentSize:assetSize];
        
        if(([dwindow styleMask] & NSFullScreenWindowMask) == NSFullScreenWindowMask)
        {
            CGFloat xPos = NSWidth([[NSScreen mainScreen] frame])/2 - NSWidth([[NSScreen mainScreen] frame])/2;
            CGFloat yPos = NSHeight([[NSScreen mainScreen] frame])/2 - NSHeight([[NSScreen mainScreen] frame])/2;
            [dwindow setFrame:NSMakeRect(xPos, yPos, NSWidth([[NSScreen mainScreen] frame]), NSHeight([[NSScreen mainScreen] frame])) display:YES];
        }
        
        else
        {
            CGFloat xPos = NSWidth([[dwindow screen] frame])/2 - NSWidth([dwindow frame])/2;
            CGFloat yPos = NSHeight([[dwindow screen] frame])/2 - NSHeight([dwindow frame])/2;
            [dwindow setFrame:NSMakeRect(xPos, yPos, NSWidth([dwindow frame]), NSHeight([dwindow frame])) display:YES];
        }
    
        if(placeholderField.hidden == NO)
            [placeholderField setHidden:YES];
        
        if(imageView.hidden == NO)
            [imageView setHidden:YES];
        
        if(player.hidden == YES)
            [player setHidden:NO];
        
        [dwindow setTitle:[filePath lastPathComponent]];
        [self addRoundyFieldWithText:[filePath lastPathComponent] forView:player];
    }
    
    else if (UTTypeConformsTo(fileUTI, kUTTypeAudio))
    {
        AVAsset *asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:filePath]];
        
        if(asset == NULL)
        {
            NSLog(@"Can't open audio \"%@\"", [filePath lastPathComponent]);
            return;
        }
        
        player.player = [AVPlayer playerWithPlayerItem:[AVPlayerItem playerItemWithAsset:asset]];
        
        NSSize assetSize = {480, 270};
        
        [dwindow setAspectRatio:assetSize];
        [dwindow setContentSize:[[NSScreen mainScreen] frame].size];
        
        if(([dwindow styleMask] & NSFullScreenWindowMask) == NSFullScreenWindowMask)
        {
            CGFloat xPos = NSWidth([[NSScreen mainScreen] frame])/2 - NSWidth([[NSScreen mainScreen] frame])/2;
            CGFloat yPos = NSHeight([[NSScreen mainScreen] frame])/2 - NSHeight([[NSScreen mainScreen] frame])/2;
            [dwindow setFrame:NSMakeRect(xPos, yPos, NSWidth([[NSScreen mainScreen] frame]), NSHeight([[NSScreen mainScreen] frame])) display:YES];
        }
        
        else
        {
            CGFloat xPos = NSWidth([[dwindow screen] frame])/2 - (480/2);
            CGFloat yPos = NSHeight([[dwindow screen] frame])/2 - (270/2);
            [dwindow setFrame:NSMakeRect(xPos, yPos, 480, 270) display:YES];
        }
        
        if(placeholderField.hidden == NO)
            [placeholderField setHidden:YES];
        
        if(imageView.hidden == NO)
            [imageView setHidden:YES];
        
        if(player.hidden == YES)
            [player setHidden:NO];
        
        [dwindow setTitle:[filePath lastPathComponent]];
        [self addRoundyFieldWithText:[filePath lastPathComponent] forView:player];
    }
    
    /*else if (UTTypeConformsTo(fileUTI, kUTTypeText))
     {
     NSLog(@"It's text");
     }*/
    
    CFRelease(fileUTI);
}

- (void)addRoundyFieldWithText:(NSString*)text forView:(NSView*)view
{
    DubsWindow *dwindow = (DubsWindow *)self.view.window;
    
    [view.subviews enumerateObjectsUsingBlock:^(NSView * subview, NSUInteger idx, BOOL *stop) {
        if([subview isMemberOfClass:[RoundView class]])
            [subview removeFromSuperview];
    }];
    
    NSString *dummyText = text;
    NSFont *textFont = [NSFont systemFontOfSize:24 weight:NSFontWeightBlack];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:textFont,NSFontAttributeName,nil];
    CGSize textSize = [dummyText sizeWithAttributes:attributes];
    
    if((textSize.width + 24) > [dwindow.contentView  bounds].size.width)
    {
        textSize.width = [dwindow.contentView  bounds].size.width - 24;
    }
    
    RoundView *roundy = [[RoundView alloc] initWithFrame:NSMakeRect(90,40,textSize.width + 24,30)];
    
    NSTextField *roundyField = [[NSTextField alloc] initWithFrame:NSMakeRect(0,0,textSize.width + 24,30)];
    [roundyField setDrawsBackground:NO];
    [roundyField setBordered:NO];
    [roundyField setBezeled:NO];
    [roundyField setFont:textFont];
    [roundyField setTextColor:[NSColor whiteColor]];
    [roundyField setStringValue:dummyText];
    [roundyField setEditable:NO];
    roundyField.alignment = NSTextAlignmentCenter;
    
    /*[roundy setFrameOrigin:NSMakePoint(
                                       (NSWidth([dwindow.contentView  bounds]) - NSWidth([roundy frame])) / 2,
                                       (NSHeight([dwindow.contentView  bounds]) - NSHeight([roundy frame])) / 2
                                       )];*/
    
    [roundy setFrameOrigin:NSMakePoint(
                                       (NSWidth([dwindow.contentView  bounds]) - NSWidth([roundy frame])) / 2,
                                       dwindow.contentView.frame.size.height - 50
                                       )];
    
    [roundy setAutoresizingMask:NSViewMinXMargin | NSViewMaxXMargin | NSViewMinYMargin | NSViewMaxYMargin];
    
    [roundy addSubview:roundyField];
    
    [view addSubview:roundy];
    
    [roundy fadeInWithDuration:4.0 completionBlock:^{
        [roundy fadeOutWithDuration:4.0 completionBlock:^{
        }];
    }];
}

- (void)updatePageControlForPage:(NSInteger)pageNumber
{
    DubsWindow *dwindow = (DubsWindow *)self.view.window;
    
    if([_pageControl superview])
    {
        [_pageControl removeFromSuperview];
    }
    
    [_pageControl setCurrentPage: pageNumber];
    
    [dwindow.contentView addSubview: _pageControl];
    NSSize size = [_pageControl intrinsicContentSize];
    [_pageControl setFrame: NSMakeRect((dwindow.frame.size.width - size.width)/2, 10, size.width, size.height)];    
}

- (void)fileCanceled:(NSNotification *)notification
{
    DubsWindow *dwindow = (DubsWindow *)self.view.window;
   
    if([_pageControl superview])
    {
        [_pageControl removeFromSuperview];
    }
    
    [player.player pause];
    [imageView setImage:nil];
    
    //[dwindow setMaxSize:[[NSScreen mainScreen] frame].size];
    
    [dwindow setFrame:NSMakeRect(0, 0, 480, 270) display:YES];
    CGFloat xPos = NSWidth([[dwindow screen] frame])/2 - NSWidth([dwindow frame])/2;
    CGFloat yPos = NSHeight([[dwindow screen] frame])/2 - NSHeight([dwindow frame])/2;
    [dwindow setFrame:NSMakeRect(xPos, yPos, NSWidth([dwindow frame]), NSHeight([dwindow frame])) display:YES];
    
    [placeholderField setHidden:NO];
    [imageView setHidden:YES];
    [player setHidden:YES];
    
    dwindow.title = @"";
}

-(void)pageControl: (BFPageControl *)control didSelectPageAtIndex: (NSInteger)index
{
    //NSLog(@"%@: Selected page at index: %li", control, index);
    //NSLog(@"control.currentPage is: %ld", (long)control.currentPage);
    
    [self setMediaForPage:index];
    [self updatePageControlForPage:index];
}

- (void)previousItem:(NSNotification *)aNotification
{
    //NSLog(@"control.currentPage is: %ld", (long)_pageControl.currentPage);
    
    if(_pageControl.currentPage != 0)
    {
        [self pageControl:_pageControl didSelectPageAtIndex:_pageControl.currentPage-1];
    }
}

- (void)nextItem:(NSNotification *)aNotification
{
    //NSLog(@"control.currentPage is: %ld", (long)_pageControl.currentPage);
    
    if(_pageControl.currentPage != (_pageControl.numberOfPages - 1) )
    {
        [self pageControl:_pageControl didSelectPageAtIndex:_pageControl.currentPage+1];
    }
}

- (void)setRepresentedObject:(id)representedObject
{
    [super setRepresentedObject:representedObject];
    // Update the view, if already loaded.
}

@end
