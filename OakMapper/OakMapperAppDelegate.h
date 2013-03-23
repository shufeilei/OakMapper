//
//  OakMapperAppDelegate.h
//  OakMapper
//
//  Created by Shufei Lei on 3/21/13.
//  Copyright (c) 2013 UCB. All rights reserved.
//

@interface OakMapperAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
