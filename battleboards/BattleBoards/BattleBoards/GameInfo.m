//
//  GameInfo.m
//  sumosmash
//
//  Created by Eric Zhang on 3/25/13.
//  Copyright (c) 2013 gutshotgames. All rights reserved.
//

#import "GameInfo.h"
//#import "Character.h"
#include "DBDefs.h"
#import <Foundation/Foundation.h>

@implementation GameInfo

@dynamic gameName, gameData, roundStartTime, roundBuffer,
         timeInterval, players, bots, hostId, currentRound;

@synthesize gameChat=_gameChat;
@synthesize GameRound=_gameRound;

-(void) reset
{
    _charsLeft = self.players.count + self.bots.count;
    _gameRound = -1;
    
    NSError* error = nil;
    do
    {
        if(error)
        {
            [self resolveConflicts:self];
        }
       
        self.gameData = [NSArray arrayWithObject:[[NSDictionary alloc] init]];
        self.currentRound = [NSNumber numberWithInt:_gameRound];
        [[self save] wait:&error];
        
    } while ([error.domain isEqual: @"CouchDB"] &&
              error.code == 409);
}

-(void) startRound
{
    if([self getNextRound])
    {
        NSError* error = nil;
        do
        {
            if(error)
            {
                [self resolveConflicts:self];
                error = nil;
            }
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"ET"]];
            [dateFormat  setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
            
            NSDate *start = [NSDate dateWithTimeInterval:[self.roundBuffer intValue] sinceDate:[NSDate date]]; // Grab current time
            self.roundStartTime = [dateFormat stringFromDate:start];
            [[self save] wait:&error];
        } while ([error.domain isEqual: @"CouchDB"] &&
                  error.code == 409);
            
    }
    
    [_delegate onRoundStart];
}

-(void) endRound
{
    if(!_isLast) return;
    
    NSDictionary* currentRound = [self.gameData objectAtIndex:[self.currentRound intValue]];
    
    for(NSDictionary* player in [self.players allValues])
    {
        if(![currentRound objectForKey:[player objectForKey:DB_USER_ID]])
        {
            [self submitMove:[[Move alloc] initWithDictionary:[player objectForKey:DB_DEFAULT_MOVE]]
                   forPlayer:[player objectForKey:DB_USER_ID]];
        }
    }
}

-(void) initializeGame
{
    _charsLeft=self.players.count;
    _gameRound = -1;
    
    [self willChangeValueForKey:@"GameRound"];
    for( int i = 0; i < [self.gameData count]; ++i )
    {
        _gameRound = i;
        NSLog(@" replaying round %d / %d", _gameRound, [self.gameData count]);
        [self checkRound:[self.gameData objectAtIndex:i]];
        if([[self.gameData objectAtIndex:i] count] < [self.players count])
        {
            break;
        }
    }
    [self didChangeValueForKey:@"GameRound"];
}

- (void) setDelegate:(id<GameUpdateDelegate>)delegate
{
    _delegate = delegate;
}

- (void) setGameOver:(BOOL) gameOver withChars:(int) chars
{
    _charsLeft= chars;
    _isGameOver = gameOver;
}

- (void) setGameChat:(GameChat *)gameChat
{
    _gameChat = gameChat;
}

- (BOOL) isGameOver
{
    return _isGameOver;
}

- (void) joinGame:(NSString*) userId isLast:(BOOL) last
{
    _isLast = last;
    NSError* error = nil;
    do
    {

        if(error)
        {
            [self resolveConflicts:self];
        }
        NSMutableDictionary* joinedPlayers = [self.players mutableCopy];
        NSMutableDictionary* player = [[joinedPlayers objectForKey:userId] mutableCopy];
        [player setObject:[NSNumber numberWithBool:YES] forKey:DB_CONNECTED];
        [joinedPlayers setObject:player forKey:userId];
        self.players = joinedPlayers;
        [[self save] wait:&error];
        
    } while ([error.domain isEqual: @"CouchDB"] &&
             error.code == 409);
    
}

