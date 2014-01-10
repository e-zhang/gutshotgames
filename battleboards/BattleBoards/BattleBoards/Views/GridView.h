//
//  GridView.h
//  BattleBoards
//
//  Created by Eric Zhang on 12/7/13.
//  Copyright (c) 2013 GutShotGames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridCell.h"


<<<<<<< HEAD
@interface GridView : UIView<GridCellDelegate>
=======
@interface GridView : UIView
>>>>>>> e8d49ca87bce1673d50e470fc5582460d192bc2e
{
    int _size;
}

-(id) initWithFrame:(CGRect) frame withSize:(int)size andGridModel:(GridModel*)grid;

-(void) updateCell:(CoordPoint*)cell;

@end
