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
#import <AdSupport/ASIdentifierManager.h>
#import <CoreImage/CoreImage.h>

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
            else if (pixelHeight == 1334.0f)
                resolution = UIDeviceResolution_iPhoneRetina47;
            else if (pixelHeight == 2208.0f)
                resolution = UIDeviceResolution_iPhoneRetina55;
            
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

+ (NSString*) userIdentifier
{
    return [[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString] retain];
}


+ (CGRect) applicationBounds
{
    return [[UIScreen mainScreen] bounds];
}

+(UIInterfaceOrientation) applicationOrientation
{
    return [[UIDevice currentDevice] orientation];
}

+ (NSString*) applicationLanguage
{
    NSArray* languages = [[NSUserDefaults standardUserDefaults]
                          objectForKey:@"AppleLanguages"];
    return [languages objectAtIndex:0];
}

+ (UIImage *)capture:(UIView*)target
{
    UIGraphicsBeginImageContextWithOptions(target.bounds.size, target.opaque, 0.0);
    [target.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRef imageRef;
    UIImage* ret;
    
    imageRef = CGImageCreateWithImageInRect([viewImage CGImage],
                                CGRectMake(0, 0,
                                    target.frame.size.width*[UIScreen mainScreen].scale,
                                    target.frame.size.height*[UIScreen mainScreen].scale));
    ret = [UIImage imageWithCGImage:imageRef
                              scale:viewImage.scale
                        orientation:viewImage.imageOrientation];
    
    CGImageRelease(imageRef);
    
    return ret;
}

+ (UIImage *) imageColorChange:(UIImage *)image color:(UIColor*)color {
    UIGraphicsBeginImageContext(image.size);
    
    CGRect contextRect;
    contextRect.origin.x = 0.0f;
    contextRect.origin.y = 0.0f;
    contextRect.size = [image size];
    // Retrieve source image and begin image context
    CGSize itemImageSize = [image size];
    CGPoint itemImagePosition;
    itemImagePosition.x = ceilf((contextRect.size.width - itemImageSize.width) / 2);
    itemImagePosition.y = ceilf((contextRect.size.height - itemImageSize.height) );
    
    UIGraphicsBeginImageContext(contextRect.size);
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    // Setup shadow
    // Setup transparency layer and clip to mask
    CGContextBeginTransparencyLayer(c, NULL);
    CGContextScaleCTM(c, 1.0, -1.0);
    CGContextClipToMask(c, CGRectMake(itemImagePosition.x, -itemImagePosition.y, itemImageSize.width, -itemImageSize.height), [image CGImage]);
    // Fill and end the transparency layer
    
    
    const float* colors = CGColorGetComponents( color.CGColor );
    CGContextSetRGBFillColor(c, colors[0], colors[1], colors[2], 1.0);
    
    contextRect.size.height = -contextRect.size.height;
    contextRect.size.height -= 15;
    CGContextFillRect(c, contextRect);
    CGContextEndTransparencyLayer(c);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage*)imageFromURL:(NSURL*)url
{
    NSData *thedata = [NSData dataWithContentsOfURL:url];
    UIImage *ret = [[UIImage alloc] initWithData:thedata];
    return ret;
}

+ (BOOL)imageWriteToDevice:(UIImage*)image filename:(NSString*)name fileext:(NSString*)ext
{
    if (nil == name) {
        return NO;
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *localFilePath = [documentsDirectory stringByAppendingPathComponent:name];
    NSData *data = nil;
    
    if (YES == [@"png" isEqualToString:ext]) {
        data = UIImagePNGRepresentation(image);
    } else if (YES == [@"jpg" isEqualToString:ext]) {
        data = UIImageJPEGRepresentation(image, 100.0f);
    } else {
        return NO;
    }
    [data writeToFile:localFilePath atomically:YES];
    
    return YES;
}

+ (UIImage*) imageReadDevice:(NSString*)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *localFilePath = [documentsDirectory stringByAppendingPathComponent:name];
    return [UIImage imageWithContentsOfFile:localFilePath];
}

+ (UIColor*) UIColorFromHex:(NSString *)hex
{
    NSString *colorString = [[hex uppercaseString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] ;
    if ([colorString length] < 6)
        return [UIColor grayColor];
    
    if ([colorString hasPrefix:@"0X"])
        colorString = [colorString substringFromIndex:2];
    else if ([colorString hasPrefix:@"#"])
        colorString = [colorString substringFromIndex:1];
    else if ([colorString length] != 6)
        return  [UIColor grayColor];
    
    NSRange range;
    range.location = 2;
    range.length = 2;
    NSString *rString = [colorString substringWithRange:range];
    range.location += 2;
    NSString *gString = [colorString substringWithRange:range];
    range.location += 2;
    NSString *bString = [colorString substringWithRange:range];
    
    unsigned int red, green, blue;
    [[NSScanner scannerWithString:rString] scanHexInt:&red];
    [[NSScanner scannerWithString:gString] scanHexInt:&green];
    [[NSScanner scannerWithString:bString] scanHexInt:&blue];
    
    return [UIColor colorWithRed:((float) red / 255.0f)
                           green:((float) green / 255.0f)
                            blue:((float) blue / 255.0f)
                           alpha:1.0f];
}

+ (UIColor*) UIColorFromRGB:(int)rgbValue {
    return [UIColor \
            colorWithRed:((float)(((int)rgbValue & 0xFF0000) >> 16))/255.0 \
            green:((float)(((int)rgbValue & 0xFF00) >> 8))/255.0 \
            blue:((float)((int)rgbValue & 0xFF))/255.0 alpha:1.0];
}

/*
 It might as well use colorWithCGColor to avoid error.
 http://stackoverflow.com/a/14546889/2268390
 */
+ (UIColor*) UIColorFromNSString:(NSString*)str
{
    CIColor *coreColor = [CIColor colorWithString:str];
    UIColor* newcolor = [UIColor colorWithCIColor:coreColor];
    newcolor = [UIColor colorWithCGColor:newcolor.CGColor];
    return [newcolor retain];
}



+ (UIColor*) UIColorFromName:(NSString *)name
{
    if (YES == [name isEqualToString:@"AliceBlue"]) {
        return [Libzed UIColorFromHex:@"0xFFF0F8FF"];
    } else if (YES == [name isEqualToString:@"AntiqueWhite"]) {
        return [Libzed UIColorFromHex:@"0xFFFAEBD7"];
    } else if (YES == [name isEqualToString:@"Aqua"]) {
        return [Libzed UIColorFromHex:@"0xFF00FFFF"];
    } else if (YES == [name isEqualToString:@"Aquamarine"]) {
        return [Libzed UIColorFromHex:@"0xFF7FFFD4"];
    } else if (YES == [name isEqualToString:@"Aqua"]) {
        return [Libzed UIColorFromHex:@"0xFF00FFFF"];
    } else if (YES == [name isEqualToString:@"Azure"]) {
        return [Libzed UIColorFromHex:@"0xFFF0FFFF"];
    } else if (YES == [name isEqualToString:@"Beige"]) {
        return [Libzed UIColorFromHex:@"0xFFF5F5DC"];
    } else if (YES == [name isEqualToString:@"Bisque"]) {
        return [Libzed UIColorFromHex:@"0xFFFFE4C4"];
    } else if (YES == [name isEqualToString:@"Black"]) {
        return [Libzed UIColorFromHex:@"0xFF000000"];
    } else if (YES == [name isEqualToString:@"BlanchedAlmond"]) {
        return [Libzed UIColorFromHex:@"0xFFFFEBCD"];
    } else if (YES == [name isEqualToString:@"Blue"]) {
        return [Libzed UIColorFromHex:@"0xFF0000FF"];
    } else if (YES == [name isEqualToString:@"BlueViolet"]) {
        return [Libzed UIColorFromHex:@"0xFF8A2BE2"];
    } else if (YES == [name isEqualToString:@"Brown"]) {
        return [Libzed UIColorFromHex:@"0xFFA52A2A"];
    } else if (YES == [name isEqualToString:@"BurlyWood"]) {
        return [Libzed UIColorFromHex:@"0xFFDEB887"];
    } else if (YES == [name isEqualToString:@"CadetBlue"]) {
        return [Libzed UIColorFromHex:@"0xFF5F9EA0"];
    } else if (YES == [name isEqualToString:@"Chartreuse"]) {
        return [Libzed UIColorFromHex:@"0xFF7FFF00"];
    } else if (YES == [name isEqualToString:@"Chocolate"]) {
        return [Libzed UIColorFromHex:@"0xFFD2691E"];
    } else if (YES == [name isEqualToString:@"Coral"]) {
        return [Libzed UIColorFromHex:@"0xFFFF7F50"];
    } else if (YES == [name isEqualToString:@"CornflowerBlue"]) {
        return [Libzed UIColorFromHex:@"0xFF6495ED"];
    } else if (YES == [name isEqualToString:@"Cornsilk"]) {
        return [Libzed UIColorFromHex:@"0xFFFFF8DC"];
    } else if (YES == [name isEqualToString:@"Crimson"]) {
        return [Libzed UIColorFromHex:@"0xFFDC143C"];
    } else if (YES == [name isEqualToString:@"Cyan"]) {
        return [Libzed UIColorFromHex:@"0xFF00FFFF"];
    } else if (YES == [name isEqualToString:@"DarkBlue"]) {
        return [Libzed UIColorFromHex:@"0xFF00008B"];
    } else if (YES == [name isEqualToString:@"DarkCyan"]) {
        return [Libzed UIColorFromHex:@"0xFF008B8B"];
    } else if (YES == [name isEqualToString:@"DarkGoldenrod"]) {
        return [Libzed UIColorFromHex:@"0xFFB8860B"];
    } else if (YES == [name isEqualToString:@"DarkGray"]) {
        return [Libzed UIColorFromHex:@"0xFFA9A9A9"];
    } else if (YES == [name isEqualToString:@"DarkGreen"]) {
        return [Libzed UIColorFromHex:@"0xFF006400"];
    } else if (YES == [name isEqualToString:@"DarkKhaki"]) {
        return [Libzed UIColorFromHex:@"0xFFBDB76B"];
    } else if (YES == [name isEqualToString:@"DarkMagenta"]) {
        return [Libzed UIColorFromHex:@"0xFF8B008B"];
    } else if (YES == [name isEqualToString:@"DarkKhaki"]) {
        return [Libzed UIColorFromHex:@"0xFFBDB76B"];
    } else if (YES == [name isEqualToString:@"DarkOliveGreen"]) {
        return [Libzed UIColorFromHex:@"0xFF556B2F"];
    } else if (YES == [name isEqualToString:@"DarkOrange"]) {
        return [Libzed UIColorFromHex:@"0xFFFF8C00"];
    } else if (YES == [name isEqualToString:@"DarkOrchid"]) {
        return [Libzed UIColorFromHex:@"0xFF9932CC"];
    } else if (YES == [name isEqualToString:@"DarkRed"]) {
        return [Libzed UIColorFromHex:@"0xFF8B0000"];
    } else if (YES == [name isEqualToString:@"DarkSalmon"]) {
        return [Libzed UIColorFromHex:@"0xFFE9967A"];
    } else if (YES == [name isEqualToString:@"DarkSeaGreen"]) {
        return [Libzed UIColorFromHex:@"0xFF8FBC8F"];
    } else if (YES == [name isEqualToString:@"DarkSlateBlue"]) {
        return [Libzed UIColorFromHex:@"0xFF483D8B"];
    } else if (YES == [name isEqualToString:@"DarkSlateGray"]) {
        return [Libzed UIColorFromHex:@"0xFF2F4F4F"];
    } else if (YES == [name isEqualToString:@"DarkTurquoise"]) {
        return [Libzed UIColorFromHex:@"0xFF00CED1"];
    } else if (YES == [name isEqualToString:@"DarkViolet"]) {
        return [Libzed UIColorFromHex:@"0xFF9400D3"];
    } else if (YES == [name isEqualToString:@"DeepPink"]) {
        return [Libzed UIColorFromHex:@"0xFFFF1493"];
    } else if (YES == [name isEqualToString:@"DeepSkyBlue"]) {
        return [Libzed UIColorFromHex:@"0xFF00BFFF"];
    } else if (YES == [name isEqualToString:@"DimGray"]) {
        return [Libzed UIColorFromHex:@"0xFF696969"];
    } else if (YES == [name isEqualToString:@"DodgerBlue"]) {
        return [Libzed UIColorFromHex:@"0xFF1E90FF"];
    } else if (YES == [name isEqualToString:@"Firebrick"]) {
        return [Libzed UIColorFromHex:@"0xFFB22222"];
    } else if (YES == [name isEqualToString:@"FloralWhite"]) {
        return [Libzed UIColorFromHex:@"0xFFFFFAF0"];
    } else if (YES == [name isEqualToString:@"ForestGreen"]) {
        return [Libzed UIColorFromHex:@"0xFF228B22"];
    } else if (YES == [name isEqualToString:@"Fuchsia"]) {
        return [Libzed UIColorFromHex:@"0xFFFF00FF"];
    } else if (YES == [name isEqualToString:@"Gainsboro"]) {
        return [Libzed UIColorFromHex:@"0xFFDCDCDC"];
    } else if (YES == [name isEqualToString:@"GhostWhite"]) {
        return [Libzed UIColorFromHex:@"0xFFF8F8FF"];
    } else if (YES == [name isEqualToString:@"Gold"]) {
        return [Libzed UIColorFromHex:@"0xFFFFD700"];
    } else if (YES == [name isEqualToString:@"Goldenrod"]) {
        return [Libzed UIColorFromHex:@"0xFFDAA520"];
    } else if (YES == [name isEqualToString:@"Gray"]) {
        return [Libzed UIColorFromHex:@"0xFF808080"];
    } else if (YES == [name isEqualToString:@"Green"]) {
        return [Libzed UIColorFromHex:@"0xFF008000"];
    } else if (YES == [name isEqualToString:@"GreenYellow"]) {
        return [Libzed UIColorFromHex:@"0xFFADFF2F"];
    } else if (YES == [name isEqualToString:@"Honeydew"]) {
        return [Libzed UIColorFromHex:@"0xFFF0FFF0"];
    } else if (YES == [name isEqualToString:@"HotPink"]) {
        return [Libzed UIColorFromHex:@"0xFFFF69B4"];
    } else if (YES == [name isEqualToString:@"IndianRed"]) {
        return [Libzed UIColorFromHex:@"0xFFCD5C5C"];
    } else if (YES == [name isEqualToString:@"Indigo"]) {
        return [Libzed UIColorFromHex:@"0xFF4B0082"];
    } else if (YES == [name isEqualToString:@"Ivory"]) {
        return [Libzed UIColorFromHex:@"0xFFFFFFF0"];
    } else if (YES == [name isEqualToString:@"Khaki"]) {
        return [Libzed UIColorFromHex:@"0xFFF0E68C"];
    } else if (YES == [name isEqualToString:@"Lavender"]) {
        return [Libzed UIColorFromHex:@"0xFFE6E6FA"];
    } else if (YES == [name isEqualToString:@"LavenderBlush"]) {
        return [Libzed UIColorFromHex:@"0xFFFFF0F5"];
    } else if (YES == [name isEqualToString:@"LawnGreen"]) {
        return [Libzed UIColorFromHex:@"0xFF7CFC00"];
    } else if (YES == [name isEqualToString:@"LemonChiffon"]) {
        return [Libzed UIColorFromHex:@"0xFFFFFACD"];
    } else if (YES == [name isEqualToString:@"LightBlue"]) {
        return [Libzed UIColorFromHex:@"0xFFADD8E6"];
    } else if (YES == [name isEqualToString:@"LightCoral"]) {
        return [Libzed UIColorFromHex:@"0xFFF08080"];
    } else if (YES == [name isEqualToString:@"LightCyan"]) {
        return [Libzed UIColorFromHex:@"0xFFE0FFFF"];
    } else if (YES == [name isEqualToString:@"LightGoldenrodYellow"]) {
        return [Libzed UIColorFromHex:@"0xFFFAFAD2"];
    } else if (YES == [name isEqualToString:@"LightGray"]) {
        return [Libzed UIColorFromHex:@"0xFFD3D3D3"];
    } else if (YES == [name isEqualToString:@"LightGreen"]) {
        return [Libzed UIColorFromHex:@"0xFF90EE90"];
    } else if (YES == [name isEqualToString:@"LightPink"]) {
        return [Libzed UIColorFromHex:@"0xFFFFB6C1"];
    } else if (YES == [name isEqualToString:@"LightSeaGreen"]) {
        return [Libzed UIColorFromHex:@"0xFF20B2AA"];
    } else if (YES == [name isEqualToString:@"LightSalmon"]) {
        return [Libzed UIColorFromHex:@"0xFFFFA07A"];
    } else if (YES == [name isEqualToString:@"LightSkyBlue"]) {
        return [Libzed UIColorFromHex:@"0xFF87CEFA"];
    } else if (YES == [name isEqualToString:@"LightSlateGray"]) {
        return [Libzed UIColorFromHex:@"0xFF778899"];
    } else if (YES == [name isEqualToString:@"LightYellow"]) {
        return [Libzed UIColorFromHex:@"0xFFFFFFE0"];
    } else if (YES == [name isEqualToString:@"Lime"]) {
        return [Libzed UIColorFromHex:@"0xFF00FF00"];
    } else if (YES == [name isEqualToString:@"LimeGreen"]) {
        return [Libzed UIColorFromHex:@"0xFF32CD32"];
    } else if (YES == [name isEqualToString:@"Linen"]) {
        return [Libzed UIColorFromHex:@"0xFFFAF0E6"];
    } else if (YES == [name isEqualToString:@"Magenta"]) {
        return [Libzed UIColorFromHex:@"0xFFFF00FF"];
    } else if (YES == [name isEqualToString:@"Maroon"]) {
        return [Libzed UIColorFromHex:@"0xFF800000"];
    } else if (YES == [name isEqualToString:@"MediumAquamarine"]) {
        return [Libzed UIColorFromHex:@"0xFF66CDAA"];
    } else if (YES == [name isEqualToString:@"MediumBlue"]) {
        return [Libzed UIColorFromHex:@"0xFF0000CD"];
    } else if (YES == [name isEqualToString:@"MediumOrchid"]) {
        return [Libzed UIColorFromHex:@"0xFFBA55D3"];
    } else if (YES == [name isEqualToString:@"MediumPurple"]) {
        return [Libzed UIColorFromHex:@"0xFF9370DB"];
    } else if (YES == [name isEqualToString:@"MediumSeaGreen"]) {
        return [Libzed UIColorFromHex:@"0xFF3CB371"];
    } else if (YES == [name isEqualToString:@"MediumSlateBlue"]) {
        return [Libzed UIColorFromHex:@"0xFF7B68EE"];
    } else if (YES == [name isEqualToString:@"MediumSpringGreen"]) {
        return [Libzed UIColorFromHex:@"0xFF00FA9A"];
    } else if (YES == [name isEqualToString:@"MediumTurquoise"]) {
        return [Libzed UIColorFromHex:@"0xFF48D1CC"];
    } else if (YES == [name isEqualToString:@"MediumVioletRed"]) {
        return [Libzed UIColorFromHex:@"0xFFC71585"];
    } else if (YES == [name isEqualToString:@"MidnightBlue"]) {
        return [Libzed UIColorFromHex:@"0xFF191970"];
    } else if (YES == [name isEqualToString:@"MintCream"]) {
        return [Libzed UIColorFromHex:@"0xFFF5FFFA"];
    } else if (YES == [name isEqualToString:@"MistyRose"]) {
        return [Libzed UIColorFromHex:@"0xFFFFE4E1"];
    } else if (YES == [name isEqualToString:@"Moccasin"]) {
        return [Libzed UIColorFromHex:@"0xFFFFE4B5"];
    } else if (YES == [name isEqualToString:@"NavajoWhite"]) {
        return [Libzed UIColorFromHex:@"0xFFFFDEAD"];
    } else if (YES == [name isEqualToString:@"Navy"]) {
        return [Libzed UIColorFromHex:@"0xFF000080"];
    } else if (YES == [name isEqualToString:@"OldLace"]) {
        return [Libzed UIColorFromHex:@"0xFFFDF5E6"];
    } else if (YES == [name isEqualToString:@"Olive"]) {
        return [Libzed UIColorFromHex:@"0xFF808000"];
    } else if (YES == [name isEqualToString:@"OliveDrab"]) {
        return [Libzed UIColorFromHex:@"0xFF6B8E23"];
    } else if (YES == [name isEqualToString:@"Orange"]) {
        return [Libzed UIColorFromHex:@"0xFFFFA500"];
    } else if (YES == [name isEqualToString:@"OrangeRed"]) {
        return [Libzed UIColorFromHex:@"0xFFFF4500"];
    } else if (YES == [name isEqualToString:@"Orchid"]) {
        return [Libzed UIColorFromHex:@"0xFFDA70D6"];
    } else if (YES == [name isEqualToString:@"PaleGoldenrod"]) {
        return [Libzed UIColorFromHex:@"0xFFEEE8AA"];
    } else if (YES == [name isEqualToString:@"PaleGreen"]) {
        return [Libzed UIColorFromHex:@"0xFF98FB98"];
    } else if (YES == [name isEqualToString:@"PaleTurquoise"]) {
        return [Libzed UIColorFromHex:@"0xFFAFEEEE"];
    } else if (YES == [name isEqualToString:@"PaleVioletRed"]) {
        return [Libzed UIColorFromHex:@"0xFFDB7093"];
    } else if (YES == [name isEqualToString:@"PapayaWhip"]) {
        return [Libzed UIColorFromHex:@"0xFFFFEFD5"];
    } else if (YES == [name isEqualToString:@"PeachPuff"]) {
        return [Libzed UIColorFromHex:@"0xFFFFDAB9"];
    } else if (YES == [name isEqualToString:@"Peru"]) {
        return [Libzed UIColorFromHex:@"0xFFCD853F"];
    } else if (YES == [name isEqualToString:@"Pink"]) {
        return [Libzed UIColorFromHex:@"0xFFFFC0CB"];
    } else if (YES == [name isEqualToString:@"Plum"]) {
        return [Libzed UIColorFromHex:@"0xFFDDA0DD"];
    } else if (YES == [name isEqualToString:@"PowderBlue"]) {
        return [Libzed UIColorFromHex:@"0xFFB0E0E6"];
    } else if (YES == [name isEqualToString:@"Purple"]) {
        return [Libzed UIColorFromHex:@"0xFF800080"];
    } else if (YES == [name isEqualToString:@"Red"]) {
        return [Libzed UIColorFromHex:@"0xFFFF0000"];
    } else if (YES == [name isEqualToString:@"RosyBrown"]) {
        return [Libzed UIColorFromHex:@"0xFFBC8F8F"];
    } else if (YES == [name isEqualToString:@"RoyalBlue"]) {
        return [Libzed UIColorFromHex:@"0xFF4169E1"];
    } else if (YES == [name isEqualToString:@"SaddleBrown"]) {
        return [Libzed UIColorFromHex:@"0xFF8B4513"];
    } else if (YES == [name isEqualToString:@"Salmon"]) {
        return [Libzed UIColorFromHex:@"0xFFFA8072"];
    } else if (YES == [name isEqualToString:@"SandyBrown"]) {
        return [Libzed UIColorFromHex:@"0xFFF4A460"];
    } else if (YES == [name isEqualToString:@"SeaGreen"]) {
        return [Libzed UIColorFromHex:@"0xFF2E8B57"];
    } else if (YES == [name isEqualToString:@"SeaShell"]) {
        return [Libzed UIColorFromHex:@"0xFFFFF5EE"];
    } else if (YES == [name isEqualToString:@"Sienna"]) {
        return [Libzed UIColorFromHex:@"0xFFA0522D"];
    } else if (YES == [name isEqualToString:@"Silver"]) {
        return [Libzed UIColorFromHex:@"0xFFC0C0C0"];
    } else if (YES == [name isEqualToString:@"SkyBlue"]) {
        return [Libzed UIColorFromHex:@"0xFF87CEEB"];
    } else if (YES == [name isEqualToString:@"SlateBlue"]) {
        return [Libzed UIColorFromHex:@"0xFF6A5ACD"];
    } else if (YES == [name isEqualToString:@"SlateGray"]) {
        return [Libzed UIColorFromHex:@"0xFF708090"];
    } else if (YES == [name isEqualToString:@"Snow"]) {
        return [Libzed UIColorFromHex:@"0xFFFFFAFA"];
    } else if (YES == [name isEqualToString:@"SpringGreen"]) {
        return [Libzed UIColorFromHex:@"0xFF00FF7F"];
    } else if (YES == [name isEqualToString:@"SteelBlue"]) {
        return [Libzed UIColorFromHex:@"0xFF4682B4"];
    } else if (YES == [name isEqualToString:@"Tan"]) {
        return [Libzed UIColorFromHex:@"0xFFD2B48C"];
    } else if (YES == [name isEqualToString:@"Teal"]) {
        return [Libzed UIColorFromHex:@"0xFF008080"];
    } else if (YES == [name isEqualToString:@"Thistle"]) {
        return [Libzed UIColorFromHex:@"0xFFD8BFD8"];
    } else if (YES == [name isEqualToString:@"Tomato"]) {
        return [Libzed UIColorFromHex:@"0xFFFF6347"];
    } else if (YES == [name isEqualToString:@"Transparent"]) {
        return [Libzed UIColorFromHex:@"0x00FFFFFF"];
    } else if (YES == [name isEqualToString:@"Turquoise"]) {
        return [Libzed UIColorFromHex:@"0xFF40E0D0"];
    } else if (YES == [name isEqualToString:@"Violet"]) {
        return [Libzed UIColorFromHex:@"0xFFEE82EE"];
    } else if (YES == [name isEqualToString:@"Wheat"]) {
        return [Libzed UIColorFromHex:@"0xFFF5DEB3"];
    } else if (YES == [name isEqualToString:@"White"]) {
        return [Libzed UIColorFromHex:@"0xFFFFFFFF"];
    } else if (YES == [name isEqualToString:@"WhiteSmoke"]) {
        return [Libzed UIColorFromHex:@"0xFFF5F5F5"];
    } else if (YES == [name isEqualToString:@"Yellow"]) {
        return [Libzed UIColorFromHex:@"0xFFFFFF00"];
    } else if (YES == [name isEqualToString:@"YellowGreen"]) {
        return [Libzed UIColorFromHex:@"0xFF9ACD32"];
    }
    
    return [Libzed UIColorFromHex:@"0xFFFFFFFF"];
}

+ (NSString*) NSStringFromUIColor:(UIColor*)color
{
    CGColorRef colorRef = [UIColor grayColor].CGColor;
    return [[CIColor colorWithCGColor:colorRef].stringRepresentation retain];
}

+(NSData *)dataForObject:(id)obj key:(NSString*)key
{
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver  *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:obj forKey:key];
    [archiver finishEncoding];
    [archiver release];
    return data;
}

+(id)objectForData:(NSData *)data key:(NSString*)key
{
    NSKeyedUnarchiver  *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    id obj = [unarchiver decodeObjectForKey:key];
    [unarchiver finishDecoding];
    [unarchiver release];
    return obj;
}

+ (UIViewController*)rootViewController
{
    return [[[UIApplication sharedApplication] keyWindow] rootViewController];
}

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}

@end
