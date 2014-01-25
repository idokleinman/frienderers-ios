//
//  TKkillTargetViewController.m
//  Frienderers
//
//  Created by Ido on 24/Jan/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import "TKKillTargetViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "TKShootViewController.h"
#import "TKSoundManager.h"


@interface TKKillTargetViewController ()

@property (strong, nonatomic) NSString* nextTargetProfileID;

@end

@implementation TKKillTargetViewController

- (UIImage *) convertToGreyscale:(UIImage *)i {
    
    int kRed = 1;
    int kGreen = 2;
    int kBlue = 4;
    
    int colors = kGreen;
    int m_width = i.size.width;
    int m_height = i.size.height;
    
    uint32_t *rgbImage = (uint32_t *) malloc(m_width * m_height * sizeof(uint32_t));
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImage, m_width, m_height, 8, m_width * 4, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGContextSetShouldAntialias(context, NO);
    CGContextDrawImage(context, CGRectMake(0, 0, m_width, m_height), [i CGImage]);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // now convert to grayscale
    uint8_t *m_imageData = (uint8_t *) malloc(m_width * m_height);
    for(int y = 0; y < m_height; y++) {
        for(int x = 0; x < m_width; x++) {
            uint32_t rgbPixel=rgbImage[y*m_width+x];
            uint32_t sum=0,count=0;
            if (colors & kRed) {sum += (rgbPixel>>24)&255; count++;}
            if (colors & kGreen) {sum += (rgbPixel>>16)&255; count++;}
            if (colors & kBlue) {sum += (rgbPixel>>8)&255; count++;}
            m_imageData[y*m_width+x]=sum/count;
        }
    }
    free(rgbImage);
    
    // convert from a gray scale image back into a UIImage
    uint8_t *result = (uint8_t *) calloc(m_width * m_height *sizeof(uint32_t), 1);
    
    // process the image back to rgb
    for(int i = 0; i < m_height * m_width; i++) {
        result[i*4]=0;
        int val=m_imageData[i];
        result[i*4+1]=val;
        result[i*4+2]=val;
        result[i*4+3]=val;
    }
    
    // create a UIImage
    colorSpace = CGColorSpaceCreateDeviceRGB();

    context = CGBitmapContextCreate(result, m_width, m_height, 8, m_width * sizeof(uint32_t), colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGImageRef image = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    UIImage *resultUIImage = [UIImage imageWithCGImage:image];
    CGImageRelease(image);
    
    free(m_imageData);
    
    // make sure the data will be released by giving it to an autoreleased NSData
    [NSData dataWithBytesNoCopy:result length:m_width * m_height];
    
    return resultUIImage;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)targetApproveButton:(id)sender
{
    [[TKSoundManager sharedManager] playSound:@"target"];
    [self performSegueWithIdentifier:@"shoot" sender:self];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    TKShootViewController *svc = [segue destinationViewController];
    svc.targetProfileID = _nextTargetProfileID;
    
}


-(void)grayScaleImageFB:(NSTimer *)timer
{
    
    for (UIView *subview in self.nextTargetFBProfileImage.subviews)
    {
//        NSLog([subview description]);
        if ([subview isKindOfClass:[UIImageView class]])
        {
            NSLog(@"found imageview");
            UIImageView *im = (UIImageView *)subview;
            im.image = [self convertToGreyscale:im.image];
        }
    }

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[TKSoundManager sharedManager] stopSoundInBackground];
    
    [[TKServer sharedInstance] nextTarget:^(NSString *nextTargetProfileID, NSError *error) {
        if (error) {
            [[UIAlertView alertWithError:error] show];
            return;
        }

        [self.nextTargetFBProfileImage setProfileID:nextTargetProfileID];
        [self.nextTargetFBProfileImage setPictureCropping:FBProfilePictureCroppingSquare];
    
        _nextTargetProfileID = nextTargetProfileID;
        
        [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(grayScaleImageFB:) userInfo:Nil repeats:NO];
        
        [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"/%@",nextTargetProfileID] completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
             if (!error)
             {
                 // Success! Include your code to handle the results here
                 NSLog(@"Next target user info: %@", result);
                 self.killLabel.text = [NSString stringWithFormat:@"Kill %@ before someone else kills you!",[result objectForKey:@"first_name"]];
            }
            else
            {
                // An error occurred, we need to handle the error
            }
        }];
    }];
}
     
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
