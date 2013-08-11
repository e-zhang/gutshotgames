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
#import <Foundation/NSCalendar.h>

#include "Tags.h"

#define degreesToRadians(x) (M_PI * x / 180.0)

#define PLAYER_HEIGHT 120
#define PLAYER_WIDTH 100

#define ARENA_RADIUS 80

enum{
    c1x = 200,
    c1y = 180,
    c2x = 200,
    c2y = 50,
    c3x = 100,
    c3y = 10,
    c4x = 285,
    c4y = 10,
    c5x = 10,
    c5y = 50
} coordinates;

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
    charidtonum = [[NSMutableDictionary alloc]init];
    actions = [[NSMutableDictionary alloc]init];

    NSArray* players = [_game.players allKeys];
    
    CGFloat angleSize = 2*M_PI/[_game.players count];
    
    [self reset];
    for (int i = 0; i < [players count]; ++i)
    {
        int oppnum = 0;
        NSDictionary* player = [_game.players objectForKey:[players objectAtIndex:i]];
        
        CharacterViewController* character = [[CharacterViewController alloc] initWithId: [player objectForKey:DB_USER_ID]
                                                                                    name:[player objectForKey:DB_USER_NAME]
                                                                                  selfId:_myPlayerId
                                                                                delegate:self];
        /*NSString* fbid = [player objectForKey:DB_FB_ID];
        if(fbid)
        {
            NSString *path = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square",
                              fbid];
            
            [character setUserPic:path];
            
        }*/
        
              
        if([[player objectForKey:DB_CONNECTED] boolValue])
        {
            character.Char.isConnected = YES;
            // dont count self, we will do this when we join
            if(![_myPlayerId isEqual:character.Char.Id])
            {
                _gameStarted++;
            }
        }
        
        [self addChildViewController:character];
        
     //   double x = cos(M_PI + angleSize*i)*ARENA_RADIUS + _gamezone.bounds.size.width/2 - 50;
     //   double y = sin(M_PI + angleSize*i)*ARENA_RADIUS + _gamezone.bounds.size.height/2 - 60;
        if([_myPlayerId isEqual:character.Char.Id]){
            character.view.frame = CGRectMake(c1x,c1y,50,100);
            [character setCharacterImage:0];
        }
        else{
            [character setCharacterImage:1];
            if(oppnum==0){
                character.view.frame = CGRectMake(c2x,c2y,50,100);
            }
            if(oppnum==1){
                character.view.frame = CGRectMake(c3x,c3y,50,100);
            }
            if(oppnum==2){
                character.view.frame = CGRectMake(c4x,c4y,50,100);
            }
            if(oppnum==3){
                character.view.frame = CGRectMake(c5x,c5y,50,100);
            }
            oppnum++;
        }
        
        [self.view addSubview:character.view];
        [_characters setObject:character.Char forKey:character.Char.Id];
        
        //animationzone
      /*  UIImageView* one = [[UIImageView alloc] initWithFrame:self.view.frame];
        if (i+1 % 2 && i!=0){
            one.frame = CGRectMake(450,80*(i-1),75,75);
        }
        else{
            one.frame = CGRectMake(50,80*i,75,75);
            one.transform = CGAffineTransformRotate(one.transform, degreesToRadians(180));
        }
        [charidtonum setObject:[NSString stringWithFormat:@"%d",100+i+1] forKey:character.Char.Id];

        one.tag = 100+i+1;
        NSLog(@"player0%d",one.tag);
        one.animationImages = [NSArray arrayWithObjects:
                               [UIImage imageNamed:@"sumo standing.png"],
                               [UIImage imageNamed:@"sumo standing2.png"], nil];
        one.animationDuration = 0.75;
        one.animationRepeatCount = 0;
        [one startAnimating];
        [_animationzone addSubview:one];*/
        
    }

}

- (BOOL) startGame
{
    [_game reset];
    [_game startRound];
    
    _gameInfo.text = @"Game starting....";

    return YES;
}


