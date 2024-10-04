//
//  RNCloudStorage.m
//  Paxxword
//
//  Created by Nx on 2020/11/1.
//

#import "RNCloudStorage.h"
#import <React/RCTEventDispatcher.h>
#import <React/RCTLog.h>
#import <React/RCTUtils.h>
#import <iCloudDocumentSync/iCloud.h>

@implementation RNCloudStorage
- (dispatch_queue_t)methodQueue
{
    return dispatch_queue_create("RNCloudFs.queue", DISPATCH_QUEUE_SERIAL);
}

+ (void)initCloud:(NSString *)containerID
{
    [[iCloud sharedCloud] setupiCloudDocumentSyncWithUbiquityContainer:containerID];
}

- (instancetype)init
{
    if (self = [super init])
    {
        // [[iCloud sharedCloud] setVerboseLogging:YES];
    }
    return self;
}


+ (BOOL)requiresMainQueueSetup
{
    return NO;
}

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(isCloudAvailable:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)
{
    BOOL cloudIsAvailable = [[iCloud sharedCloud] checkCloudAvailability];
    BOOL cloudContainerIsAvailable = [[iCloud sharedCloud] checkCloudUbiquityContainer];
    BOOL ret = cloudIsAvailable && cloudContainerIsAvailable;
    return resolve(@(ret));
}

RCT_EXPORT_METHOD(mkdir:(NSDictionary *)options
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    NSString *targetPath = [options objectForKey:@"targetPath"];
    
    [[iCloud sharedCloud] createDirectory:targetPath completion:^(NSError *error) {
      if (error == nil) {
          return resolve(nil);
      } else {
          return reject(@"error", error.description, nil);
      }
    }];
}

RCT_EXPORT_METHOD(uploadFile:(NSDictionary *)options
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    NSString *targetPath = [options objectForKey:@"targetPath"];
    NSString *content = [options objectForKey:@"content"];
    
    [[iCloud sharedCloud] saveAndCloseDocumentWithName:targetPath withContent:[content dataUsingEncoding:NSUTF8StringEncoding] completion:^(UIDocument *cloudDocument, NSData *documentData, NSError *error) {
        if (error == nil) {
            return resolve(nil);
        } else {
            return reject(@"error", error.description, nil);
        }
    }];
}

RCT_EXPORT_METHOD(downloadFile:(NSDictionary *)options
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    NSString *targetPath = [options objectForKey:@"targetPath"];
    BOOL fileExists = [[iCloud sharedCloud] doesFileExistInCloud:targetPath];
    if (!fileExists) {
        return reject(@"Not Exist", [NSString stringWithFormat:@"File Not Exist"], nil);
    }
    
    [[iCloud sharedCloud] retrieveCloudDocumentWithName:targetPath completion:^(UIDocument *cloudDocument, NSData *documentData, NSError *error) {
        if (error) {
            return reject(@"Unknown Error", error.description, nil);
        } else {
            return resolve([[NSString alloc] initWithData:documentData encoding:NSUTF8StringEncoding]);
        }
    }];
}

RCT_EXPORT_METHOD(listFiles:(NSDictionary *)options
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    NSString *targetPath = [options objectForKey:@"targetPath"];
    BOOL includeSize = [options[@"includeSize"] boolValue];
    NSArray<NSURL *> *files = [[iCloud sharedCloud] listCloudFiles:targetPath];
    NSMutableArray<NSDictionary *> *fileNames = @[].mutableCopy;
    for (NSURL *url in files) {
        NSMutableDictionary *result = @{@"url": url.absoluteString, @"name": url.lastPathComponent}.mutableCopy;
        if (includeSize) {
          [result setObject:[[iCloud sharedCloud] fileSize:url.absoluteString]?:@(0) forKey:@"size"];
        }
        [fileNames addObject:result];
    }
    return resolve(fileNames);
}

RCT_EXPORT_METHOD(deleteFile:(NSDictionary *)options
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    NSString *targetPath = [options objectForKey:@"targetPath"];
    BOOL fileExists = [[iCloud sharedCloud] doesFileExistInCloud:targetPath];
    if (!fileExists) {
        return reject(@"Not Exist", [NSString stringWithFormat:@"File Not Exist"], nil);
    }
    
    [[iCloud sharedCloud] deleteDocumentWithName:targetPath completion:^(NSError *error) {
        if (error) {
            return reject(@"Unknown Error", error.description, nil);
        } else {
            return resolve(nil);
        }
    }];
}

RCT_EXPORT_METHOD(isFileExist:(NSDictionary *)options
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    NSString *targetPath = [options objectForKey:@"targetPath"];
    BOOL fileExists = [[iCloud sharedCloud] doesFileExistInCloud:targetPath];
    return resolve(@(fileExists));
}

RCT_EXPORT_METHOD(renameFile:(NSDictionary *)options
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    NSString *targetPath = [options objectForKey:@"targetPath"];
    BOOL fileExists = [[iCloud sharedCloud] doesFileExistInCloud:targetPath];
    if (!fileExists) {
        return reject(@"Not Exist", [NSString stringWithFormat:@"File Not Exist"], nil);
    }
    
    NSString *newName = [options objectForKey:@"newName"];
    if (!newName.length) {
        return reject(@"New Name Invalid", nil, nil);
    }
    
    [[iCloud sharedCloud] renameOriginalDocument:targetPath withNewName:newName completion:^(NSError *error) {
        if (error) {
            return reject(@"Unknown Error", error.description, nil);
        } else {
            return resolve(nil);
        }
    }];
}
@end
