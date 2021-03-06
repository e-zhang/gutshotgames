//
//  GameInfo.h
//  sumosmash
//
//  Created by Eric Zhang on 3/25/13.
//  Copyright (c) 2013 gutshotgames. All rights reserved.
//

#import <CouchCocoa/CouchCocoa.h>
#import "GameChat.h"

@protocol GameUpdateDelegate <NSObject>

- (BOOL) onPlayerJoined:(NSDictionary*) player;
- (void) updateWithUnits:(NSDictionary*)units andPoints:(int)points forPlayer:(NSString*) playerId;
- (void) onRoundComplete;
- (void) onRoundStart;

@end

@interface GameInfo : CouchModel<CouchDocumentModel>
{
    id<GameUpdateDelegate> _delegate;
    int _charsLeft;
    BOOL _isGameOver;
    int _gameRound;
    BOOL _isLast;
    
    GameChat* _gameChat;
}

@property (nonatomic) NSString* gameName;
@property (nonatomic) NSArray* gameData;
@property (nonatomic) NSNumber* currentRound;
@property (nonatomic) NSNumber* gridSize;

@property (nonatomic) NSString* roundStartTime;
@property (nonatomic) NSNumber* roundBuffer;
@property (nonatomic) NSNumber* timeInterval;

@property (nonatomic) NSDictionary* players;

@property (nonatomic) NSString* hostId;

@property (readonly, nonatomic) GameChat* gameChat;
@property (readonly) int GameRound;

-(void) initializeGame;
- (void) setDelegate:(id<GameUpdateDelegate>) delegate;

- (void) reset:(NSString*)playerId;
- (void) startRound;
- (void) endRound;

- (BOOL) isGameOver;
- (void) setGameOver:(BOOL) gameOver withChars:(int) chars;
- (void) setGameChat:(GameChat *)gameChat;

- (void) sendChat:(NSString*) chat fromUser:(NSString*) name;

- (BOOL) joinGame:(NSString*) userId withLocations:(NSArray*)starts;
- (void) leaveGame:(NSString*) userId;
- (void) submitUnits:(NSDictionary*)units andPoints:(int)points forPlayer:(NSString*)player;




@end
