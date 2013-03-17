//
//  libzed.m
//  trickandmurder
//
//  Created by zedoul on 12. 5. 16..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import "Libzed.h"
#import <stdlib.h>
#import <time.h>

@implementation Libzed

+ (NSObject*) choice:(NSMutableArray*) array {
    return (NSObject*)[array objectAtIndex:(arc4random() % [array count])];
}

static Libzed* InstanceofLibzed= nil;

+ (Libzed*) getSingleton {
    if( nil == InstanceofLibzed){
		InstanceofLibzed = [[Libzed alloc] init];
        InstanceofLibzed->debug = FALSE;
	}
	return InstanceofLibzed;
}

// reference : http://stackoverflow.com/questions/56648/whats-the-best-way-to-shuffle-an-nsmutablearray
+ (void) shuffle:(NSMutableArray*) array {
    static BOOL seeded = NO;
    if(!seeded)
    {
        seeded = YES;
        srandom(time(NULL));
    }
    
    NSUInteger count = [array count];
    for (NSUInteger i = 0; i < count; ++i) {
        int nElements = count - i;
        int n = (random() % nElements) + i;
        [array exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

+ (NSMutableArray*) range:(NSInteger) num {
    NSMutableArray* ret = [[NSMutableArray alloc] initWithCapacity:(num)];
    NSInteger i = 0;
    while (i < num) {
        [ret addObject:ANUM(i)];
        i++;
    }
    return ret;
}

+ (NSMutableArray*) range:(NSInteger) num without:(NSMutableArray*) nums{
    NSMutableArray* ret = [[NSMutableArray alloc] initWithCapacity:(num)];
    NSInteger i = 0;
    while (i < num) {
        BOOL toadd = TRUE;
        for (NSNumber* t in nums) {
            if (i == [t intValue]) {
                toadd = FALSE;
                break;
            }
        }
        if (TRUE == toadd) {
            [ret addObject:ANUM(i)];
        }
        i++;
    }
    
    return ret;
}

+ (NSInteger) random:(NSInteger) exclusive_upper_bound {
    if (0 < exclusive_upper_bound) {
        srand([[NSDate date] timeIntervalSince1970]);
        return arc4random() % exclusive_upper_bound;
    } else {
        return -1;
    }
}

+ (UIDeviceResolution)resolution
{
    UIDeviceResolution resolution = UIDeviceResolution_Unknown;
    UIScreen *mainScreen = [UIScreen mainScreen];
    CGFloat scale = ([mainScreen respondsToSelector:@selector(scale)] ? mainScreen.scale : 1.0f);
    CGFloat pixelHeight = (CGRectGetHeight(mainScreen.bounds) * scale);
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        if (scale == 2.0f) {
            if (pixelHeight == 960.0f)
                resolution = UIDeviceResolution_iPhoneRetina35;
            else if (pixelHeight == 1136.0f)
                resolution = UIDeviceResolution_iPhoneRetina4;
            
        } else if (scale == 1.0f && pixelHeight == 480.0f)
            resolution = UIDeviceResolution_iPhoneStandard;
        
    } else {
        if (scale == 2.0f && pixelHeight == 2048.0f) {
            resolution = UIDeviceResolution_iPadRetina;
            
        } else if (scale == 1.0f && pixelHeight == 1024.0f) {
            resolution = UIDeviceResolution_iPadStandard;
        }
    }
    
    return resolution;
}

+ (NSDate*) getDate:(NSTimeInterval)t
{
    return [NSDate dateWithTimeIntervalSince1970:(t)];
}

+ (NSTimeInterval) getInterval:(NSDate*)t
{
    return [t timeIntervalSince1970];
}

+ (UIImage *)capture:(UIView*)target
{
    UIDeviceResolution l = [self resolution];
    CGRect bound = [[UIScreen mainScreen] bounds];
    
    UIGraphicsBeginImageContextWithOptions(target.bounds.size, target.opaque, 0.0);
    [target.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRef imageRef;
    UIImage* ret;
    
    if( UIDeviceResolution_iPhoneRetina4 != l) {
        imageRef = CGImageCreateWithImageInRect([viewImage CGImage],
                                                CGRectMake(0,
                                                           26*[UIScreen mainScreen].scale,
                                                           bound.size.width*[UIScreen mainScreen].scale,
                                                           IPHONE_HEIGHT*[UIScreen mainScreen].scale));
        ret = [UIImage imageWithCGImage:imageRef
                                  scale:viewImage.scale
                            orientation:viewImage.imageOrientation];
    } else {
        imageRef = CGImageCreateWithImageInRect([viewImage CGImage],
                                                CGRectMake(0,
                                                           26*[UIScreen mainScreen].scale,
                                                           bound.size.width*[UIScreen mainScreen].scale,
                                                           IPHONE5_IMAGE_HEIGHT*[UIScreen mainScreen].scale));
        ret = [UIImage imageWithCGImage:imageRef
                                  scale:viewImage.scale
                            orientation:viewImage.imageOrientation];
    }
    
    CGImageRelease(imageRef);
    
    return ret;
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end