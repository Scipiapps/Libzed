//
//  Libzed.h
//  trickandmurder
//
//  Created by zedoul on 12. 5. 16..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ANUM(x) [NSNumber numberWithInt:x]
#define APAIR(x,y) [NSMutableArray arrayWithObjects:x, y, nil]
#define ATRIPLE(x,y,z) [NSMutableArray arrayWithObjects:x, y, z, nil]
#define __FUNC_START__ printf("=====FUNC_START %s:%d=====\n", __func__, __LINE__);
#define __FUNC_END__ printf("_____FUNC_FINISH %s:%d_____\n", __func__, __LINE__);

#define IPHONE_HEIGHT 239
#define IPHONE5_HEIGHT 320
#define IPHONE5_IMAGE_HEIGHT 327

enum {
    UIDeviceResolution_Unknown          = 0,
    UIDeviceResolution_iPhoneStandard   = 1,    // iPhone 1,3,3GS Standard Display  (320x480px)
    UIDeviceResolution_iPhoneRetina35   = 2,    // iPhone 4,4S Retina Display 3.5"  (640x960px)
    UIDeviceResolution_iPhoneRetina4    = 3,    // iPhone 5 Retina Display 4"       (640x1136px)
    UIDeviceResolution_iPadStandard     = 4,    // iPad 1,2,mini Standard Display       (1024x768px)
    UIDeviceResolution_iPadRetina       = 5     // iPad 3 Retina Display            (2048x1536px)
}; typedef NSUInteger UIDeviceResolution;

@interface Libzed : NSObject {
    BOOL debug;
}

/* application settings */
+ (CGRect) applicationBounds;
+ (NSString*) applicationLanguage;

/* Tools */
+ (NSObject*) choice:(NSMutableArray*) array;
+ (void) shuffle:(NSMutableArray*) array;
+ (NSMutableArray*) range:(NSInteger) num;
+ (NSMutableArray*) range:(NSInteger) num1 without:(NSMutableArray*) nums;
+ (NSInteger) random:(NSInteger) exclusive_upper_bound;
+ (UIDeviceResolution)resolution;
+ (NSDate*) getDate:(NSTimeInterval)t;
+ (NSTimeInterval) getInterval:(NSDate*)t;
+ (NSString*) userIdentifier;
+ (UIImage *) capture:(UIView*)target;

+ (UIImage *) imageColorChange:(UIImage *)image color:(UIColor*)color;
+ (UIImage*) imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
+ (UIImage*) imageFromURL:(NSURL*)url;
+ (BOOL) imageWriteToDevice:(UIImage*)image filename:(NSString*)name fileext:(NSString*)ext;
+ (UIImage*) imageReadDevice:(NSString*)file;

+ (UIColor*) UIColorFromRGB:(int)rgbValue;
+ (UIColor*) UIColorFromHex:(NSString *)hex;
+ (UIColor*) UIColorFromNSString:(NSString*)str;
+ (UIColor*) UIColorFromName:(NSString *)name;
+ (NSString*) NSStringFromUIColor:(UIColor*)color;

+ (NSData *)dataForObject:(id)obj key:(NSString*)key;
+ (id)objectForData:(NSData *)data key:(NSString*)key;

/* View */
+ (UIViewController*)rootViewController;

@end