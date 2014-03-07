//
//  CoreDataStack.h
//  State Restoration Test
//
//  Created by Daniel Tull on 07/03/2014.
//  Copyright (c) 2014 Daniel Tull. All rights reserved.
//

@import CoreData;
@import UIKit;

extern const struct CoreDataStackProperties {
	__unsafe_unretained NSString *modelURL;
	__unsafe_unretained NSString *storeType;
	__unsafe_unretained NSString *storeURL;
	__unsafe_unretained NSString *storeOptions;
	__unsafe_unretained NSString *managedObjectContext;
} CoreDataStackProperties;

@interface CoreDataStack : NSObject <UIStateRestoring>

- (instancetype)initWithModelURL:(NSURL *)modelURL
					   storeType:(NSString *)storeType
						storeURL:(NSURL *)storeURL
					storeOptions:(NSDictionary *)storeOptions;

@property (nonatomic, readonly) NSURL *modelURL;
@property (nonatomic, readonly) NSString *storeType;
@property (nonatomic, readonly) NSURL *storeURL;
@property (nonatomic, readonly) NSDictionary *storeOptions;

@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;

@end
