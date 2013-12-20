//
//  GameInfo.h
//  sumosmash
//
//  Created by Eric Zhang on 3/25/13.
//  Copyright (c) 2013 gutshotgames. All rights reserved.
//

#import <CouchCocoa/CouchCocoa.h>
#import "CoordPoint.h"
#import "GameChat.h"

@protocol GameUpdateDelegate <NSObject>

- (BOOL) onPlayerJoined:(NSDictionary*) player;
- (BOOL) onMove:(CoordPoint*)move byPlayer:(NSString*) playerId;
- (BOOL) addBombs:(NSArray*)bombs byPlayer:(NSString*)playerId;
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

- (void) reset;
- (void) startRound;
- (void) endRound;

- (BOOL) isGameOver;
- (void) setGameOver:(BOOL) gameOver withChars:(int) chars;
- (void) setGameChat:(GameChat *)gameChat;

- (void) sendChat:(NSString*) chat fromUser:(NSString*) name;

- (void) joinGame:(NSString*) userId isLast:(BOOL) isLast;
- (void) leaveGame:(NSString*) userId;
- (void) submitMove:(CoordPoint*)move andBombs:(NSArray*)bombs byPlayer:(NSString*)player;




@end
