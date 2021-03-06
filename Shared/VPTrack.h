//
//  VPTrack.h
//  VideoParty
//
//  Created by Torsten Kammer on 10.08.12.
//
//

#import <Foundation/Foundation.h>

@class VPVideo;

@interface VPTrack : NSObject

@property (nonatomic, copy) VPVideo *video;

// Unique for a given server session
@property (nonatomic, assign) NSUInteger trackID;

@property (nonatomic, assign) NSUInteger positionInList;
@property (nonatomic, assign) NSInteger votes;
@property (nonatomic, copy) NSString *submitter;

@property (nonatomic, assign) BOOL canRemove;
@property (nonatomic, assign) BOOL canVoteUp;
@property (nonatomic, assign) BOOL canVoteDown;
@property (nonatomic, assign) BOOL wasSubmittedByMe;
@property (nonatomic, assign) BOOL yetToPlay;

- (void)remove;
- (void)voteUp;
- (void)voteDown;

@end
