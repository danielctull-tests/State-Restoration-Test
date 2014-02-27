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

@interface AppDelegate ()
@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

	self.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];

	UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
	EventsViewController *eventsViewController = (EventsViewController *)navigationController.topViewController;
	eventsViewController.managedObjectContext = self.managedObjectContext;

    return YES;
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
	NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
	NSURL *storeURL = [documentsURL URLByAppendingPathComponent:@"store.sqlite"];
	NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
	NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
	[persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
											 configuration:nil
													   URL:storeURL
												   options:nil
													 error:NULL];

	managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator;
	_managedObjectContext = managedObjectContext;
}

- (BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder {
	[coder encodeObject:self.managedObjectContext forKey:@"managedObjectContext"];
	return YES;
}

- (BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder {
	self.managedObjectContext = [coder decodeObjectOfClass:[NSManagedObjectContext class]
													forKey:@"managedObjectContext"];
	
	NSLog(@"%@:%@ %@", self, NSStringFromSelector(_cmd), self.managedObjectContext);
	return YES;
}

@end
