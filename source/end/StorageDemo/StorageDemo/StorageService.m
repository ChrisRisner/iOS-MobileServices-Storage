/*
 Copyright 2013 Microsoft Corp
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import "StorageService.h"
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>

@interface StorageService()

@property (nonatomic, strong)   MSTable *tablesTable;
@property (nonatomic, strong)   MSTable *tableRowsTable;
@property (nonatomic, strong)   MSTable *containersTable;
@property (nonatomic, strong)   MSTable *blobsTable;
@property (nonatomic)           NSInteger busyCount;

@end

@implementation StorageService

static StorageService *singletonInstance;

+ (StorageService*)getInstance{
    if (singletonInstance == nil) {
        singletonInstance = [[super alloc] init];
    }
    return singletonInstance;
}

-(StorageService *) init
{
    // Initialize the Mobile Service client with your URL and key
    MSClient *newClient = [MSClient clientWithApplicationURLString:@"https://storagedemo.azure-mobile.net/"
            withApplicationKey:@"oZaSIwBYgHrBiCApdCVcatyDxHQRCT23"];
    
    // Add a Mobile Service filter to enable the busy indicator
    self.client = [newClient clientwithFilter:self];
    
    self.tablesTable = [_client getTable:@"Tables"];
    self.tableRowsTable = [_client getTable:@"TableRows"];
    
    self.containersTable = [_client getTable:@"BlobContainers"];
    self.blobsTable = [_client getTable:@"BlobBlobs"];
    
    self.tables = [[NSMutableArray alloc] init];
    self.busyCount = 0;
    
    return self;
}

- (void) busy:(BOOL) busy
{
    // assumes always executes on UI thread
    if (busy) {
        if (self.busyCount == 0 && self.busyUpdate != nil) {
            self.busyUpdate(YES);
        }
        self.busyCount ++;
    }
    else
    {
        if (self.busyCount == 1 && self.busyUpdate != nil) {
            self.busyUpdate(FALSE);
        }
        self.busyCount--;
    }
}

- (void) logErrorIfNotNil:(NSError *) error
{
    if (error) {
        NSLog(@"ERROR %@", error);
    }
}



#pragma mark * MSFilter methods


- (void) handleRequest:(NSURLRequest *)request
                onNext:(MSFilterNextBlock)onNext
            onResponse:(MSFilterResponseBlock)onResponse
{
    // A wrapped response block that decrements the busy counter
    MSFilterResponseBlock wrappedResponse = ^(NSHTTPURLResponse *response, NSData *data, NSError *error) {
        [self busy:NO];
        onResponse(response, data, error);
    };
    
    // Increment the busy counter before sending the request
    [self busy:YES];
    onNext(request, wrappedResponse);
}

#pragma Storage Methods

- (void) refreshTablesOnSuccess:(CompletionBlock) completion{
    [self.tablesTable readWithCompletion:^(NSArray *results, NSInteger totalCount, NSError *error) {
        
        [self logErrorIfNotNil:error];
        
        self.tables = [results mutableCopy];
        
        // Let the caller know that we finished
        completion();
    }];
}

- (void) refreshTableRowsOnSuccess:(NSString *)tableName withCompletion:(CompletionBlock) completion {
    
    
    NSString *queryString = [NSString stringWithFormat:@"table=%@", tableName];
    
    [self.tableRowsTable readWithQueryString:queryString completion:^(NSArray *results, NSInteger totalCount, NSError *error) {
        
        [self logErrorIfNotNil:error];
        
        self.tableRows = [results mutableCopy];
        
        // Let the caller know that we finished
        completion();
    }];
}

- (void) updateTableRow:(NSDictionary *)item withTableName:(NSString *)tableName withCompletion:(CompletionBlock) completion {
    NSLog(@"Update Table Row %@", item);
    
    NSDictionary *params = @{ @"table" : tableName };
    
    [self.tableRowsTable update:item parameters:params completion:^(NSDictionary *result, NSError *error) {
        
        [self logErrorIfNotNil:error];
        
        NSLog(@"Results: %@", result);
        
        // Let the caller know that we finished
        completion();
    }];
}

- (void) insertTableRow:(NSDictionary *)item withTableName:(NSString *)tableName withCompletion:(CompletionBlock) completion {
    NSLog(@"Insert Table Row %@", item);
    
    NSDictionary *params = @{ @"table" : tableName };
    
    [self.tableRowsTable insert:item parameters:params completion:^(NSDictionary *result, NSError *error) {
        
        [self logErrorIfNotNil:error];
        
        NSLog(@"Results: %@", result);
        
        // Let the caller know that we finished
        completion();
    }];
}

- (void) createTable:(NSString *)tableName withCompletion:(CompletionBlock) completion {
    NSDictionary *item = @{ @"tableName" : tableName };
    
    [self.tablesTable insert:item completion:^(NSDictionary *result, NSError *error) {
        
        [self logErrorIfNotNil:error];
        
        NSLog(@"Results: %@", result);
        
        // Let the caller know that we finished
        completion();
    }];
}

- (void) deleteTable:(NSString *)tableName withCompletion:(CompletionBlock) completion {
    NSDictionary *idItem = @{ @"id" :@0 };
    NSDictionary *params = @{ @"tableName" : tableName };
    
    [self.tablesTable delete:idItem parameters:params completion:^(NSNumber *itemId, NSError *error) {
        [self logErrorIfNotNil:error];
        
        NSLog(@"Results: %@", itemId);
        
        // Let the caller know that we finished
        completion();
    }];
}

- (void) deleteTableRow:(NSDictionary *)item withTableName:(NSString *)tableName withCompletion:(CompletionBlock) completion {
    NSLog(@"Delete Table Row %@", item);
    
    //Have to send over all three as params since Mobile Services
    //will strip everything but the ID from the item dictionary
    NSDictionary *params = @{ @"tableName" : tableName ,
                              @"partitionKey" : [item objectForKey:@"PartitionKey"] ,
                              @"rowKey" : [item objectForKey:@"RowKey"]};
    
    [self.tableRowsTable delete:item parameters:params completion:^(NSNumber *itemId, NSError *error) {
        
        
        [self logErrorIfNotNil:error];
        
        NSLog(@"Results: %@", itemId);
        
        // Let the caller know that we finished
        completion();
    }];
}









#pragma blobs

- (void) refreshContainersOnSuccess:(CompletionBlock) completion{
    [self.containersTable readWithCompletion:^(NSArray *results, NSInteger totalCount, NSError *error) {
        
        [self logErrorIfNotNil:error];
        
        self.containers = [results mutableCopy];
        
        // Let the caller know that we finished
        completion();
    }];
}

- (void) createContainer:(NSString *)containerName withPublicSetting:(BOOL)isPublic withCompletion:(CompletionBlock) completion {
    NSDictionary *item = @{ @"containerName" : containerName };
    
    NSDictionary *params = @{ @"isPublic" : [NSNumber numberWithBool:isPublic] };
    
    [self.containersTable insert:item parameters:params completion:^(NSDictionary *result, NSError *error) {
        
        [self logErrorIfNotNil:error];
        
        NSLog(@"Results: %@", result);
        
        // Let the caller know that we finished
        completion();
    }];
}

- (void) deleteContainer:(NSString *)containerName withCompletion:(CompletionBlock) completion {
    NSDictionary *idItem = @{ @"id" :@0 };
    NSDictionary *params = @{ @"containerName" : containerName };
    
    [self.containersTable delete:idItem parameters:params completion:^(NSNumber *itemId, NSError *error) {
        [self logErrorIfNotNil:error];
        
        NSLog(@"Results: %@", itemId);
        
        // Let the caller know that we finished
        completion();
    }];
}

- (void) refreshBlobsOnSuccess:(NSString *)containerName withCompletion:(CompletionBlock) completion {
    
    
    NSString *queryString = [NSString stringWithFormat:@"container=%@", containerName];
    
    [self.blobsTable readWithQueryString:queryString completion:^(NSArray *results, NSInteger totalCount, NSError *error) {
        
        [self logErrorIfNotNil:error];
        
        self.blobs = [results mutableCopy];
        
        // Let the caller know that we finished
        completion();
    }];
}

- (void) deleteBlob:(NSString *)blobName fromContainer:(NSString *)containerName withCompletion:(CompletionBlock) completion {
    NSDictionary *idItem = @{ @"id" :@0 };
    NSDictionary *params = @{ @"containerName" : containerName, @"blobName" : blobName };
    
    [self.blobsTable delete:idItem parameters:params completion:^(NSNumber *itemId, NSError *error) {
        [self logErrorIfNotNil:error];
        
        NSLog(@"Results: %@", itemId);
        
        // Let the caller know that we finished
        completion();
    }];
}

- (void) getSasUrlForNewBlob:(NSString *)blobName forContainer:(NSString *)containerName withCompletion:(CompletionWithSasBlock) completion {
    NSDictionary *item = @{  };
    NSDictionary *params = @{ @"containerName" : containerName, @"blobName" : blobName };
    
    [self.blobsTable insert:item parameters:params completion:^(NSDictionary *item, NSError *error) {
        NSLog(@"Item: %@", item);
        
        completion([item objectForKey:@"sasUrl"]);
    }];
}

@end