-(void) restartGame:(UIButton*) sender
{
    [self startGame];
    
    [[self.view viewWithTag:SUBMIT_BUTTON] setHidden:NO];
    UIView* restart = [self.view viewWithTag:RESTART_BUTTON];
    if(restart)
    {
        [restart setHidden:YES];
    }
    
    for(Character* c in [_characters allValues])
    {
        [c reset];
    }
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil gameInfo:(GameInfo*)game myid:(NSString *) myid
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        //animationzone
        _animationzone = [[UIView alloc]initWithFrame:CGRectMake(300,400,600,300)];
     //   _animationzone.backgroundColor = [UIColor yellowColor];
        [self.view addSubview:_animationzone];
        
     //   [self.view addSubview:_gamezone];
        _game = game;
        [_game.gameChat setDelegate:self];
        [_game setDelegate:self];
        
        _selectedMove = [Move GetDefaultMove];
        
        _status = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, 75, 30)];
        _status.font = [UIFont systemFontOfSize:14.0];
        _gameInfo = [[UITextView alloc] initWithFrame:CGRectMake(10, 125, 160, 400)];
        _gameInfo.editable = NO;
        _gameInfo.userInteractionEnabled = YES;
        _gameInfo.scrollEnabled = YES;
        _gameInfo.font = [UIFont systemFontOfSize:9.0];
        
        UIButton* submit = [[UIButton alloc] initWithFrame:CGRectMake(10, 120, 70, 25)];
        [submit setTitle:@"Submit Move" forState:UIControlStateNormal];
        [submit setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        submit.titleLabel.font = [UIFont systemFontOfSize:10.0];
        submit.backgroundColor = [UIColor lightGrayColor];
        submit.layer.borderColor = [[UIColor blackColor] CGColor];
        submit.layer.borderWidth = 1.5;
        submit.showsTouchWhenHighlighted = YES;
        submit.tag = SUBMIT_BUTTON;
        [submit addTarget:self action:@selector(submitMove:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:submit];
        
        if([myid isEqual:_game.hostId])
        {
            UIButton* restart = [[UIButton alloc] initWithFrame:CGRectMake(90,30,70,25)];
            [restart setTitle:@"Restart Game" forState:UIControlStateNormal];
            [restart setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            restart.titleLabel.font = [UIFont systemFontOfSize:10.0];
            restart.backgroundColor = [UIColor lightGrayColor];
            restart.layer.borderColor = [[UIColor blackColor] CGColor];
            restart.layer.borderWidth = 1.5;
            restart.showsTouchWhenHighlighted = YES;
            restart.tag = RESTART_BUTTON;
            [restart addTarget:self action:@selector(restartGame:) forControlEvents:UIControlEventTouchUpInside];
            [restart setHidden:YES];
            [self.view addSubview:restart];
        }
        
        _countdownLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 50, 100, 25)];
        [_countdownLabel setText:@""];
        _countdownLabel.font = [UIFont systemFontOfSize:10.0];
        [self.view addSubview:_countdownLabel];
        
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

        [_game addObserver:self forKeyPath:@"GameRound" options:NSKeyValueObservingOptionNew context:nil];
        
        _gameStarted = 0;
        [self initPlayers];
        _myPlayerName = ((Character*)[_characters objectForKey:_myPlayerId]).Name;
        _status.text = @"Waiting for players...";
        
        BOOL isLast = _gameStarted == ([_game.players count] - 1);
        [_game joinGame:_myPlayerId];
        ++_gameStarted;
        if(isLast)
        {
            [self startGame];
        }
        
        [self.view addSubview:_status];
        [_righthandinfo addSubview:_gameInfo];
        [_game initializeGame];
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

- (void) observeValueForKeyPath:(NSString *)keyPath
                       ofObject:(id)object
                         change:(NSDictionary *)change
                        context:(void *)context
{
    if([keyPath isEqual:@"GameRound"])
    {
        _status.text = [NSString stringWithFormat:@"Round %d", [[change objectForKey:NSKeyValueChangeKindKey] intValue]];
    }
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

- (BOOL) onMoveSubmitted:(Move *)move byPlayer:playerId
{
    Character* player = [_characters objectForKey:playerId];
    BOOL hasMove = [player hasNextMove];
    
    [player UpdateNextMove:move];
    
    return hasMove;
}

- (void) onRoundStart
{
    if(![_game isGameOver]) return;
    
    _countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                       target:self
                                                     selector:@selector(countdown)
                                                     userInfo:nil
                                                    repeats:YES];
}

-(void) countdown
{
    if([_game isGameOver]) return;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"ET"]];
    [dateFormat  setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
    
    NSDate* start = [dateFormat dateFromString:_game.roundStartTime];
    NSTimeInterval cd = [start timeIntervalSinceNow];
    if(cd >= 0)
    {
        _countdownLabel.text = [NSString stringWithFormat:@"Round starting in %d", (int) cd];
    }
    else
    {
        NSDate* end = [NSDate dateWithTimeInterval:[_game.timeInterval intValue] sinceDate:start];
        cd = [end timeIntervalSinceNow];
        if(cd >= 0)
        {
            _countdownLabel.text = [NSString stringWithFormat:@"Round ends in %d", (int)cd];
        }
        else
        {
            [_game endRound];
            [_countdownTimer invalidate];
            _countdownTimer = nil;
        }
    }
}

