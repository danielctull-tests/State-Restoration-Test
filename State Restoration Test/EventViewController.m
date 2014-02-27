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

@end
