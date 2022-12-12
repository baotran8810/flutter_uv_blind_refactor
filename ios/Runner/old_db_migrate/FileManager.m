//
//  FileManager.m
//  UVX
//
//  Created by Luan Tran on 10/27/15.
//  Copyright © 2015 csnguyen. All rights reserved.
//

#import "FileManager.h"

@implementation FileManager

@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize fileList;

+ (instancetype)sharedInstance {
    static FileManager *sharedInstance;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        sharedInstance = [[FileManager alloc] init];
    });
    return sharedInstance;
}

// Save new item
- (bool)commit:(FileItem *)fileItem {
    [self fetchFileList];
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *storeData = [NSEntityDescription insertNewObjectForEntityForName:@"FileItem" inManagedObjectContext:context];
    if (self.fileList == nil || [self.fileList count] == 0) {
        [storeData setValue:@"0" forKey:@"fileId"];
    } else {
        FileItem *file = [self.fileList lastObject];
        int newId = [file.fileId intValue] + 1;
        fileItem.fileId = [NSString stringWithFormat:@"%d", newId];
        [storeData setValue:[NSString stringWithFormat:@"%d", newId] forKey:@"fileId"];
    }
    [storeData setValue:fileItem.fileName forKey:@"fileName"];
    [storeData setValue:fileItem.sourceContent forKey:@"sourceContent"];
    [storeData setValue:fileItem.translatedContent forKey:@"translatedContent"];
    [storeData setValue:fileItem.targetLanguage forKey:@"targetLanguage"];
    [storeData setValue:fileItem.createdDate forKey:@"createdDate"];
    [storeData setValue:fileItem.readOutContent forKey:@"readOutContent"];
    [storeData setValue:fileItem.codeType forKey:@"codeType"];
    if (fileItem.ids) {
        [storeData setValue:fileItem.ids forKey:@"ids"];
    }
    
    // Commit new item
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        return false;
    }

    return true;
}

// Query all items
- (NSArray *)fetchFileList {
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdDate" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FileItem" inManagedObjectContext:context];
    [fetchRequest setResultType:NSDictionaryResultType];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    self.fileList = [context executeFetchRequest:fetchRequest error:&error];
    return [NSArray arrayWithArray:[self.fileList sortedArrayUsingDescriptors:sortDescriptors]];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack
// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"UVX" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    bool needMigrate = NO;
    bool needDeleteOld  = NO;
    
    NSString *kDbName = @"UVX.sqlite";
    
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:kDbName];
    NSURL *groupURL = [[self applicationGroupDirectory] URLByAppendingPathComponent:kDbName];
    NSURL *targetURL = nil;
    
    if ([fileManager fileExistsAtPath:[storeURL path]]) {
        NSLog(@"old single app db exist.");
        targetURL = storeURL;
        needMigrate = YES;
    }
    
    if ([fileManager fileExistsAtPath:[groupURL path]]) {
        NSLog(@"group db exist");
        needMigrate = NO;
        targetURL = groupURL;

        if ([fileManager fileExistsAtPath:[storeURL path]]) {
            needDeleteOld = YES;
        }
    }
    
    if (targetURL == nil)
        targetURL = groupURL;

    
    NSDictionary *options = @{
                              NSMigratePersistentStoresAutomaticallyOption : @YES,
                              NSInferMappingModelAutomaticallyOption : @YES
                              };
    NSError *error = nil;
    
    NSPersistentStore *store;
    store = [__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:targetURL options:options error:&error];
    
    if (!store) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    if (needMigrate) {
        NSError *error = nil;
        NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [context setPersistentStoreCoordinator:__persistentStoreCoordinator];
        [__persistentStoreCoordinator migratePersistentStore:store toURL:groupURL options:options withType:NSSQLiteStoreType error:&error];
        if (error != nil) {
            NSLog(@"Error when migration to groupd url %@, %@", error, [error userInfo]);
            abort();
        }
    }

    if (needDeleteOld) {
        [self deleteDocumentAtUrl:storeURL];
    }
    
    return __persistentStoreCoordinator;
}

-(void) deleteDocumentAtUrl:(NSURL *) url {
    NSFileCoordinator *fileCoordinator = [[NSFileCoordinator alloc] initWithFilePresenter:nil];
    NSError *error;
    [fileCoordinator coordinateWritingItemAtURL:url options:NSFileCoordinatorWritingForDeleting error:&error byAccessor:^(NSURL * _Nonnull newURL) {
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtURL:newURL error:&error];
    }];
}

#pragma mark - Application's Documents directory
// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

-(NSURL *) applicationGroupDirectory {
    NSString *bid = [[NSBundle mainBundle] bundleIdentifier];
    NSString *groupBid = [NSString stringWithFormat:@"group.%@", bid];
    return [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:groupBid];
}

-(NSManagedObject *) getFileWithUrlString:(NSString *) urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    NSManagedObjectID *objectID = [[self persistentStoreCoordinator] managedObjectIDForURIRepresentation:url];
    if (objectID) {
        return [[self managedObjectContext] objectWithID:objectID];
    }
    return nil;
}

@end