- (void) onPlayerJoined:(NSString *)playerId
{
    Character* joiner = [_characters objectForKey:playerId];
    
    if(!joiner.IsConnected)
    {
        // not connected, newly joined
        joiner.IsConnected = YES;
    }
}

- (void) onRoundComplete
{
    if ([_game isGameOver]) return;
    
    for( Character* c in [_characters allValues])
    {
        if([MoveStrings[c.NextMove.Type] isEqual:@"Attack"] || [MoveStrings[c.NextMove.Type] isEqual:@"Super Attack"]){
            NSString *recepient;
            for( Character* d in [_characters allValues])
            {
                if ([d.Id isEqualToString:c.NextMove.TargetId]){
                    recepient = d.Name;
                }
            }
            _gameInfo.text = [NSString stringWithFormat:@"%@\n%@", _gameInfo.text,
                              [NSString stringWithFormat:@"%@ used move: %@ to %@", c.Name, MoveStrings[c.NextMove.Type],recepient]];
        }else{
            _gameInfo.text = [NSString stringWithFormat:@"%@\n%@", _gameInfo.text,
                          [NSString stringWithFormat:@"%@ used move: %@", c.Name, MoveStrings[c.NextMove.Type]]];
        }
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
        Character* c = [points objectAtIndex:charIdx];
        [self get5:c.Id];
    }
    
    //defends
    for (NSInteger charIdx=0; charIdx<[defends count]; charIdx++){
        Character* c = [defends objectAtIndex:charIdx];
        [self defend:c.Id];
    }
    
    // animate simultaneous attacks
    for (NSInteger charIdx=0; charIdx<[sameAttacks count]; charIdx++){
        NSArray* attks = [sameAttacks objectAtIndex:charIdx];
      //  [self attack:[attks objectAtIndex:0] to:[attks objectAtIndex:1]];
        
        
        NSMutableDictionary* add = [[NSMutableDictionary alloc] init];
        [add setObject:@"simuattack" forKey:@"move"];
        [add setObject:[attks objectAtIndex:0] forKey:@"a"];
        [add setObject:[attks objectAtIndex:1] forKey:@"b"];
        [actions setObject:add forKey:[NSString stringWithFormat:@"%d",charIdx+1]];
        
    }
    
    // animate normal attacks
    for (NSInteger charIdx=0; charIdx<[attacks count]; charIdx++){
        Character* c = [attacks objectAtIndex:charIdx];
     //   [self normalattack:c.Id to:c.NextMove.TargetId];
        
        
        NSMutableDictionary* add = [[NSMutableDictionary alloc] init];
        [add setObject:@"attack" forKey:@"move"];
        [add setObject:c.Id forKey:@"from"];
        [add setObject:c.NextMove.TargetId forKey:@"to"];
        [actions setObject:add forKey:[NSString stringWithFormat:@"%d",charIdx+1]];
    }
    
    NSLog(@"actions-%@",actions);
    if([actions objectForKey:@"1"]){
        if([[[actions objectForKey:@"1"] objectForKey:@"move"]isEqual:@"attack"]){
            [self attack:[[actions objectForKey:@"1"] objectForKey:@"from"] to:[[actions objectForKey:@"1"] objectForKey:@"to"] movenumber:1];
        }
        if([[actions objectForKey:@"1"] objectForKey:@"simuattack"]){
            [self simulattack:[[actions objectForKey:@"1"] objectForKey:@"a"] to:[[actions objectForKey:@"1"] objectForKey:@"b"] movenumber:1];
        }
    }
    else{
        [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(reset) userInfo:nil repeats:NO];

    }
    
    [self commitRound];
    
    if([_game isGameOver])
    {
        _status.text = @"Game Over";
        [[self.view viewWithTag:SUBMIT_BUTTON] setHidden:YES];
        UIView* restart = [self.view viewWithTag:RESTART_BUTTON];
        if(restart)
        {
            [restart setHidden:NO];
        }
    }
}

-(void)get5:(NSString *)player{
    int playernum = [[charidtonum objectForKey:player] intValue];
    NSLog(@"get5-%d",playernum);
    for (UIImageView *a in [_animationzone subviews]) {
        if(a.tag==playernum){
            NSLog(@"ab-%d",playernum);
            [a stopAnimating];
            a.animationImages = [NSArray arrayWithObjects:
                                 [UIImage imageNamed:@"sumo get 5 points.png"],
                                 nil];
            a.animationDuration = 0;
            a.animationRepeatCount = 0;
            [a startAnimating];
        }
    }
}

