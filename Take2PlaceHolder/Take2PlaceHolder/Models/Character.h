//
//  Character.h
//  Take2PlaceHolder
//
//  Created by Eric Zhang on 2/19/13.
//
//

#import <Foundation/Foundation.h>
#import "Moves.h"
#import "cocos2d.h"

#define REBATE_POINTS 2;

@interface Character : NSObject
{
    NSString* _id;
    
    int _points;
    int _life;
    
    int _pointsUpdate;
    int _lifeUpdate;
    
    Move _nextMove;
    
    CCLabelTTF* _characterDisplay;
    
}

-(id) initWithId:(NSString*) playerId;
-(void) setDisplayLocation:(CGPoint) loc;

-(BOOL) UpdateNextMove:(Move) nextMove;
-(BOOL) IsValidMove:(Move) move;
-(void) RandomizeNextMove:(NSString*) target;

-(BOOL) IsDead;

-(BOOL) OnAttack:(MoveType) move;
-(void) OnRebate;;
-(NSString*) CommitUpdates;

@property (readonly, nonatomic) NSString* Id;
@property (readonly, nonatomic) Move NextMove;
@property (readonly, nonatomic) CCLabelTTF* Display;

@end

