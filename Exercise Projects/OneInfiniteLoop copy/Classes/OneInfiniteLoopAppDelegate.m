//
//  OneInfiniteLoopAppDelegate.m
//  OneInfiniteLoop
//
//  Created by jeff on 8/13/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

#import "OneInfiniteLoopAppDelegate.h"
#import "InfiniteViewController.h"


@implementation OneInfiniteLoopAppDelegate

@synthesize window;
@synthesize navigationController;

#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *positionArray = [defaults objectForKey:@"archive key"];
    if (positionArray != nil)
    {
        BOOL first = YES;
        int hierarchyLevel = 0;
        for (NSNumber *oneNumber in positionArray) 
        {
            if (first) {
                first = NO;
            }
            else {
                int rowNumber = [oneNumber intValue];
                InfiniteViewController *controller = [[InfiniteViewController alloc] initWithStyle:UITableViewStylePlain];
                controller.hierarchyLevel = ++hierarchyLevel;
                controller.rowInParent = rowNumber;
                [self.navigationController pushViewController:controller animated:NO];
                [controller release];
            }
        }
    }

	[window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
}


- (void)applicationWillTerminate:(UIApplication *)application {
	
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

