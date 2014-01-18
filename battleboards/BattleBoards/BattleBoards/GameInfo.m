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
         timeInterval, players, hostId, currentRound, gridSize;

@synthesize gameChat=_gameChat;
@synthesize GameRound=_gameRound;



-(void) reset
{
    _charsLeft = self.players.count;
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

- (void) joinGame:(NSString*) userId withLocation:(NSArray *)start
{
    for(NSString* playerId in self.players)
    {
        NSDictionary* player = [self.players objectForKey:playerId];
        if([[player objectForKey:DB_CONNECTED] boolValue])
        {
            [_delegate onPlayerJoined:player];
            _isLast = YES;
        }
        else
        {
            _isLast = [playerId isEqualToString:userId];
        }
    }
    
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
        [player setObject:start forKey:DB_START_LOC];
        [joinedPlayers setObject:player forKey:userId];
        self.players = joinedPlayers;
        [[self save] wait:&error];
        
    } while ([error.domain isEqual: @"CouchDB"] &&
             error.code == 409);
    
    [_delegate onPlayerJoined:[self.players objectForKey:userId]];
    if(_isLast)
    {
        [self startRound];
    }

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
    NSLog(@"nextround");
    [self willChangeValueForKey:@"GameRound"];
    _gameRound = [self.currentRound intValue] + 1;
    NSLog(@"_gameRound-%d",_gameRound);
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

- (void) submitMove:(NSArray*)move Bombs:(NSArray*)bombs andPoints:(int)points forPlayer:(NSString *)player
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
        
        
        NSDictionary* playerData = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects: move, bombs, points, nil]
                                                           forKeys:[NSArray arrayWithObjects: DB_MOVE, DB_BOMBS, DB_POINTS, nil]];
        [currentRound setObject:playerData forKey:player];

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
                start = [_delegate onPlayerJoined:player];
            }
            
            if(start)
            {
                NSLog(@"start round");
                [self startRound];
            }
            
        }
    }
    else if ([self.currentRound intValue] >= 0 && [self.gameData count] > 0)
    {
        
        if([self.currentRound intValue] >= _gameRound && _gameRound >= 0)
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



-(void) checkRound:(NSDictionary*) currentRound
{
    NSLog(@"currentround-%d,players-%d,charsleft-%d",[currentRound count],[self.players count],_charsLeft);

    if ([currentRound count] == _charsLeft)
    {
        for(NSString* playerId in currentRound)
        {
            NSDictionary* player = [currentRound objectForKey:playerId];
            _isLast = ![_delegate onMove:[player objectForKey:DB_MOVE]
                                   Bombs:[player objectForKey:DB_BOMBS]
                               andPoints:[[player objectForKey:DB_POINTS] intValue]
                               forPlayer:playerId];
          //  NSLog(@"player: %@ using move %@", playerId, MoveStrings[move.Type]);
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
