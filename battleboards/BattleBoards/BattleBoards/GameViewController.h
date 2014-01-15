//
//  GameViewController.h
//  BattleBoards
//
//  Created by Eric Zhang on 12/7/13.
//  Copyright (c) 2013 GutShotGames. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GridView.h"
#import "GameInfo.h"

@interface GameViewController : UIViewController<RoundUpdateDelegate,GridViewDelegate>{
    
    GridModel* _gridModel;
    GridView* _gridView;
    
    UIButton *_bomb;
    UIButton *_move;
}


- (id)initWithGameInfo:(GameInfo*)gI playerId:(NSString *)myid;

-(void) updateRoundForCells:(NSArray *)cells andPlayers:(NSDictionary *)players;

@end
