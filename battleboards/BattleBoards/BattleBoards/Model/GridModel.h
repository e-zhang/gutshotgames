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

<<<<<<< HEAD
@interface GridModel : CouchModel<CouchDocumentModel>
=======

@protocol RoundUpdateDelegate <NSObject>
-(void) updateRoundForCells:(NSArray*)cells andPlayers:(NSDictionary*)players;
@end

@interface GridModel : NSObject<GameUpdateDelegate>
>>>>>>> e8d49ca87bce1673d50e470fc5582460d192bc2e
{
    NSArray* _grid;
    NSMutableDictionary* _players;
    GameInfo* _gameInfo;
    NSString* _myPlayerId;
    id<RoundUpdateDelegate> _delegate;
}

<<<<<<< HEAD
-(id) initWithSize:(int) size;
=======
-(id) initWithGame:(GameInfo*)game andPlayer:(NSString*)player andDelegate:(id) delegate;

-(CellValue*) getCellAtRow:(int)row andCol:(int)col;

// update database
-(void) submitForMyPlayer;
>>>>>>> e8d49ca87bce1673d50e470fc5582460d192bc2e

// gameupdate delegate
-(BOOL) onPlayerJoined:(NSDictionary *)player;
-(BOOL) onMove:(NSArray*)move andBombs:(NSArray*)bombs forPlayer:(NSString*)player;
-(void) onRoundComplete;
-(void) onRoundStart;



@end
