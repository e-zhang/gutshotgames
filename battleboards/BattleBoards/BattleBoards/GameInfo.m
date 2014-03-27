//
//  GameInfo.m
//  sumosmash
//
//  Created by Eric Zhang on 3/25/13.
//  Copyright (c) 2013 gutshotgames. All rights reserved.
//

#import "GameInfo.h"

#import "DBDefs.h"
#import "GameDefinitions.h"

#import <Foundation/Foundation.h>

@implementation GameInfo

@dynamic gameName, gameData, roundStartTime, roundBuffer,
         timeInterval, players, hostId, currentRound, gridSize;

@synthesize gameChat=_gameChat;
@synthesize GameRound=_gameRound;



-(void) reset:(NSString*)playerId
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
        NSMutableDictionary* players = [self.players mutableCopy];
        NSMutableDictionary* player = [[players objectForKey:playerId] mutableCopy];
        [player setObject:[[NSArray alloc] init] forKey:DB_START_LOC];
        [player setObject:[NSNumber numberWithBool:NO] forKey:DB_CONNECTED];
        [players setObject:player forKey:playerId];
        self.players = players;
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
    
//    [self willChangeValueForKey:@"GameRound"];
//    for( int i = 0; i < [self.gameData count]; ++i )
//    {
//        _gameRound = i;
//        NSLog(@" replaying round %d / %d", _gameRound, [self.gameData count]);
//        [self checkRound:[self.gameData objectAtIndex:i]];
//        if([[self.gameData objectAtIndex:i] count] < [self.players count])
//        {
//            break;
//        }
//    }
//    [self didChangeValueForKey:@"GameRound"];
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

- (BOOL) joinGame:(NSString*) userId withLocation:(NSArray *)start
{
    _isLast = YES;
    for(NSString* playerId in self.players)
    {
        NSDictionary* player = [self.players objectForKey:playerId];
        if([[player objectForKey:DB_CONNECTED] boolValue])
        {
            [_delegate onPlayerJoined:player];
            _isLast &= YES;
        }
        else
        {
            _isLast &= [playerId isEqualToString:userId];
        }
    }
    
    BOOL allUnits=NO;
    NSError* error = nil;
    do
    {

        if(error)
        {
            [self resolveConflicts:self];
        }
        NSMutableDictionary* joinedPlayers = [self.players mutableCopy];
        NSMutableDictionary* player = [[joinedPlayers objectForKey:userId] mutableCopy];
        NSMutableArray* unitStarts = [[player objectForKey:DB_START_LOC] mutableCopy];

        [unitStarts addObject:start];
        
        [player setObject:unitStarts forKey:DB_START_LOC];
        [joinedPlayers setObject:player forKey:userId];
        
        allUnits = unitStarts.count == NUMBER_OF_UNITS;
        
        if(allUnits)
        {
            [player setObject:[NSNumber numberWithBool:YES] forKey:DB_CONNECTED];
        }
        
        self.players = joinedPlayers;
        [[self save] wait:&error];
        
    } while ([error.domain isEqual: @"CouchDB"] &&
             error.code == 409);
    
    if(allUnits)
    {
        [_delegate onPlayerJoined:[self.players objectForKey:userId]];
        if(_isLast)
        {
            [self startRound];
        }
    }

    return allUnits;
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
    NSLog(@"nextround, isLast - %d, currentround - %d ", _isLast, [self.currentRound intValue]);

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
            

            NSMutableArray* rounds = [self.gameData mutableCopy];
            [rounds addObject:[NSMutableDictionary dictionaryWithCapacity:[self.players count]]];
            self.currentRound = [NSNumber numberWithInt:[rounds count]-1];
            self.gameData = rounds;
            [[self save] wait:&error];
        }while ([error.domain isEqual: @"CouchDB"] &&
                error.code == 409);
            
    }

    [self willChangeValueForKey:@"GameRound"];
    _gameRound = [self.currentRound intValue];
    [self didChangeValueForKey:@"GameRound"];
    
    
    NSLog(@"_gameRound-%d, currentRound-%d, gamedata-%d",_gameRound, [self.currentRound intValue], [self.gameData count]);
    
    NSAssert(_gameRound<0 || _gameRound == [self.gameData count]-1, @"game round and current round OUT OF SYNC");

    return isLast;
}

- (void) submitUnits:(NSDictionary*)units andPoints:(int)points forPlayer:(NSString *)player
{
    NSError* error = nil;
    do
    {
        if(error)
        {
            [self resolveConflicts:self];
            error = nil;
        }
        
        if(_gameRound >= [self.gameData count])
        {
            NSLog(@"GAME ROUND IS TOO LARGE: %d", _gameRound);
            break;
        }
        
        NSMutableDictionary* currentRound = [[self.gameData objectAtIndex:_gameRound] mutableCopy];
        NSMutableArray* data = [self.gameData mutableCopy];
        
        // last if count - 1 entries and no count for self
        _isLast = ([currentRound count] == _charsLeft - 1) && ![currentRound objectForKey:player];
        
        
        NSDictionary* playerData = [NSDictionary dictionaryWithObjectsAndKeys:
                                    units,DB_UNITS,
                                    @(points),DB_POINTS, nil];
        
        [currentRound setObject:playerData forKey:player];

        [data setObject:currentRound atIndexedSubscript:_gameRound];
        NSLog(@"data - %@", data);
        
        self.gameData = data;
        [[self save] wait:&error];
        
    } while([error.domain isEqual:@"CouchDB"] && error.code == 409);
    
    
    NSLog(@"current round is: %d, game round is %d", [self.currentRound intValue], _gameRound);
    if([self.currentRound intValue] == _gameRound)
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
        int connected = 0;
        for(NSString* playerId in self.players)
        {
            NSDictionary* player = [self.players objectForKey:playerId];
            if([[player objectForKey:DB_CONNECTED] boolValue])
            {
                connected++;
                start = [_delegate onPlayerJoined:player];
            }
        }
    }
    
    
    if(_gameRound < 0 && self.currentRound == 0)
    {
        NSLog(@"start round");
        [self startRound];
    }
    
    
    if ([self.currentRound intValue] >= 0 && [self.gameData count] > 0)
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
    NSLog(@"currentround-%d, players-%d,charsleft-%d",[currentRound count],[self.players count],_charsLeft);

    if ([currentRound count] <= _charsLeft)
    {
        for(NSString* playerId in currentRound)
        {
            NSDictionary* player = [currentRound objectForKey:playerId];
            [_delegate updateWithUnits:[player objectForKey:DB_UNITS]
                    andPoints:[[player objectForKey:DB_POINTS] intValue]
                    forPlayer:playerId];
          //  NSLog(@"player: %@ using move %@", playerId, MoveStrings[move.Type]);
        }
        
        if([currentRound count] == _charsLeft)
        {
            NSLog(@"round complete!");
            [_delegate onRoundComplete];
            [self startRound];
        }
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
