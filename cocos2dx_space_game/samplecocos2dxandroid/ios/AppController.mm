//
//  Cocos2DxFirstIosSampleAppController.mm
//  Cocos2DxFirstIosSample
//
//  Created by Jorge Jordán Arenas on 10/03/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "AppController.h"
#import "cocos2d.h"
#import "EAGLView.h"
#import "AppDelegate.h"

#import "RootViewController.h"

@implementation AppController

@synthesize window;
@synthesize viewController;

#pragma mark -
#pragma mark Application lifecycle

// cocos2d application instance
static AppDelegate s_sharedApplication;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // Override point for customization after application launch.

    // Add the view controller's view to the window and display.
    window = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    EAGLView *__glView = [EAGLView viewWithFrame: [window bounds]
                                     pixelFormat: kEAGLColorFormatRGBA8
                                     depthFormat: GL_DEPTH_COMPONENT16
                              preserveBackbuffer: NO
                                      sharegroup: nil
                                   multiSampling: NO
                                 numberOfSamples:0 ];

    // Use RootViewController manage EAGLView
    viewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
    viewController.wantsFullScreenLayout = YES;
    viewController.view = __glView;

    // Set RootViewController to window
    if ( [[UIDevice currentDevice].systemVersion floatValue] < 6.0)
    {
        // warning: addSubView doesn't work on iOS6
        [window addSubview: viewController.view];
    }
    else
    {
        // use this method on ios6
        [window setRootViewController:viewController];
    }
    
    [window makeKeyAndVisible];

    [[UIApplication sharedApplication] setStatusBarHidden: YES];

    cocos2d::CCApplication::sharedApplication()->run();
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    cocos2d::CCDirector::sharedDirector()->pause();
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    cocos2d::CCDirector::sharedDirector()->resume();
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
    cocos2d::CCApplication::sharedApplication()->applicationDidEnterBackground();
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
    cocos2d::CCApplication::sharedApplication()->applicationWillEnterForeground();
}

- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
     cocos2d::CCDirector::sharedDirector()->purgeCachedData();
}


- (void)dealloc {
    [super dealloc];
}

#pragma UnityAdsDelegate methods
- (void)unityAdsVideoCompleted:(NSString *)rewardItemKey skipped:(BOOL)skipped
{
    if ([[[UnityAds sharedInstance] getZone] isEqualToString:@"rewardedVideo"]) {
        // todo call reward
        s_sharedApplication.rewardItemOne();
    }
}


#pragma Unity Ads Test
int UnityAdsInit (void *gameIdP)
{
    NSLog(@"[UnityAds] UnityAdsInit");
    UIApplication* app = [UIApplication sharedApplication];
    AppController* controller = (AppController*)[app delegate];
    UIViewController* rootController = [controller.window rootViewController];
    NSString* gameId = [NSString stringWithFormat:@"%s", gameIdP];
    [[UnityAds sharedInstance] startWithGameId:gameId andViewController:rootController];
    [[UnityAds sharedInstance] setDelegate:controller];
    
    return 1;
}

int UnityAdsCanShow (void *zoneStringP)
{
    NSLog(@"[UnityAds] UnityAdsCanShow");
    NSString* zoneId = [NSString stringWithFormat:@"%s", zoneStringP];
    [[UnityAds sharedInstance] setZone:zoneId];
    
    if ([[UnityAds sharedInstance] canShow]) {
        return 1;
    } else {
        return 0;
    }

    
    return 1;
}

int UnityAdsShow (void* zoneStringP)
{
    NSLog(@"[UnityAds] UnityAdsShow");
    NSString* zoneId = [NSString stringWithFormat:@"%s", zoneStringP];
    [[UnityAds sharedInstance] setZone:zoneId];
    
    if ([[UnityAds sharedInstance] canShow]) {
        [[UnityAds sharedInstance] show];
        return 1;
    } else {
        return 0;
    }

    
    return 1;
}



@end

