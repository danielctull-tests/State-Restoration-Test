//
//  EventsViewController.h
//  State Restoration Test
//
//  Created by Daniel Tull on 27/02/2014.
//  Copyright (c) 2014 Daniel Tull. All rights reserved.
//

@import UIKit;
@import CoreData;
@class CoreDataStack;

@interface EventsViewController : UITableViewController
@property (nonatomic) CoreDataStack *coreDataStack;
@end
