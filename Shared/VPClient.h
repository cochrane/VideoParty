//
//  VPClient.h
//  VideoParty
//
//  Created by Torsten Kammer on 10.08.12.
//
//

#import <Foundation/Foundation.h>

#import "VPConnection.h"

@class VPClient;
@class VPTrack;
@class VPVideo;

@protocol VPClientDelegate <NSObject>

- (void)vpClientRequestedPassword:(VPClient *)client;
- (void)vpClient:(VPClient *)client changedUsernameTo:(NSString *)newName;;

- (void)vpClient:(VPClient *)client gotTrackList:(NSArray *)track;
- (void)vpClient:(VPClient *)client addedTrack:(VPTrack *)track;
- (void)vpClient:(VPClient *)client removedTrack:(VPTrack *)track;
- (void)vpClient:(VPClient *)client updatedTrack:(VPTrack *)track;
- (void)vpClient:(VPClient *)client startedPlayingTrack:(VPTrack *)track;

- (void)vpClient:(VPClient *)client userConnected:(NSString *)name;
- (void)vpClient:(VPClient *)client userDisconnected:(NSString *)name;

- (void)vpClient:(VPClient *)client receivedError:(NSError *)error;
- (void)vpClientDisconnected:(VPClient *)client;

@end

@interface VPClient : VPConnection

@property (weak, nonatomic) id <VPClientDelegate> delegate;

- (id)initWithNetService:(NSNetService *)service userName:(NSString *)userName;
- (id)initWithInputStream:(NSInputStream *)input outputStream:(NSOutputStream *)output userName:(NSString *)userName;

- (void)setPassword:(NSString *)password;

- (void)addVideo:(VPVideo *)video;

@property (nonatomic, copy, readonly) NSString *username;

@property (nonatomic, retain, readonly) VPTrack *currentlyPlayingTrack;

- (NSUInteger)countOfConnectedUsers;
- (NSString *)objectInConnectedUsersAtIndex:(NSUInteger)index;

@end
