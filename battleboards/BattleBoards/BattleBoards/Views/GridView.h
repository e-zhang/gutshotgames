//
//  GridView.h
//  BattleBoards
//
//  Created by Eric Zhang on 12/7/13.
//  Copyright (c) 2013 GutShotGames. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GridModel.h"

@protocol GridViewDelegate <NSObject>
-(void) onUnitSelected:(int)unit;
-(void) onUndoLocation:(CoordPoint*)loc;
-(void) onUndoMove:(CoordPoint*)move forUnit:(int)unit;
-(void) onUndoBomb:(CoordPoint*)bomb forUnit:(int)unit;
@end

@interface GridView : UIView<UIGestureRecognizerDelegate>
{
    GridModel* _grid;
    CGPoint lastLocation;
    id<GridViewDelegate> _delegate;
}

@property CGPoint startTouchPosition;
@property UIView *dragView;

-(void) updateCell:(CoordPoint*)cell;
-(void) refreshCosts:(BOOL) showMoves;

-(void) startGame;

- (id)initWithFrame:(CGRect)frame gridModel:(GridModel *)grid andDelegate:(id)delegate;

@end
