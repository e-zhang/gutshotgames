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
@end

@interface GridModel : NSObject<GameUpdateDelegate>
{
    NSArray* _grid;
    NSMutableDictionary* _players;
    GameInfo* _gameInfo;
    NSString* _myPlayerId;
}

-(id) initWithGame:(GameInfo*)game andPlayer:(NSString*)player;

-(CellValue*) getCellAtRow:(int)row andCol:(int)col;

-(void) addMove:(CoordPoint*)coord forPlayer:(Player*)player;
-(void) addBombs:(NSArray*)bombs forPlayer:(Player*)player;

@end