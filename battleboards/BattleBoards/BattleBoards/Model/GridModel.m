//
//  GridModel.m
//  BattleBoards
//
//  Created by Eric Zhang on 12/7/13.
//  Copyright (c) 2013 GutShotGames. All rights reserved.
//

#import "GridModel.h"
#import "DBDefs.h"

#define START_POINTS 5

@implementation GridModel

@synthesize Players=_players;


-(id) initWithGame:(GameInfo *)game andPlayer:(NSString *)player andDelegate:(id)delegate
{

    if([super init])
    {
        _delegate = delegate;
        _gameInfo = game;
        _myPlayerId = player;
        int size = [_gameInfo.gridSize intValue];
               
        NSMutableArray* grid = [NSMutableArray arrayWithCapacity:size];
        for(int i = 0; i < size; ++i)
        {
            NSMutableArray* row = [NSMutableArray arrayWithCapacity:size];
            for(int i = 0; i < size; ++i)
            {
                CellValue* cell = [[CellValue alloc] init];
                cell.state = EMPTY;
                [row addObject:cell];
            }
            [grid addObject:row];
        }
        _grid = grid;
        
        _charColors = [NSArray arrayWithObjects:
                       [UIColor blueColor],
                       [UIColor yellowColor],
                       [UIColor greenColor],
                       [UIColor purpleColor],
                       [UIColor orangeColor],
                       [UIColor brownColor],
                       [UIColor cyanColor],
                       [UIColor magentaColor],
                       nil];
    }
    
    return self;
}


-(CellValue*) getCellAtRow:(int)row andCol:(int)col
{
    return _grid[row][col];
}

<<<<<<< HEAD
<<<<<<< HEAD
-(void)beginGame{
    NSLog(@"beginGame");
    init = YES;
    _gameStarted = 0;
    [_delegate initplayers:_gameInfo.players];
    
    for(NSString* playerId in _gameInfo.players)
    {
        if(![playerId isEqualToString:_myPlayerId])
        {
            NSDictionary* player = [_gameInfo.players objectForKey:playerId];

            if([[player objectForKey:DB_CONNECTED] boolValue])
                _gameStarted++;
        }
    }
    
    BOOL isLast = _gameStarted == ([_gameInfo.players count] - 1);
    [_gameInfo joinGame:_myPlayerId isLast:isLast];
    [self onPlayerJoined:_myPlayerId];
    
    NSLog(@"beginGame - %d - %d",_gameStarted, [_gameInfo.players count] - 1);
    if(isLast)
    {
        [self startGame];
    }
    
    [_gameInfo initializeGame];

}

-(BOOL) submitForMyPlayer
=======
-(void) submitForMyPlayer
>>>>>>> 9eca385274a4ad10699a6e4ccce5b4b391b163ae
=======
-(void) submitForMyPlayer
>>>>>>> 9eca385274a4ad10699a6e4ccce5b4b391b163ae
{
    Player* myP = [_players objectForKey:_myPlayerId];
    NSMutableArray* bombs = [[NSMutableArray alloc] initWithCapacity:myP.Bombs.count];
    for (CoordPoint* b in myP.Bombs) {
        [bombs addObject:[b arrayFromCoord]];
    }
<<<<<<< HEAD
<<<<<<< HEAD
    NSLog(@"move,%@",myP.Move);
    NSLog(@"player-%@",myP);
    
    NSLog(@"init-%hhd,move-%@",init,myP.Move);
    if(init == YES && myP.Move == nil)
    {
        return NO;
    }
    else
    {
        NSArray* move = myP.Move ? [myP.Move arrayFromCoord] : [myP.Location arrayFromCoord];

        NSLog(@"submit move");
        init = NO;
        
        [_gameInfo submitMove:move andBombs:bombs forPlayer:_myPlayerId];
        return YES;
    }
}

-(void)makeAllInit
{
    NSLog(@"clearCells");
    int size = [_gameInfo.gridSize intValue];

    for(int i = 0; i < size; ++i)
    {
        for(int x = 0; x < size; ++x)
        {
            CellValue* cell = [self getCellAtRow:x andCol:i];
            
            if(cell.state!=INIT)
            {
                NSLog(@"not init");
                cell.state = INIT;
                
                [_delegate refreshCellatRow:x andCol:i];
            }
        }
    }

}


