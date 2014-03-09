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
	
	[_progress setProgress:0];
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
		double progress = 0;
		progress = totalBytesRead;
		progress = progress/totalBytesExpectedToRead;
		
		[_progress setProgress:progress animated:YES];
		
		float mbRead = totalBytesRead/1000/1000;
		float mbTotal = totalBytesExpectedToRead/1000/1000;
		
		NSString *status = [NSString stringWithFormat:@"%.1fmb of %.1fmb read.", mbRead, mbTotal];
		
		[_verboseLabel setText:status];
	};
	
	FFmpegWrapperCompletionBlock completeBlock = ^(BOOL success, NSError *error)
	{
		if (success)
		{
			[_progress setProgressTintColor:[UIColor greenColor]];
			[_verboseLabel setText:[_verboseLabel.text stringByAppendingString:@"..Success!"]];
			NSFileManager *fileMan = [NSFileManager defaultManager];
			NSError *deleteError;
			[fileMan removeItemAtURL:_appDel.videoURL error:&deleteError];
			if (deleteError)
			{
				[_verboseLabel setText:[NSString stringWithFormat:@"Error cleaning up: %@", deleteError]];
			}
		}
		else
		{
			NSLog(@"Error: %@", error);
		}
		
	};
	
	NSDictionary *opts = [[NSDictionary alloc] initWithObjects:@[@"mp4"]
													   forKeys:@[kFFmpegInputFormatKey]];
	
	[_encoder convertInputPath:input.path
					outputPath:outputPath
					   options:opts
				 progressBlock:progBlock
			   completionBlock:completeBlock];
}

@end
