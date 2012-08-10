//
//  VPClient+FromTrack.m
//  VideoParty
//
//  Created by Torsten Kammer on 10.08.12.
//
//

#import "VPClient+FromTrack.h"

#import "VPTrack.h"

@implementation VPClient (FromTrack)

- (void)removeTrack:(VPTrack *)track;
{
	NSString *line = [NSString stringWithFormat:@"Remove %lu", track.trackID];
	[self sendLine:line];
}

- (void)voteOnTrack:(VPTrack *)track delta:(NSInteger)upOrDown;
{
	NSString *line = [NSString stringWithFormat:@"Vote %lu %ld", track.trackID, upOrDown];
	[self sendLine:line];
}

@end
