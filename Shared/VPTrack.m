//
//  VPTrack.m
//  VideoParty
//
//  Created by Torsten Kammer on 10.08.12.
//
//

#import "VPTrack.h"

#import "VPClient+FromTrack.h"

@interface VPTrack ()

@property (nonatomic, weak) VPClient *client;
@property (nonatomic, assign) BOOL didVoteUp;
@property (nonatomic, assign) BOOL didVoteDown;

@end

@implementation VPTrack

- (BOOL)yetToPlay
{
	VPTrack *playing = self.client.currentlyPlayingTrack;
	
	return playing.positionInList < self.positionInList;
}

- (BOOL)canRemove
{
	if (!self.wasSubmittedByMe) return NO;
	if (!self.yetToPlay) return NO;
	
	return YES;
}

- (BOOL)canVoteUp
{
	if (self.wasSubmittedByMe) return NO;
	if (self.didVoteUp) return NO;
	if (!self.yetToPlay) return NO;
	
	return YES;	
}

- (BOOL)canVoteDown
{
	if (self.wasSubmittedByMe) return NO;
	if (self.didVoteDown) return NO;
	if (!self.yetToPlay) return NO;
	
	return YES;
}

- (BOOL)wasSubmittedByMe
{
	return [self.submitter isEqualToString:self.client.username];
}

- (void)remove;
{
	if (!self.canRemove) return;
	
	[self.client removeTrack:self];
}
- (void)voteUp;
{
	if (!self.canVoteUp) return;
	
	[self.client voteOnTrack:self delta:+1];
	self.didVoteDown = NO;
	self.didVoteUp = YES;
}
- (void)voteDown;
{
	if (!self.canVoteDown) return;
	
	[self.client voteOnTrack:self delta:-1];
	self.didVoteDown = YES;
	self.didVoteUp = NO;
}

@end