-(void)defend:(NSString *)player{
    int playernum = [[charidtonum objectForKey:player] intValue];
    NSLog(@"defendplayer-%d",playernum);

    for (UIImageView *a in [_animationzone subviews]) {
        if(a.tag==playernum){
            NSLog(@"ab-%d",playernum);
            [a stopAnimating];
            a.animationImages = [NSArray arrayWithObjects:
                                 [UIImage imageNamed:@"sumo defend 1.png"],
                                 nil];
            a.animationDuration = 0;
            a.animationRepeatCount = 0;
            [a startAnimating];
        }
    }
}

-(void)attack:(NSString *)player1 to:(NSString *)player2 movenumber:(int)t{
    // sleep(t*10);
    
    int playernum = [[charidtonum objectForKey:player1] intValue];
    NSLog(@"attackplayernum-%d",playernum);
    int playernum1 = [[charidtonum objectForKey:player2] intValue];
    NSLog(@"attackplayernum1-%d",playernum1);

    UIImageView *attacker;
    UIImageView *defender;
    for (UIImageView *a in [_animationzone subviews]) {
        if(a.tag==playernum){
            attacker = a;
        }
        if(a.tag==playernum1){
            defender = a;
        }
    }
    int tpg=0;
    int tpgy=0;
    int org=0;
    int orgy=0;
    int rotation=1;
    int fallrotation=1;
    NSArray* players = [_game.players allKeys];

    NSLog(@"below");
    [attacker stopAnimating];
    
    [UIView animateWithDuration:2 animations:^{
        // animation 1
        attacker.animationImages = [NSArray arrayWithObjects:
                                    [UIImage imageNamed:@"sumo walk 1.png"],
                                    [UIImage imageNamed:@"sumo walk 2.png"],
                                    [UIImage imageNamed:@"sumo walk 3.png"],nil];
        //         attacker.transform = CGAffineTransformMakeRotation(0);
        //         attacker.transform = CGAffineTransformScale(attacker.transform,1, 1);
        //         attacker.transform = CGAffineTransformRotate(attacker.transform, degreesToRadians(-45));
        
        CGRect frame;
        frame= attacker.frame;
        frame.origin.x= tpg;
        frame.origin.y= tpgy;
        attacker.frame=frame;
        attacker.alpha=1.0;
        [attacker startAnimating];
        
    } completion:^(BOOL finished){
        NSLog(@"poop");
        [UIView animateWithDuration:1 animations:^{
            // animation 2
            attacker.animationImages = [NSArray arrayWithObjects:
                                        [UIImage imageNamed:@"sumo attack 1.png"],
                                        [UIImage imageNamed:@"sumo attack 2.png"],
                                        [UIImage imageNamed:@"sumo attack 3.png"],nil];
            //        attacker.transform = CGAffineTransformMakeRotation(rotation);
            //        attacker.transform = CGAffineTransformScale(attacker.transform,.5, .5);
            //        attacker.transform = CGAffineTransformMakeScale(1, 1);
            
            CGRect frame;
            frame= attacker.frame;
            frame.origin.x= tpg-1;
            frame.origin.y= tpgy-1;
            attacker.frame=frame;
            attacker.alpha=1.0;
            [attacker startAnimating];
            [self fall:defender:fallrotation];
        } completion:^(BOOL finished){
            NSLog(@"loop");
            [UIView animateWithDuration:2 animations:^{
                // animation 3
                attacker.animationImages = [NSArray arrayWithObjects:
                                            [UIImage imageNamed:@"sumo walk 1.png"],
                                            [UIImage imageNamed:@"sumo walk 2.png"],
                                            [UIImage imageNamed:@"sumo walk 3.png"],nil];
                //        attacker.transform = CGAffineTransformRotate(attacker.transform, degreesToRadians(225));
                //           attacker.transform = CGAffineTransformMakeRotation(rotation);
                //         attacker.transform = CGAffineTransformScale(attacker.transform,1, 1);
                //          attacker.transform = CGAffineTransformMakeScale(1, 1);
                //          attacker.transform = CGAffineTransformRotate(attacker.transform, degreesToRadians(-45));
                CGRect frame;
                frame= attacker.frame;
                frame.origin.x= org;
                frame.origin.y= orgy;
                attacker.frame=frame;
                attacker.alpha=1.0;
                [attacker startAnimating];
                
            } completion:^(BOOL finished){
                
                if([actions objectForKey:[NSString stringWithFormat:@"%d",t+1]]){
                    if([[[actions objectForKey:[NSString stringWithFormat:@"%d",t+1]] objectForKey:@"move"]isEqual:@"attack"]){
                        [self attack:[[actions objectForKey:[NSString stringWithFormat:@"%d",t+1]] objectForKey:@"from"] to:[[actions objectForKey:[NSString stringWithFormat:@"%d",t+1]] objectForKey:@"to"] movenumber:t+1];
                    }
                    if([[actions objectForKey:[NSString stringWithFormat:@"%d",t+1]] objectForKey:@"simuattack"]){
                        [self simulattack:[[actions objectForKey:[NSString stringWithFormat:@"%d",t+1]] objectForKey:@"a"] to:[[actions objectForKey:[NSString stringWithFormat:@"%d",t+1]] objectForKey:@"b"] movenumber:t+1];
                    }
                }
                else{
                    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(reset) userInfo:nil repeats:NO];
                }
                
            }];
        }];
    }];
}

