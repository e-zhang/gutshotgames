//
//  GridCell.h
//  BattleBoards
//
//  Created by Eric Zhang on 12/7/13.
//  Copyright (c) 2013 GutShotGames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridModel.h"

@interface GridCell : UIView<CellStateDelegate>
{
    GridModel* _grid;
    CoordPoint* _cell;
}


-(id) initWithFrame:(CGRect)frame andGrid:(GridModel*)grid andCoord:(CoordPoint*)coord;


-(void) update;


// todo: determine how we want to do touches
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;

@end
