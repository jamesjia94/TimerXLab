//
//  TimerUniformViewController.m
//  timer
//
//  Created by XLab Developer on 11/11/12.
//  Copyright (c) 2012 Treehousecs.jamesmatt. All rights reserved.
//  Inserted comment

#import "TimerUniformViewController.h"

@interface TimerUniformViewController ()
@property (weak, nonatomic) IBOutlet UIButton *takePictureButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation TimerUniformViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	_takePictureButton.hidden=YES;
    timer=[NSTimer scheduledTimerWithTimeInterval:3600 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
}

-(void)timerFired
{
    _takePictureButton.hidden=NO;
    UIApplication* app = [UIApplication sharedApplication];
    UILocalNotification* alarm = [[UILocalNotification alloc] init];
    alarm.fireDate = nil;
    alarm.alertBody = @"Check timer!";
    [app presentLocalNotificationNow:(alarm)];
}

- (IBAction)takePicture:(UIButton *)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    else
    {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    [imagePicker setDelegate:self];
    [self presentViewController:imagePicker animated:YES completion:Nil];
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:@"latest_photo.png"];
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"])
    {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        [self.imageView setImage:image];
        NSData *webData = UIImagePNGRepresentation(image);
        [webData writeToFile:imagePath atomically: YES];
    }
    [self dismissViewControllerAnimated:YES completion:Nil];
}

- (IBAction)cancel:(UIButton *)sender {
    [timer invalidate];
    [self dismissViewControllerAnimated:YES completion:Nil];
}
@end
