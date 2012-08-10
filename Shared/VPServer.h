//
//  VPServer.h
//  VideoParty
//
//  Created by Torsten Kammer on 10.08.12.
//
//

#import <Foundation/Foundation.h>

@class VPClient;

@interface VPServer : NSObject

@property (readonly, nonatomic) VPClient *localClient;

@end