-(void)simulattack:(NSString *)player1 to:(NSString *)player2 movenumber:(int)t{
   
    int playernum = [[charidtonum objectForKey:player1] intValue];
    NSLog(@"simulattackplayernum-%d",playernum);
    int playernum1 = [[charidtonum objectForKey:player2] intValue];
    NSLog(@"simulattackplayernum1-%d",playernum1);
    
    UIImageView *attacker;
    UIImageView *defender;
    for (UIImageView *a in [_animationzone subviews]) {
        if(a.tag==playernum){
            attacker = a;
        }
        if(a.tag==playernum1){
            defender = a;
        }
    }
    int tpg=0 ,tpgb=0;
    int tpgy=0, tpgyb=0;
    int org=0, orgb=0;
    int orgy=0, orgyb=0;
    int rotation=1, rotationb=1;
    int fallrotation=1, fallrotationb=1;
    NSArray* players = [_game.players allKeys];
    
    [UIView animateWithDuration:2 animations:^{
        // animation 1
        attacker.animationImages = [NSArray arrayWithObjects:
                                    [UIImage imageNamed:@"sumo walk 1.png"],
                                    [UIImage imageNamed:@"sumo walk 2.png"],
                                    [UIImage imageNamed:@"sumo walk 3.png"],nil];
        //         attacker.transform = CGAffineTransformMakeRotation(0);
        //         attacker.transform = CGAffineTransformScale(attacker.transform,1, 1);
        //         attacker.transform = CGAffineTransformRotate(attacker.transform, degreesToRadians(-45));
        
        CGRect frame;
        frame= attacker.frame;
        frame.origin.x= tpg;
        frame.origin.y= tpgy;
        attacker.frame=frame;
        attacker.alpha=1.0;
        [attacker startAnimating];
        
        defender.animationImages = [NSArray arrayWithObjects:
                                    [UIImage imageNamed:@"sumo walk 1.png"],
                                    [UIImage imageNamed:@"sumo walk 2.png"],
                                    [UIImage imageNamed:@"sumo walk 3.png"],nil];
        //         attacker.transform = CGAffineTransformMakeRotation(0);
        //         attacker.transform = CGAffineTransformScale(attacker.transform,1, 1);
        //         attacker.transform = CGAffineTransformRotate(attacker.transform, degreesToRadians(-45));
        
        CGRect frame1;
        frame1= defender.frame;
        frame1.origin.x= tpgb;
        frame1.origin.y= tpgyb;
        defender.frame=frame1;
        defender.alpha=1.0;
        [defender startAnimating];
        
    } completion:^(BOOL finished){
        NSLog(@"poop");
        [UIView animateWithDuration:1 animations:^{
            // animation 2
            attacker.animationImages = [NSArray arrayWithObjects:
                                        [UIImage imageNamed:@"sumo attack 1.png"],
                                        [UIImage imageNamed:@"sumo attack 2.png"],
                                        [UIImage imageNamed:@"sumo attack 3.png"],nil];
            //        attacker.transform = CGAffineTransformMakeRotation(rotation);
            //        attacker.transform = CGAffineTransformScale(attacker.transform,.5, .5);
            //        attacker.transform = CGAffineTransformMakeScale(1, 1);
            
            CGRect frame;
            frame= attacker.frame;
            frame.origin.x= tpg-1;
            frame.origin.y= tpgy-1;
            attacker.frame=frame;
            attacker.alpha=1.0;
            [attacker startAnimating];

            defender.animationImages = [NSArray arrayWithObjects:
                                        [UIImage imageNamed:@"sumo attack 1.png"],
                                        [UIImage imageNamed:@"sumo attack 2.png"],
                                        [UIImage imageNamed:@"sumo attack 3.png"],nil];
            //        attacker.transform = CGAffineTransformMakeRotation(rotation);
            //        attacker.transform = CGAffineTransformScale(attacker.transform,.5, .5);
            //        attacker.transform = CGAffineTransformMakeScale(1, 1);
            
            CGRect frame1;
            frame1= defender.frame;
            frame1.origin.x= tpgb-1;
            frame1.origin.y= tpgyb-1;
            defender.frame=frame;
            defender.alpha=1.0;
            [defender startAnimating];
            
        } completion:^(BOOL finished){
            NSLog(@"loop");
            [UIView animateWithDuration:2 animations:^{
                // animation 3
                attacker.animationImages = [NSArray arrayWithObjects:
                                            [UIImage imageNamed:@"sumo walk 1.png"],
                                            [UIImage imageNamed:@"sumo walk 2.png"],
                                            [UIImage imageNamed:@"sumo walk 3.png"],nil];

                CGRect frame;
                frame= attacker.frame;
                frame.origin.x= org;
                frame.origin.y= orgy;
                attacker.frame=frame;
                attacker.alpha=1.0;
                [attacker startAnimating];
                
                defender.animationImages = [NSArray arrayWithObjects:
                                            [UIImage imageNamed:@"sumo walk 1.png"],
                                            [UIImage imageNamed:@"sumo walk 2.png"],
                                            [UIImage imageNamed:@"sumo walk 3.png"],nil];
                
                CGRect frame1;
                frame1= attacker.frame;
                frame1.origin.x= orgb;
                frame1.origin.y= orgyb;
                defender.frame=frame;
                defender.alpha=1.0;
                [attacker startAnimating];
                
            } completion:^(BOOL finished){
                
                if([actions objectForKey:[NSString stringWithFormat:@"%d",t+1]]){
                    if([[[actions objectForKey:[NSString stringWithFormat:@"%d",t+1]] objectForKey:@"move"]isEqual:@"attack"]){
                        [self attack:[[actions objectForKey:[NSString stringWithFormat:@"%d",t+1]] objectForKey:@"from"] to:[[actions objectForKey:[NSString stringWithFormat:@"%d",t+1]] objectForKey:@"to"] movenumber:t+1];
                    }
                    if([[actions objectForKey:[NSString stringWithFormat:@"%d",t+1]] objectForKey:@"simuattack"]){
                        [self simulattack:[[actions objectForKey:[NSString stringWithFormat:@"%d",t+1]] objectForKey:@"a"] to:[[actions objectForKey:[NSString stringWithFormat:@"%d",t+1]] objectForKey:@"b"] movenumber:t+1];
                    }
                }
                else{
                    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(reset) userInfo:nil repeats:NO];
                }
                
            }];
        }];
    }];
}

