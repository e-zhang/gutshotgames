//
//  GameInfo.h
//  sumosmash
//
//  Created by Eric Zhang on 3/25/13.
//  Copyright (c) 2013 gutshotgames. All rights reserved.
//

#import <CouchCocoa/CouchCocoa.h>
#import "Move.h"
#import "GameChat.h"

@protocol GameUpdateDelegate <NSObject>

- (BOOL) onPlayerJoined:(NSString*) playerId;
- (BOOL) onMoveSubmitted:(Move*) move byPlayer:(NSString*) playerId;
- (void) onRoundComplete;
- (void) onRoundStart;

@end

@interface GameInfo : CouchModel<CouchDocumentModel>
{
    id<GameUpdateDelegate> _delegate;
    int _charsDead;
    int _gameRound;
    BOOL _isLast;
    
    GameChat* _gameChat;
}

@property (nonatomic) NSString* gameName;
@property (nonatomic) NSArray* gameData;
@property (nonatomic) NSNumber* currentRound;

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
- (void) setGameOver:(int) chars;
- (void) setGameChat:(GameChat *)gameChat;

- (void) sendChat:(NSString*) chat fromUser:(NSString*) name;

- (void) joinGame:(NSString*) userId isLast:(BOOL) isLast;
- (void) leaveGame:(NSString*) userId;
- (void) submitMove:(Move*) move forPlayer:(NSString*)player;

- (void) simulateRound:(NSDictionary*) characters withDefenders:(NSMutableArray**)defenders
                                                  withPointGetters:(NSMutableArray**)pointGetters
                                                  withSimultaneousAttackers:(NSMutableArray**)simAttackers
                                                  withAttackers:(NSMutableArray**)attackers;


@end
