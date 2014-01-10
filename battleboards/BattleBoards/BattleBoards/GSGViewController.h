//
//  GSGViewController.h
//  BattleBoards
//
//  Created by Eric Zhang on 12/7/13.
//  Copyright (c) 2013 GutShotGames. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GridView.h"
#import "GameInfo.h"

<<<<<<< HEAD
@interface GSGViewController : UIViewController<GameUpdateDelegate,GridViewDelegate>{
    
    GameInfo *_gI;
=======
@interface GSGViewController : UIViewController<GameUpdateDelegate>{
>>>>>>> e8d49ca87bce1673d50e470fc5582460d192bc2e
    GridView *_gridView;
    
    UIButton *_bomb;
    UIButton *_move;
}


- (id)initwithGameData:(GameInfo*)gI myid:(NSString *)myid;

@end
