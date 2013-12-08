//
//  GridCell.m
//  BattleBoards
//
//  Created by Eric Zhang on 12/7/13.
//  Copyright (c) 2013 GutShotGames. All rights reserved.
//

#import "GridCell.h"
#import "CellStates.h"

@implementation GridCell

- (id)initWithFrame:(CGRect)frame andGrid:(GridModel *)grid
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _grid = grid;
        [self update];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


-(void) update
{
    if(
}

@end