- (void) leaveGame:(NSString*) userId
{
    NSError* error = nil;
    do
    {
        
        if(error)
        {
            [self resolveConflicts:self];
        }
        NSMutableDictionary* joinedPlayers = [self.players mutableCopy];
        NSMutableDictionary* player = [[joinedPlayers objectForKey:userId] mutableCopy];
        [player setObject:[NSNumber numberWithBool:NO] forKey:DB_CONNECTED];
        [joinedPlayers setObject:player forKey:userId];
        self.players = joinedPlayers;
        [[self save] wait:&error];
        
    } while ([error.domain isEqual: @"CouchDB"] &&
             error.code == 409);
    
}


-(BOOL) getNextRound
{
    [self willChangeValueForKey:@"GameRound"];
    _gameRound = [self.currentRound intValue] + 1;
    [self didChangeValueForKey:@"GameRound"];
    BOOL isLast = _isLast;
    _isLast = NO;
    
    if(isLast)
    {
        NSError* error = nil;
        do
        {
            if(error)
            {
                [self resolveConflicts:self];
            }
            
            self.currentRound = [NSNumber numberWithInt:_gameRound];
            NSMutableArray* rounds = [self.gameData mutableCopy];
            if(_gameRound >= [rounds count])
            {
                [rounds addObject:[NSMutableDictionary dictionaryWithCapacity:[self.players count]]];
            }
            self.gameData = rounds;
            [[self save] wait:&error];
        }while ([error.domain isEqual: @"CouchDB"] &&
                error.code == 409);
            
    }
    
    return isLast;
}


-(void) addToTeam:(NSString *)team forPlayer:(NSString *)playerId
{
    NSError* error = nil;
    do
    {
        if(error)
        {
            [self resolveConflicts:self];
        }
       
        NSMutableDictionary* players = [self.players mutableCopy];
        NSMutableDictionary* player = [players objectForKey:team];
        NSMutableArray* invites = [player objectForKey:DB_TEAM_INVITES];
        if(![invites containsObject:playerId])
        {
            [invites addObject:playerId];
        }
        [player setObject:invites forKey:DB_TEAM_INVITES];
        [players setObject:player forKey:team];
        self.players = players;
        
        [[self save] wait:&error];
    }while ([error.domain isEqual: @"CouchDB"] &&
            error.code == 409);
}


- (void) submitMove:(Move *)move forPlayer:(NSString *)player
{
    NSError* error = nil;
    do
    {
        if(error)
        {
            [self resolveConflicts:self];
            error = nil;
        }
        
        if(_gameRound >= [self.gameData count]) break;
        
        NSMutableDictionary* currentRound = [[self.gameData objectAtIndex:_gameRound] mutableCopy];
        NSMutableArray* data = [self.gameData mutableCopy];
        
        // last if count - 1 entries and no count for self
        _isLast = ([currentRound count] == _charsLeft - 1) && ![currentRound objectForKey:player];
        
        [currentRound setObject:[move getMove] forKey:player];
        [data setObject:currentRound atIndexedSubscript:_gameRound];
        NSLog(@"data - %@", data);
        
        self.gameData = data;
        [[self save] wait:&error];
        
    } while([error.domain isEqual:@"CouchDB"] && error.code == 409);
    
    
    NSLog(@"current round is: %d, game round is %d", [self.currentRound intValue], _gameRound);
    if([self.currentRound intValue] >= _gameRound)
    {
        NSAssert([self.currentRound intValue] == _gameRound || [self.currentRound intValue] == _gameRound+1, @"gameround out of sync");
        [self checkRound:[self.gameData objectAtIndex:_gameRound]];

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
     /*   Character* c = [characters objectForKey:playerId];
        switch(c.NextMove.Type)
        {
            case ATTACK:
            case SUPERATTACK:
            {
                Character* target = [characters objectForKey:c.NextMove.TargetId];
                
                [c OnRebate:[target OnAttack:c.NextMove.Type by:c.Id]];
                
                if([seenPlayers containsObject:playerId]) break;
                
                if((target.NextMove.Type == ATTACK || target.NextMove.Type == SUPERATTACK) &&
                   [target.NextMove.TargetId isEqual:playerId])
                {
                    [*simAttackers addObject:[NSArray arrayWithObjects:playerId,c.NextMove.TargetId,nil]];
                    [seenPlayers addObject:c.NextMove.TargetId];
                    [seenPlayers addObject:playerId];
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
        [seenPlayers addObject:playerId];*/
    }
    

    
}

