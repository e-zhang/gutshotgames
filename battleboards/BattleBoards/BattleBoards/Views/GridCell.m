//
//  GridCell.m
//  BattleBoards
//
//  Created by Eric Zhang on 12/7/13.
//  Copyright (c) 2013 GutShotGames. All rights reserved.
//

#import "GridCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation GridCell

- (id)initWithFrame:(CGRect)frame andGrid:(GridModel *)grid andCoord:(CoordPoint *)coord
{
    NSLog(@"corez");
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"should be called?");
        // Initialization code
        _grid = grid;
        _cell = coord;
        
        self.backgroundColor = [UIColor greenColor];
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.borderWidth = 1.0f;
        
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    id state = [_grid getStateForRow:_cell.x andCol:_cell.y];
    
    if([state isEmpty])
        [_delegate cellTouched:_cell];
}

-(void) update
{
        CellValue* cell = [_grid getCellAtRow:_cell.x andCol:_cell.y];

    id state = cell.state; 
    NSLog(@"called-%@",state);
    
    NSLog(@"intvalue-%d",[state intValue]);
    switch([state intValue])
    {
	case EMPTY:
	    self.layer.borderColor = [UIColor blackColor].CGColor;
	    self.backgroundColor = [UIColor whiteColor];
	    break;
	case BOMB:
	    self.backgroundColor = [UIColor grayColor];
	    self.layer.borderColor = [UIColor redColor].CGColor;
	    break;
	case GONE:
	    self.backgroundColor = [UIColor blackColor];
	    self.layer.borderColor = [UIColor blackColor].CGColor;
	    break;
	case OCCUPIED:
	    break;
    }
}

-(void) displayMovePossibilities{}

-(void) displayBombPossibilities{}


@end
