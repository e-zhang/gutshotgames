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
#import "GridModel.h"

@interface GameViewController : UIViewController<RoundUpdateDelegate>
{
    GridView* _gridView;

    GridModel* _gridModel;
}

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
             gameInfo:(GameInfo*)game playerId:(NSString*)playerId;


-(void) updateRoundForCells:(NSArray *)cells andPlayers:(NSDictionary *)players;

@end
