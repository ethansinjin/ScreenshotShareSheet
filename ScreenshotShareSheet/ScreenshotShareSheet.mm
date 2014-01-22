#line 1 "/Users/ethangillius/Developer/Cydia/ScreenshotShareSheet/ScreenshotShareSheet/ScreenshotShareSheet.xm"
#import <SpringBoard/SpringBoard.h>
#import "TTOpenInAppActivity.h"
#import <AudioToolbox/AudioToolbox.h>
#import <PhotoLibraryServices/PLPhotoStreamsHelper.h>











#include <logos/logos.h>
#include <substrate.h>
@class PLPhotoStreamsHelper; @class SBScreenShotter; 
static void (*_logos_orig$_ungrouped$SBScreenShotter$finishedWritingScreenshot$didFinishSavingWithError$context$)(SBScreenShotter*, SEL, id, id, void*); static void _logos_method$_ungrouped$SBScreenShotter$finishedWritingScreenshot$didFinishSavingWithError$context$(SBScreenShotter*, SEL, id, id, void*); static BOOL (*_logos_orig$_ungrouped$PLPhotoStreamsHelper$shouldPublishScreenShots)(PLPhotoStreamsHelper*, SEL); static BOOL _logos_method$_ungrouped$PLPhotoStreamsHelper$shouldPublishScreenShots(PLPhotoStreamsHelper*, SEL); 

#line 16 "/Users/ethangillius/Developer/Cydia/ScreenshotShareSheet/ScreenshotShareSheet/ScreenshotShareSheet.xm"



static void _logos_method$_ungrouped$SBScreenShotter$finishedWritingScreenshot$didFinishSavingWithError$context$(SBScreenShotter* self, SEL _cmd, id screenshot, id error, void* context) {
    NSLog(@"-[<SBScreenShotter: %p> finishedWritingScreenshot:%@ didFinishSavingWithError:%@ context:%p]", self, screenshot, error, context);
    
    
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    
    NSString *settingsPath = [NSString stringWithFormat:@"%@/Library/Preferences/%@", NSHomeDirectory(), @"com.ethansquared.ScreenshotShareSheet.plist"];
    NSMutableDictionary *settings = [NSMutableDictionary dictionaryWithContentsOfFile:
                     settingsPath];
	NSNumber* enabledPreference = [settings objectForKey:@"enabled"];
    NSNumber* openInPreference = [settings objectForKey:@"openinenabled"];
    NSNumber* delayPreference = [settings objectForKey:@"delay"];
    
    if(settings == nil){
        settings = [[NSMutableDictionary alloc] init];
        enabledPreference = [NSNumber numberWithBool:YES];
        openInPreference = [NSNumber numberWithBool:NO];
        delayPreference = [NSNumber numberWithDouble:0.40];
        NSNumber *photoStreamPreference = [NSNumber numberWithBool:YES];
        [settings setObject:enabledPreference forKey:@"enabled"];
        [settings setObject:openInPreference forKey:@"openinenabled"];
        [settings setObject:delayPreference forKey:@"delay"];
        [settings setObject:photoStreamPreference forKey:@"photostream"];
        BOOL result = [settings writeToFile:settingsPath atomically:YES];
        if(result){
            NSLog(@"The user didn't have a settings file yet. Generated one");
        }else{
            NSLog(@"The user didn't have a settings file yet. Generating FAILED");
        }
    }
    
    if([enabledPreference boolValue]){
    
        
        [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
            
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        
            
            [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:[group numberOfAssets] - 1] options:0 usingBlock:^(ALAsset *alAsset, NSUInteger index, BOOL *innerStop) {
            
                
                if (alAsset) {
                    UIWindow* topWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
                    topWindow.hidden = NO;
                    topWindow.windowLevel = UIWindowLevelAlert;
                    UIViewController *vc  = [[UIViewController alloc] init];
                
                    [topWindow setRootViewController:vc];
                    
                
                    ALAssetRepresentation *representation = [alAsset defaultRepresentation];
                    UIImage *latestPhoto = [UIImage imageWithCGImage:[representation fullScreenImage]];
                
                    NSString *tempDir = NSTemporaryDirectory();
                    NSString *path = [tempDir stringByAppendingPathComponent:[representation filename]];
                    NSURL *fileURL = [NSURL fileURLWithPath:path];
                
                    [UIImagePNGRepresentation(latestPhoto) writeToFile:path atomically:NO];
                
                    TTOpenInAppActivity *openInActivity = [[TTOpenInAppActivity alloc] initWithView:vc.view andRect:vc.view.bounds];
                
                    
                    NSArray *activityItems = @[ fileURL ];
                    UIActivityViewController *activityController;
                    if([openInPreference boolValue]){
                        activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:@[ openInActivity ]];
                    }else{
                        activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:@[ ]];
                    }
                    activityController.excludedActivityTypes = @[UIActivityTypeSaveToCameraRoll, UIActivityTypePrint, UIActivityTypeAirDrop ];
                
                    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
                        openInActivity.superViewController = activityController;
                        [openInActivity release];
                        [vc presentViewController:activityController animated:YES completion:NULL];
                    } else {
                        UIPopoverController *activityPopoverController = [[UIPopoverController alloc] initWithContentViewController:activityController];
                        openInActivity.superViewController = activityPopoverController;
                        [openInActivity release];
                        [activityPopoverController presentPopoverFromRect:CGRectMake(CGRectGetMidX(vc.view.bounds), 0, 1, 1) inView:vc.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                    }
                

                
                    activityController.completionHandler = ^(NSString *activityType, BOOL completed) {
                        
                    
                        [[NSFileManager defaultManager] removeItemAtURL:fileURL error:NULL];
                    
                        [topWindow performSelector:@selector(setHidden:) withObject:self afterDelay:[delayPreference floatValue]]; 
                        [topWindow release];
                        [activityController release];
                    };
                
                }
            }];
        } failureBlock: ^(NSError *error) {
            
            
            NSLog(@"No groups");
        }];
    
        [library release];
    
    }
    

    _logos_orig$_ungrouped$SBScreenShotter$finishedWritingScreenshot$didFinishSavingWithError$context$(self, _cmd, screenshot,error,context);
    
}




































