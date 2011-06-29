//
//  ExpandingTableViewProjectAppDelegate.h
//  ExpandingTableViewProject
//
//  Created by Ryan Newsome on 4/12/11.
//

#import <UIKit/UIKit.h>

@class ExpandingTableViewProjectViewController;

@interface ExpandingTableViewProjectAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    ExpandingTableViewProjectViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet ExpandingTableViewProjectViewController *viewController;

@end

