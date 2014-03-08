//
//  EventsViewController.m
//  State Restoration Test
//
//  Created by Daniel Tull on 27/02/2014.
//  Copyright (c) 2014 Daniel Tull. All rights reserved.
//

#import "EventsViewController.h"
#import "EventViewController.h"
#import "Event.h"
#import "CoreDataStack.h"

@interface EventsViewController ()
@property (nonatomic) NSArray *events;
@end

@implementation EventsViewController

#pragma mark - UIStateRestoring

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
	[super decodeRestorableStateWithCoder:coder];
	self.coreDataStack = [coder decodeObjectOfClass:[CoreDataStack class] forKey:@"coreDataStack"];
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
	[super encodeRestorableStateWithCoder:coder];
	[coder encodeObject:self.coreDataStack forKey:@"coreDataStack"];
}

#pragma mark - UIViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	Event *event = [self.events objectAtIndex:self.tableView.indexPathForSelectedRow.row];
	EventViewController *eventViewController = segue.destinationViewController;
	eventViewController.coreDataStack = self.coreDataStack;
	eventViewController.event = event;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[self fetchEvents];
}

#pragma mark - EventsViewController

- (void)setCoreDataStack:(CoreDataStack *)coreDataStack {
	_coreDataStack = coreDataStack;
	[self fetchEvents];
}

- (IBAction)addEvent:(id)sender {
	Event *event = [Event insertInManagedObjectContext:self.coreDataStack.managedObjectContext];
	event.date = [NSDate new];
	[self.coreDataStack.managedObjectContext save:NULL];
	[self fetchEvents];
}

- (void)fetchEvents {
	NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:[Event entityName]];
	request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:EventAttributes.date ascending:NO]];
	self.events = [self.coreDataStack.managedObjectContext executeFetchRequest:request error:NULL];
}

- (void)setEvents:(NSArray *)events {
	_events = [events copy];
	[self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.events.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
	Event *event = [self.events objectAtIndex:indexPath.row];
	cell.textLabel.text = event.date.description;
    return cell;
}

@end
