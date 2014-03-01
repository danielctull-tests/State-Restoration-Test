//
//  EventViewController.m
//  State Restoration Test
//
//  Created by Daniel Tull on 27/02/2014.
//  Copyright (c) 2014 Daniel Tull. All rights reserved.
//

#import "EventViewController.h"
#import "Event.h"

@interface EventViewController ()
@property (nonatomic, weak) IBOutlet UILabel *label;
@property (nonatomic) NSURL *eventObjectURI;
@end

@implementation EventViewController

#pragma mark - EventViewController

- (void)setEvent:(Event *)event {
	_event = event;
	self.label.text = event.date.description;
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
	_managedObjectContext = managedObjectContext;
	[self retrieveEvent];
}

- (void)setEventObjectURI:(NSURL *)eventObjectURI {
	_eventObjectURI = [eventObjectURI copy];
	[self retrieveEvent];
}

- (void)retrieveEvent {
	if (!self.managedObjectContext) return;
	if (!self.eventObjectURI) return;

	NSManagedObjectID *eventObjectID = [self.managedObjectContext.persistentStoreCoordinator managedObjectIDForURIRepresentation:self.eventObjectURI];
	self.event = (Event *)[self.managedObjectContext objectWithID:eventObjectID];
}

#pragma mark - UIViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.label.text = self.event.date.description;
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
	[super decodeRestorableStateWithCoder:coder];
	self.eventObjectURI = [coder decodeObjectOfClass:[NSURL class] forKey:@"eventObjectURI"];
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
	[super encodeRestorableStateWithCoder:coder];
	[coder encodeObject:[self.event.objectID URIRepresentation] forKey:@"eventObjectURI"];
}

@end
