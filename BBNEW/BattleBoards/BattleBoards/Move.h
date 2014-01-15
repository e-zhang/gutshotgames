//
//  PlayerMove.h
//  Take2PlaceHolder
//
//  Created by Eric Zhang on 2/19/13.
//
//


@interface Move : NSObject

@property (copy) NSString* TargetId;
//@property MoveType Type;

+(Move* ) GetDefaultMove;
-(id) initWithDictionary:(NSDictionary*) move;
//-(id) initWithTarget:(NSString *) target withType:(MoveType) type;

-(NSDictionary*) getMove;

@end


