//
//  Character.h
//  Take2PlaceHolder
//
//  Created by Eric Zhang on 2/19/13.
//
//

#import <Foundation/Foundation.h>
#import "MoveType.h"

@interface Character : NSObject
{
    uint _id;
    
    int _points;
    int _life;
    
    MoveType _nextMove;
    
}
@end
