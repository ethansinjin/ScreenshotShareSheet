#line 1 "/Users/ethan/Desktop/ScreenshotShareSheet/ScreenshotShareSheet/ScreenshotShareSheet.xm"
#import <SpringBoard/SpringBoard.h>












#include <logos/logos.h>
#include <substrate.h>
@class SBScreenShotter; 
static void (*_logos_orig$_ungrouped$SBScreenShotter$finishedWritingScreenshot$didFinishSavingWithError$context$)(SBScreenShotter*, SEL, id, id, void*); static void _logos_method$_ungrouped$SBScreenShotter$finishedWritingScreenshot$didFinishSavingWithError$context$(SBScreenShotter*, SEL, id, id, void*); 

#line 14 "/Users/ethan/Desktop/ScreenshotShareSheet/ScreenshotShareSheet/ScreenshotShareSheet.xm"



static void _logos_method$_ungrouped$SBScreenShotter$finishedWritingScreenshot$didFinishSavingWithError$context$(SBScreenShotter* self, SEL _cmd, id screenshot, id error, void* context) {
    NSLog(@"-[<SBScreenShotter: %p> finishedWritingScreenshot:%@ didFinishSavingWithError:%@ context:%p]", self, screenshot, error, context);
    NSLog(@"ScreenshotShareSheet: A screenshot was taken.");
    
    
    





    







    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        
        
        [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:[group numberOfAssets] - 1] options:0 usingBlock:^(ALAsset *alAsset, NSUInteger index, BOOL *innerStop) {
            
            
            if (alAsset) {
                ALAssetRepresentation *representation = [alAsset defaultRepresentation];
                UIImage *latestPhoto = [UIImage imageWithCGImage:[representation fullScreenImage]];
                
                
                NSArray *activityItems = @[latestPhoto];
                UIActivityViewController *activityController =
                [[UIActivityViewController alloc]
                 initWithActivityItems:activityItems
                 applicationActivities:nil];
                activityController.excludedActivityTypes = @[ UIActivityTypeSaveToCameraRoll ];
                
                UIWindow* topWindow = [[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds] retain];
                topWindow.hidden = NO;
                UIViewController *vc  = [[UIViewController alloc] init];
                [topWindow setRootViewController:vc];
                [vc presentViewController:activityController animated:YES completion:NULL];
                
                activityController.completionHandler = ^(NSString *activityType, BOOL completed) {
                    [topWindow performSelector:@selector(setHidden:) withObject:self afterDelay:0.40f]; 
                    
                    [topWindow release];
                    [vc release];
                    [activityController release];
                };

            }
        }];
    } failureBlock: ^(NSError *error) {
        
        NSLog(@"No groups");
    }];
    
    
    





















    


    _logos_orig$_ungrouped$SBScreenShotter$finishedWritingScreenshot$didFinishSavingWithError$context$(self, _cmd, screenshot,error,context);
    
}

































static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$SBScreenShotter = objc_getClass("SBScreenShotter"); MSHookMessageEx(_logos_class$_ungrouped$SBScreenShotter, @selector(finishedWritingScreenshot:didFinishSavingWithError:context:), (IMP)&_logos_method$_ungrouped$SBScreenShotter$finishedWritingScreenshot$didFinishSavingWithError$context$, (IMP*)&_logos_orig$_ungrouped$SBScreenShotter$finishedWritingScreenshot$didFinishSavingWithError$context$);} }
#line 143 "/Users/ethan/Desktop/ScreenshotShareSheet/ScreenshotShareSheet/ScreenshotShareSheet.xm"
