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
    BOOL _isTarget;
    
    int _points;
    int _life;
    
    int _pointsUpdate;
    int _lifeUpdate;
    
    Move* _nextMove;
}

-(id) initWithId:(NSString*) playerId andName:(NSString*)name;

-(void) reset;

- (NSString*) getStats;

-(BOOL) UpdateNextMove:(Move*) nextMove;
-(BOOL) hasNextMove;
-(BOOL) IsValidMove:(Move*) move;
-(Move*) RandomizeNextMove:(NSString*) target;

-(BOOL) IsDead;

-(BOOL) OnAttack:(MoveType) move by:(NSString*)attacker;
-(void) OnRebate;;
-(NSString*) CommitUpdates;

@property (readonly, nonatomic) Move* NextMove;
@property (readonly, nonatomic) NSString* Name;
@property (readonly, nonatomic) NSString* Id;
@property (readonly, nonatomic) int Life;
@property (readonly, nonatomic) int Points;
@property (nonatomic) BOOL IsConnected;
@property (nonatomic) BOOL IsTarget;

@end

