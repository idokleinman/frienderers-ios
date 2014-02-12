//
//  TKAppViewController.m
//  Frienderers
//
//  Created by Amit Attias on 1/24/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import "TKAppViewController.h"
#import "TKServer.h"
#import "TKAppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import <NSObject+BKBlockObservation.h>

TKAppViewController* AppController() {
    return ((TKAppDelegate*)[UIApplication sharedApplication].delegate).appViewController;
}

@interface TKInternalViewController : UIViewController
@end

@implementation TKInternalViewController
@end

@interface TKAppViewController ()

@property (strong, nonatomic) TKInternalViewController* internalViewController;
@property (strong, nonatomic) IBOutlet UIButton* testerButton;

@end

@implementation TKAppViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

#ifdef DEBUG
    self.testerButton.hidden = NO;
#endif
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"remoteNotificationReceived" object:nil];
    
    UINavigationController* n = self.childViewControllers[0];
    self.internalViewController = (TKInternalViewController*)n.topViewController;
    
    self.profilePictures = [NSMutableDictionary dictionary];
    
    [[TKServer sharedInstance] bk_addObserverForKeyPath:@"state" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld task:^(id obj, NSDictionary *change) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString* currentState = NSStringFromTKUserState([TKServer sharedInstance].state);
            
            if ([change[NSKeyValueChangeNewKey] intValue] == [change[NSKeyValueChangeOldKey] intValue]) {
                return; // value change
            }

            NSLog(@"state changed to: %@, %@", currentState, change);
            
            [self.internalViewController.navigationController popToRootViewControllerAnimated:NO];
            UIViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:currentState];
            [self.internalViewController.navigationController pushViewController:vc animated:NO];

        });
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self reloadState];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)reloadState {
    NSLog(@"reload state");

    [[TKServer sharedInstance] hello:^(TKGameInfo *gameInfo, NSError *error) {
//        [self.internalViewController dismissViewControllerAnimated:NO completion:nil];
//        
//        if (gameInfo) {
//            [self.internalViewController performSegueWithIdentifier:@"game" sender:self];
//        }
//        else {
//            [self.internalViewController performSegueWithIdentifier:@"create" sender:self];
//        }
    }];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(TKNotificationView *)createNotificationViewWithData:(NSDictionary *)data
{
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"TKNotificationView" owner:self options:nil];
    TKNotificationView *view = arr[0];
    
    RemoteNotifications type = (RemoteNotifications)[data[@"type"] intValue];
    
    switch (type) {
        case remoteNotificationKillSucceeded:
            //popup
            [view.popupView.layer setBorderColor:[UIColor redColor].CGColor];
            [view.popupView.layer setBorderWidth:2.0];
            view.headerLabel.hidden = YES;
            [view.topTitleLabel setText:@"KILLED"];
            [view.topTitleLabel setFont:[UIFont fontWithName:@"Rosewood" size:67.0]];
            [view.fbProfilePicture setImage:self.profilePictures[data[@"subjectid"]]];
            [view.bottomTitleLabel setText:@"REST IN PEACE"];
            [view.bottomTitleLabel setFont:[UIFont fontWithName:@"Rosewood" size:35.0]];
            view.continueButton.hidden = YES;
            view.buttonLabel.hidden = YES;
            view.needsToFadeOut = YES;
            view.singleLabel.hidden = YES;
            view.notificationImage.hidden = YES;
            
            break;
            
        case remoteNotificationKillFailed:
            // popup
            [view.singleLabel setAttributedText:getAsPopupAttributedString(@"Witness \n Warning!", NSTextAlignmentCenter)];
            view.headerLabel.hidden = YES;
            view.topTitleLabel.hidden = YES;
            view.notificationImage.hidden = YES;
            view.bottomTitleLabel.hidden = YES;
            view.continueButton.hidden = YES;
            view.fbProfilePicture.hidden = YES;
            view.buttonLabel.hidden = YES;
            view.needsToFadeOut = YES;
            
            break;
        
        case remoteNotificationRunAway:
            // popup
            [view.singleLabel setAttributedText:getAsPopupAttributedString(@"Shooting \n Nearby!", NSTextAlignmentCenter)];
            view.headerLabel.hidden = YES;
            view.topTitleLabel.hidden = YES;
            view.notificationImage.hidden = YES;
            view.fbProfilePicture.hidden = YES;
            view.bottomTitleLabel.hidden = YES;
            view.continueButton.hidden = YES;
            view.buttonLabel.hidden = YES;
            view.needsToFadeOut = YES;
            
            break;
            
        case remoteNotificationSomeoneDied:
            // popup
            [view.popupView.layer setBorderColor:[UIColor redColor].CGColor];
            [view.popupView.layer setBorderWidth:2.0];
            view.headerLabel.hidden = YES;
            [view.topTitleLabel setText:@"KILLED"];
            [view.topTitleLabel setFont:[UIFont fontWithName:@"Rosewood" size:67.0]];
            [view.fbProfilePicture setImage:self.profilePictures[data[@"subjectid"]]];
            [view.bottomTitleLabel setText:@"REST IN PEACE"];
            [view.bottomTitleLabel setFont:[UIFont fontWithName:@"Rosewood" size:35.0]];
            view.continueButton.hidden = YES;
            view.buttonLabel.hidden = YES;
            view.needsToFadeOut = YES;
            view.singleLabel.hidden = YES;
            view.notificationImage.hidden = YES;
            
            break;
            
        case remoteNotificationSomeoneWin:
            [view.headerLabel setAttributedText:getAsSmallAttributedString([NSString stringWithFormat:@"%@ just killed the last victim", data[@"name"]],NSTextAlignmentCenter)];
            view.headerLabel.hidden = YES;
            [view.topTitleLabel setText:@"WINNER"];
            [view.topTitleLabel setFont:[UIFont fontWithName:@"Rosewood" size:67.0]];
            [view.fbProfilePicture setImage:self.profilePictures[data[@"subjectid"]]];
            [view.bottomTitleLabel setText:@"MEGA KILLER"];
            [view.bottomTitleLabel setFont:[UIFont fontWithName:@"Rosewood" size:35.0]];
            
            [view.buttonLabel setAttributedText:getAsSmallAttributedString(@"Let's start another round", NSTextAlignmentCenter)];
            view.needsToFadeOut = NO;
            view.singleLabel.hidden = YES;
            view.notificationImage.hidden = YES;
            
            break;
            
        case remoteNotificationYouDead:
            [view.headerLabel setAttributedText:getAsSmallAttributedString([NSString stringWithFormat:@"%@ just shot you", data[@"name"]], NSTextAlignmentCenter)];
            [view.topTitleLabel setText:@"YOU'RE DEAD"];
            [view.topTitleLabel setFont:[UIFont fontWithName:@"Rosewood" size:40.0]];
            [view.fbProfilePicture setImage:self.profilePictures[data[@"subjectid"]]];
            [view.bottomTitleLabel setText:@"REST IN PEACE"];
            [view.bottomTitleLabel setFont:[UIFont fontWithName:@"Rosewood" size:35.0]];
            view.continueButton.hidden = YES;
            [view.buttonLabel setAttributedText:getAsSmallAttributedString(@"You won't be forgotten & will be updated with the events to come", NSTextAlignmentCenter)];
            view.singleLabel.hidden = YES;
            view.needsToFadeOut = NO;
            view.notificationImage.hidden = YES;
            
            break;
            
        case remoteNotificationGameBegins:
            [view.singleLabel setAttributedText:getAsSmallAttributedString(@"The game is starting now! \n There's no way out \n All you have left is to kill or die", NSTextAlignmentCenter)];
            view.headerLabel.hidden = YES;
            view.topTitleLabel.hidden = YES;
            view.notificationImage.hidden = YES;
            view.bottomTitleLabel.hidden = YES;
            view.fbProfilePicture.hidden = YES;
            view.continueButton.hidden = YES;
            view.buttonLabel.hidden = YES;
            view.needsToFadeOut = YES;
            
            break;
            
        case remoteNotificationsInviteReceived:
        {
            NSString *str = [NSString stringWithFormat:@"%@ has invited you to join a Frienderers game starts on %@", data[@"name"], data[@"start_time"]];
            
            [view.singleLabel setAttributedText:getAsSmallAttributedString(str, NSTextAlignmentCenter)];
            view.headerLabel.hidden = YES;
            view.topTitleLabel.hidden = YES;
            view.notificationImage.hidden = YES;
            view.bottomTitleLabel.hidden = YES;
            view.fbProfilePicture.hidden = YES;
            view.continueButton.hidden = NO;
            view.buttonLabel.hidden = NO;
            [view.buttonLabel setAttributedText:getAsSmallAttributedString(@"Accept or die!", NSTextAlignmentCenter)];
            view.needsToFadeOut = NO;
            
            break;
        }
            
        case remoteNotificationsBTClosed:
        {
            UIImage *bluetoothImage = [UIImage imageNamed:@"BlueTooth"];
            
            [view.notificationImage setImage:bluetoothImage];
            [view.buttonLabel setAttributedText:getAsSmallAttributedString(@"Frienderers is using only Bluetooth Low Energy, \n so it won't kill your battery", NSTextAlignmentCenter)];
            [view.singleLabel setAttributedText:getAsSmallAttributedString(@"Bluetooth is your secret weapon & \n it must be enabled at all times", NSTextAlignmentCenter)];
            
            view.notificationImage.hidden = NO;
            view.buttonLabel.hidden = NO;
            view.singleLabel.hidden = NO;
            view.fbProfilePicture.hidden = YES;
            view.headerLabel.hidden = YES;
            view.topTitleLabel.hidden = YES;
            view.bottomTitleLabel.hidden = YES;
            view.continueButton.hidden = YES;
            view.needsToFadeOut = NO;
            
            break;
        }
            
        default:
            break;
    }
    
    return view;
}

