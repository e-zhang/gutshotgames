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
    
    int _points;
    int _life;
    
    int _pointsUpdate;
    int _lifeUpdate;
    
    Move* _nextMove;
   
    UILabel* _characterDisplay;
    UIImage* _characterPic;
}

-(id) initWithId:(NSString*) playerId;
-(UIImage*) getUserPic:(NSString*) fbId;
-(void) setUserDisplay;

-(BOOL) UpdateNextMove:(Move*) nextMove;
-(BOOL) hasNextMove;
-(BOOL) IsValidMove:(Move*) move;
-(Move*) RandomizeNextMove:(NSString*) target;

-(BOOL) IsDead;

-(BOOL) OnAttack:(MoveType) move;
-(void) OnRebate;;
-(NSString*) CommitUpdates;

@property (readonly, nonatomic) Move* NextMove;
@property (readonly, nonatomic) UILabel* Display;
@property (readonly, nonatomic) NSString* name;

@end

