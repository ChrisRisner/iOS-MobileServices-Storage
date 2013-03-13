//
//  StorageService.m
//  StorageDemo
//
//  Created by Chris Risner on 3/12/13.
//  Copyright (c) 2013 Microsoft DPE. All rights reserved.
//

#import "StorageService.h"
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>

@interface StorageService()

@property (nonatomic, strong)   MSTable *tablesTable;
@property (nonatomic, strong)   MSTable *tableRowsTable;
@property (nonatomic, strong)   MSTable *containersTable;
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


@end
