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

@synthesize gameChat=_gameChat;

// todo: probably keep a mutable copy of the rounds and stuff on hand to set
// the dynamic properties to, so we dont incur the cost of the copy each time

-(void) initializeGame
{
    _isOver = NO;
    _gameRound = -1;
}

- (void) setDelegate:(id<GameUpdateDelegate>)delegate
{
    _delegate = delegate;
}

- (void) setGameOver:(BOOL)over
{
    _isOver = over;
}

- (void) setGameChat:(GameChat *)gameChat
{
    _gameChat = gameChat;
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
        [player setObject:[NSNumber numberWithBool:YES] forKey:DB_CONNECTED];
        [joinedPlayers setObject:player forKey:userId];
        self.players = joinedPlayers;
        [[self save] wait:&error];
        
    } while ([error.domain isEqualToString: CouchHTTPErrorDomain] &&
             error.code == 409);
    
}

-(int) getNextRound:(NSString *)playerId
{
    if([playerId isEqual:self.hostId])
    {
        NSError* error = nil;
        do
        {
            self.currentRound = [NSNumber numberWithInt:[self.currentRound intValue] + 1];
            NSMutableArray* rounds = [self.gameData mutableCopy];
            [rounds addObject:[NSMutableDictionary dictionaryWithCapacity:[self.players count]]];
            self.gameData = rounds;
        }while ([error.domain isEqualToString: CouchHTTPErrorDomain] &&
                error.code == 409);
    }

    return ++_gameRound;
}

- (void) submitMove:(Move *)move forPlayer:(NSString *)player
{
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
    
    if ([[self.gameData objectAtIndex:[self.currentRound intValue]] count] == [self.players count]
        && [self.currentRound intValue] == _gameRound)
    {
        [_delegate onRoundComplete];
    }
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

- (void) sendChat:(NSString *)chat fromUser:(NSString *)name
{
    NSMutableArray* history = [_gameChat.chatHistory mutableCopy];
    [history addObject:[NSArray arrayWithObjects:name, chat, nil]];
    
    self.gameChat.chatHistory = history;
    NSLog( @"history is %@", _gameChat.chatHistory);
    NSLog( @"chat is %@", history);
    
    [[_gameChat save] wait];
    
}

- (void) couchDocumentChanged:(CouchDocument *)doc
{
    if (self.document != doc)
    {
        NSLog(@"Update on different doc");
        return;
    }
    
    if([self.currentRound intValue] < 0)
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
    else if ([self.currentRound intValue] >= 0)
    {
        NSLog(@"round data: %d, round number: %d", [self.gameData count], [self.currentRound intValue]);
        NSDictionary* currentRound = [self.gameData objectAtIndex:[self.currentRound intValue]];
        
        for(NSString* playerId in currentRound)
        {
            Move* move = [[Move alloc] initWithDictionary:[currentRound objectForKey:playerId]];
            [_delegate onMoveSubmitted:move byPlayer:playerId];
        }
        
        NSLog(@"current round is: %@, game round is %d", self.currentRound, _gameRound);
        if ([currentRound count] == [self.players count] && [self.currentRound intValue] == _gameRound)
        {
            [_delegate onRoundComplete];
        }
    }

    
}



@end
