//
//  RNCloudStorage.h
//  Paxxword
//
//  Created by Nx on 2020/11/1.
//

#import <React/RCTBridgeModule.h>

NS_ASSUME_NONNULL_BEGIN

@interface RNCloudStorage : NSObject <RCTBridgeModule>
+ (void)initCloud:(NSString *)containerID;
@end

NS_ASSUME_NONNULL_END
