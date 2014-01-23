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
        [_gameInfo setDelegate:self];
        _myPlayerId = player;
        _players = [[NSMutableDictionary alloc] initWithCapacity:game.players.count];
        int size = [_gameInfo.gridSize intValue];
               
        NSMutableArray* grid = [NSMutableArray arrayWithCapacity:size];
        for(int i = 0; i < size; ++i)
        {
            NSMutableArray* row = [NSMutableArray arrayWithCapacity:size];
            for(int j = 0; j < size; ++j)
            {
                CellValue* cell = [[CellValue alloc] initWithCoord:
                                   [CoordPoint coordWithX:i andY:j]];
                [row addObject:cell];
            }
            [grid addObject:row];
        }
        _grid = grid;
        
        _charColors = [NSArray arrayWithObjects:
                       [UIColor blueColor],
                       [UIColor greenColor],
                       [UIColor purpleColor],
                       [UIColor orangeColor],
                       [UIColor brownColor],
                       [UIColor cyanColor],
                       [UIColor yellowColor],
                       [UIColor magentaColor],
                       nil];

    }
    
    return self;
}

-(void) beginGameAtCoord:(CoordPoint *)coord
{
    [_gameInfo initializeGame];
    [_gameInfo joinGame:_myPlayerId withLocation:[coord arrayFromCoord]];
}


-(CellValue*) getCellWithCoord:(CoordPoint *)coord
{
    return _grid[coord.x][coord.y];
}

-(BOOL) isCoordInBounds:(CoordPoint *)coord
{
    return coord.x < self.GridSize && coord.y < self.GridSize &&
           coord.x >= 0 && coord.y >= 0;
}

-(BOOL) playerMoved:(CoordPoint *)coord
{
    Player* player = _players[_myPlayerId];
    
    CellValue* value = [self getCellWithCoord:coord];
    
    if(value.state == GONE) return NO;
    
    // has a previous move, we need to update
    CoordPoint* prev = player.Move;
    
    BOOL canMove = [player addMove:[self getCellWithCoord:coord]];
    
    if(canMove)
    {
        prev = prev ? prev : player.Location;
        [self movePlayer:player.Id from:prev to:player.Move];
    }
    
    return canMove;
}

-(BOOL) bombPlaced:(CoordPoint *)coord
{
    Player* player = _players[_myPlayerId];
    CellValue* value = [self getCellWithCoord:coord];

    if(value.state == GONE || value.state == BOMB) return NO;
    
    BOOL canBomb = [player addBomb:[self getCellWithCoord:coord]];

    if(canBomb)
    {
        value.state = BOMB;
    }
    
    return canBomb;
}

-(void) calculateGridPossibilities
{
    // algorithm: do a breadth first search
    
    //reset all the cells
    for(int row=0; row < self.GridSize; ++row)
    {
        for(int col=0; col < self.GridSize; ++col)
        {
            CellValue* cell = _grid[row][col];
            cell.cost = -1;
        }
    }
    
    CoordPoint* loc = self.MyPlayer.Move ? self.MyPlayer.Move : self.MyPlayer.Location;
    NSMutableArray* cells = [[NSMutableArray alloc] initWithObjects:loc, nil];
    [self getCellWithCoord:loc].cost = 0;
    // initialize first set of cells

    while(cells.count > 0)
    {
        CoordPoint* coord = [cells lastObject];
        [cells removeLastObject];
        
        CellValue* cell = [self getCellWithCoord:coord];
        
        if(cell.cost >= self.MyPlayer.Points) continue;
        
        for(CoordPoint* n in [coord getSurroundingCoord])
        {
            if(![self isCoordInBounds:n] ) continue;
            CellValue* neighbor = [self getCellWithCoord:n];
            if(neighbor.state == GONE) continue;
            if(neighbor.cost <= 0 || neighbor.cost > cell.cost + 1)
            {
                neighbor.cost = cell.cost + 1;
                [cells addObject:n];
            }

        };
    }
}

-(void) submitForMyPlayer

{
    Player* myP = self.MyPlayer;
    NSMutableArray* bombs = [[NSMutableArray alloc] initWithCapacity:myP.Bombs.count];
    for (CoordPoint* b in myP.Bombs) {
        [bombs addObject:[b arrayFromCoord]];
    }
    
    NSArray* move = myP.Move ? [myP.Move arrayFromCoord] : [[NSArray alloc] init];
    
    [_gameInfo submitMove:move Bombs:bombs andPoints:myP.Points forPlayer:_myPlayerId];
}


