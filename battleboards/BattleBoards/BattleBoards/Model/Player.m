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


-(void) updateWithUnits:(NSArray *)units andPoints:(int)points
{
    NSAssert(units.count == _units.count, @"Unequal number of units in update");
    
    _points = points;
    for(int i = 0; i < units.count; ++i)
    {
        Unit* unit = _units[i];
        NSDictionary* unitDB = units[i];
        
        CoordPoint* moveCoord = nil;
        NSArray* move = unitDB[DB_MOVE];
        if(move.count > 0)
        {
            moveCoord = [CoordPoint coordWithArray:move];
        }
        NSArray* bombs = unitDB[DB_BOMBS];
        NSMutableArray* bombCoords = [NSMutableArray arrayWithCapacity:bombs.count];
        for(NSArray* b in bombs)
        {
            CoordPoint* bombCoord = [CoordPoint coordWithArray:b];
            [bombCoords addObject:bombCoord];
        }
        
        [unit updateMove:moveCoord Bombs:bombCoords];
    }
}


-(NSArray*) getUnitsForDB
{
    NSMutableArray* units = [NSMutableArray arrayWithCapacity:_units.count];
    for(Unit* unit in _units)
    {
        NSMutableArray* bombs = [[NSMutableArray alloc] initWithCapacity:unit.Bombs.count];
        for (CoordPoint* b in unit.Bombs)
        {
            [bombs addObject:[b arrayFromCoord]];
        }
        
        NSArray* move = unit.Move ? [unit.Move arrayFromCoord] : [[NSArray alloc] init];
        
        NSDictionary* unitDB = [NSDictionary dictionaryWithObjectsAndKeys:
                               move, DB_MOVE,
                               bombs, DB_BOMBS, nil];
        [units addObject:unitDB];
    }
    
    return units;
}


-(void) addRoundBonus:(int)bonus
{
    [self willChangeValueForKey:@"Points"];
    _points += bonus;
    [self didChangeValueForKey:@"Points"];
    
    [_lastPlays removeAllObjects];
}

-(void) setSelected:(int)selected
{
    _selectedUnit = selected;
}

-(BOOL) getAlive
{
    BOOL unitsAlive = NO;
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
    [_lastPlays removeLastObject];
    
    CellStates state = [last[2] intValue];
    int selected = [last[3] intValue];
    switch(state)
    {
        case OCCUPIED:
            [_units[selected] undoMove:last[0]];
            break;
        case BOMB:
            [_units[selected] undoBomb:last[0]];
            break;
        default:
            NSLog(@"invalid last play state %d", state);
            return nil;
    }
    
    [self willChangeValueForKey:@"Points"];
    _points += [last[1] intValue];
    [self didChangeValueForKey:@"Points"];
    
    return [NSArray arrayWithObjects:last[0], last[3], nil];
}


-(BOOL) addMove:(CellValue *)move
{
    if(![self checkDistance:move]) return NO;
    
    [self.SelectedUnit addMove:move];
    
    [self willChangeValueForKey:@"Points"];
    [_lastPlays addObject:[NSArray arrayWithObjects:
                           move.coord, @(move.cost), @(OCCUPIED), @(_selectedUnit), nil]];
    

    [self didChangeValueForKey:@"Points"];
    return YES;
}

-(BOOL) addBomb:(CellValue *)bomb
{
    if(![self checkDistance:bomb]) return NO;
    
    [self.SelectedUnit addBomb:bomb];
    
    [self willChangeValueForKey:@"Points"];
    [_lastPlays addObject:[NSArray arrayWithObjects:
                           bomb.coord, @(bomb.cost), @(BOMB), @(_selectedUnit),  nil]];
    

    [self didChangeValueForKey:@"Points"];
    return YES;
}


-(BOOL) checkDistance:(CellValue*)dest
{
    if(dest.cost < 0) return NO;

    _points -= dest.cost;

    
    return YES;
}


@end
