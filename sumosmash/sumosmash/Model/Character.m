//
//  Character.m
//  Take2PlaceHolder
//
//  Created by Eric Zhang on 2/19/13.
//
//

#import "Character.h"

@implementation Character

@synthesize NextMove = _nextMove, Name = _name, Id = _id,
            IsConnected = _isConnected, IsTarget=_isTarget, Life=_life, Points = _points;

-(id) initWithId:(NSString *)playerId andName:(NSString *)name
{
    _id = playerId;
    _name = name;
    _isConnected = NO;
    
    [self reset];
    
    return self;
}


-(void) reset
{
    _isTarget = NO;
    
    _life = 10;
    _points = 10;
    _lifeUpdate = 0;
    _pointsUpdate = 0;
}

-(NSString*) getStats
{
    
    return [NSString stringWithFormat:@"%@:\nLives: %d Points: %d\nLast Move: %@", _name, _life, _points,MoveStrings[self.NextMove.Type]];
}


-(BOOL) hasNextMove;
{
    return _nextMove == [Move GetDefaultMove];
}

-(BOOL) UpdateNextMove:(Move*)nextMove
{
    BOOL isValid = [self IsValidMove:nextMove];
    
    _nextMove = isValid ? nextMove : [Move GetDefaultMove];
    
    return isValid;
}

-(BOOL) IsValidMove:(Move*) move
{
    BOOL isValid = move.Type != MOVECOUNT;
    if (move.Type == ATTACK || move.Type == SUPERATTACK)
    {
        isValid &= move.TargetId != nil;
    }
    
    isValid &= MovePointValues[move.Type] <= _points;
    
    return isValid && ![self IsDead];
}

-(Move*) RandomizeNextMove:(NSString *)target
{
    int nextType;
    do
    {
        nextType = (MoveType) arc4random() % (uint) MOVECOUNT;
    } while (MovePointValues[nextType] > _points);
    
    Move* nextMove = [[Move alloc] initWithTarget:target withType:nextType];
    [self UpdateNextMove:nextMove];
    
    return nextMove;
}

-(BOOL) IsDead
{
    return _life <= 0;
}

-(BOOL) OnAttack:(MoveType) move by:(NSString *)attacker
{
    _pointsUpdate = _nextMove.Type == GETPOINTS ? -1 : _pointsUpdate;
    if(!(move == SUPERATTACK && _nextMove.Type == SUPERATTACK && [_nextMove.TargetId isEqual:attacker]))
    {
        _lifeUpdate += MoveDamageValues[move] + (_nextMove.Type == DEFEND);
    }
    
    return _pointsUpdate < 0;
}

-(void) OnRebate
{
    _pointsUpdate = MovePointValues[_nextMove.Type] + REBATE_POINTS;
}

-(NSString*) CommitUpdates
{
    [self willChangeValueForKey:@"Points"];
    _points -=  _pointsUpdate < 0 ? 0 : MovePointValues[_nextMove.Type] - _pointsUpdate;
    [self didChangeValueForKey:@"Points"];
    [self willChangeValueForKey:@"Life"];
    _life = MAX(0, _life + _lifeUpdate);
    [self didChangeValueForKey:@"Life"];
    
    NSString* move = [NSString stringWithFormat:@" %@ used move: %@ \n" , _id, MoveStrings[self.NextMove.Type]];
    
    _nextMove = [Move GetDefaultMove];
    _pointsUpdate = 0;
    _lifeUpdate = 0;
    
    return move;
}

@end
