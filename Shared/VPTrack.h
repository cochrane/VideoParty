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

@property (nonatomic, assign) NSUInteger positionInList;
@property (nonatomic, assign) NSInteger votes;
@property (nonatomic, copy) NSString *submitter;

@property (nonatomic, assign) BOOL canRemove;
@property (nonatomic, assign) BOOL canVoteUp;
@property (nonatomic, assign) BOOL canVoteDown;

- (void)remove;
- (void)voteUp;
- (void)voteDown;

@end
