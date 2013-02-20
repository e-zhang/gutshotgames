//
//  PlayerMove.h
//  Take2PlaceHolder
//
//  Created by Eric Zhang on 2/19/13.
//
//

#import "MoveType.h"

typedef struct
{
    
    int TargetId;
    MoveType Move;
   
} Move;

typedef struct
{
    
    int SenderId;
    Move SenderMove;
    
} MoveMessage;
