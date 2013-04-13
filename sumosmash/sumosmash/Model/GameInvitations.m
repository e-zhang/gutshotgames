//
//  GameInvitations.m
//  sumosmash
//
//  Created by Eric Zhang on 4/9/13.
//  Copyright (c) 2013 gutshotgames. All rights reserved.
//

#import "GameInvitations.h"

@implementation GameInvitations

@dynamic gameRequests;

-(void) setDelegate:(id)delegate
{
    _delegate = delegate;
}

-(void) releaseDelegate
{
    _delegate = nil;
}

-(void) couchDocumentChanged:(CouchDocument *)doc
{
    if(self.document != doc)
    {
        NSLog(@"document for game invitation not the same");
    }
    
    if([self.gameRequests count] > 0)
    {
        [_delegate onInviteReceived:self.gameRequests];
    }
}

@end