-(TKNotificationView *)showNotification:(NSDictionary *)params
{
    TKNotificationView *view = [self createNotificationViewWithData:params];
    view.alpha = 0;
    [self.view addSubview:view];
    
    [UIView animateWithDuration:0.4 animations:^{
        view.alpha = 1.0;
    } completion:^(BOOL finished) {
        if (view.needsToFadeOut) {
            [self performSelector:@selector(closeNotificationView:) withObject:view afterDelay:7.0];
        }
    }];
    
    return view;
}

-(void)handleNotification:(NSNotification *)notification
{
    [self showNotification:notification.userInfo[@"loc-args"]];
}

-(void)closeNotificationView:(TKNotificationView *)view
{
    if (view.superview) {
        [view removeFromSuperview];
    }
}

-(void)loadProfilePicture:(NSString *)facebookID
{
    NSString *urlString = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=240&height=240", facebookID];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    [[session dataTaskWithURL:url
            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                UIImage *image = [self convertToGreyscale:data];
                self.profilePictures[facebookID] = image;
            }] resume];
}

- (UIImage *) convertToGreyscale:(NSData *)data {
    
    UIImage *i = [UIImage imageWithData:data];
    
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

#pragma mark - Tester

- (IBAction)showTester:(id)sender {
    [self performSegueWithIdentifier:@"tester" sender:self];
}

@end
