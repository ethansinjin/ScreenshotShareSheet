#line 1 "/Users/ethan/Desktop/ScreenshotShareSheet/ScreenshotShareSheet/ScreenshotShareSheet.xm"
#import <SpringBoard/SpringBoard.h>
#import "TTOpenInAppActivity.h"
#import <AudioToolbox/AudioToolbox.h>











#include <logos/logos.h>
#include <substrate.h>
@class SBScreenShotter; 
static void (*_logos_orig$_ungrouped$SBScreenShotter$finishedWritingScreenshot$didFinishSavingWithError$context$)(SBScreenShotter*, SEL, id, id, void*); static void _logos_method$_ungrouped$SBScreenShotter$finishedWritingScreenshot$didFinishSavingWithError$context$(SBScreenShotter*, SEL, id, id, void*); 

#line 15 "/Users/ethan/Desktop/ScreenshotShareSheet/ScreenshotShareSheet/ScreenshotShareSheet.xm"



static void _logos_method$_ungrouped$SBScreenShotter$finishedWritingScreenshot$didFinishSavingWithError$context$(SBScreenShotter* self, SEL _cmd, id screenshot, id error, void* context) {
    NSLog(@"-[<SBScreenShotter: %p> finishedWritingScreenshot:%@ didFinishSavingWithError:%@ context:%p]", self, screenshot, error, context);
    NSLog(@"ScreenshotShareSheet: A screenshot was taken.");
    
    

    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        
        
        [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:[group numberOfAssets] - 1] options:0 usingBlock:^(ALAsset *alAsset, NSUInteger index, BOOL *innerStop) {
            
            
            if (alAsset) {
                UIWindow* topWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
                topWindow.hidden = NO;
                topWindow.windowLevel = UIWindowLevelAlert;
                UIViewController *vc  = [[UIViewController alloc] init];
                
                [topWindow setRootViewController:vc];
                [vc release];
                
                ALAssetRepresentation *representation = [alAsset defaultRepresentation];
                UIImage *latestPhoto = [UIImage imageWithCGImage:[representation fullScreenImage]];
                
                NSString *tempDir = NSTemporaryDirectory();
                NSString *path = [tempDir stringByAppendingPathComponent:[representation filename]];
                NSURL *fileURL = [NSURL fileURLWithPath:path];
                
                [UIImagePNGRepresentation(latestPhoto) writeToFile:path atomically:NO];
                
                TTOpenInAppActivity *openInActivity = [[TTOpenInAppActivity alloc] initWithView:vc.view andRect:vc.view.bounds];
                
                
                NSArray *activityItems = @[ fileURL ];
                UIActivityViewController *activityController =
                [[UIActivityViewController alloc]
                 initWithActivityItems:activityItems
                 applicationActivities:@[ openInActivity ]];
                activityController.excludedActivityTypes = @[UIActivityTypeSaveToCameraRoll,UIActivityTypeAssignToContact];
                
                openInActivity.superViewController = activityController;
                [openInActivity release];
                
                [vc presentViewController:activityController animated:YES completion:NULL];
                
                activityController.completionHandler = ^(NSString *activityType, BOOL completed) {
                    
                    
                    [[NSFileManager defaultManager] removeItemAtURL:fileURL error:NULL];
                    
                    [topWindow performSelector:@selector(setHidden:) withObject:self afterDelay:0.40f]; 
                    
                    [topWindow release];
                    [activityController release];
                };
            }
        }];
    } failureBlock: ^(NSError *error) {
        
        NSLog(@"No groups");
    }];
    
    [library release];
    
    






















    _logos_orig$_ungrouped$SBScreenShotter$finishedWritingScreenshot$didFinishSavingWithError$context$(self, _cmd, screenshot,error,context);
    
}

































static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$SBScreenShotter = objc_getClass("SBScreenShotter"); MSHookMessageEx(_logos_class$_ungrouped$SBScreenShotter, @selector(finishedWritingScreenshot:didFinishSavingWithError:context:), (IMP)&_logos_method$_ungrouped$SBScreenShotter$finishedWritingScreenshot$didFinishSavingWithError$context$, (IMP*)&_logos_orig$_ungrouped$SBScreenShotter$finishedWritingScreenshot$didFinishSavingWithError$context$);} }
#line 147 "/Users/ethan/Desktop/ScreenshotShareSheet/ScreenshotShareSheet/ScreenshotShareSheet.xm"
