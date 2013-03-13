//
//  StorageService.h
//  StorageDemo
//
//  Created by Chris Risner on 3/12/13.
//  Copyright (c) 2013 Microsoft DPE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>

#pragma mark * Block Definitions


typedef void (^CompletionBlock) ();
typedef void (^CompletionWithIndexBlock) (NSUInteger index);
typedef void (^CompletionWithMessagesBlock) (id messages);
typedef void (^BusyUpdateBlock) (BOOL busy);


@interface StorageService : NSObject<MSFilter>

@property (nonatomic, strong)   NSArray *tables;
@property (nonatomic, strong)   NSArray *tableRows;
@property (nonatomic, strong)   NSArray *containers;
@property (nonatomic, strong)   MSClient *client;
@property (nonatomic, copy)     BusyUpdateBlock busyUpdate;

+(StorageService*) getInstance;

- (void) handleRequest:(NSURLRequest *)request
                onNext:(MSFilterNextBlock)onNext
            onResponse:(MSFilterResponseBlock)onResponse;

- (void) refreshTablesOnSuccess:(CompletionBlock) completion;
- (void) refreshTableRowsOnSuccess:(NSString *)tableName withCompletion:(CompletionBlock) completion;
- (void) updateTableRow:(NSDictionary *)item withTableName:(NSString *)tableName withCompletion:(CompletionBlock) completion;
- (void) insertTableRow:(NSDictionary *)item withTableName:(NSString *)tableName withCompletion:(CompletionBlock) completion;
- (void) createTable:(NSString *)tableName withCompletion:(CompletionBlock) completion;
- (void) deleteTable:(NSString *)tableName withCompletion:(CompletionBlock) completion;

@end
