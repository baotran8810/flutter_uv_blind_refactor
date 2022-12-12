//
//  FileManager.h
//  UVX
//
//  Created by Luan Tran on 10/27/15.
//  Copyright © 2015 csnguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "FileItem.h"

@interface FileManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

// Singleton
@property (strong, nonatomic) NSArray* fileList;

+ (instancetype)sharedInstance;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (NSArray*)fetchFileList;
@end
