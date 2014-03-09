//
//  AppDelegate.m
//  ffmpeg
//
//  Created by Jeffrey Klarfeld on 3/6/14.
//  Copyright (c) 2014 Jeffrey Klarfeld. All rights reserved.
//

#import "AppDelegate.h"
#include "avformat.h"
#include "avcodec.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	av_register_all();
	avcodec_register_all();
	
	AVCodec *h264 = avcodec_find_encoder(CODEC_ID_H264);
    
	NSLog(@"h264: %s", h264->long_name);
	
	AVCodec * codec = NULL;
	while((codec = av_codec_next(codec)))
	{
		//NSLog(@"%s: %s", codec->name, codec->long_name);
	}
    
	AVCodec *other = avcodec_find_encoder_by_name("libx264");
    
	NSLog(@"h264: %s", other->long_name);
	
	AVBitStreamFilterContext *temp = av_bitstream_filter_init("h264_mp4toannexb");
	
	if (temp)
	{
		NSLog(@"temp was init!");
	}
	else
	{
		NSLog(@"temp wasn't init");
	}
	
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
	NSLog(@"url: %@", url);
	NSLog(@"sourceApplication: %@", sourceApplication);
	
	_videoURL = url;
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"com.ffmpeg.videoURLArrived" object:self];
	
	return YES;
}

- (NSString *) applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

@end
