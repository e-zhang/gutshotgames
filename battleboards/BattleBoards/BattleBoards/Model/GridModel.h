//
//  GridModel.h
//  BattleBoards
//
//  Created by Eric Zhang on 12/7/13.
//  Copyright (c) 2013 GutShotGames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CouchCocoa/CouchCocoa.h>
#import "Player.h"
#import "GameInfo.h"
#import "CellValue.h"


@protocol RoundUpdateDelegate <NSObject>

-(void) updateRoundForCells:(NSArray*)cells andPlayers:(NSDictionary*)players;
-(void) initPlayer:(Player*)p;
-(void) startGame;
-(void) onRoundStart:(int)round;

@end

@interface GridModel : NSObject<GameUpdateDelegate>
{

    NSArray* _grid;
    NSMutableDictionary* _players;
    GameInfo* _gameInfo;
    NSString* _myPlayerId;
    id<RoundUpdateDelegate> _delegate;
    
    NSArray* _charColors;
}

-(id) initWithGame:(GameInfo*)game andPlayer:(NSString*)player andDelegate:(id) delegate;
-(BOOL) beginGameAtCoord:(CoordPoint*)coord;

-(CellValue*) getCellWithCoord:(CoordPoint*)coord;
-(BOOL) isCoordInBounds:(CoordPoint*)coord;

-(BOOL) playerMoved:(CoordPoint*)coord;
-(BOOL) bombPlaced:(CoordPoint*)coord;

-(void) calculateGridPossibilities;

-(void) submitForMyPlayer;
-(NSArray*) undoForMyPlayer;
-(NSArray*) undoMove:(CoordPoint*)move forUnit:(int)unit;
-(NSArray*) undoBomb:(CoordPoint*)bomb forUnit:(int)unit;


-(NSString*) composePlayerId:(NSString*)userid withTag:(int)tag;
-(NSArray*) decomposePlayerId:(NSString*)composite;


// gameupdate delegate
-(BOOL) onPlayerJoined:(NSDictionary *)player;
-(void) updateWithUnits:(NSArray *)units andPoints:(int)points forPlayer:(NSString *)playerId;
-(void) onRoundComplete;
-(void) onRoundStart;

@property (readonly) Player* MyPlayer;
@property (readonly) int GridSize;
@property (readonly) NSDictionary* Players;
@property (readonly) NSArray* CharColors;

@end
