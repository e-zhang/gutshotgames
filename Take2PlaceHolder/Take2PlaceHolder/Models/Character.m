//
//  Character.m
//  Take2PlaceHolder
//
//  Created by Eric Zhang on 2/19/13.
//
//

#import "Character.h"

@implementation Character

@synthesize Id = _id, NextMove = _nextMove, Display = _characterDisplay;

-(id) initWithId:(NSString *)playerId
{
    _id = playerId;
    
    _life = 5;
    _points = 5;
    _lifeUpdate = 0;
    _pointsUpdate = 0;
    
    _characterDisplay= [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@: Lives-%d Points-%d", _id, _life, _points]
                                          fontName:@"Arial" fontSize:21.0];
    return self;
}

-(id) initWithId:(NSString *) playerId withLife:(int) life withPoints:(int) points
{
    _id = playerId;
    
    _life = life;
    _points = points;
    _lifeUpdate = 0;
    _pointsUpdate = 0;
    
    return self;
}

-(void) setDisplayLocation:(CGPoint)loc
{
    [_characterDisplay setPosition:loc];
}

-(BOOL) UpdateNextMove:(Move)nextMove
{
    BOOL isValid = [self IsValidMove:nextMove];
    
    _nextMove = isValid ? nextMove : DEFAULT_MOVE;
    
    return isValid;
}

-(BOOL) IsValidMove:(Move) move
{
    BOOL isValid = YES;
    if (move.Type == ATTACK || move.Type == SUPERATTACK)
    {
        isValid &= move.TargetId != nil;
    }
    
    isValid &= MovePointValues[move.Type] <= _points;
    
    return isValid;
}

-(void) RandomizeNextMove:(NSString *)target
{
    int nextType;
    do
    {
        nextType = (MoveType) arc4random() % (uint) MOVECOUNT;
    } while (MovePointValues[nextType] > _points);
    
    Move nextMove = {.TargetId = target, .Type= (MoveType) nextType};
    [self UpdateNextMove:nextMove];
}

-(BOOL) IsDead
{
    return _life <= 0;
}

-(BOOL) OnAttack:(MoveType) move
{
    _pointsUpdate = _nextMove.Type == GETPOINTS ? -1 : 0;
    if(!(move == SUPERATTACK && _nextMove.Type == SUPERATTACK))
    {
        _lifeUpdate = MoveDamageValues[move] + (_nextMove.Type == DEFEND);
    }
    
    return _pointsUpdate < 0;
}

-(void) OnRebate
{
    _pointsUpdate = MovePointValues[_nextMove.Type] + REBATE_POINTS;
}

-(NSString*) CommitUpdates
{
    _points -=  _pointsUpdate < 0 ? 0 : MovePointValues[_nextMove.Type] - _pointsUpdate;
    _life += _lifeUpdate;
    
    _pointsUpdate = 0;
    _lifeUpdate = 0;
    
    _characterDisplay.string = [NSString stringWithFormat: @"%@: Lives-%d Points-%d", _id, _life, _points];
    
    return [NSString stringWithFormat:@" %@ used move: %@ \n" , self.Id, MoveStrings[self.NextMove.Type]];
}

@end
