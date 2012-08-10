//
//  VPClient.h
//  VideoParty
//
//  Created by Torsten Kammer on 10.08.12.
//
//

#import <Foundation/Foundation.h>

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

- (void)vpClient:(VPClient *)client receivedError:(NSError *)error;

@end

@interface VPClient : NSObject

@property (weak, nonatomic) id <VPClientDelegate> delegate;

- (id)initWithNetService:(NSNetService *)service userName:(NSString *)userName;
- (id)initWithWriteStream:(CFWriteStreamRef)writeStream readStream:(CFReadStreamRef)readStream;

- (void)setPassword:(NSString *)password;

- (void)addVideo:(VPVideo *)video;

@property (nonatomic, copy) NSString *username;

@property (nonatomic, readonly) VPTrack *currentlyPlayingTrack;

@end