-(void)superattack:(NSString *)player1 to:(NSString *)player2 movenumber:(int)t{
    
}

-(void)fall: (UIImageView *) falli :(int)fallrotation{
    
    CGPoint originalCenter = falli.center;
    [UIView animateWithDuration:2.0
                     animations:^{
                         falli.animationImages = [NSArray arrayWithObjects:
                                                  [UIImage imageNamed:@"sumo fall 1.png"],
                                                  [UIImage imageNamed:@"sumo fall 2.png"],nil];
                         
                         falli.animationDuration = 1.5;
                         falli.animationRepeatCount = 0;
                         [falli startAnimating];
                         
                         
                         CGPoint center = falli.center;
                         center.y += 1;
                         falli.center = center;
                     }
                     completion:^(BOOL finished){
                         
                         [UIView animateWithDuration:2.0
                                          animations:^{
                                              falli.animationImages = [NSArray arrayWithObjects:
                                                                       [UIImage imageNamed:@"sumo standing.png"],
                                                                       [UIImage imageNamed:@"sumo standing2.png"], nil];
                                              falli.animationDuration = 0.75;
                                              falli.animationRepeatCount = 0;
                                              [falli startAnimating];
                                              falli.center = originalCenter;
                                          }
                                          completion:^(BOOL finished){
                                              ;
                                          }];
                         
                     }];
}

