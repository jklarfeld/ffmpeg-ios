//
//  ViewController.h
//  ffmpeg
//
//  Created by Jeffrey Klarfeld on 3/6/14.
//  Copyright (c) 2014 Jeffrey Klarfeld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *videoLabel;
@property (weak, nonatomic) IBOutlet UIButton *convertOutlet;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (weak, nonatomic) IBOutlet UILabel *verboseLabel;

- (IBAction)openFromFileSystem:(UIButton *)sender;

- (IBAction)convertButton:(UIButton *)sender;
@end
