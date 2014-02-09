//
//  GridModel.m
//  BattleBoards
//
//  Created by Eric Zhang on 12/7/13.
//  Copyright (c) 2013 GutShotGames. All rights reserved.
//

#import "GridModel.h"

#import "DBDefs.h"
#import "GameDefinitions.h"

@implementation GridModel

@synthesize Players=_players;
@synthesize CharColors=_charColors;


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
                       [UIColor redColor],
                       [UIColor purpleColor],
                       [UIColor orangeColor],
                       [UIColor brownColor],
                       [UIColor cyanColor],
                       [UIColor yellowColor],
                       [UIColor magentaColor],
                       nil];

        [_gameInfo reset:_myPlayerId];
        
        [self initializePlayer];
    }
    
    return self;
}

-(void) initializePlayer
{
    NSDictionary* player = _gameInfo.players[_myPlayerId];

    int points = START_POINTS + _gameInfo.players.count;
        
    Player* p = [[Player alloc] initWithProperties:player
                                         andPoints:points];
        
    _players[_myPlayerId] = p;
}


-(BOOL) beginGameAtCoord:(CoordPoint *)coord
{
    BOOL begin = [_gameInfo joinGame:_myPlayerId
                        withLocation:[coord arrayFromCoord]];
    
    
    
    [self movePlayer:[self composePlayerId:_myPlayerId withTag:begin] from:coord to:coord];
    return begin;
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

    CellValue* value = [self getCellWithCoord:coord];
    
    if(value.state == GONE) return NO;
    
    // has a previous move, we need to update
    Player* player = self.MyPlayer;
    Unit* unit = player.SelectedUnit;
    
    CoordPoint* prev = unit.Move;
    
    BOOL canMove = [player addMove:[self getCellWithCoord:coord]];
    
    if(canMove)
    {
        prev = prev ? prev : unit.Location;
        [self movePlayer:[self composePlayerId:_myPlayerId withTag:unit.GameTag ] from:prev to:unit.Move];
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
        [value.bombers addObject:[self composePlayerId:_myPlayerId
                                               withTag:player.SelectedUnit.GameTag]];
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
    
    Unit* selected = self.MyPlayer.SelectedUnit;
    
    if(!selected) return;
    
    CoordPoint* loc = selected.Location;
    
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
            if(neighbor.cost < 0 || neighbor.cost > cell.cost + 1)
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
 
    [_gameInfo submitUnits:[myP getUnitsForDB] andPoints:myP.Points forPlayer:_myPlayerId];
}


-(NSArray*) undoForMyPlayer
{
    Player* myP = self.MyPlayer;
    CoordPoint* play = [myP undoLastPlay];
    
    if(!play) return nil;
    
    CellValue* cell = [self getCellWithCoord:play];
    NSString* pId = [self composePlayerId:myP.Id withTag:myP.SelectedUnit.GameTag];
    
    if([cell.occupants containsObject:pId])
    {
        [self movePlayer:pId from:play to:myP.SelectedUnit.Location];
        return [NSArray arrayWithObjects:play, myP.SelectedUnit.Location,nil];
    }
    else if([cell.bombers containsObject:pId])
    {
        [cell.bombers removeObject:pId];
        if(cell.bombers.count == 0)
        {
            cell.state = cell.occupants.count > 0 ? OCCUPIED : EMPTY;
        }
        return [NSArray arrayWithObject:play];
    }
    
    return nil;
}


-(void) updateWithUnits:(NSArray *)units andPoints:(int)points forPlayer:(NSString *)playerId
{
    Player* p = _players[playerId];
    [p updateWithUnits:units andPoints:points];
}


-(BOOL) onPlayerJoined:(NSDictionary *)player
{
    BOOL startGame = NO;
    NSString* userId = player[DB_USER_ID];
    
    Player* p = _players[userId];

    NSLog(@"playerjoined-%@",player);

    BOOL newPlayer = !p && _gameInfo.players[userId];
    
    if(newPlayer)
    {
        NSLog(@"OPJ-INIT");
        int points = START_POINTS + _gameInfo.players.count;

        p = [[Player alloc] initWithProperties:player
                                     andPoints:points];

        _players[userId] = p;
        startGame = YES;
    }
    
    if(p.Units.count == 0)
    {
        [p addUnits:player[DB_START_LOC]];

        [_delegate initPlayer:p];
        startGame = YES;
    }

    
    startGame = startGame && _players.count == _gameInfo.players.count &&
                self.MyPlayer.Units.count == NUMBER_OF_UNITS;
    if(startGame)
    {
        // initialize the rest of the players
        for(Player* player in [_players allValues])
        {
            if([player.Id isEqualToString:_myPlayerId]) continue;

            for(Unit* unit in player.Units)
            {
                [self movePlayer:player.Id from:unit.Location to:unit.Location];
            }
        }
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
        for(Unit* unit in player.Units)
        {
            [unit reset];
        }
        
        [player setSelected:-1];
    }
    

    [_delegate updateRoundForCells:[updatedCells allObjects] andPlayers:_players];
    
    for(Player* player in [_players allValues])
    {
        [player addRoundBonus:_players.count];
    }
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
        if([p.Id isEqualToString:_myPlayerId]) continue;
        
        for(Unit* u in p.Units)
        {
            if(!u.Move) continue;

            [self movePlayer:[self composePlayerId:p.Id withTag:u.GameTag]
                        from:u.Location
                          to:u.Move];
            
            [cells addObject:u.Location];
            [cells addObject:u.Move];
        }

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
        if([p.Id isEqualToString:_myPlayerId]) continue;
        
        for(Unit* unit in p.Units)
        {
            for(CoordPoint* bomb in unit.Bombs)
            {
                // update old location
                CellValue* value = [self getCellWithCoord:bomb];
                value.state = GONE;
                [value.bombers addObject:[self composePlayerId:p.Id withTag:unit.GameTag]];
                [cells addObject:bomb];
            }
        }
    }

    // update points to bombers
    for(CoordPoint* cell in cells)
    {
        CellValue* value = [self getCellWithCoord:cell];
        for(NSString* occupantId in value.occupants)
        {
            NSArray* ids = [self decomposePlayerId:occupantId];
            Player* player = _players[ids[0]];
            Unit* unit = player.Units[[ids[1] intValue]];
            unit.Alive = NO;
            
//            for(NSString* bomberId in value.bombers)
//            {
//                Unit* bomber = _players[occupantId];
//                [bomber getPointsFromBomb:player.Points/value.bombers.count];
//            }
        }
    }
    
    return [cells allObjects];
}

-(NSString*) composePlayerId:(NSString *)userid withTag:(int)tag
{
    return[NSString stringWithFormat:@"%@|%d",
                userid,
                tag & UNIT_TAG_MASK];
}

-(NSArray*) decomposePlayerId:(NSString*)composite
{
    return [composite componentsSeparatedByString:@"|"];
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