-(void)reset{
    
    NSLog(@"heyyo");
    
    for (UIImageView *a in [_animationzone subviews]) {
            [a removeFromSuperview];
    }
    
  //  NSLog(@"players-%@",_game.players);
    actions = [[NSMutableDictionary alloc]init];
    NSArray* players = [_game.players allKeys];
    int playnum = [players count];
   /* for (int i = 0; i < [players count]; ++i)
    {        
             
    UIImageView* one = [[UIImageView alloc] initWithFrame:self.view.frame];
    if (i+1 % 2 && i!=0){
        one.frame = CGRectMake(450,80*(i-1),75,75);
    }
    else{
        one.frame = CGRectMake(50,80*(i),75,75);
        one.transform = CGAffineTransformRotate(one.transform, degreesToRadians(180));
    }
    
    one.tag = 100+i+1;
    NSLog(@"player0%d",one.tag);
    one.animationImages = [NSArray arrayWithObjects:
                           [UIImage imageNamed:@"sumo standing.png"],
                           [UIImage imageNamed:@"sumo standing2.png"], nil];
    one.animationDuration = 0.75;
    one.animationRepeatCount = 0;
    [one startAnimating];
    [_animationzone addSubview:one];
    }*/
    
  /*  UITapGestureRecognizer *opptap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(opptapping:)];
    [opptap setNumberOfTapsRequired:1];

    UITapGestureRecognizer *selftap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selftapping:)];
    [selftap setNumberOfTapsRequired:1];
    
    if(playnum==2){
        UIImageView* one = [[UIImageView alloc] initWithFrame:self.view.frame];
        one.frame = CGRectMake(c1x,c1y,50,100);
        one.tag = 101;
        one.image =  [UIImage imageNamed:@"golf wars normal 1.png"];

        [one addGestureRecognizer:selftap];
        [one setUserInteractionEnabled:YES];
        
        [self.view addSubview:one];
        
        UIImageView* two = [[UIImageView alloc] initWithFrame:self.view.frame];
        two.frame = CGRectMake(c2x,c2y,50,100);
        two.tag = 102;
        two.image = [UIImage imageNamed:@"golf wars front swing.png"];
        
        [two addGestureRecognizer:opptap];
        [two setUserInteractionEnabled:YES];
        
        [self.view addSubview:two];
    }
    if(playnum==3){
        UIImageView* one = [[UIImageView alloc] initWithFrame:self.view.frame];
        one.frame = CGRectMake(c1x,c1y,50,100);
        one.tag = 101;
        one.image =  [UIImage imageNamed:@"golf wars normal 1.png"];
        
        [self.view addSubview:one];
        
        UIImageView* two = [[UIImageView alloc] initWithFrame:self.view.frame];
        two.frame = CGRectMake(c2x,c2y,50,100);
        two.tag = 102;
        two.image = [UIImage imageNamed:@"golf wars front swing.png"];
        
        [self.view addSubview:two];
        
        UIImageView* three = [[UIImageView alloc] initWithFrame:self.view.frame];
        three.frame = CGRectMake(c3x,c3y,50,100);
        three.tag = 103;
        three.image = [UIImage imageNamed:@"golf wars front swing.png"];
        
        [self.view addSubview:three];
    }
    if(playnum==4){
        UIImageView* one = [[UIImageView alloc] initWithFrame:self.view.frame];
        one.frame = CGRectMake(c1x,c1y,50,100);
        one.tag = 101;
        one.image =  [UIImage imageNamed:@"golf wars normal 1.png"];
        
        [self.view addSubview:one];
        
        UIImageView* two = [[UIImageView alloc] initWithFrame:self.view.frame];
        two.frame = CGRectMake(c2x,c2y,50,100);
        two.tag = 102;
        two.image = [UIImage imageNamed:@"golf wars front swing.png"];
        
        [self.view addSubview:two];
        
        UIImageView* three = [[UIImageView alloc] initWithFrame:self.view.frame];
        three.frame = CGRectMake(c3x,c3y,50,100);
        three.tag = 103;
        three.image = [UIImage imageNamed:@"golf wars front swing.png"];
        
        [self.view addSubview:three];
        
        UIImageView* four = [[UIImageView alloc] initWithFrame:self.view.frame];
        four.frame = CGRectMake(c4x,c4y,50,100);
        four.tag = 104;
        four.image = [UIImage imageNamed:@"golf wars front swing.png"];
        
        [self.view addSubview:four];
    }
    if(playnum==5){
        UIImageView* one = [[UIImageView alloc] initWithFrame:self.view.frame];
        one.frame = CGRectMake(c1x,c1y,50,100);
        one.tag = 101;
        one.image =  [UIImage imageNamed:@"golf wars normal 1.png"];
        
        [self.view addSubview:one];
        
        UIImageView* two = [[UIImageView alloc] initWithFrame:self.view.frame];
        two.frame = CGRectMake(c2x,c2y,50,100);
        two.tag = 102;
        two.image = [UIImage imageNamed:@"golf wars front swing.png"];
        
        [self.view addSubview:two];
        
        UIImageView* three = [[UIImageView alloc] initWithFrame:self.view.frame];
        three.frame = CGRectMake(c3x,c3y,50,100);
        three.tag = 103;
        three.image = [UIImage imageNamed:@"golf wars front swing.png"];
        
        [self.view addSubview:three];
        
        UIImageView* four = [[UIImageView alloc] initWithFrame:self.view.frame];
        four.frame = CGRectMake(c4x,c4y,50,100);
        four.tag = 104;
        four.image = [UIImage imageNamed:@"golf wars front swing.png"];
        
        [self.view addSubview:four];
        
        UIImageView* five = [[UIImageView alloc] initWithFrame:self.view.frame];
        five.frame = CGRectMake(c5x,c5y,50,100);
        five.tag = 105;
        five.image = [UIImage imageNamed:@"golf wars front swing.png"];
        
        [self.view addSubview:five];
    }
*/
}

