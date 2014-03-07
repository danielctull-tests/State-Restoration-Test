//
//  EventViewController.h
//  State Restoration Test
//
//  Created by Daniel Tull on 27/02/2014.
//  Copyright (c) 2014 Daniel Tull. All rights reserved.
//

@import UIKit;
@import CoreData;
@class Event;
@class CoreDataStack;

@interface EventViewController : UIViewController
@property (nonatomic) CoreDataStack *coreDataStack;
@property (nonatomic) Event *event;
@end
