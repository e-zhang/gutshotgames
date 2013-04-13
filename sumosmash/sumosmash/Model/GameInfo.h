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

- (void) onPlayerJoined:(NSString*) playerId;
- (void) onMoveSubmitted:(Move*) move byPlayer:(NSString*) playerId;
- (void) onRoundComplete;

@end

@interface GameInfo : CouchModel<CouchDocumentModel>
{
    id<GameUpdateDelegate> _delegate;
    BOOL _isOver;
    
    GameChat* _gameChat;
}

@property (nonatomic) NSString* gameName;
@property (nonatomic) NSArray* gameData;
@property (nonatomic) NSNumber* currentRound;

@property (nonatomic) NSString* startDate;
@property (nonatomic) NSInteger* timeInterval;

@property (nonatomic) NSDictionary* players;

@property (nonatomic) NSString* hostId;

@property (readonly, nonatomic) GameChat* gameChat;

- (void) setDelegate:(id<GameUpdateDelegate>) delegate;

- (BOOL) isGameOver;
- (void) setGameOver:(BOOL) over;
- (void) setGameChat:(GameChat *)gameChat;

- (void) sendChat:(NSString*) chat fromUser:(NSString*) name;

- (void) joinGame:(NSString*) userId;
- (void) getNextRound:(NSString*) playerId;
- (void) submitMove:(Move*) move forPlayer:(NSString*)player;

- (void) simulateRound:(NSDictionary*) characters withDefenders:(NSMutableArray**)defenders
                                                  withPointGetters:(NSMutableArray**)pointGetters
                                                  withSimultaneousAttackers:(NSMutableArray**)simAttackers
                                                  withAttackers:(NSMutableArray**)attackers;


@end