-(void)opptapping:(UIGestureRecognizer *)gesture
{
    gesture.view.backgroundColor = [UIColor redColor];
    [self slideup];
}

-(void)selftapping:(UIGestureRecognizer *)gesture
{
    gesture.view.backgroundColor = [UIColor redColor];
    [self slideup];
}

- (void) commitRound
{
    for(Character* c in [_characters allValues])
    {
        NSLog(@"%@",[c CommitUpdates]);
    }
    
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
 //   [self setGamezone:nil];
    [self setChatTable:nil];
    [self setMessageText:nil];
    [self setButtonslider:nil];
    [self setSlideoutleft:nil];
    [self setRighthandinfo:nil];
    [self setRighthandbutton:nil];
 //   [self setRighthandexpand:nil];
    [self setSupera:nil];
    [self setA:nil];
    [self setDefend:nil];
    [self setGet5:nil];
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

- (IBAction)righthandexpand:(id)sender {
    if ([sender isSelected]) {
        [sender setSelected:NO];
        [self slideright];
    }
    else {
        [sender setSelected:YES];
        [self slideleft];
    }
}

- (IBAction)submitmove:(id)sender {
    
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

- (IBAction)superaa:(id)sender {
    _supera.selected = YES;
    [_supera setBackgroundColor:[UIColor redColor]];

    _a.selected = NO;
    [_a setBackgroundColor:NO];

    _defend.selected = NO;
    [_defend setBackgroundColor:NO];
    
    _get5.selected = NO;
    [_get5 setBackgroundColor:NO];
}

- (IBAction)aa:(id)sender {
    _a.selected = YES;
    [_a setBackgroundColor:[UIColor redColor]];
    
    _supera.selected = NO;
    [_supera setBackgroundColor:NO];
    
    _defend.selected = NO;
    [_defend setBackgroundColor:NO];
    
    _get5.selected = NO;
    [_get5 setBackgroundColor:NO];
}

- (IBAction)defenda:(id)sender {
    _defend.selected = YES;
    [_defend setBackgroundColor:[UIColor redColor]];
    
    _supera.selected = NO;
    [_supera setBackgroundColor:NO];
    
    _a.selected = NO;
    [_a setBackgroundColor:NO];
    
    _get5.selected = NO;
    [_get5 setBackgroundColor:NO];
}

- (IBAction)get5a:(id)sender {
    _get5.selected = YES;
    [_get5 setBackgroundColor:[UIColor redColor]];
    
    _supera.selected = NO;
    [_supera setBackgroundColor:NO];
    
    _a.selected = NO;
    [_a setBackgroundColor:NO];
    
    _defend.selected = NO;
    [_defend setBackgroundColor:NO];
}

-(void)slideright{
    NSLog(@"width_%f",self.view.frame.size.width);
    NSTimeInterval animationDuration = 1.0/* determine length of animation */;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];

    _righthandinfo.frame = CGRectMake(self.view.frame.size.height,0, _righthandinfo.bounds.size.width, _righthandinfo.bounds.size.height);
    
    _slideoutleft.frame = CGRectMake(self.view.frame.size.height - _slideoutleft.frame.size.width,0, _slideoutleft.bounds.size.width, _slideoutleft.bounds.size.height);
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView commitAnimations];
    
}

-(void)slideleft{
    NSTimeInterval animationDuration = 1.0/* determine length of animation */;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];

    
    _righthandinfo.frame = CGRectMake(self.view.frame.size.height-_righthandinfo.frame.size.width,0, _righthandinfo.bounds.size.width, _righthandinfo.bounds.size.height);
    
    _slideoutleft.frame = CGRectMake(self.view.frame.size.height-_righthandinfo.frame.size.width-_slideoutleft.frame.size.width,0, _slideoutleft.bounds.size.width, _slideoutleft.bounds.size.height);
    
    [UIView commitAnimations];
        
}

-(void)slideup{
    NSTimeInterval animationDuration = 1.0/* determine length of animation */;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    
    _buttonslider.frame = CGRectMake(0,self.view.frame.size.width - _buttonslider.frame.size.height, _buttonslider.bounds.size.width, _buttonslider.bounds.size.height);
    
    [UIView commitAnimations];
    
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [self sendMessage];
    [textField resignFirstResponder];
    
    return NO;
}

@end
