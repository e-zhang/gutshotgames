//
//  GameView.m
//  sumosmash
//
//  Created by Danny Witters on 10/03/2013.
//  Copyright (c) 2013 gutshotgames. All rights reserved.
//

#import "GameView.h"
#include "DBDefs.h"

#import <CouchCocoa/CouchCocoa.h>
#import <QuartzCore/QuartzCore.h>
#import "Character.h"
#import "MoveMenu.h"

#define degreesToRadians(x) (M_PI * x / 180.0)

#define PLAYER_HEIGHT 120
#define PLAYER_WIDTH 100

#define ARENA_RADIUS 80

#define HEADER_TAG 9
#define MESSAGE_TAG 8

typedef enum{
    twplayer1x = 200,
    twplayer1y = 50,
    twrota = 160,
    twplayer2x = 500,
    twplayer2y = 50,
    twrotb = 0
} twoplayergame;

typedef enum{
    thplayer1x = 200,
    thplayer1y = 125,
    throta = -34,
    thplayer2x = 550,
    thplayer2y = 50,
    throtb = -70,
    thplayer3x = 550,
    thplayer3y = 400,
    throtc = 70,
} threeplayergame;

typedef enum{
    foplayer1x = 200,
    foplayer1y = 50,
    foplayer2x = 500,
    foplayer2y = 50,
} fourplayergame;

@interface GameView ()


@end

NSString * const messageWatermark = @"Send a message...";


@implementation GameView


/*
- (void)countdownUpdateMethod:(NSTimer*)theTimer {
    // code is written so one can see everything that is happening
    // I am sure, some people would combine a few of the lines together
    NSDate *currentDate = [NSDate date];
    NSTimeInterval elaspedTime = [currentDate timeIntervalSinceDate:startTime];
    
    NSTimeInterval difference = countdownSeconds - elaspedTime;
    if (difference <= 0) {
        [theTimer invalidate];  // kill the timer
        difference = 0;         // set to zero just in case iOS fired the timer late
        // play a sound asynchronously if you like
    }
    
    // update the label with the remainding seconds
    countdownLabel.text = [NSString stringWithFormat:@"Seconds: %.1f", difference];
}

- (IBAction)startCountdown {
    NSTimeInterval countdownSeconds = 10;  // Set this to whatever you want
    startTime = [NSDate date];
    
    // update the label
    countdownLabel.text = [NSString stringWithFormat:@"Seconds: %.1f", countdownSeconds];
    
    // create the timer, hold a reference to the timer if we want to cancel ahead of countdown
    // in this example, I don't need it
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector (countdownUpdateMethod:) userInfo:nil repeats:YES];
    
    // couple of points:
    // 1. we have to invalidate the timer if we the view unloads before the end
    // 2. also release the NSDate if don't reach the end
}*/


- (IBAction)returntap:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void) initPlayers
{
    NSLog(@"players-%@",_game.players);
    NSArray* players = [_game.players allKeys];
    
    CGFloat angleSize = 2*M_PI/[_game.players count];
    
    for (int i = 0; i < [players count]; ++i)
    {
        NSDictionary* player = [_game.players objectForKey:[players objectAtIndex:i]];
        
        CharacterViewController* character = [[CharacterViewController alloc] initWithId: [player objectForKey:DB_USER_ID]
                                                                                    name:[player objectForKey:DB_USER_NAME]
                                                                                  selfId:_myPlayerId
                                                                                delegate:self];
        NSString* fbid = [player objectForKey:DB_FB_ID];
        if(fbid)
        {
            NSString *path = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square",
                              fbid];
            
            [character setUserPic:path];
            
        }
        
              
        if([[player objectForKey:DB_CONNECTED] boolValue])
        {
            character.Char.isConnected = YES;
            _gameStarted++;
        }
        
        [self addChildViewController:character];
        
        double x = cos(M_PI + angleSize*i)*ARENA_RADIUS + _gamezone.bounds.size.width/2 - 50;
        double y = sin(M_PI + angleSize*i)*ARENA_RADIUS + _gamezone.bounds.size.height/2 - 60;
        character.view.frame =  CGRectMake(x,
                                           y,
                                           PLAYER_WIDTH,
                                           PLAYER_HEIGHT);
        
        [_gamezone addSubview:character.view];
        [_characters setObject:character.Char forKey:character.Char.Id];
        
        //animationzone
        UIImageView* one = [[UIImageView alloc] initWithFrame:self.view.frame];
        if (i+1 % 2 && i!=0){
            one.frame = CGRectMake(450,50,75,75);
        }
        else{
            one.frame = CGRectMake(50,50,75,75);
            one.transform = CGAffineTransformRotate(one.transform, degreesToRadians(180));
        }
        one.tag = i+1;
        one.animationImages = [NSArray arrayWithObjects:
                               [UIImage imageNamed:@"sumo standing.png"],
                               [UIImage imageNamed:@"sumo standing2.png"], nil];
        one.animationDuration = 0.75;
        one.animationRepeatCount = 0;
        [one startAnimating];
        [_animationzone addSubview:one];
        
    }

}

