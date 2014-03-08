//
//  EventViewController.m
//  State Restoration Test
//
//  Created by Daniel Tull on 27/02/2014.
//  Copyright (c) 2014 Daniel Tull. All rights reserved.
//

#import "EventViewController.h"
#import "Event.h"
#import "CoreDataStack.h"

@interface EventViewController ()
@property (nonatomic, weak) IBOutlet UILabel *label;
@end

@implementation EventViewController

#pragma mark - EventViewController

- (void)setEvent:(Event *)event {
	_event = event;
	self.label.text = event.date.description;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.label.text = self.event.date.description;
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
	[super decodeRestorableStateWithCoder:coder];
	self.coreDataStack = [coder decodeObjectOfClass:[CoreDataStack class] forKey:@"coreDataStack"];

	NSURL *eventObjectURI = [coder decodeObjectOfClass:[NSURL class] forKey:@"eventObjectURI"];
	NSManagedObjectContext *context = self.coreDataStack.managedObjectContext;
	NSManagedObjectID *eventObjectID = [context.persistentStoreCoordinator managedObjectIDForURIRepresentation:eventObjectURI];
	self.event = (Event *)[context objectWithID:eventObjectID];
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
	[super encodeRestorableStateWithCoder:coder];
	[coder encodeObject:self.coreDataStack forKey:@"coreDataStack"];
	[coder encodeObject:[self.event.objectID URIRepresentation] forKey:@"eventObjectURI"];
}

@end
