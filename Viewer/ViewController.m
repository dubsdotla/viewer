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
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)awakeFromNib
{
    dwindow = (DubsWindow *)self.view.window;
}

- (void)viewDidAppear
{
    [super viewDidAppear];
    
    if(placeholderField.hidden == NO)
    {
        [dwindow setMaxSize:[[NSScreen mainScreen] frame].size];
        
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
}

- (void)viewDidDisappear
{
    [super viewDidDisappear];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)fileDropped:(NSNotification *)notification
{
    [player.player pause];
    [imageView setImage:nil];
    
    NSDictionary *userInfo = notification.userInfo;
    NSString *filePath = [userInfo objectForKey:@"filePath"];
    NSLog(@"FILEPATH IS: %@", filePath);
    
    CFStringRef fileExtension = (__bridge CFStringRef) [filePath pathExtension];
    CFStringRef fileUTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExtension, NULL);
    
    NSLog(@"FILEUTI IS: %@", (__bridge NSString*)fileUTI);
    
    if (UTTypeConformsTo(fileUTI, kUTTypeImage) || UTTypeConformsTo(fileUTI, kUTTypePDF) || [(__bridge NSString*)fileUTI isEqualToString:@"com.adobe.encapsulated-postscript"])
    {
        NSImage *droppedImage = [[NSImage alloc] initWithContentsOfFile:filePath];
        
        [imageView setImage:droppedImage];
        
        NSSize imageSize = [droppedImage size];
        
        [dwindow setAspectRatio:imageSize];
        [dwindow setContentSize:imageSize];
        
        CGFloat xPos = NSWidth([[dwindow screen] frame])/2 - NSWidth([dwindow frame])/2;
        CGFloat yPos = NSHeight([[dwindow screen] frame])/2 - NSHeight([dwindow frame])/2;
        [dwindow setFrame:NSMakeRect(xPos, yPos, NSWidth([dwindow frame]), NSHeight([dwindow frame])) display:YES];
        
        [placeholderField setHidden:YES];
        [imageView setHidden:NO];
        [player setHidden:YES];
    }
    
    else if (UTTypeConformsTo(fileUTI, kUTTypeMovie))
    {
        AVAsset *asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:filePath]];
        
        NSSize assetSize = [[[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] naturalSize];
        
        player.player = [AVPlayer playerWithPlayerItem:[AVPlayerItem playerItemWithAsset:asset]];
        
        [dwindow setAspectRatio:assetSize];
        [dwindow setContentSize:assetSize];
        
        CGFloat xPos = NSWidth([[dwindow screen] frame])/2 - NSWidth([dwindow frame])/2;
        CGFloat yPos = NSHeight([[dwindow screen] frame])/2 - NSHeight([dwindow frame])/2;
        [dwindow setFrame:NSMakeRect(xPos, yPos, NSWidth([dwindow frame]), NSHeight([dwindow frame])) display:YES];
        
        [placeholderField setHidden:YES];
        [imageView setHidden:YES];
        [player setHidden:NO];
    }
    
    else if (UTTypeConformsTo(fileUTI, kUTTypeAudio))
    {
        AVAsset *asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:filePath]];
                
        player.player = [AVPlayer playerWithPlayerItem:[AVPlayerItem playerItemWithAsset:asset]];
        
        NSSize assetSize = {480, 270};
        
        [dwindow setAspectRatio:assetSize];
        [dwindow setContentSize:[[NSScreen mainScreen] frame].size];
        
        CGFloat xPos = NSWidth([[dwindow screen] frame])/2 - (480/2);
        CGFloat yPos = NSHeight([[dwindow screen] frame])/2 - (270/2);
        [dwindow setFrame:NSMakeRect(xPos, yPos, 480, 270) display:YES];
        
        [placeholderField setHidden:YES];
        [imageView setHidden:YES];
        [player setHidden:NO];
    }
    
    /*else if (UTTypeConformsTo(fileUTI, kUTTypeText))
    {
        NSLog(@"It's text");
    }*/
    
    CFRelease(fileUTI);
}

- (void)fileCanceled:(NSNotification *)notification
{
    [player.player pause];
    [imageView setImage:nil];
    
    [dwindow setMaxSize:[[NSScreen mainScreen] frame].size];
    
    [dwindow setFrame:NSMakeRect(0, 0, 480, 270) display:YES];
    CGFloat xPos = NSWidth([[dwindow screen] frame])/2 - NSWidth([dwindow frame])/2;
    CGFloat yPos = NSHeight([[dwindow screen] frame])/2 - NSHeight([dwindow frame])/2;
    [dwindow setFrame:NSMakeRect(xPos, yPos, NSWidth([dwindow frame]), NSHeight([dwindow frame])) display:YES];
    
    [placeholderField setHidden:NO];
    [imageView setHidden:YES];
    [player setHidden:YES];
}

- (void)setRepresentedObject:(id)representedObject
{
    [super setRepresentedObject:representedObject];
    // Update the view, if already loaded.
}


@end
