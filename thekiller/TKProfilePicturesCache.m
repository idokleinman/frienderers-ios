//
//  TKProfilePicturesCache.m
//  Frienderers
//
//  Created by Elad Ben-Israel on 2/12/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import "NSObject+Binding.h"
#import "TKProfilePicturesCache.h"
#import "TKServer.h"

@interface TKProfilePicturesCache ()

@property (strong, nonatomic) NSMutableDictionary* profilePictures;

@end

@implementation TKProfilePicturesCache

+ (instancetype)sharedInstance {
    static TKProfilePicturesCache* i = NULL;
    if (!i) {
        i = [[TKProfilePicturesCache alloc] init];
    }
    return i;
}

- (id)init {
    self = [super init];
    if (self) {
        self.profilePictures = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)start {
    [[TKServer sharedInstance] addObserver:self forKeyPath:@"game" callback:^(id value) {
        TKGameInfo* gameInfo = [TKServer sharedInstance].game;
        if (!gameInfo) {
            return;
        }
        
        [self preloadPhotos];
    }];
}

- (BOOL)profilePictureForFBID:(NSString*)fbid completion:(void(^)(UIImage* image))completion {
    NSAssert([NSThread isMainThread], @"this should run on the main thread");
    UIImage* cached = self.profilePictures[fbid];
    if (cached) {
        if (completion) {
            completion(cached);
        }
        return YES;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=240&height=240", fbid];
    NSURL *url = [NSURL URLWithString:urlString];
    [[[NSURLSession sharedSession] dataTaskWithURL:url
                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                     UIImage *image = [self convertToGreyscale:data];
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         self.profilePictures[fbid] = image;
                                         if (completion) {
                                             completion(image);
                                         }
                                     });
                                 }] resume];
    return NO;
}




- (void)preloadPhotos {
    for (NSString *fbid in [TKServer sharedInstance].game.invited) {
        [self profilePictureForFBID:fbid completion:nil];
    }
}

- (UIImage *)convertToGreyscale:(NSData *)data {
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

@end
