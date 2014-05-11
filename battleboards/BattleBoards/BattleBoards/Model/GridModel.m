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

        
        [self initializePlayer];
    }
    
    return self;
}

-(void) reset
{
    [_gameInfo reset:_myPlayerId];
    [_gameInfo initializeGame];
}

-(void) initializePlayer
{
    NSDictionary* player = _gameInfo.players[_myPlayerId];

    int points = START_POINTS*2;
        
    Player* p = [[Player alloc] initWithProperties:player
                                         andPoints:points];
        
    _players[_myPlayerId] = p;
}

-(BOOL) beginGameAtCoords
{
    NSMutableArray* starts = [NSMutableArray arrayWithCapacity:NUMBER_OF_UNITS];
    for(Unit* unit in self.MyPlayer.Units)
    {
        [starts addObject:[unit.Location arrayFromCoord]];
    }
    
    return [_gameInfo joinGame:_myPlayerId withLocations:starts];
}

-(CoordPoint*) undoLocation:(CoordPoint*) coord
{
    NSArray* loc = [self.MyPlayer removeUnit:coord];
    
    [self movePlayer:[self composePlayerId:_myPlayerId
                                   withTag:[loc[0]intValue]]
                from:loc[1] to:nil];
    
    return loc ? loc[1] : nil;
}


-(BOOL) beginGameAtCoord:(CoordPoint *)coord
{
    if(self.MyPlayer.Units.count == NUMBER_OF_UNITS) return NO;
    
    [self.MyPlayer addUnits:[NSArray arrayWithObject:[coord arrayFromCoord]]];
    
    [self movePlayer:[self composePlayerId:_myPlayerId
                                   withTag:self.MyPlayer.Units.count-1]
                from:coord
                  to:coord];
    return YES;
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
    if(coord.x >= _grid.count || coord.y >= _grid.count) return NO;
    
    CellValue* value = [self getCellWithCoord:coord];
    
    if(value.state == GONE) return NO;
    
    // has a previous move, we need to update
    Player* player = self.MyPlayer;
    Unit* unit = player.SelectedUnit;
    
    BOOL canMove = [player addMove:[self getCellWithCoord:coord]];
    
    if(canMove)
    {
        [self movePlayer:[self composePlayerId:_myPlayerId withTag:unit.GameTag ] from:unit.Location to:unit.Move];
    }
    
    return canMove;
}

-(BOOL) bombPlaced:(CoordPoint *)coord
{
    if(coord.x >= _grid.count || coord.y >= _grid.count) return NO;

    Player* player = _players[_myPlayerId];
    CellValue* value = [self getCellWithCoord:coord];

    if(value.state == GONE || value.state == BOMB) return NO;
    
    BOOL canBomb = [player addBomb:[self getCellWithCoord:coord]];

    if(canBomb)
    {
        value.state = BOMB;
        [value.bombers addObject:_myPlayerId];
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
            cell.moveCost = -1;
            
            int dist = INT_MAX;
            for(Unit* unit in self.MyPlayer.Units)
            {
                if(!unit.Alive) continue;
                dist = MIN(dist, [CoordPoint distanceFrom:unit.Location To:cell.coord]);
            }
            cell.bombCost = dist;
        }
    }
    
    Unit* selected = self.MyPlayer.SelectedUnit;
    
    if(!selected) return;
    
    CoordPoint* loc = selected.Location;
    
    NSMutableArray* cells = [[NSMutableArray alloc] initWithObjects:loc, nil];
    [self getCellWithCoord:loc].moveCost = 0;
    // initialize first set of cells

    while(cells.count > 0)
    {
        CoordPoint* coord = [cells lastObject];
        [cells removeLastObject];
        
        CellValue* cell = [self getCellWithCoord:coord];
        
        if(cell.moveCost >= self.MyPlayer.Points) continue;
        
        for(CoordPoint* n in [coord getSurroundingCoord])
        {
            if(![self isCoordInBounds:n] ) continue;
            CellValue* neighbor = [self getCellWithCoord:n];
            if(neighbor.state == GONE) continue;
            if(neighbor.moveCost < 0 || neighbor.moveCost > cell.moveCost + 1)
            {
                neighbor.moveCost = cell.moveCost + 1;
                [cells addObject:n];
            }

        };
    }
}


-(void) submitForMyPlayer

