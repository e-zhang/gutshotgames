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
#import "CharacterViewController.h"
#import "MoveMenu.h"

#define INITIAL_PLAYER_HEIGHT 100
#define PLAYER_HEIGHT 80

#define HEADER_TAG 0
#define MESSAGE_TAG 1

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
    for (int i = 0; i < [players count]; ++i)
    {
        NSDictionary* player = [_game.players objectForKey:[players objectAtIndex:i]];
        
        CharacterViewController* character = [[CharacterViewController alloc] initWithId: [player objectForKey:DB_USER_ID]
                                                                                    name:[player objectForKey:DB_USER_NAME]
                                                                                  selfId:_myPlayerId
                                                                            onMoveTarget:self onMoveSelect:@selector(submitMove:)];
        NSString* fbid = [player objectForKey:DB_FB_ID];
        if(fbid)
        {
            NSString *path = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square",
                              fbid];
            
            [character setUserPic:path];
            
        }
        
              
        if([player objectForKey:DB_CONNECTED])
        {
            character.Char.isConnected = YES;
            _gameStarted++;
        }
        
        [self addChildViewController:character];
        character.view.frame =  CGRectMake(10,
                                           self.view.frame.size.height - INITIAL_PLAYER_HEIGHT,
                                           75 + i * PLAYER_HEIGHT + 10,
                                           75);
        [_gamezone addSubview:character.view];
        [_characters setObject:character.Char forKey:character.Char.Id];
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
        [_game getNextRound:_myPlayerId];
    }

    return YES;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil gameInfo:(GameInfo*)game myid:(NSString *) myid
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.view addSubview:_gamezone];
        _game = game;
        [_game.gameChat setDelegate:self];
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
        
        if(_gameStarted == [_game.players count])
        {
            [self startGame];
        }
        
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

- (void) submitMove:(Move *)move
{
    [_game submitMove:move forPlayer:_myPlayerId];
}

- (void) onMoveSubmitted:(Move *)move byPlayer:playerId
{
    Character* player = [_characters objectForKey:playerId];
    
    if(![player hasNextMove])
    {
        [player UpdateNextMove:move];
    }
}

- (void) onPlayerJoined:(NSString *)playerId
{
    Character* joiner = [_characters objectForKey:playerId];
    
    if(!joiner.IsConnected)
    {
        // not connected, newly joined
        _gameStarted++;
        joiner.IsConnected = YES;
    }
    
    if(_gameStarted == [_game.players count])
    {
        [self startGame];
    }
}

- (void) onRoundComplete
{
    if ([_game isGameOver]) return;
    
    //simulate attacks
    NSMutableArray* defends = [[NSMutableArray alloc] init];
    NSMutableArray* points = [[NSMutableArray alloc] init];
    NSMutableArray* sameAttacks = [[NSMutableArray alloc] init];
    NSMutableArray* attacks = [[NSMutableArray alloc] init];
    
    [_game simulateRound:_characters withDefenders:&defends
                                     withPointGetters:&points
                                     withSimultaneousAttackers:&sameAttacks
                                     withAttackers:&attacks];
    
    // animate defenders
    
    // animate points
    
    // animate simultaneous attacks
    
    // animate normal attacks
    
    
        
    [self commitRound];
    
    if(![_game isGameOver])
    {
        [_game getNextRound:_myPlayerId];
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
    NSLog(@"%@, %@", _messageText.text, _myPlayerName);
    
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
    [self setStatus:nil];
//    [self setMovearea:nil];
//    [self setSmbutton:nil];
//    [self setTargetPicker:nil];
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
        
        header = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 120.0, 45.0)];
        header.tag = HEADER_TAG;
        header.font = [UIFont systemFontOfSize:11.0];
        header.textAlignment = UITextAlignmentRight;
        header.textColor = [UIColor blueColor];
        header.numberOfLines = 2;
        [cell.contentView addSubview:header];
        
        message = [[UILabel alloc] initWithFrame:CGRectMake(140.0, 0.0, 250.0, 45.0)];
        message.tag = MESSAGE_TAG;
        message.font = [UIFont systemFontOfSize:10.0];
        message.textAlignment = UITextAlignmentLeft;
        message.textColor = [UIColor blackColor];
        message.numberOfLines = 0;
        [cell.contentView addSubview:message];
    } else {
        header = (UILabel *) [cell.contentView viewWithTag:HEADER_TAG];
        message = (UILabel *) [cell.contentView viewWithTag:MESSAGE_TAG];
    }
    
        
    NSDateFormatter* format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd: hh:mm:ss"];
    NSString* time = [format stringFromDate:[NSDate date]];
    NSArray* chat = [_game.gameChat.chatHistory objectAtIndex:indexPath.row];
    NSLog( @"history is %@", _game.gameChat.chatHistory);
    NSLog( @"chat is %d - %@", indexPath.row, chat);
    
    header.text = [NSString stringWithFormat:@"[%@] %@:",
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
