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

#import <Foundation/Foundation.h>
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>

#pragma mark * Block Definitions


typedef void (^CompletionBlock) ();
typedef void (^CompletionWithIndexBlock) (NSUInteger index);
typedef void (^CompletionWithMessagesBlock) (id messages);
typedef void (^CompletionWithSasBlock) (NSString *sasUrl);
typedef void (^BusyUpdateBlock) (BOOL busy);


@interface StorageService : NSObject<MSFilter>

@property (nonatomic, strong)   NSArray *tables;
@property (nonatomic, strong)   NSArray *tableRows;
@property (nonatomic, strong)   NSArray *containers;
@property (nonatomic, strong)   NSArray *blobs;
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
- (void) deleteTableRow:(NSDictionary *)item withTableName:(NSString *)tableName withCompletion:(CompletionBlock) completion;

- (void) refreshContainersOnSuccess:(CompletionBlock) completion;
- (void) createContainer:(NSString *)containerName withPublicSetting:(BOOL)isPublic withCompletion:(CompletionBlock) completion;
- (void) deleteContainer:(NSString *)containerName withCompletion:(CompletionBlock) completion;
- (void) refreshBlobsOnSuccess:(NSString *)containerName withCompletion:(CompletionBlock) completion;
- (void) deleteBlob:(NSString *)blobName fromContainer:(NSString *)containerName withCompletion:(CompletionBlock) completion;
- (void) getSasUrlForNewBlob:(NSString *)blobName forContainer:(NSString *)containerName withCompletion:(CompletionWithSasBlock) completion;

@end
