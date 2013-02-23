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
    
    NSString* TargetId;
    MoveType Type;
   
} Move;

typedef struct
{
    
    NSString* SenderId;
    Move SenderMove;
    
} MoveMessage;

static Move DEFAULT_MOVE = {.TargetId = nil, .Type = MOVECOUNT};
