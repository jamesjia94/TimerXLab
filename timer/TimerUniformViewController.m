//
//  TimerUniformViewController.m
//  timer
//
//  Created by XLab Developer on 11/11/12.
//  Copyright (c) 2012 Treehousecs.jamesmatt. All rights reserved.
//

#import "TimerUniformViewController.h"

@interface TimerUniformViewController ()
@property (weak, nonatomic) IBOutlet UIButton *takePictureButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation TimerUniformViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    //Gets all the image files from Document Directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSArray *filePathsArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:documentsDirectory  error:nil];
    NSMutableArray *imgFiles = [[NSMutableArray alloc] init];
    for (int i=0; i<filePathsArray.count; i++) {
        NSString *strFilePath = [filePathsArray objectAtIndex:0];
        if ([[strFilePath pathExtension] isEqualToString:@"jpg"]) {
            [imgFiles addObject:[filePathsArray objectAtIndex:i]];
        }
    }
    //Add code here that displays the images onto something
    
	_takePictureButton.hidden=YES;
    timer=[NSTimer scheduledTimerWithTimeInterval:3600 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
}

//Allows user to take a picture and notifies the user that the timer has gone off.
-(void)timerFired
{
    _takePictureButton.hidden=NO;
    UIApplication* app = [UIApplication sharedApplication];
    UILocalNotification* alarm = [[UILocalNotification alloc] init];
    alarm.fireDate = nil;
    alarm.alertBody = @"Check timer!";
    [app presentLocalNotificationNow:(alarm)];
}

//Given that device can take a picture, prompts user to take a picture. Otherwise, prompts user to pick a picture from photo reel.
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

//Saves the image onto photo reel and application's directory.
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //Saves image onto application's directory folder for later use.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:@"latest_photo.png"];
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"])
    {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        //Saves image onto phone's photo reel
        UIImageWriteToSavedPhotosAlbum(image, self,
                                       @selector(image:finishedSavingWithError:contextInfo:),
                                       nil);
        
        [self.imageView setImage:image];
        NSData *webData = UIImagePNGRepresentation(image);
        [webData writeToFile:imagePath atomically: YES];
    }
    [self dismissViewControllerAnimated:YES completion:Nil];
}

//Creates a notification if image cannot be saved.
-(void)image:(UIImage *)image
finishedSavingWithError:(NSError *)
error contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image/video"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

//Switches back to main view and invalidates the timer.
- (IBAction)cancel:(UIButton *)sender {
    [timer invalidate];
    [self dismissViewControllerAnimated:YES completion:Nil];
}
@end