-(void)clearcosts
{
    NSLog(@"clearCells");
    int size = [_gameInfo.gridSize intValue];
    
    for(int i = 0; i < size; ++i)
    {
        for(int x = 0; x < size; ++x)
        {
            CellValue* cell = [self getCellAtRow:x andCol:i];
            cell.bombCost = 0;
            cell.moveCost = 0;
        }
    }
    
}

-(void)initailizePositionatRow:(int)row andCol:(int)col
{
    NSLog(@"initializpos-%d%d",row,col);
    CellValue* cell = [self getCellAtRow:row andCol:col];
    cell.state = OCCUPIED;
    NSLog(@"myplayerid-%@",_myPlayerId);
    Player* myP = _players[_myPlayerId];
    NSLog(@"player-%@",myP);
    [myP setInitialPos:[CoordPoint coordWithX:row andY:col]];
}
=======
    
    NSArray* move = myP.Move ? [myP.Move arrayFromCoord] : nil;
    
    [_gameInfo submitMove:move andBombs:bombs forPlayer:_myPlayerId];
}
=======
    
    NSArray* move = myP.Move ? [myP.Move arrayFromCoord] : nil;
    
    [_gameInfo submitMove:move andBombs:bombs forPlayer:_myPlayerId];
}

>>>>>>> 9eca385274a4ad10699a6e4ccce5b4b391b163ae

>>>>>>> 9eca385274a4ad10699a6e4ccce5b4b391b163ae

-(BOOL) onMove:(NSArray *)move andBombs:(NSArray *)bombs forPlayer:(NSString *)player
{
    CoordPoint* moveCoord = nil;
    if(move)
    {
        moveCoord = [CoordPoint coordWithArray:move];
        
    }
    
    NSMutableArray* bombCoords = [NSMutableArray arrayWithCapacity:bombs.count];
    for(NSArray* b in bombs)
    {
        CoordPoint* bombCoord = [CoordPoint coordWithArray:b];
        [bombCoords addObject:bombCoord];
    }
    
    Player* p = [_players objectForKey:player];
    
    return [p updateMove:moveCoord andBombs:bombCoords];
}

-(BOOL) onPlayerJoined:(NSDictionary *)player
{
<<<<<<< HEAD
<<<<<<< HEAD
    NSLog(@"playerjoined-%@",player);
    Player* p = _players[player];
    NSLog(@"p-%@--%@",p,[_gameInfo.players objectForKey:player]);

    if(!p && [_gameInfo.players objectForKey:player])
=======
=======
>>>>>>> 9eca385274a4ad10699a6e4ccce5b4b391b163ae
    NSString* userId = player[DB_USER_ID];
    
    Player* p = _players[userId];
    
    if(!p)
>>>>>>> 9eca385274a4ad10699a6e4ccce5b4b391b163ae
    {
        NSLog(@"OPJ-INIT");
        int points = START_POINTS + _gameInfo.players.count;
<<<<<<< HEAD
<<<<<<< HEAD
        p = [[Player alloc] initWithProperties:[_gameInfo.players objectForKey:player] andPoints:points];
        _players[player] = p;
        [_delegate playerupdate:player newpoints:points withPlayers:_gameInfo.players];

=======
=======
>>>>>>> 9eca385274a4ad10699a6e4ccce5b4b391b163ae
        p = [[Player alloc] initWithProperties:player
                                     withColor:_charColors[_gameInfo.players.count]
                                     andPoints:points];
        _players[userId] = p;
<<<<<<< HEAD
>>>>>>> 9eca385274a4ad10699a6e4ccce5b4b391b163ae
=======
>>>>>>> 9eca385274a4ad10699a6e4ccce5b4b391b163ae
    }
    NSLog(@"players count-%d, _gameinfo.players count - %d", _players.count, _gameInfo.players.count);
    if(_players.count==_gameInfo.players.count)
        [self startGame];

    return _players.count == _gameInfo.players.count;
}

-(void) onRoundStart
{
<<<<<<< HEAD
<<<<<<< HEAD
    NSLog(@"R STARTS-%d",_gameInfo.GameRound);
    [_delegate startNextRound:_gameInfo.GameRound];
 
}