- (BOOL) startGame
{
    if([_myPlayerId isEqual:_game.hostId])
    {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"ET"]];
        [dateFormat  setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
        
        NSDate *now = [NSDate date]; // Grab current time
        _game.startDate = [dateFormat stringFromDate:now];
    }
    
    _status.text = [NSString stringWithFormat:@"Round: %d",[_game getNextRound:_myPlayerId]];
    _gameInfo.text = @"Game starting....";

    return YES;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil gameInfo:(GameInfo*)game myid:(NSString *) myid
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        //animationzone
        _animationzone = [[UIView alloc]initWithFrame:CGRectMake(300,400,600,300)];
        _animationzone.backgroundColor = [UIColor yellowColor];
        [self.view addSubview:_animationzone];
        
        [self.view addSubview:_gamezone];
        _game = game;
        [_game initializeGame];
        [_game.gameChat setDelegate:self];
        [_game setDelegate:self];
        
        _selectedMove = [Move GetDefaultMove];
        
        _status = [[UILabel alloc] initWithFrame:CGRectMake(90, 0, 75, 30)];
        _status.font = [UIFont systemFontOfSize:14.0];
        _gameInfo = [[UITextView alloc] initWithFrame:CGRectMake(0, 250, 200, 100)];
        _gameInfo.editable = NO;
        _gameInfo.scrollEnabled = YES;
        _gameInfo.font = [UIFont systemFontOfSize:9.0];
        
        UIButton* submit = [[UIButton alloc] initWithFrame:CGRectMake(90, 30, 70, 25)];
        [submit setTitle:@"Submit Move" forState:UIControlStateNormal];
        [submit setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        submit.titleLabel.font = [UIFont systemFontOfSize:10.0];
        submit.backgroundColor = [UIColor lightGrayColor];
        submit.layer.borderColor = [[UIColor blackColor] CGColor];
        submit.layer.borderWidth = 1.5;
        submit.showsTouchWhenHighlighted = YES;
        [submit addTarget:self action:@selector(submitMove:) forControlEvents:UIControlEventTouchUpInside];
        
        NSLog(@"game starting with id %@", _game.gameName);
        _characters = [[NSMutableDictionary alloc] initWithCapacity:[_game.players count]];
        _deadCharacters = [[NSMutableDictionary alloc] initWithCapacity:[_game.players count]];
        
        _messageText.layer.borderWidth = 2;
        _messageText.layer.borderColor = [[UIColor darkGrayColor] CGColor];
        _messageText.text = messageWatermark;
        _messageText.textColor = [UIColor grayColor];
        _messageText.font = [UIFont italicSystemFontOfSize:10.0f];
        
        _chatTable.layer.borderWidth = 2;
        _chatTable.layer.cornerRadius = 8;
        _chatTable.layer.borderColor = [[UIColor blackColor] CGColor];
        _chatTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _myPlayerId = myid;
        // _status = [[UILabel alloc]init];
     /*   if([[gamedata.properties objectForKey:@"player1"]isEqualToString:myid]){
            UIButton *startgame = [UIButton buttonWithType:UIButtonTypeCustom];
            [startgame setFrame:CGRectMake(170,80,100,50)];
            [startgame setTitle:@"Start Game" forState:UIControlStateNormal];
            [startgame setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [startgame addTarget:self action:@selector(initiategame:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.view addSubview:startgame];

        }*/
        
        _gameStarted = 0;
        [self initPlayers];
        _myPlayerName = ((Character*)[_characters objectForKey:_myPlayerId]).Name;
        _status.text = @"Waiting for players...";
        
        if(_gameStarted == [_game.players count])
        {
            [self startGame];
        }
        
        [_gamezone addSubview:_status];
        [_gamezone addSubview:_gameInfo];
        [_gamezone addSubview:submit];
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft || interfaceOrientation==UIInterfaceOrientationLandscapeRight)
        return YES;
    
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    //[NSTimer scheduledTimerWithTimeInterval: 10.0 target: self selector:@selector(checkforgameupdates:) userInfo: nil repeats:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) submitMove:(UIButton*) sender
{
    if(![[_characters objectForKey:_myPlayerId] UpdateNextMove:_selectedMove])
    {
        UIAlertView *myAlert1 = [[UIAlertView alloc]initWithTitle:nil
                                                          message:@"Invalid move selected to submit"
                                                         delegate:self
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [myAlert1 show];
        return;
    }
    [_game submitMove:_selectedMove forPlayer:_myPlayerId];
    Character* c = [_characters objectForKey:_selectedMove.TargetId];
    c.IsTarget = NO;
}

- (BOOL) onMoveSelect:(Move *)move
{
    if(_gameStarted == [_characters count])
    {
        _selectedMove = move;
        return YES;
    }
    return NO;
}

-(void) onPressSelect:(NSString *)playerId
{
    for(Character* c in [_characters allValues])
    {
        c.IsTarget = [c.Id isEqual:playerId];
    }
}

- (void) onMoveSubmitted:(Move *)move byPlayer:playerId
{
    Character* player = [_characters objectForKey:playerId];
    
    [player UpdateNextMove:move];
}

- (void) onPlayerJoined:(NSString *)playerId
{
    Character* joiner = [_characters objectForKey:playerId];
    
    if(!joiner.IsConnected)
    {
        // not connected, newly joined
        joiner.IsConnected = YES;
        
        if(++_gameStarted == [_game.players count])
        {
            [self startGame];
        }
    }

}

- (void) onRoundComplete
{
    if ([_game isGameOver]) return;
    
    for( Character* c in [_characters allValues])
    {
        _gameInfo.text = [NSString stringWithFormat:@"%@\n%@", _gameInfo.text,
                          [NSString stringWithFormat:@"%@ used move: %@", c.Name, MoveStrings[c.NextMove.Type]]];
    }
    //simulate attacks
    NSMutableArray* defends = [[NSMutableArray alloc] init];
    NSMutableArray* points = [[NSMutableArray alloc] init];
    NSMutableArray* sameAttacks = [[NSMutableArray alloc] init];
    NSMutableArray* attacks = [[NSMutableArray alloc] init];
    
    [_game simulateRound:_characters withDefenders:&defends
                                     withPointGetters:&points
                                     withSimultaneousAttackers:&sameAttacks
                                     withAttackers:&attacks];
    
    //get5s
    for (int charIdx=0; charIdx<[points count]; charIdx++){
        [self get5:charIdx+1];
    }
    
    //defends
    for (NSInteger charIdx=0; charIdx<[defends count]; charIdx++){
        [self defend:charIdx+1];
    }
    
    // animate simultaneous attacks
    for (NSInteger charIdx=0; charIdx<[defends count]; charIdx++){
        [self attack:charIdx+1 to:(recepient)];
    }
    
    // animate normal attacks
    for (NSInteger charIdx=0; charIdx<[defends count]; charIdx++){
        [self normalattack:charIdx+1 to:(recepient)];
    }
    
    [self commitRound];
    
    if(![_game isGameOver])
    {
        _status.text = [NSString stringWithFormat:@"Round: %d", [_game getNextRound:_myPlayerId]];
    }
    else
    {
        _status.text = @"Game Over";
    }
}

- (void) commitRound
{
    //commit round updates
    NSMutableArray* deadChars = [[NSMutableArray alloc] init];
    for(Character* c in [_characters allValues])
    {
        if([c IsDead])
        {
            [deadChars  addObject:c];
        }
    }
    
    int charsLeft = [_characters count] - [deadChars count];
    [_game setGameOver: charsLeft <= 1];
    if( charsLeft == 1)
    {
        for(Character* c in [_characters allValues])
        {
            if([deadChars containsObject:c]) continue;
            
            NSLog(@"Game Over...\n Winner is %@", c.Name);
            break;
        }
    }
    else if (charsLeft == 0)
    {
        NSLog(@"Game Over...\n Draw between ");
        for(Character* c in deadChars)
        {
            NSLog(@"%@", c.Name);
        }
    }
    else
    {
        for(Character* c in deadChars)
        {
            NSLog(@"%@ has been killed\n", c.Name);
            [_characters removeObjectForKey:c.Name];
            [_deadCharacters setObject:c forKey:c.Name];
        }
        
    }

}


- (void) sendMessage
{
    [_game sendChat:_messageText.text fromUser:_myPlayerName];
    
    NSArray* paths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:[_game.gameChat.chatHistory count]-1
                                                                 inSection:0]];
    [_chatTable insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationLeft];
    
    _messageText.text = messageWatermark;
    _messageText.textColor = [UIColor grayColor];
    _messageText.font = [UIFont italicSystemFontOfSize:10.0f];
}

