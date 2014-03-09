//
//  CoreDataStack.m
//  State Restoration Test
//
//  Created by Daniel Tull on 07/03/2014.
//  Copyright (c) 2014 Daniel Tull. All rights reserved.
//

#import "CoreDataStack.h"

const struct CoreDataStackProperties CoreDataStackProperties = {
	.modelURL = @"modelURL",
	.storeType = @"storeType",
	.storeURL = @"storeURL",
	.storeOptions = @"storeOptions",
	.managedObjectContext = @"managedObjectContext"
};

@interface CoreDataStack () <UIObjectRestoration>
@end

@implementation CoreDataStack
@synthesize managedObjectContext = _managedObjectContext;

#pragma mark - NSObject

- (NSString *)description {
	return [NSString stringWithFormat:@"<%@: %p; model = %@; store = %@>",
			NSStringFromClass([self class]),
			self,
			[self.modelURL lastPathComponent],
			[self.storeURL lastPathComponent]];
}

#pragma mark - CoreDataStack

- (instancetype)initWithModelURL:(NSURL *)modelURL
					   storeType:(NSString *)storeType
						storeURL:(NSURL *)storeURL
					storeOptions:(NSDictionary *)storeOptions {

	self = [self init];
	if (!self) return nil;

	_modelURL = [modelURL copy];
	_storeType = [storeType copy];
	_storeOptions = [storeOptions copy];
	_storeURL = [storeURL copy];

	NSString *identifier = [[NSUUID UUID] UUIDString];
	[UIApplication registerObjectForStateRestoration:self restorationIdentifier:identifier];

	return self;
}

- (NSManagedObjectContext *)managedObjectContext {

	if (!_managedObjectContext) {

		NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:self.modelURL];
		NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
		NSError *error;
		NSPersistentStore *store = [persistentStoreCoordinator addPersistentStoreWithType:self.storeType
																			configuration:nil
																					  URL:self.storeURL
																				  options:self.storeOptions
																					error:&error];
		if (!store) {
			NSLog(@"%@:%@ %@", self, NSStringFromSelector(_cmd), error);
			abort();
		}

		_managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
		_managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator;
	}

	return _managedObjectContext;
}

#pragma mark - UIStateRestoring

- (Class<UIObjectRestoration>)objectRestorationClass {
	return [self class];
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
	[coder encodeObject:self.modelURL forKey:CoreDataStackProperties.modelURL];
	[coder encodeObject:self.storeType forKey:CoreDataStackProperties.storeType];
	[coder encodeObject:self.storeURL forKey:CoreDataStackProperties.storeURL];
	[coder encodeObject:self.storeOptions forKey:CoreDataStackProperties.storeOptions];
}

#pragma mark - UIObjectRestoration

+ (id<UIStateRestoring>)objectWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder {

	NSURL *modelURL = [coder decodeObjectOfClass:[NSURL class] forKey:CoreDataStackProperties.modelURL];
	NSString *storeType = [coder decodeObjectOfClass:[NSString class] forKey:CoreDataStackProperties.storeType];
	NSURL *storeURL = [coder decodeObjectOfClass:[NSURL class] forKey:CoreDataStackProperties.storeURL];
	NSDictionary *storeOptions = [coder decodeObjectOfClass:[NSDictionary class] forKey:CoreDataStackProperties.storeOptions];

	CoreDataStack *stack = [[self alloc] initWithModelURL:modelURL storeType:storeType storeURL:storeURL storeOptions:storeOptions];

	NSString *identifier = [identifierComponents lastObject];
	[UIApplication registerObjectForStateRestoration:stack restorationIdentifier:identifier];

	return stack;
}

@end
