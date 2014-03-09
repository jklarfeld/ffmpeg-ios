//
//  ViewController.m
//  ffmpeg
//
//  Created by Jeffrey Klarfeld on 3/6/14.
//  Copyright (c) 2014 Jeffrey Klarfeld. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import <FFmpegWrapper.h>
#import "avformat.h"
#import "avcodec.h"
#define simulatorURL @"file:///Users/jklarfeld/Dropbox/Videos/Tuerck'd_Ep.6_orig.mp4"

@interface ViewController ()

@property (strong, nonatomic) AppDelegate *appDel;
@property (strong, atomic) FFmpegWrapper *encoder;

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
	_encoder = [[FFmpegWrapper alloc] init];
	[_convertOutlet setEnabled:NO];
	
	AVCodec *codec = avcodec_find_encoder_by_name("libx264");
	NSLog(@"find encoder by name: %s", codec->long_name);
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)urlArrived
{
	_videoLabel.text = [@"Video: " stringByAppendingString:[_appDel.videoURL.pathComponents lastObject]];
	[_convertOutlet setEnabled:YES];
}

- (IBAction)openFromFileSystem:(UIButton *)sender
{
    NSURL *vidURL = [NSURL URLWithString:simulatorURL];
    _appDel.videoURL = vidURL;
    _videoLabel.text = [@"Video: " stringByAppendingString:[_appDel.videoURL.pathComponents lastObject]];
	[_convertOutlet setEnabled:YES];
}

- (IBAction)convertButton:(UIButton *)sender
{
	if (_appDel.videoURL)
	{
		[self convertWithInputPath:_appDel.videoURL];
	}
	
}

- (void)convertWithInputPath:(NSURL *)input
{
	NSString *outputPath = [[_appDel applicationDocumentsDirectory] stringByAppendingString:@"/out.ts"];
	NSLog(@"outputPath: %@", outputPath);
	
	FFmpegWrapperProgressBlock progBlock = ^(NSUInteger bytesRead, uint64_t totalBytesRead, uint64_t totalBytesExpectedToRead)
	{
		NSLog(@"progBlock:");
		NSLog(@"Total Bytes Read: %llu", totalBytesRead);
		NSLog(@"Bytes Read: %lu", (unsigned long)bytesRead);
		NSLog(@"Total Bytes Expected: %llu", totalBytesExpectedToRead);
	};
	
	FFmpegWrapperCompletionBlock completeBlock = ^(BOOL success, NSError *error)
	{
		if (success)
		{
			NSLog(@"Success!");
		}
		else
		{
			NSLog(@"Error: %@", error);
		}
		
	};
	
	NSDictionary *opts = [[NSDictionary alloc] initWithObjects:@[@"mp4", @"ts"]
													   forKeys:@[kFFmpegInputFormatKey, kFFmpegOutputFormatKey]];
	
	[_encoder convertInputPath:input.path
					outputPath:outputPath
					   options:opts
				 progressBlock:progBlock
			   completionBlock:completeBlock];
}

@end