-(void) onRoundComplete
{
    NSLog(@"R COMPLETE");
    // todo figure out how to check for equality
    NSMutableSet* updatedCells = [[NSMutableSet alloc] init];
    
=======
    
}

-(void) onRoundComplete
{
    // todo figure out how to check for equality
    NSMutableSet* updatedCells = [[NSMutableSet alloc] init];
    
>>>>>>> 9eca385274a4ad10699a6e4ccce5b4b391b163ae
    // update moves
    NSArray* cells = [self checkMoves];
    [updatedCells addObjectsFromArray:cells];
    
    cells = [self checkBombs];
    [updatedCells addObjectsFromArray:cells];
<<<<<<< HEAD
    
    if(_gameInfo.GameRound==0)
    {
        int size = [_gameInfo.gridSize intValue];
        
        for(int a = 0; a < size; ++a)
        {
            for(int b = 0; b < size; ++b)
            {
                CellValue *cell = _grid[a][b];
                
                if(cell.state == INIT)
                {
                    NSLog(@"cellholy-%d%d",a,b);
                    cell.state = EMPTY;
                }
            }
        }
    }
=======
>>>>>>> 9eca385274a4ad10699a6e4ccce5b4b391b163ae
=======
    
}

-(void) onRoundComplete
{
    // todo figure out how to check for equality
    NSMutableSet* updatedCells = [[NSMutableSet alloc] init];
    
    // update moves
    NSArray* cells = [self checkMoves];
    [updatedCells addObjectsFromArray:cells];
    
    cells = [self checkBombs];
    [updatedCells addObjectsFromArray:cells];
>>>>>>> 9eca385274a4ad10699a6e4ccce5b4b391b163ae

    
    for(Player* player in _players)
    {
<<<<<<< HEAD
<<<<<<< HEAD
        Player *player = _players[a];
=======
>>>>>>> 9eca385274a4ad10699a6e4ccce5b4b391b163ae
=======
>>>>>>> 9eca385274a4ad10699a6e4ccce5b4b391b163ae
        [player reset];
        if(_gameInfo.GameRound>0)
        {
            player.Points = player.Points + START_POINTS;
            NSLog(@"new round player point-%d",player.Points);
            [_delegate playerupdate:a newpoints:player.Points withPlayers:_gameInfo.players];

        }
        NSLog(@"resetting player-%@-%@",player.Id,player.Move);
    }
    
    [_delegate updateRoundForCells:[updatedCells allObjects] andPlayers:_players];
}

-(NSArray*) checkMoves
{
    NSMutableSet* cells = [[NSMutableSet alloc] init];
    for(Player* p in _players)
    {
        if(!p.Move) continue;
        NSLog(@"plocation-%@,move-%@",p.Location,p.Move);
        // update old location
        CellValue* value = [self getCellAtRow:p.Location.x andCol:p.Location.y];
        
        value.state = value.occupants.count <= 1 ? EMPTY : OCCUPIED;
        [value.occupants removeObject:p.Id];
        [cells addObject:p.Location];
        
        // update new location
        value = [self getCellAtRow:p.Move.x andCol:p.Move.y];
        value.state = OCCUPIED;
        NSLog(@"this one-%d%d,-%@",p.Move.x,p.Move.y,p.Id);
        //[value.occupants addObject:p.Id];
        [value insertOccupant:p.Id];
        NSLog(@"value.occupants-%@",value.occupants);
        [cells addObject:p.Move];
    
    }
    NSLog(@"cells-%@",cells);
    return [cells allObjects];
}

-(NSArray*) checkBombs
{
    NSMutableSet* cells = [[NSMutableSet alloc] init];
    for(Player* p in _players)
    {
        for(CoordPoint* bomb in p.Bombs)
        {
            // update old location
            CellValue* value = [self getCellAtRow:bomb.x andCol:bomb.y];
            value.state = BOMB;
            [value.bombers addObject:p.Id];
            [cells addObject:bomb];
        }
    }

    // update points to bombers
    for(CoordPoint* cell in cells)
    {
        CellValue* value = [self getCellAtRow:cell.x andCol:cell.y];
        for(NSString* occupantId in value.occupants)
        {
            Player* player = _players[occupantId];
            player.Alive = NO;
            
            for(NSString* bomberId in value.bombers)
            {
                Player* bomber = _players[occupantId];
                [bomber getPointsFromBomb:player.Points/value.bombers.count];
            }
        }
    }
    
    return [cells allObjects];
}

