//
//  AppDelegate.m
//  State Restoration Test
//
//  Created by Daniel Tull on 27/02/2014.
//  Copyright (c) 2014 Daniel Tull. All rights reserved.
//

@import CoreData;
#import "AppDelegate.h"
#import "EventsViewController.h"
#import "CoreDataStack.h"

@interface AppDelegate ()
@property (nonatomic) CoreDataStack *coreDataStack;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

	// If not restored
	if (!self.coreDataStack) {
		NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
		NSURL *storeURL = [documentsURL URLByAppendingPathComponent:@"store.sqlite"];
		NSBundle *mainBundle = [NSBundle mainBundle];
		NSURL *modelURL = [mainBundle URLForResource:@"Model" withExtension:@"momd"];
		self.coreDataStack = [[CoreDataStack alloc] initWithModelURL:modelURL storeType:NSSQLiteStoreType storeURL:storeURL storeOptions:nil];

		UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
		id viewController = navigationController.topViewController;
		if ([viewController respondsToSelector:@selector(setCoreDataStack:)])
			[viewController setCoreDataStack:self.coreDataStack];
	}

	return YES;
}

- (BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder {
	[coder encodeObject:self.coreDataStack forKey:@"coreDataStack"];
	return YES;
}

- (BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder {
	return YES;
}

- (void)application:(UIApplication *)application didDecodeRestorableStateWithCoder:(NSCoder *)coder {
	self.coreDataStack = [coder decodeObjectOfClass:[CoreDataStack class] forKey:@"coreDataStack"];
	NSLog(@"%@:%@ %@", self, NSStringFromSelector(_cmd), self.coreDataStack);
}

@end
