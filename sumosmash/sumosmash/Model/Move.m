//
//  Moves.m
//  Take2PlaceHolder
//
//  Created by Eric Zhang on 3/10/13.
//
//

#import "Move.h"

static Move* _defaultMove;

@implementation Move

@synthesize TargetId, Type;

+(Move*) GetDefaultMove
{
    if(!_defaultMove)
    {
        _defaultMove = [Move alloc];
        _defaultMove.TargetId = nil;
        _defaultMove.Type = MOVECOUNT;
    }
    
    return _defaultMove;
}

-(id) initWithTarget:(NSString *)target withType:(MoveType)type
{
    if([super init])
    {
        self.TargetId = target;
        self.Type = type;
    }
    
    return self;
}

-(id) initWithDictionary:(NSDictionary *)move
{
    return [self initWithTarget:[move objectForKey:@"target"]
                       withType:(MoveType)[[move objectForKey:@"type"] intValue]];
}

-(NSDictionary*) getMove
{
    return [NSDictionary dictionaryWithObjectsAndKeys:self.TargetId, @"target",
                                                     [NSNumber numberWithInt: self.Type], @"type",
                                                     nil];
}



@end
