//
//  ViewController.m
//  ffmpeg
//
//  Created by Jeffrey Klarfeld on 3/6/14.
//  Copyright (c) 2014 Jeffrey Klarfeld. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)urlArrived
{
	AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	_videoLabel.text = [@"Video: " stringByAppendingString:[appDel.videoURL.pathComponents lastObject]];
}

@end
