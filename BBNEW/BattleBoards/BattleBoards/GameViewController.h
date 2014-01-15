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
    
    UIActivityIndicatorView *_activityView;
    
    UIView *_sidePanel;
    UIButton *_submitButton;

    UILabel *_noticeMsg;
    UILabel *_roundInfo;
}

-(id) initWithGameInfo:(GameInfo*)game playerId:(NSString*)playerId;


-(void) updateRoundForCells:(NSArray *)cells andPlayers:(NSDictionary *)players;

@end
