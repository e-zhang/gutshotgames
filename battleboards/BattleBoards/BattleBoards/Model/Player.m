//
//  Player.m
//  BattleBoards
//
//  Created by Eric Zhang on 1/29/14.
//  Copyright (c) 2014 GutShotGames. All rights reserved.
//

#import "Player.h"
#import "DBDefs.h"

#import "GameDefinitions.h"



@implementation Player

@synthesize Id=_userId;
@synthesize FacebookId=_fbId;
@synthesize Name=_name;
@synthesize GameId=_gameId;
@synthesize Units=_units;
@synthesize Points=_points;
@synthesize Bombs = _bombs;


-(id) initWithProperties:(NSDictionary *)props
               andPoints:(int)points
{
    if([super init])
    {
        _name = props[DB_USER_NAME];
        _userId = props[DB_USER_ID];
        
        _gameId = [props[INGAMEID] intValue];
        
        _units = [NSMutableArray arrayWithCapacity:NUMBER_OF_UNITS];
        _selectedUnit = -1;
        
        _points = points;

        _fbId = props[@"fb_id"];
        
        _lastPlays = [[NSMutableArray alloc] init];
        
        _bombs = [[NSMutableArray alloc] init];
        
        _updated = NO;
    }
    
    return self;
}


-(void) addUnits:(NSArray*)units
{
    for(int i = 0; i < NUMBER_OF_UNITS; ++i)
    {
        int tag = _gameId << 1 | i;
        Unit* unit = [[Unit alloc] initWithStart:[CoordPoint coordWithArray:units[i]]
                                      withGameId:tag];
        [_units addObject:unit];
    }
}


-(BOOL) updateWithUnits:(NSDictionary *)units andPoints:(int)points
{
    if(_updated) return NO;
    
    NSArray* moves = units[DB_MOVE];
    NSAssert(moves.count == _units.count, @"Unequal number of units in update");
    
    for(int i = 0; i < moves.count; ++i)
    {
        Unit* unit = _units[i];
        NSArray* move = moves[i];
        
        CoordPoint* moveCoord = nil;

        if(move.count > 0)
        {
            moveCoord = [CoordPoint coordWithArray:move];
        }

        [unit updateMove:moveCoord];
    }
    
    NSArray* bombs = units[DB_BOMBS];
    for(NSArray* b in bombs)
    {
        CoordPoint* bombCoord = [CoordPoint coordWithArray:b];
        [_bombs addObject:bombCoord];
    }
    
    _points = points;
    
    _updated = YES;
    
    return YES;
}


-(NSDictionary*) getInfoForDB
{
    NSMutableArray* units = [NSMutableArray arrayWithCapacity:_units.count];
    for(Unit* unit in _units)
    {
        NSArray* move = unit.Move ? [unit.Move arrayFromCoord] : [[NSArray alloc] init];

        [units addObject:move];
    }
    
    NSMutableArray* bombs = [[NSMutableArray alloc] initWithCapacity:_bombs.count];
    for (CoordPoint* b in _bombs)
    {
        [bombs addObject:[b arrayFromCoord]];
    }
    
    
    return [NSDictionary dictionaryWithObjectsAndKeys:
                            units, DB_MOVE,
                            bombs, DB_BOMBS, nil];
}


-(void) addRoundBonus:(int)bonus
{
    [self willChangeValueForKey:@"Points"];
    _points += bonus;
    [self didChangeValueForKey:@"Points"];
    
    [_lastPlays removeAllObjects];
    [_bombs removeAllObjects];
    _updated = NO;
}

-(void) setSelected:(int)selected
{
    _selectedUnit = selected;
}

-(BOOL) Alive
{
    BOOL unitsAlive = _units.count == 0;
    for(Unit* unit in _units)
    {
        unitsAlive = unitsAlive || unit.Alive;
    }
    
    return unitsAlive;
}

-(Unit*) SelectedUnit
{
    if(_selectedUnit < 0 || _selectedUnit > _units.count) return nil;
    
    return _units[_selectedUnit];
}


-(NSArray*) undoLastPlay
{
    if(_lastPlays.count == 0) return nil;
    NSArray* last = [_lastPlays lastObject];

    CellStates state = [last[STATE_IDX] intValue];
    switch(state)
    {
        case OCCUPIED:
            [_units[[last[UNIT_IDX] intValue]] undoMove:last[COORD_IDX]];
            [_lastPlays removeLastObject];
            break;
        case BOMB:
            [self undoBomb:last[COORD_IDX]];
            break;
        default:
            NSLog(@"invalid last play state %d", state);
            return nil;
    }
    
    
    return last;
}

-(void) undoMove:(CoordPoint *)move forUnit:(int)unit
{
    for(NSArray* last in _lastPlays)
    {
        if([last[COORD_IDX] isEqual:move])
        {
            [self willChangeValueForKey:@"Points"];
            _points += [last[COST_IDX] intValue];
            [self didChangeValueForKey:@"Points"];
            
            [_units[unit] undoMove:move];
            [_lastPlays removeObject:last];
            break;
        }
    }
}


-(void) undoBomb:(CoordPoint *)bomb
{
    for(NSArray* last in _lastPlays)
    {
        if([last[COORD_IDX] isEqual:bomb])
        {
            [self willChangeValueForKey:@"Points"];
            _points += [last[COST_IDX] intValue];
            [self didChangeValueForKey:@"Points"];
            
            [_bombs removeObject:bomb];
            [_lastPlays removeObject:last];
            break;
        }
    }
}


-(BOOL) addMove:(CellValue *)move
{
    if(![self checkDistance:move forMove:YES]) return NO;
    
    [self.SelectedUnit addMove:move];
    
    [self willChangeValueForKey:@"Points"];
    [_lastPlays addObject:[NSArray arrayWithObjects:
                           move.coord, @(move.moveCost), @(OCCUPIED), @(_selectedUnit), nil]];
    

    [self didChangeValueForKey:@"Points"];
    return YES;
}

-(BOOL) addBomb:(CellValue *)bomb
{
    if(![self checkDistance:bomb forMove:NO]) return NO;
    
    [_bombs addObject:bomb.coord];
    
    [self willChangeValueForKey:@"Points"];
    [_lastPlays addObject:[NSArray arrayWithObjects:
                           bomb.coord, @(bomb.bombCost), @(BOMB),  nil]];
    

    [self didChangeValueForKey:@"Points"];
    return YES;
}


-(BOOL) checkDistance:(CellValue*)dest forMove:(BOOL)move
{
    if(move && dest.moveCost < 0) return NO;
    
    if(!move && dest.bombCost > _points) return NO;
    
    _points -= move ? dest.moveCost : dest.bombCost;

    return YES;
}


@end