<<<<<<< HEAD
<<<<<<< HEAD
-(void)populateMovePossibilities{
    Player* myP = [_players objectForKey:_myPlayerId];
    int points = myP.Points , cost = 0;
    checkM = 0;
    NSLog(@"points-%d,mylocfeqwation-%d-%d",points,myP.Location.x,myP.Location.y);
    
    [self checkMovePossatCoordPoint:myP.Location cost:cost points:points];
    [_delegate showMovePossibilities];

}

-(void)populateBombPossibilities{
    Player* myP = [_players objectForKey:_myPlayerId];
    int points = myP.Points , cost = 0;
    checkB = 0;
    NSLog(@"populateBombPoss-%d-%d",cost,points);
    [self checkBombPossatCoordPoint:myP.Location cost:cost points:points];
    [_delegate showBombPossibilities];

}

-(void)checkMovePossatCoordPoint:(CoordPoint *)a cost:(int)b points:(int)c{
    
    checkM++;
    BOOL done = YES;
    CellValue *cell = [self getCellAtRow:a.x andCol:a.y];
    
  // NSLog(@"checkMove-%d%d-cost%d,point%d,moveCost%d",a.x,a.y,b,c,cell.moveCost);

    if((!cell.moveCost && cell.state != BOMB) || (b <= cell.moveCost))
    {
   //     NSLog(@"setting");
        cell.moveCost = b;
    }
    else
    {
    //    NSLog(@"already set-%d",checkM--);
        checkM--;
        
        if(checkM==0)
        {
          //  [_delegate showMovePossibilities];
        }
        return;
    }
    
  //  NSLog(@"continueCheck");
    b++; c--;

    if(a.x+1 < [_gameInfo.gridSize intValue])
    {
    //    NSLog(@"left-%d-%d",a.x+1,a.y);
        CoordPoint *newP = [CoordPoint coordWithX:a.x+1 andY:a.y];
        if(c >= 0)
        {
            done = NO;
            [self checkMovePossatCoordPoint:newP cost:b points:c];
        }
    }
    
    if(a.x-1 >= 0)
    {
     //   NSLog(@"right-%d-%d",a.x-1,a.y);
        CoordPoint *newP = [CoordPoint coordWithX:a.x-1 andY:a.y];
        if(c >= 0)
        {
            done = NO;
            [self checkMovePossatCoordPoint:newP cost:b points:c];
        }
    }
    
    if(a.y+1 < [_gameInfo.gridSize intValue])
    {
     //   NSLog(@"up-%d-%d",a.x,a.y+1);
        CoordPoint *newP = [CoordPoint coordWithX:a.x andY:a.y+1];
        if(c >= 0)
        {
            done = NO;
            [self checkMovePossatCoordPoint:newP cost:b points:c];
        }
    }
    
    if(a.y-1 >= 0)
    {
      //  NSLog(@"down-%d-%d",a.x,a.y-1);
        CoordPoint *newP = [CoordPoint coordWithX:a.x andY:a.y-1];
        if(c >= 0)
        {
            done = NO;
            [self checkMovePossatCoordPoint:newP cost:b points:c];
        }
    }
    
    if(done==YES)
        checkM--;
  //  NSLog(@"checkM-%d",checkM);
    if(done==YES && checkM==0)
    {
    //    [_delegate showMovePossibilities];
    }
}

