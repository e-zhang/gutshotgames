//
//  Character.h
//  Take2PlaceHolder
//
//  Created by Eric Zhang on 2/19/13.
//
//

#import <Foundation/Foundation.h>
#import "Move.h"

#define REBATE_POINTS 2;

@interface Character : NSObject
{
    NSString* _id;
    NSString* _name;
    
    BOOL _isConnected;
    
    int _points;
    int _life;
    
    int _pointsUpdate;
    int _lifeUpdate;
    
    Move* _nextMove;
}

-(id) initWithId:(NSString*) playerId andName:(NSString*)name;

- (NSString*) getStats;

-(BOOL) UpdateNextMove:(Move*) nextMove;
-(BOOL) hasNextMove;
-(BOOL) IsValidMove:(Move*) move;
-(Move*) RandomizeNextMove:(NSString*) target;

-(BOOL) IsDead;

-(BOOL) OnAttack:(MoveType) move;
-(void) OnRebate;;
-(NSString*) CommitUpdates;

@property (readonly, nonatomic) Move* NextMove;
@property (readonly, nonatomic) NSString* Name;
@property (readonly, nonatomic) NSString* Id;
@property (nonatomic) BOOL IsConnected;

@end

