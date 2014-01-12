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

<<<<<<< HEAD

@protocol RoundUpdateDelegate <NSObject>
-(void)startGame;
-(void)startNextRound:(int)roundNum;
-(void)updateRoundForCells:(NSArray *)cells andPlayers:(NSDictionary *)players andRound:(int)roundNum;
-(void)initplayers:(NSDictionary*)players;
-(void)refreshCellatRow:(int)x andCol:(int)y;

-(void)showMovePossibilities;
-(void)showBombPossibilities;
@end

@interface GridModel : NSObject<GameUpdateDelegate>
=======
@interface GridModel : CouchModel<CouchDocumentModel>
>>>>>>> 5ff438ca72e1e36df958fb0ab557aeb8682d4480
{
    BOOL init;
    int _gameStarted;
    NSArray* _grid;
    NSMutableDictionary* _players;
<<<<<<< HEAD
    GameInfo* _gameInfo;
    id<RoundUpdateDelegate> _delegate;
    
    int checkB;
    int checkM;
}

@property (strong, nonatomic) NSString* myPlayerId;

-(id) initWithGame:(GameInfo*)game andPlayer:(NSString*)player andDelegate:(id) delegate;
-(CellValue*) getCellAtRow:(int)row andCol:(int)col;
-(void)initailizePositionatRow:(int)row andCol:(int)col;
-(void)makeAllInit;
-(void)beginGame;

// update database
-(BOOL) submitForMyPlayer;

// gameupdate delegate
-(BOOL) onPlayerJoined:(NSString *)player;
-(BOOL) onMove:(NSArray*)move andBombs:(NSArray*)bombs forPlayer:(NSString*)player;
-(void) onRoundComplete;
-(void) onRoundStart;
=======
}

-(id) initWithSize:(int) size;

-(id) getStateForRow:(int)row andCol:(int)col;
-(void) setState:(id)state forRow:(int)row andCol:(int)col;
-(void) addPlayer:(Player*)p;
>>>>>>> 5ff438ca72e1e36df958fb0ab557aeb8682d4480

-(void) couchDocumentChanged:(CouchDocument *)doc;

@property(readonly) NSDictionary* Players;

@end
