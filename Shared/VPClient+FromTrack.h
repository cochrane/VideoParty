//
//  VPClient+FromTrack.h
//  VideoParty
//
//  Created by Torsten Kammer on 10.08.12.
//
//

#import "VPClient.h"

@class VPTrack;

@interface VPClient (FromTrack)

- (void)removeTrack:(VPTrack *)track;
- (void)voteOnTrack:(VPTrack *)track isUp:(BOOL)upOrDown;

@end