-(NSArray*) cancelForMyPlayer
{
    Player* myP = self.MyPlayer;
    
    NSMutableArray* updatedCells = [[NSMutableArray alloc] init];
    
    [updatedCells addObject:myP.Location];
    if(myP.Move)
    {
        [updatedCells addObject:myP.Move];
        // undo move
        [self movePlayer:myP.Id from:myP.Move to:myP.Location];
    }
    
    [updatedCells addObjectsFromArray:myP.Bombs];
    
    for(CoordPoint* bomb in myP.Bombs)
    {
        CellValue* value = [self getCellWithCoord:bomb];
        [value.bombers removeObject:myP.Id];
        
        if(value.bombers.count > 0)
        {
            value.state = BOMB;
        }
        else if (value.occupants.count > 0)
        {
            value.state = OCCUPIED;
        }
        else
        {
            value.state = EMPTY;
        }
    }
    
    [myP cancel];
    
    return updatedCells;
}

-(BOOL) onMove:(NSArray *)move Bombs:(NSArray *)bombs andPoints:(int)points forPlayer:(NSString *)player
{
    CoordPoint* moveCoord = nil;
    if(move.count > 0)
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
    
    return [p updateMove:moveCoord Bombs:bombCoords andPoints:points];
}

-(BOOL) onPlayerJoined:(NSDictionary *)player
{
    if(_players.count == _gameInfo.players.count) return NO;

    NSString* userId = player[DB_USER_ID];
    
    Player* p = _players[userId];

    NSLog(@"playerjoined-%@",player);

    BOOL newPlayer = !p && [_gameInfo.players objectForKey:userId];
    
    if( newPlayer )
    {
        NSLog(@"OPJ-INIT");
        int points = START_POINTS + _gameInfo.players.count;
        p = [[Player alloc] initWithProperties:player
                                     withColor:_charColors[_players.count]
                                     withGameId:_players.count
                                     andPoints:points];
        _players[userId] = p;
        
        CellValue* start = [self getCellWithCoord:p.Location];
        [start.occupants addObject:userId];
        start.state = OCCUPIED;
        
        [_delegate initPlayer:p];
    }
    
    
    BOOL startGame = _players.count == _gameInfo.players.count;
    if(startGame)
    {
        [_delegate startGame];
    }
    return startGame;
}

-(void) onRoundStart
{
    [_delegate onRoundStart:_gameInfo.GameRound];
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
    

    for(Player* player in [_players allValues])
    {
        [player reset];
    }
    

    [_delegate updateRoundForCells:[updatedCells allObjects] andPlayers:_players];
}

-(void) movePlayer:(NSString*)name from:(CoordPoint*)src to:(CoordPoint*)dst
{
    NSLog(@"move %@ from %@ - to %@",name, src, dst);
    // update old location
    CellValue* value = [self getCellWithCoord:src];
    
    value.state = value.occupants.count <= 1 ? EMPTY : OCCUPIED;
    [value.occupants removeObject:name];

    
    // update new location
    value = [self getCellWithCoord:dst];
    value.state = OCCUPIED;
    [value.occupants addObject:name];
    NSLog(@"value.occupants-%@",value.occupants);
}


-(NSArray*) checkMoves
{
    NSMutableSet* cells = [[NSMutableSet alloc] init];
    for(Player* p in [_players allValues])
    {
        // we've already updated the current player
        if(p.Id == _myPlayerId || !p.Move) continue;
        
        [self movePlayer:p.Id from:p.Location to:p.Move];
        
        [cells addObject:p.Location];
        [cells addObject:p.Move];
    
    }
    NSLog(@"cells-%@",cells);
    return [cells allObjects];
}

-(NSArray*) checkBombs
{
    NSMutableSet* cells = [[NSMutableSet alloc] init];
    for(Player* p in [_players allValues])
    {
        // we've already updated for the current player
        if(p.Id == _myPlayerId) continue;
        for(CoordPoint* bomb in p.Bombs)
        {
            // update old location
            CellValue* value = [self getCellWithCoord:bomb];
            value.state = GONE;
            [value.bombers addObject:p.Id];
            [cells addObject:bomb];
        }
    }

    // update points to bombers
    for(CoordPoint* cell in cells)
    {
        CellValue* value = [self getCellWithCoord:cell];
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


-(Player*) MyPlayer
{
    return _players[_myPlayerId];
}


-(int) GridSize
{
    return [_gameInfo.gridSize intValue];
}

@end
