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

@interface GSGViewController : UIViewController

- (id)initwithGameData:(GameInfo*)gI myid:(NSString *)myid;

@end
