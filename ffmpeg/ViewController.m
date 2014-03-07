//
//  ViewController.m
//  ffmpeg
//
//  Created by Jeffrey Klarfeld on 3/6/14.
//  Copyright (c) 2014 Jeffrey Klarfeld. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

#define simulatorURL @"file:///Users/jklarfeld/Dropbox/Videos/Tuerckd_Ep.6%20%5B720p%5D.mp4"

@interface ViewController ()

@property (strong, nonatomic) AppDelegate *appDel;

@end

@implementation ViewController

@synthesize videoLabel = _videoLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(urlArrived)
												 name:@"com.ffmpeg.videoURLArrived"
											   object:nil];
    _appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)urlArrived
{
	_videoLabel.text = [@"Video: " stringByAppendingString:[_appDel.videoURL.pathComponents lastObject]];
}

- (IBAction)openFromFileSystem:(UIButton *)sender
{
    NSURL *vidURL = [NSURL URLWithString:simulatorURL];
    _appDel.videoURL = vidURL;
    _videoLabel.text = [@"Video: " stringByAppendingString:[_appDel.videoURL.pathComponents lastObject]];
}
@end
