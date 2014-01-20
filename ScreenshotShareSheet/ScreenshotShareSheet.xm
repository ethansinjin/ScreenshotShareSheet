#import <SpringBoard/SpringBoard.h>
#import "TTOpenInAppActivity.h"

// Logos by Dustin Howett
// See http://iphonedevwiki.net/index.php/Logos

/*
iOSOpenDev post-project creation from template requirements (remove these lines after completed) -- \
	Link to libsubstrate.dylib: \
	(1) go to TARGETS > Build Phases > Link Binary With Libraries and add /opt/iOSOpenDev/lib/libsubstrate.dylib \
	(2) remove these lines from *.xm files (not *.mm files as they're automatically generated from *.xm files)
*/

%hook SBScreenShotter

-(void)finishedWritingScreenshot:(id)screenshot didFinishSavingWithError:(id)error context:(void*)context
{
    %log;
    NSLog(@"ScreenshotShareSheet: A screenshot was taken.");
    //the user just took a screenshot. We should offer to do something with it.
    //most main code goes here, BEFORE %orig
    /*
    NSString *message = [NSString stringWithFormat:@"You just took a screenshot!"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"TEST" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
    */
    /*
    id lib = [PLPhotoLibrary sharedPhotoLibrary];
    id allPhotosAlbum = [lib allPhotosAlbum];
    id contents = [lib albumContents];
    id lastPhoto = [contents objectAtIndex:[contents count] -1];
    UIImage *screenshot = [lastPhoto newFullSizeImage];
     */
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    // Enumerate just the photos and videos group by using ALAssetsGroupSavedPhotos.
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        // Within the group enumeration block, filter to enumerate just photos.
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        
        // Chooses the photo at the last index
        [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:[group numberOfAssets] - 1] options:0 usingBlock:^(ALAsset *alAsset, NSUInteger index, BOOL *innerStop) {
            
            // The end of the enumeration is signaled by asset == nil.
            if (alAsset) {
                UIWindow* topWindow = [[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds] retain];
                topWindow.hidden = NO;
                UIViewController *vc  = [[UIViewController alloc] init];
                
                [topWindow setRootViewController:vc];
                
                ALAssetRepresentation *representation = [alAsset defaultRepresentation];
                UIImage *latestPhoto = [UIImage imageWithCGImage:[representation fullScreenImage]];
                NSURL *assetURL = [representation valueForProperty:ALAssetPropertyAssetURL];
                
                TTOpenInAppActivity *openInActivity = [[TTOpenInAppActivity alloc] initWithView:vc.view andRect:vc.view.bounds];
                
                // Do something interesting with the AV asset.
                NSArray *activityItems = @[latestPhoto, assetURL];
                UIActivityViewController *activityController =
                [[UIActivityViewController alloc]
                 initWithActivityItems:activityItems
                 applicationActivities:@[ openInActivity ]];
                activityController.excludedActivityTypes = @[UIActivityTypeSaveToCameraRoll,UIActivityTypeAssignToContact];
                
                openInActivity.superViewController = activityController;
                [openInActivity release];
                
                [vc presentViewController:activityController animated:YES completion:NULL];
                
                activityController.completionHandler = ^(NSString *activityType, BOOL completed) {
                    [topWindow performSelector:@selector(setHidden:) withObject:self afterDelay:0.40f]; // delay is for the animation to complete.
                    //let's hope this works
                    [topWindow release];
                    [vc release];
                    [activityController release];
                };
            }
        }];
    } failureBlock: ^(NSError *error) {
        // Typically you should handle an error more gracefully than this.
        NSLog(@"No groups");
    }];
    
    /*NSArray *activityItems = @[@"image here"];
    UIActivityViewController *activityController =
    [[UIActivityViewController alloc]
     initWithActivityItems:activityItems
     applicationActivities:nil];
    
    UIWindow* topWindow = [[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds] retain];
   // topWindow.windowLevel = 1200.0f;
    topWindow.hidden = NO;
    UIViewController *vc  = [[UIViewController alloc] init];
    [topWindow setRootViewController:vc];
    [vc presentViewController:activityController animated:YES completion:NULL];
    
    activityController.completionHandler = ^(NSString *activityType, BOOL completed) {
        [topWindow performSelector:@selector(setHidden:) withObject:self afterDelay:0.40f]; // delay is for the animation to complete.
        //let's hope this works
        [topWindow release];
        [vc release];
        [activityController release];
    };*/

    %orig(screenshot,error,context);
    
}

/* EXAMPLE METHODS (Leave commented out)

+ (id)sharedInstance
{
	%log;

	return %orig;
}

- (void)messageWithNoReturnAndOneArgument:(id)originalArgument
{
	%log;

	%orig(originalArgument);
	
	// or, for exmaple, you could use a custom value instead of the original argument: %orig(customValue);
}

- (id)messageWithReturnAndNoArguments
{
	%log;

	id originalReturnOfMessage = %orig;
	
	// for example, you could modify the original return value before returning it: [SomeOtherClass doSomethingToThisObject:originalReturnOfMessage];

	return originalReturnOfMessage;
}

*/

%end