{
    Player* myP = self.MyPlayer;
 
    [_gameInfo submitUnits:[myP getInfoForDB] andPoints:myP.Points forPlayer:_myPlayerId];
    
    [myP setSelected:-1];
}


-(NSArray*) undoForMyPlayer
{
    Player* myP = self.MyPlayer;
    NSArray* play = [myP undoLastPlay];
    
    if(!play) return nil;
    
    CoordPoint* playCoord = play[COORD_IDX];
    CellValue* cell = [self getCellWithCoord:playCoord];
    CellStates state = [play[STATE_IDX] intValue];
    
    switch(state)
    {
        case OCCUPIED:
        {
            Unit* selected = myP.Units[[play[UNIT_IDX] intValue]];
            NSString* pId = [self composePlayerId:myP.Id withTag:selected.GameTag];
            [self movePlayer:pId from:playCoord to:selected.Location];
            return[NSArray arrayWithObjects:playCoord, selected.Location, nil];
        }
        case BOMB:
        {
            [cell.bombers removeObject:myP.Id];
            if(cell.bombers.count == 0)
            {
                cell.state = cell.occupants.count > 0 ? OCCUPIED : EMPTY;
            }
            return [NSArray arrayWithObject:playCoord];
        }
        default:
            return nil;
    }

}

-(NSArray*) undoBomb:(CoordPoint *)bomb forUnit:(int)unit
{
    Player* myP = self.MyPlayer;
    
    [myP undoBomb:bomb];
    CellValue* cell = [self getCellWithCoord:bomb];
    
    [cell.bombers removeObject:myP.Id];
    if(cell.bombers.count == 0)
    {
        cell.state = cell.occupants.count > 0 ? OCCUPIED : EMPTY;
    }
    return [NSArray arrayWithObject:bomb];
}


-(NSArray*) undoMove:(CoordPoint *)move forUnit:(int)unit
{
    Player* myP = self.MyPlayer;
    
    [myP undoMove:move forUnit:unit];
    Unit* selected = myP.Units[unit];
    NSString* pId = [self composePlayerId:myP.Id withTag:selected.GameTag];
    
    [self movePlayer:pId from:move to:selected.Location];
    return [NSArray arrayWithObjects:move, selected.Location,nil];
}


-(void) updateWithUnits:(NSDictionary*)units
              andPoints:(int)points
              forPlayer:(NSString *)playerId
{
    Player* p = _players[playerId];
    if([p updateWithUnits:units andPoints:points])
    {
        [_delegate onPlayerSubmitted:p.GameId];
    }

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
        int points = START_POINTS*2;

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
    // initialize the rest of the players
    for(Player* player in [_players allValues])
    {
        if(!([player.Id isEqualToString:_myPlayerId] || startGame)) continue;

        for(Unit* unit in player.Units)
        {
            [self movePlayer:[self composePlayerId:player.Id withTag:unit.GameTag]
                        from:unit.Location to:unit.Location];
        }
    }
    if(startGame)
    {
        [_delegate startGame];
    }
    
    return startGame;
}

-(void) onRoundStart
{
    [_delegate onRoundStart:[_gameInfo.currentRound intValue]];
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

        [player addRoundBonus:START_POINTS];
    }
    

    [_delegate updateRoundForCells:[updatedCells allObjects] andPlayers:_players];

}

-(void) movePlayer:(NSString*)name from:(CoordPoint*)src to:(CoordPoint*)dst
{
    NSLog(@"move %@ from %@ - to %@",name, src, dst);
    // update old location
    CellValue* value = [self getCellWithCoord:src];
    
    value.state = value.occupants.count <= 1 ? (value.bombers.count > 0 ? BOMB : EMPTY) : OCCUPIED;
    [value.occupants removeObject:name];

    
    // update new location
    if(dst)
    {
        value = [self getCellWithCoord:dst];
        value.state = OCCUPIED;
        [value.occupants addObject:name];
        NSLog(@"value.occupants-%@",value.occupants);
    }

}


-(NSArray*) checkMoves
{
    NSMutableSet* cells = [[NSMutableSet alloc] init];
    for(Player* p in [_players allValues])
    {
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
        BOOL myP = [p.Id isEqualToString:_myPlayerId];
        for(CoordPoint* bomb in p.Bombs)
        {
            // update old location
            CellValue* value = [self getCellWithCoord:bomb];
            value.state = GONE;
            [cells addObject:bomb];
            
            // we've already updated for the current player
            if(!myP)
            {
                [value.bombers addObject:p.Id];
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
