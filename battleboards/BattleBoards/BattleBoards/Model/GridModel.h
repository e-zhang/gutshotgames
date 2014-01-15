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
<<<<<<< HEAD
-(void)startGame;
-(void)startNextRound:(int)roundNum;
-(void)updateRoundForCells:(NSArray *)cells andPlayers:(NSDictionary *)players andRound:(int)roundNum;
-(void)initplayers:(NSDictionary*)players;
-(void)refreshCellatRow:(int)x andCol:(int)y;
-(void)playerupdate:(NSString *)pId newpoints:(int)points withPlayers:(NSDictionary *)players;

-(void)showMovePossibilities;
-(void)showBombPossibilities;
=======
-(void) updateRoundForCells:(NSArray*)cells andPlayers:(NSDictionary*)players;
>>>>>>> 9eca385274a4ad10699a6e4ccce5b4b391b163ae
@end

@interface GridModel : NSObject<GameUpdateDelegate>
{
<<<<<<< HEAD
    BOOL init;
    BOOL movement;

    int _gameStarted;
=======
>>>>>>> 9eca385274a4ad10699a6e4ccce5b4b391b163ae
    NSArray* _grid;
    NSMutableDictionary* _players;
    GameInfo* _gameInfo;
    NSString* _myPlayerId;
    id<RoundUpdateDelegate> _delegate;
    
    NSArray* _charColors;
}

-(id) initWithGame:(GameInfo*)game andPlayer:(NSString*)player andDelegate:(id) delegate;


-(CellValue*) getCellAtRow:(int)row andCol:(int)col;

-(void)cellTap:(int)row andCol:(int)col;

-(void)showMovePs;
-(void)showBombPs;
// update database
-(void) submitForMyPlayer;

// gameupdate delegate
-(BOOL) onPlayerJoined:(NSDictionary *)player;
-(BOOL) onMove:(NSArray*)move andBombs:(NSArray*)bombs forPlayer:(NSString*)player;
-(void) onRoundComplete;
-(void) onRoundStart;

@property (readonly) Player* MyPlayer;
@property (readonly) int GridSize;
@property (readonly) NSDictionary* Players;

@end
