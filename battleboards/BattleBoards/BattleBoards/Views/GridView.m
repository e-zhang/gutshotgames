//
//  GridView.m
//  BattleBoards
//
//  Created by Eric Zhang on 12/7/13.
//  Copyright (c) 2013 GutShotGames. All rights reserved.
//

#import "GridView.h"
#import "GridCell.h"


@implementation GridView

- (id)initWithFrame:(CGRect)frame andGridModel:(GridModel *)grid
{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.tag = -1;
        // Initialization code
        _grid = grid;
        int size = grid.GridSize;
        float width = frame.size.width / size;
        float height = frame.size.height / size;
        for(int r = 0; r < size; ++r)
        {
            for(int c = 0; c < size; ++c)
            {
                GridCell* cell = [[GridCell alloc] initWithFrame:CGRectMake(r*width, c*height, width, height)
                                                         andGrid:grid
                                                        andCoord:[CoordPoint coordWithX:r andY:c]];
                cell.tag = r*size + c;
                cell.userInteractionEnabled = NO;
                [self addSubview:cell];
            }
        }

        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self action:@selector(initLocation:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:tap];
    }
    return self;
}

-(void) updateCell:(CoordPoint *)cell
{
    int tag = cell.x*_grid.GridSize + cell.y;
    GridCell* gridCell = (GridCell*)[self viewWithTag:tag];
    NSLog(@"gridview cellupdate-%@",gridCell);
    [gridCell update];
}

-(void) refreshCosts
{
    for(GridCell* cell in self.subviews)
    {
        [cell showCost];
    }
}

-(void) cellDragged:(UIPanGestureRecognizer*) sender
{
    if([sender state] == UIGestureRecognizerStateEnded)
    {
        
        CGPoint start = [sender locationInView:self];
        CGPoint translation = [sender translationInView:self];
        
        CGPoint point = CGPointMake(start.x + translation.x,
                                    start.y + translation.y);
        
        CoordPoint* coord = [self getCoordAtPoint:point];
        
        [_grid playerMoved:coord];
        
	}
}

-(void) initLocation:(UITapGestureRecognizer*)sender
{
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        CGPoint point = [sender locationInView:self];
        CoordPoint* coord = [self getCoordAtPoint:point];
        
        [_grid beginGameAtCoord:coord];
        
        // reset tap gesture recognizer
        sender.enabled = NO;
        [self removeGestureRecognizer:sender];

        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self action:@selector(cellTapped:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:tap];
        
        
        UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc]
                                       initWithTarget:self action:@selector(cellDragged:)];
        pan.delegate = self;
        pan.minimumNumberOfTouches = 1;
        pan.maximumNumberOfTouches = 2;
        [self addGestureRecognizer:pan];
    }
}

-(void) cellTapped:(UITapGestureRecognizer*)sender
{
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        CGPoint point = [sender locationInView:self];
        CoordPoint* coord = [self getCoordAtPoint:point];
        
        [_grid bombPlaced:coord];
    }
}



-(BOOL) gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if(![gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) return YES;
    CGPoint location = [gestureRecognizer locationInView:self];

    CoordPoint* coord = [self getCoordAtPoint:location];

    return [coord isEqual:_grid.MyPlayer.Location];
}


-(CoordPoint*) getCoordAtPoint:(CGPoint)point
{
    int width = self.frame.size.width / _grid.GridSize;
    int height = self.frame.size.height / _grid.GridSize;
    int x = point.x / width;
    int y = point.y / height;
    
    return [CoordPoint coordWithX:x andY:y];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{ow
    // Drawing code
}
*/

@end