-(void)checkBombPossatCoordPoint:(CoordPoint *)a cost:(int)b points:(int)c{
    
    checkB++;
    BOOL done = YES;
    CellValue *cell = [self getCellAtRow:a.x andCol:a.y];
    
    NSLog(@"checkBomb-%d%d-cost%d,point%d,bombCost%d",a.x,a.y,b,c,cell.bombCost);
    
    if((!cell.bombCost && cell.state != BOMB) || (b <= cell.bombCost))
    {
  //      NSLog(@"setting");
        cell.bombCost = b;
    }
    else
    {
        checkB--;
        NSLog(@"14 checkB-%d",checkB);
        if(checkB==0)
            [_delegate showBombPossibilities];
        return;
    }
    
 //   NSLog(@"continueCheck");
    b++; c--;
    
    if(a.x+1 < [_gameInfo.gridSize intValue])
    {
        CoordPoint *newP = [CoordPoint coordWithX:a.x+1 andY:a.y];
        if(c >= 0)
        {
            done = NO;
            [self checkBombPossatCoordPoint:newP cost:b points:c];
        }
    }
    
    if(a.x-1 >= 0)
    {
        CoordPoint *newP = [CoordPoint coordWithX:a.x-1 andY:a.y];
        if(c >= 0)
        {
            done = NO;
            [self checkBombPossatCoordPoint:newP cost:b points:c];
        }
    }
    
    if(a.y+1 < [_gameInfo.gridSize intValue])
    {
        CoordPoint *newP = [CoordPoint coordWithX:a.x andY:a.y+1];
        if(c >= 0)
        {
            done = NO;
            [self checkBombPossatCoordPoint:newP cost:b points:c];
        }
    }
    
    if(a.y-1 >= 0)
    {
        CoordPoint *newP = [CoordPoint coordWithX:a.x andY:a.y-1];
        if(c >= 0)
        {
            done = NO;
            [self checkBombPossatCoordPoint:newP cost:b points:c];
        }
    }
    
    //if(done==YES)
    checkB--;
    NSLog(@"checkB-%d",checkB);
    if(checkB==0)
    {
        NSLog(@"53146");
        [_delegate showBombPossibilities];
    }
}

-(void)cellTap:(int)row andCol:(int)col{
    
    CoordPoint* cell = [CoordPoint coordWithX:row andY:col];
    CellValue* value = [self getCellAtRow:cell.x andCol:cell.y];
    
    if(movement)
    {
        movement = NO;
        
        Player* myP = [_players objectForKey:_myPlayerId];
        
        if(value.moveCost && !myP.Move && (![myP.Location.arrayFromCoord isEqualToArray:cell.arrayFromCoord]))
        {
            value.state = OCCUPIED;
            
            CellValue* cell1 = [self getCellAtRow:myP.Location.x andCol:myP.Location.y];
            cell1.state = EMPTY;
            NSLog(@"movementmyoldlocation-%d%d",myP.Location.x,myP.Location.y);
            [myP addMove:cell];
            myP.Points = myP.Points - value.moveCost;
            [_delegate updateRoundForCells:[NSArray arrayWithObjects:myP.Location,cell, nil] andPlayers:_players[_myPlayerId] andRound:_gameInfo.GameRound];
            [self clearcosts];
            [self populateBombPossibilities];
        }
    }
    else
    {
        if(value.bombCost)
        {
            if(value.bombCost && value.state!=BOMB && value.state!=GONE)
            {
                Player* myP = [_players objectForKey:_myPlayerId];

                [myP addBomb:cell];
                myP.Points = myP.Points - value.bombCost;
                NSLog(@"newp-%d-%d",myP.Points,value.bombCost);
                value.state = BOMB;

                NSLog(@"sho12312uld?");
                [_delegate updateRoundForCells:[NSArray arrayWithObjects:cell, nil] andPlayers:0 andRound:_gameInfo.GameRound];
                [self clearcosts];
                [self populateBombPossibilities];
                [_delegate showBombPossibilities];

            }
        }
    }

}

-(void)showMovePs{
    NSLog(@"showmoveps");
    [self populateMovePossibilities];
    [_delegate showMovePossibilities];
    movement = YES;
}

-(void)showBombPs{
    [_delegate showBombPossibilities];
=======

-(Player*) MyPlayer
{
    return _players[_myPlayerId];
>>>>>>> 9eca385274a4ad10699a6e4ccce5b4b391b163ae
}

=======

-(Player*) MyPlayer
{
    return _players[_myPlayerId];
}

>>>>>>> 9eca385274a4ad10699a6e4ccce5b4b391b163ae
-(int) GridSize
{
    return [_gameInfo.gridSize intValue];
}

@end
