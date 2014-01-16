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
        
        [_gameInfo initializeGame];
    }
    
    return self;
}


-(CellValue*) getCellAtRow:(int)row andCol:(int)col
{
    return _grid[row][col];
}


-(void) submitForMyPlayer

{
    Player* myP = [_players objectForKey:_myPlayerId];
    NSMutableArray* bombs = [[NSMutableArray alloc] initWithCapacity:myP.Bombs.count];
    for (CoordPoint* b in myP.Bombs) {
        [bombs addObject:[b arrayFromCoord]];
    }
    
    NSArray* move = myP.Move ? [myP.Move arrayFromCoord] : nil;
    
    [_gameInfo submitMove:move andBombs:bombs forPlayer:_myPlayerId];
}


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

    NSString* userId = player[DB_USER_ID];
    
    Player* p = _players[userId];

    NSLog(@"playerjoined-%@",player);
    
    if(!p && [_gameInfo.players objectForKey:userId])
    {
        NSLog(@"OPJ-INIT");
        int points = START_POINTS + _gameInfo.players.count;
        p = [[Player alloc] initWithProperties:player
                                     withColor:_charColors[_gameInfo.players.count]
                                     withGameId:_gameInfo.players.count
                                     andPoints:points];
        _players[userId] = p;
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
    

    for(Player* player in _players)
    {
        [player reset];
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
        [value.occupants addObject:p.Id];
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


-(Player*) MyPlayer
{
    return _players[_myPlayerId];
}


-(int) GridSize
{
    return [_gameInfo.gridSize intValue];
}

@end
