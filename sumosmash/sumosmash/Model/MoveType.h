//
//  MoveType.h
//  Take2PlaceHolder
//
//  Created by Eric Zhang on 2/19/13.
//
//  Enum for all the possible moves a player can make
//

typedef enum
{
    GETPOINTS = 0,
    DEFEND = 1,
    ATTACK = 2,
    SUPERATTACK = 3,
    GETLIFE = 4,
    
    MOVECOUNT
    
} MoveType;


static NSString* MoveStrings[] = {@"Get Points", @"Defend", @"Attack", @"Super Attack", @"Get Life", @"NO MOVE"};

// to compare against current points for available moves
static int MovePointValues[] = {-5, 0, 1, 3, 0, 0};

static int MoveDamageValues[] = {0, 0, -1, -2, 2, 0};
