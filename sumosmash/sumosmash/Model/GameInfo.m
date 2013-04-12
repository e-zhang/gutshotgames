//
//  GameInfo.m
//  sumosmash
//
//  Created by Eric Zhang on 3/25/13.
//  Copyright (c) 2013 gutshotgames. All rights reserved.
//

#import "GameInfo.h"
#import "Character.h"
#include "DBDefs.h"

@implementation GameInfo

@dynamic gameName, gameData, startDate,
         timeInterval, players, hostId, currentRound;

// todo: probably keep a mutable copy of the rounds and stuff on hand to set
// the dynamic properties to, so we dont incur the cost of the copy each time

- (void) setDelegate:(id<GameUpdateDelegate>)delegate
{
    _delegate = delegate;
}

- (void) setGameOver:(BOOL)over
{
    _isOver = over;
}

- (BOOL) isGameOver
{
    return _isOver;
}

- (void) joinGame:(NSString*) userId
{
    NSError* error = nil;
    do
    {
        NSMutableDictionary* joinedPlayers = [self.players mutableCopy];
        NSMutableDictionary* player = [[joinedPlayers objectForKey:userId] mutableCopy];
        [player setObject:[NSNumber numberWithBool:true] forKey:DB_CONNECTED];
        [[self save] wait:&error];
        
    } while ([error.domain isEqualToString: CouchHTTPErrorDomain] &&
             error.code == 409);
    
}

-(void) getNextRound:(NSString *)playerId
{
    if(![playerId isEqual:self.hostId]) return;
    
    self.currentRound = [NSNumber numberWithInt:[self.currentRound intValue] + 1];
    NSMutableArray* rounds = [self.gameData mutableCopy];
    [rounds addObject:[NSMutableDictionary dictionaryWithCapacity:[self.players count]]];
    self.gameData = rounds;
    
    NSError* error;
    if(![[self save] wait:&error])
    {
        NSLog(@"Could not get next round with error %@", [error localizedDescription]);
    }
}

- (void) submitMove:(Move *)move forPlayer:(NSString *)player
{
    NSLog(@"currentRound is %@", [self.currentRound stringValue]);
    NSError* error = nil;
    
    do
    {
        
        NSMutableDictionary* currentRound = [[self.gameData objectAtIndex:[self.currentRound intValue]] mutableCopy];
        [currentRound setObject:[move getMove] forKey:player];
        
        NSMutableArray* data = [self.gameData mutableCopy];
        [data setObject:currentRound atIndexedSubscript:[self.currentRound intValue]];
        
        self.gameData = data;
        [[self save] wait:&error];
        
    } while([error.domain isEqualToString:CouchHTTPErrorDomain] && error.code == 409);
}

- (void) simulateRound:(NSDictionary *)characters withDefenders:(NSMutableArray *__autoreleasing *)defenders
                                                  withPointGetters:(NSMutableArray *__autoreleasing *)pointGetters
                                                  withSimultaneousAttackers:(NSMutableArray*__autoreleasing *)simAttackers
                                                  withAttackers:(NSMutableArray *__autoreleasing *)attackers
{
    NSMutableSet* seenPlayers = [[NSMutableSet alloc] initWithCapacity:[characters count]];
    for(NSString* playerId in characters)
    {
        Character* c = [characters objectForKey:playerId];
        switch(c.NextMove.Type)
        {
            case ATTACK:
            case SUPERATTACK:
            {
                Character* target = [characters objectForKey:c.NextMove.TargetId];
                if ([target OnAttack:c.NextMove.Type])
                {
                    [c OnRebate];
                }
                
                if((target.NextMove.Type == ATTACK || target.NextMove.Type == SUPERATTACK) &&
                   [target.NextMove.TargetId isEqual:playerId] &&
                   ![seenPlayers containsObject:playerId])
                {
                    [*simAttackers addObject:[NSArray arrayWithObjects:playerId,c.NextMove.TargetId,nil]];
                    [seenPlayers addObject:c.NextMove.TargetId];
                }
                else
                {
                    [*attackers addObject:c];
                }
                break;
            }
            case DEFEND:
            {
                [*defenders addObject:c];
                break;
            }
            case GETPOINTS:
            {
                [*pointGetters addObject:c];
                break;
            }
            default: break;
        }
        [seenPlayers addObject:playerId];
    }
    
    for(Character* c in [characters allValues])
    {
        NSLog(@"%@",[c CommitUpdates]);
    }
    
}

- (void) couchDocumentChanged:(CouchDocument *)doc
{
    if (self.document != doc)
    {
        NSLog(@"Update on different doc");
        return;
    }
    
    if(!self.startDate)
    {
        for(NSString* playerId in self.players)
        {
            NSDictionary* player = [self.players objectForKey:playerId];
            if([player objectForKey:DB_CONNECTED])
            {
                [_delegate onPlayerJoined:playerId];
            }
        }
    }
    else if (self.currentRound >= 0)
    {
        NSDictionary* currentRound = [self.gameData objectAtIndex:[self.currentRound intValue]];
        
        for(NSString* playerId in currentRound)
        {
            Move* move = [[Move alloc] initWithDictionary:[currentRound objectForKey:playerId]];
            [_delegate onMoveSubmitted:move byPlayer:playerId];
        }
        
        if ([currentRound count] == [self.players count])
        {
            [_delegate onRoundComplete];
        }
    }

    
}

-(void) didLoadFromDocument
{
   
 }


@end