static BOOL _logos_method$_ungrouped$PLPhotoStreamsHelper$shouldPublishScreenShots(PLPhotoStreamsHelper* self, SEL _cmd) {
    NSString *settingsPath = [NSString stringWithFormat:@"%@/Library/Preferences/%@", NSHomeDirectory(), @"com.ethansquared.ScreenshotShareSheet.plist"];
    NSMutableDictionary *settings = [NSMutableDictionary dictionaryWithContentsOfFile:
                                     settingsPath];
	NSNumber* preference = [settings objectForKey:@"photostream"];
    if(preference == nil){
        
        preference = [NSNumber numberWithBool:YES];
        [settings setObject:preference forKey:@"photostream"];
        [settings writeToFile:settingsPath atomically:YES];
    }
    return [preference boolValue];
}


static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$SBScreenShotter = objc_getClass("SBScreenShotter"); MSHookMessageEx(_logos_class$_ungrouped$SBScreenShotter, @selector(finishedWritingScreenshot:didFinishSavingWithError:context:), (IMP)&_logos_method$_ungrouped$SBScreenShotter$finishedWritingScreenshot$didFinishSavingWithError$context$, (IMP*)&_logos_orig$_ungrouped$SBScreenShotter$finishedWritingScreenshot$didFinishSavingWithError$context$);Class _logos_class$_ungrouped$PLPhotoStreamsHelper = objc_getClass("PLPhotoStreamsHelper"); MSHookMessageEx(_logos_class$_ungrouped$PLPhotoStreamsHelper, @selector(shouldPublishScreenShots), (IMP)&_logos_method$_ungrouped$PLPhotoStreamsHelper$shouldPublishScreenShots, (IMP*)&_logos_orig$_ungrouped$PLPhotoStreamsHelper$shouldPublishScreenShots);} }
#line 184 "/Users/ethangillius/Developer/Cydia/ScreenshotShareSheet/ScreenshotShareSheet/ScreenshotShareSheet.xm"
