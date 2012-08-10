//
//  VPVideo.h
//  VideoParty
//
//  Created by Torsten Kammer on 10.08.12.
//
//

#import <Foundation/Foundation.h>

@interface VPVideo : NSObject

- (id)initWithService:(NSString *)serviceName videoID:(NSString *)videoID;

@property (readonly, nonatomic, copy) NSString *service;
@property (readonly, nonatomic, copy) NSString *videoID;

@end