- (void) sendChat:(NSString *)chat fromUser:(NSString *)name
{
    NSError* error = nil;
    do {
        if(error != nil)
        {
            [self resolveConflicts:self.gameChat];
            error = nil;
        }
        NSMutableArray* history = [_gameChat.chatHistory mutableCopy];
        [history addObject:[NSArray arrayWithObjects:name, chat, nil]];

        _gameChat.chatHistory = history;
        
        [[_gameChat save] wait:&error];
    } while([error.domain isEqualToString:CouchHTTPErrorDomain] && error.code == 409);
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
        BOOL start = NO;
        for(NSString* playerId in self.players)
        {
            NSDictionary* player = [self.players objectForKey:playerId];
            if([[player objectForKey:DB_CONNECTED] boolValue])
            {
                start = [_delegate onPlayerJoined:playerId];
            }
            
            if(start)
            {
                [self startRound];
            }
            
        }
    }
    else if ([self.currentRound intValue] >= 0 && [self.gameData count] > 0)
    {
        [self checkForTeams];
        
        if([self.currentRound intValue] >= _gameRound)
        {
            NSLog(@"round data: %d, round number: %d", [self.gameData count], [self.currentRound intValue]);
            NSDictionary* currentRound = [self.gameData objectAtIndex:_gameRound];
            
            if(!currentRound) return;
            
            NSLog(@"current round is: %d, game round is %d", [self.currentRound intValue], _gameRound);
            NSAssert([self.currentRound intValue] == _gameRound || [self.currentRound intValue] == _gameRound+1, @"gameround out of sync");
            [self checkRound:currentRound];
        }

    }
}


-(void) checkForTeams
{
    NSMutableDictionary* players = [self.players mutableCopy];
    for( NSDictionary* p in [self.players allValues] )
    {
        NSMutableArray* invites = [[NSMutableArray alloc] init];
        for( NSString* invite in [p objectForKey:DB_TEAM_INVITES])
        {
            if(![_delegate onTeamInvite:invite forPlayer:[p objectForKey:DB_USER_ID]])
            {
                
            }
        }
    }
}


-(void) checkRound:(NSDictionary*) currentRound
{
    NSLog(@"currentround-%d,players-%d,charsleft-%d",[currentRound count],[self.players count],_charsLeft);

    if ([currentRound count] == _charsLeft)
    {
        for(NSString* playerId in currentRound)
        {
            Move* move = [[Move alloc] initWithDictionary:[currentRound objectForKey:playerId]];
          //  NSLog(@"player: %@ using move %@", playerId, MoveStrings[move.Type]);
            _isLast = ![_delegate onMoveSubmitted:move byPlayer:playerId];
        }
        NSLog(@"round complete!");
        [_delegate onRoundComplete];
        [self startRound];
    }
    else if([currentRound count] == 0)
    {
        [_delegate onRoundStart];
    }
}

-(void) resolveConflicts:(CouchModel*) model
{
    NSLog(@"current revision:%@", [model.document currentRevisionID]);
    NSArray* conflicts = [model.document getConflictingRevisions];
    NSLog(@"current conflicts:%@", conflicts);
    for (CouchRevision* rev in conflicts)
    {
        NSLog(@"rev-properties: %@", rev.properties);
        for(NSString* prop in rev.properties)
        {
            [model setValue:[rev.properties objectForKey:prop] ofProperty:prop];
        }
    }
    NSLog(@"properties %@", model.propertiesToSave);
}



@end
