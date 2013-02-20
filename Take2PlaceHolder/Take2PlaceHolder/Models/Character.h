//
//  Character.h
//  Take2PlaceHolder
//
//  Created by Eric Zhang on 2/19/13.
//
//

#import <Foundation/Foundation.h>
#import "Moves.h"

@interface Character : NSObject
{
    uint _id;
    
    int _points;
    int _life;
    
    MoveType _nextMove;
    
}

-(void) UpdateNextMove:(Move) move;

@end