- (void) onChatUpdate:(int)count
{
    int numRows = [_chatTable numberOfRowsInSection:0];
    NSMutableArray* paths = [[NSMutableArray alloc] initWithCapacity:count-numRows];
    
    for(int i = numRows; i < count; ++i)
    {
        [paths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    [_chatTable insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationLeft];
}


- (void)viewDidUnload {
    [self setGamezone:nil];
    [self setChatTable:nil];
    [self setMessageText:nil];
    [super viewDidUnload];
}



//UITableViewDelegates
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ChatCellIdentifier";
    
    UILabel *header, *message;
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
        
        header = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 40.0, 40.0)];
        header.tag = HEADER_TAG;
        header.font = [UIFont systemFontOfSize:7.0];
        header.textAlignment = UITextAlignmentRight;
        header.textColor = [UIColor blueColor];
        header.numberOfLines = 2;
        [cell.contentView addSubview:header];
        
        message = [[UILabel alloc] initWithFrame:CGRectMake(45.0, 0.0, 150.0, 40.0)];
        message.tag = MESSAGE_TAG;
        message.font = [UIFont systemFontOfSize:7.0];
        message.textAlignment = UITextAlignmentLeft;
        message.textColor = [UIColor blackColor];
        message.numberOfLines = 2;
        [cell.contentView addSubview:message];
    } else {
        header = (UILabel *) [cell.contentView viewWithTag:HEADER_TAG];
        message = (UILabel *) [cell.contentView viewWithTag:MESSAGE_TAG];
    }
    
        
    NSDateFormatter* format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"hh:mm"];
    NSString* time = [format stringFromDate:[NSDate date]];
    NSArray* chat = [_game.gameChat.chatHistory objectAtIndex:indexPath.row];
    
    header.text = [NSString stringWithFormat:@"[%@] \n%@:",
                           time, [chat objectAtIndex:0]];
    
    message.text = [chat objectAtIndex:1];
    
	return cell;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [_game.gameChat.chatHistory count];
}

// UITextDelegates

- (void) textFieldDidBeginEditing:(UITextField*)textView
{
    if([_messageText.text isEqual:messageWatermark])
    {
        _messageText.text = @"";
        _messageText.textColor = [UIColor blackColor];
        _messageText.font = [UIFont systemFontOfSize:11.0f];
    }
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    if([_messageText.text isEqual:@""])
    {
        _messageText.text = messageWatermark;
        _messageText.textColor = [UIColor grayColor];
        _messageText.font = [UIFont italicSystemFontOfSize:10.0f];
    }
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [self sendMessage];
    [textField resignFirstResponder];
    
    return NO;
}

@end
