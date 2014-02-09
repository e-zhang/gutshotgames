//
//  GridView.m
//  BattleBoards
//
//  Created by Eric Zhang on 12/7/13.
//  Copyright (c) 2013 GutShotGames. All rights reserved.
//

#import "GridView.h"
#import "GridCell.h"

#import "GameDefinitions.h"


@implementation GridView

- (id)initWithFrame:(CGRect)frame gridModel:(GridModel *)grid andDelegate:(id)delegate
{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.tag = -1;
        // Initialization code
        _grid = grid;
        _delegate = delegate;
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

-(void) refreshCosts:(BOOL) showMoves
{
    if(!showMoves)
    {
        [self.dragView removeFromSuperview];
        self.dragView = nil;
    }

    for(GridCell* cell in self.subviews)
    {
        [cell showCost:showMoves];
    }
}

-(void) cellDragged:(UIPanGestureRecognizer*) sender
{
    //move dragview
    CGPoint point = [sender locationInView:self];
    
    CGRect myFrame = self.dragView.frame;
    myFrame.origin.x = point.x;
    myFrame.origin.y = point.y;
    [self.dragView setFrame:myFrame];
    
    if([sender state] == UIGestureRecognizerStateEnded)
    {
        
        CGPoint point = [sender locationInView:self];
        
        CoordPoint* coord = [self getCoordAtPoint:point];
        
        
        NSLog(@"dragged to (%f,%f) - %@", point.x, point.y, coord);
        
        CoordPoint* move = _grid.MyPlayer.SelectedUnit.Move;
        
        if(![_grid playerMoved:coord])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid move"
                                                            message:@"Cannot move player to that location"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            if(move)
            {
                [self updateCell:move];
            }
            
            [self updateCell:_grid.MyPlayer.SelectedUnit.Location];
            [self updateCell:coord];
        }
        
        [self.dragView removeFromSuperview];
        
	}
}

-(void) initLocation:(UITapGestureRecognizer*)sender
{
    
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        CGPoint point = [sender locationInView:self];
        CoordPoint* coord = [self getCoordAtPoint:point];
        
        NSLog(@"Init at (%f,%f) - %@", point.x, point.y, coord);
        
        if([_grid beginGameAtCoord:coord])
        {
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
        else
        {
            [self updateCell:coord];
        }
    }
}

-(void) cellTapped:(UITapGestureRecognizer*)sender
{
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        CGPoint point = [sender locationInView:self];
        CoordPoint* coord = [self getCoordAtPoint:point];
        
        Player* player = _grid.MyPlayer;
        Unit* selected = player.SelectedUnit;
        
        for(Unit* unit in player.Units)
        {
            if([unit.Location isEqual:coord] && (!selected || selected.GameTag != unit.GameTag))
            {
                [_delegate onUnitSelected:unit.GameTag & UNIT_TAG_MASK];
                return;
            }
        }
        
        if(!selected) return;
        
        if(![_grid bombPlaced:coord])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid bomb"
                                                            message:@"Cannot place bomb at that location"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            [self updateCell:coord];
        }
    }
}

-(BOOL) gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if(![gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) return YES;
    CGPoint location = [gestureRecognizer locationInView:self];

    Unit* selected = _grid.MyPlayer.SelectedUnit;
    
    if(!selected) return NO;
    
    CoordPoint* coord = [self getCoordAtPoint:location];

    BOOL shouldBegin = [coord isEqual:selected.Location];
    
    if(!self.dragView && shouldBegin)
    {
        int size = _grid.GridSize;
        float width = self.frame.size.width / size;
        float height = self.frame.size.height / size;
        
        self.dragView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width, height)];
        self.dragView.layer.cornerRadius = width / 2;
        self.dragView.backgroundColor = [UIColor darkGrayColor];
        [self.dragView setCenter:location];
        
        [self refreshCosts:YES];
        [self addSubview:self.dragView];
    }
    
    return shouldBegin;
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
