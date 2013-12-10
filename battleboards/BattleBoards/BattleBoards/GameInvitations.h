//
//  GameInvitations.h
//  sumosmash
//
//  Created by Eric Zhang on 4/9/13.
//  Copyright (c) 2013 gutshotgames. All rights reserved.
//

#import <CouchCocoa/CouchCocoa.h>

#import "GameRequest.h"

@protocol InvitationUpdateDelegate <NSObject>

-(void) onInviteReceived:(NSArray*) invites;

@end

@interface GameInvitations : CouchModel<CouchDocumentModel>
{
    id<InvitationUpdateDelegate> _delegate;
}

@property (nonatomic) NSArray* gameRequests;

- (void) setDelegate:(id<InvitationUpdateDelegate>) delegate;
- (void) releaseDelegate;

@end
