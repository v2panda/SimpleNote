//
//  PDAFonts.m
//  SimpleWeather
//
//  Created by Panda on 15/9/10.
//  Copyright (c) 2015年 xuzhen. All rights reserved.
//

#import "PDAFonts.h"
#import <CoreText/CoreText.h>



@implementation PDAFonts

+ (BOOL)isFontDonwnloaded:(NSString *)fontName{
    UIFont *aFont = [UIFont fontWithName:fontName size:12.0];
    if (aFont && ([aFont.fontName compare:fontName] == NSOrderedSame || [aFont.familyName compare:fontName]== NSOrderedSame)) {
        return YES;
    }else{
        return NO;
    }
}

+ (void)load
{
    // 圆体简
    NSString *fontName = @"STYuanti-SC-Regular";
    __block NSString *errorMessage;
    
    [self isFontDonwnloaded:fontName];
    
    if ([self isFontDonwnloaded:fontName]) {
        NSLog(@"字体已下载，可以使用！");
    }else{
        NSLog(@"下载字体！");
        // Create a dictionary with the font's PostScript name.
        NSMutableDictionary *attrs = [NSMutableDictionary dictionaryWithObjectsAndKeys:fontName, kCTFontNameAttribute, nil];
        
        // Create a new font descriptor reference from the attributes dictionary.
        CTFontDescriptorRef desc = CTFontDescriptorCreateWithAttributes((__bridge CFDictionaryRef)attrs);
        
        NSMutableArray *descs = [NSMutableArray arrayWithCapacity:0];
        [descs addObject:(__bridge id)desc];
        CFRelease(desc);
        
        __block BOOL errorDuringDownload = NO;
        
        // Start processing the font descriptor..
        // This function returns immediately, but can potentially take long time to process.
        // The progress is notified via the callback block of CTFontDescriptorProgressHandler type.
        // See CTFontDescriptor.h for the list of progress states and keys for progressParameter dictionary.
        CTFontDescriptorMatchFontDescriptorsWithProgressHandler( (__bridge CFArrayRef)descs, NULL,  ^(CTFontDescriptorMatchingState state, CFDictionaryRef progressParameter) {
            
            //NSLog( @"state %d - %@", state, progressParameter);
            
            double progressValue = [[(__bridge NSDictionary *)progressParameter objectForKey:(id)kCTFontDescriptorMatchingPercentage] doubleValue];
            
            if (state == kCTFontDescriptorMatchingDidBegin) {
                dispatch_async( dispatch_get_main_queue(), ^ {
                    
                    NSLog(@"Begin Matching");
                });
            } else if (state == kCTFontDescriptorMatchingDidFinish) {// 在这更新字体
                dispatch_async( dispatch_get_main_queue(), ^ {
                    
                    // Log the font URL in the console
                    CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)fontName, 0., NULL);
                    CFStringRef fontURL = CTFontCopyAttribute(fontRef, kCTFontURLAttribute);
                    CFRelease(fontURL);
                    CFRelease(fontRef);
                    if (!errorDuringDownload) {
                        NSLog(@"%@ downloaded", fontName);
                    }
                    
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"PDAFonts" object:self userInfo:nil];
                    
                });
            } else if (state == kCTFontDescriptorMatchingWillBeginDownloading) {
                dispatch_async( dispatch_get_main_queue(), ^ {
                    NSLog(@"Begin Downloading");
                });
            } else if (state == kCTFontDescriptorMatchingDidFinishDownloading) {
                dispatch_async( dispatch_get_main_queue(), ^ {
                    NSLog(@"Finish downloading");
                });
            } else if (state == kCTFontDescriptorMatchingDownloading) {
                dispatch_async( dispatch_get_main_queue(), ^ {
                    NSLog(@"Downloading %.0f%% complete", progressValue);
                });
            } else if (state == kCTFontDescriptorMatchingDidFailWithError) {
                // An error has occurred.
                // Get the error message
                NSError *error = [(__bridge NSDictionary *)progressParameter objectForKey:(id)kCTFontDescriptorMatchingError];
                if (error != nil) {
                    errorMessage = [error description];
                } else {
                    errorMessage = @"ERROR MESSAGE IS NOT AVAILABLE!";
                }
                // Set our flag
                errorDuringDownload = YES;
                
                dispatch_async( dispatch_get_main_queue(), ^ {
                    
                    NSLog(@"Download error: %@", errorMessage);
                });
            }
            
            return (bool)YES;
        });

    }
}

@end
