//
//  VPConnection.h
//  VideoParty
//
//  Created by Torsten Kammer on 10.08.12.
//
//

#import <Foundation/Foundation.h>

@interface VPConnection : NSObject

- (id)initWithInputStream:(NSInputStream *)input outputStream:(NSOutputStream *)output;

// To be used by subclasses
- (void)sendLine:(NSString *)line;

// To be overriden by subclasses.
// Do not call super.
- (void)parseLine:(NSString *)line;
- (void)disconnected;
- (void)receivedError:(NSError *)error;

@end
