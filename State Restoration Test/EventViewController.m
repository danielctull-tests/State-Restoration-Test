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
	self.managedObjectContext = [coder decodeObjectOfClass:[NSManagedObjectContext class]
													forKey:@"managedObjectContext"];

	NSLog(@"%@:%@ %@", self, NSStringFromSelector(_cmd), self.managedObjectContext);

	NSURL *eventObjectURI = [coder decodeObjectOfClass:[NSURL class] forKey:@"eventObjectURI"];
    NSManagedObjectID *eventObjectID = [self.managedObjectContext.persistentStoreCoordinator managedObjectIDForURIRepresentation:eventObjectURI];
	self.event = (Event *)[self.managedObjectContext objectWithID:eventObjectID];
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
	[super encodeRestorableStateWithCoder:coder];
	[coder encodeObject:self.managedObjectContext forKey:@"managedObjectContext"];
	[coder encodeObject:[self.event.objectID URIRepresentation] forKey:@"eventObjectURI"];
}

@end
