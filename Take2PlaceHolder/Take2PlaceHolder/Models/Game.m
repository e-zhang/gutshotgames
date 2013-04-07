//
//  Game.m
//  Take2PlaceHolder
//
//  Created by Eric Zhang on 3/9/13.
//
//

#import "Game.h"

@implementation Game
@dynamic rounds, host, num_players, current_round;
@synthesize delegate = _delegate;

-(void) couchDocumentChanged:(CouchDocument *)doc
{
}

-(void) RoundComplete
{
    [_delegate OnRoundComplete];
}

@end
