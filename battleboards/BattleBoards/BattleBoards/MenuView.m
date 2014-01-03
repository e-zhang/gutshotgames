//
//  MenuView.m
//  sumosmash
//
//  Created by Danny Witters on 10/03/2013.
//  Copyright (c) 2013 gutshotgames. All rights reserved.
//


#import "MenuView.h"
#import <unistd.h>
#import "MBProgressHUD.h"

#import <QuartzCore/QuartzCore.h>

#import "GameInfo.h"
#import "GameInvitations.h"
#include "DBDefs.h"
#include "Tags.h"

#import "InvitationsViewController.h"
#define EXPAND_SIZE 0
#define WINDOW_SIZE 480

@interface MenuView ()

@property (nonatomic, strong)GameViewController *gamewindow;

@end

@interface CustomFriendsTableViewController : FBFriendPickerViewController

@end

@implementation MenuView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _gameServer = [[Server alloc] init];

    }
    return self;
}

- (void)secondViewControllerDismissed:(NSDictionary *)data
{}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:204 green:204 blue:204 alpha:1];
    // Do any additional setup after loading the view from its nib.
       
    [self createAccountLabels];
    
//    _cab.hidden = userType == NONE ? NO : YES;

    _players = [[NSMutableArray alloc] init];
//    [_gameinvitations setContentSize:CGSizeMake(450,1400)];

    
    UIView* inviteView = [self.view viewWithTag:INVITATIONS_VIEW];
    CGRect frame = CGRectMake(inviteView.bounds.origin.x + 5, inviteView.bounds.origin.y + 50,
                              inviteView.bounds.size.width - 10, inviteView.bounds.size.height - 50);
    InvitationsViewController* invites = [[InvitationsViewController alloc]
                                          initWithFrame:frame
                                          invitations:_gameServer.gameInvitations
                                          target:self
                                          selector:@selector(gotogame:)];
    [self addChildViewController:invites];
    [inviteView addSubview:invites.view];
    
    UICollectionView* collection = (UICollectionView*)[self.view viewWithTag:SAVED_GAMES];
    
    [collection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"game_cell"];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft || interfaceOrientation==UIInterfaceOrientationLandscapeRight)
        return YES;
    
    return NO;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) createAccountLabels
{
    NSString* username; NSString* userId; NSData* userPic;
    UserType userType = [_gameServer.user GetUserName:&username Pic:&userPic Id:&userId];
    
    UIView* view = [self.view viewWithTag:PLAYER_VIEW];
    [view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    switch (userType)
    {
        case FACEBOOK:
        {
            UIImageView *myImageView = [[UIImageView alloc] init];
            
            UILabel* label1 = [[UILabel alloc] init];
            label1.textColor = [UIColor darkGrayColor];
            label1.backgroundColor = [UIColor clearColor];
            
            myImageView.image = [[UIImage alloc]initWithData:userPic];
            label1.text = username;
            
            myImageView.frame = CGRectMake(10,15,35,35);
            label1.frame = CGRectMake(55,15,100,40);
            label1.font = [UIFont fontWithName:@"GillSans" size:16.0f];
            [view addSubview:myImageView];
            [view addSubview:label1];
            break;
        }
        case GSG:
        {
            UILabel* label1 = [[UILabel alloc] init];
            label1.textColor = [UIColor darkGrayColor];
            label1.backgroundColor = [UIColor clearColor];
            label1.text = username;
            label1.frame = CGRectMake(85,self.view.frame.size.height-40,400,40);
            label1.font = [UIFont fontWithName:@"GillSans" size:24.0f];
            [view addSubview:label1];
            break;
        }
        case NONE:
        {
            UIButton* login = [[UIButton alloc] initWithFrame:CGRectMake(20, 40, 150, 40)];
            [login setTitle:@"Log In" forState:UIControlStateNormal];
            [login addTarget:self action:@selector(createviafb:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:login];
            break;
        }
    }
    
}

- (void)updateView1 {
    // get the app delegate, so that we can reference the session property
    
    //AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    
    if (FBSession.activeSession.isOpen) {
        // valid account UI is shown whenever the session is open
        NSLog(@"wjt");
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
             
             //createaccount
//             NSDictionary *inDocument = [NSDictionary dictionaryWithObjectsAndKeys:
//                                         @"createaccount", @"action",
//                                         @"fb",@"type",
//                                         user.id,@"fb_id",
//                                         user.name,@"fb_name",
//                                         [user objectForKey:@"email"],@"email",
//                                         nil];
//             
//             MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//             hud.labelText = @"Creating Account";
//             dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
//             dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//                 [MBProgressHUD hideHUDForView:self.view animated:YES];
//             });
             
             [self SaveAccountInfo:user];
             
              NSLog(@"hello");
             [self createAccountLabels];
         }];
    }
    
}

-(void)openfb{
    if (!FBSession.activeSession.isOpen) {
        FBSession *session =
        [[FBSession alloc] initWithAppID:nil
                             permissions:nil
                         urlSchemeSuffix:nil
                      tokenCacheStrategy:nil];
        
        [FBSession setActiveSession:session];
        [session openWithBehavior:FBSessionLoginBehaviorUseSystemAccountIfPresent
                completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             [self openfb1];
         }];
    }
    
    else if (FBSession.activeSession.isOpen) {
        [self openfb1];
    }
}

-(void)openfb1{
    [self dismissModalViewControllerAnimated:NO];
    
    /*if (nil == self.facebook) {
        self.facebook = [[Facebook alloc]
                         initWithAppId:FBSession.activeSession.appID
                         andDelegate:nil];
        
        // Store the Facebook session information
        self.facebook.accessToken = FBSession.activeSession.accessToken;
        self.facebook.expirationDate = FBSession.activeSession.expirationDate;
    }
    
    if (self.friendPickerController == nil) {
        // Create friend picker, and get data loaded into it.
        self.friendPickerController = [[FBFriendPickerViewController alloc] init];
        self.friendPickerController.title = @"Select a Friend";
        self.friendPickerController.delegate = self;
        self.friendPickerController.allowsMultipleSelection = YES;
    }
    
    NSSet *fields = [NSSet setWithObjects:@"installed", nil];
    self.friendPickerController.fieldsForRequest = fields;
    [self.friendPickerController loadData];
    
    [self presentViewController:self.friendPickerController animated:YES completion:nil];

    CGFloat searchBarHeight = 44.0;
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,searchBarHeight)];
    self.searchBar.autoresizingMask = self.searchBar.autoresizingMask |
    UIViewAutoresizingFlexibleWidth;
    self.searchBar.delegate = self;
    self.searchBar.showsCancelButton = YES;
    
    [self.friendPickerController.canvasView addSubview:self.searchBar];
    */
    UIView *bottombar = [[UIView alloc]init];
    bottombar.backgroundColor = [UIColor darkGrayColor];
    
    UIButton *library = [[UIButton alloc] init];
    [library setTitle:@"Sumo Friends" forState:UIControlStateNormal];
    [library addTarget:self action:@selector(friendsselective) forControlEvents:UIControlEventTouchUpInside];
    library.backgroundColor = [UIColor clearColor];
    
    UIButton *web = [[UIButton alloc] init];
    [web setTitle:@"Invite Friends" forState:UIControlStateNormal];
    [web addTarget:self action:@selector(allfriends) forControlEvents:UIControlEventTouchUpInside];
    web.backgroundColor = [UIColor clearColor];
    
    [bottombar addSubview:library];
    [bottombar addSubview:web];
    
    [self.friendPickerController.canvasView addSubview:bottombar];
    
    CGRect newFrame = self.friendPickerController.view.bounds;
   // newFrame.size.height -= searchBarHeight;
   // newFrame.origin.y = searchBarHeight;
    self.friendPickerController.canvasView.backgroundColor =  [UIColor blackColor];
    
        library.frame = CGRectMake(0, 0, 180, 55);
        library.titleLabel.font = [UIFont fontWithName:@"GillSans" size:20.0f];
        web.titleLabel.font = [UIFont fontWithName:@"GillSans" size:20.0f];
        bottombar.frame = CGRectMake(0,self.friendPickerController.canvasView.frame.size.height-55,self.view.frame.size.width,55);
        web.frame = CGRectMake(self.friendPickerController.canvasView.frame.size.width-180, 0, 180, 55);
  }

- (IBAction)createaccsubmit:(id)sender {
    
  
    [self SaveAccountInfo:nil];

}

- (void) SaveAccountInfo:(NSDictionary<FBGraphUser> *)fbUser
{
    CFUUIDRef uuidObject = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidStr1 = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuidObject);
    CFRelease(uuidObject);
    UserAccount* serverAccount = [_gameServer GetUser:uuidStr1];
    UserAccount* userAccount = _gameServer.user;
    
    serverAccount.userid = uuidStr1;
    userAccount.userid = uuidStr1;
    
    RESTOperation *op, *op1;
    
    if(fbUser)
    {
        serverAccount.fb_id = fbUser.id;
        serverAccount.fb_name = fbUser.name;
        
        op = [serverAccount save];
        
        userAccount.fb_id = fbUser.id;
        userAccount.fb_name = fbUser.name;
        
        op1 = [userAccount save];
    
    }
    else
    {
//        userAccount.password = @"";
//        userAccount.username = _accountusername.text;
//        userAccount.email = _accountemail.text;
//        
//        op = [userAccount save];
//        
//        serverAccount.password = @"";
//        serverAccount.username = _accountusername.text;
//        serverAccount.email = _accountemail.text;
        
        op1 = [serverAccount save];
    }
    
//    CouchDocument *doc2 = [self.serverupdate documentWithID:uuidStr1];
//    
//    NSDictionary *inDocument2 = [NSDictionary dictionaryWithObjectsAndKeys:
//                                 @"",@"update",
//                                 @"",@"gamerequests",
//                                 nil];
//    
//    op4 = [doc2 putProperties: inDocument2];
    
    BOOL err, err1;
    err = [op wait]; err1 = [op1 wait];
    if(!err)
    {
        NSLog(@"%d,%d", err, err1);
        UIAlertView *myAlert1 = [[UIAlertView alloc]initWithTitle:nil
                                                          message:@"A connection error occured. Try again soon."
                                                         delegate:self
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [myAlert1 show];
    }

}

- (IBAction)createviafb:(id)sender {
    //fb
    
    if (FBSession.activeSession.isOpen) {
        // if a user logs out explicitly, we delete any cached token information, and next
        // time they run the applicaiton they will be presented with log in UX again; most
        // users will simply close the app or switch away, without logging out; this will
        // cause the implicit cached-token login to occur on next launch of the application
        
        [self updateView1];
        
    } else {
        
        NSArray *permissions = [NSArray arrayWithObjects:@"email", nil];
        
        [FBSession openActiveSessionWithReadPermissions:permissions
                                           allowLoginUI:YES
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                          [self updateView1];
                                      }];
    }

}


-(void)gotogame:(GameRequest*) request
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading";
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        GameInfo* game = [_gameServer getGameForRequest:request];
     //   self.gamewindow = [[GSGViewController alloc] initWithNibName:@"GSGViewController" bundle:nil gameInfo:game myid:_gameServer.user.userid];
        //self.gamewindow.delegate = self;
        
        [self.gamewindow setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        
        [self presentViewController:self.gamewindow animated:YES completion:nil];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
    

}


- (IBAction) showCreateGame:(id)sender
{
    UIView* selectedMenu = [self.view viewWithTag:CREATE_VIEW];
    
    UIView* createView = [[[NSBundle mainBundle] loadNibNamed:@"CreateGameView" owner:self options:nil] objectAtIndex:0];
    
    [selectedMenu addSubview:createView];
    
    [self resizeSubviews:CREATE_VIEW];
    
    UICollectionView* collection = (UICollectionView*)[createView viewWithTag:INVITE_COLLECTION];
    
    [collection registerClass:[UICollectionViewCell class]
                                      forCellWithReuseIdentifier:@"invite_cell"];
    
}


- (IBAction) resetMainMenu:(id)sender
{
   for(UIView* v in [self.view subviews])
   {
       switch(v.tag)
       {
           case CREATE_VIEW:
               
               [[v viewWithTag:CREATE_WINDOW] removeFromSuperview];
               break;
           default: break;
       }
       [UIView animateWithDuration:.1f animations:^{
           CGRect frame = v.frame;
           frame.size.width = WINDOW_SIZE / [[self.view subviews] count];
           frame.origin.x = frame.size.width * (v.tag - 1);
           NSLog(@"%@, %@", NSStringFromCGRect(v.frame), NSStringFromCGRect(frame));
           v.frame = frame;
       }];
   }
}

- (void) resizeSubviews:(int)tag
{
    for(UIView* v in [self.view subviews])
    {
        float wDelta = 1.f * EXPAND_SIZE/([[self.view subviews] count]);
        float oDelta = wDelta;
        if(v.tag < tag)
        {
            wDelta *= -1.f;
            oDelta *= (v.tag-1) == 0 ? 0 : -1.0f/tag;
        }
        else if(v.tag > tag)
        {
            wDelta *= -1.f;
            oDelta *= [[self.view subviews] count] - v.tag + 1;
        }
        else
        {
            wDelta *= [[self.view subviews] count] - 1;
            oDelta *= -1.0f * (tag - 1);
        }
        
        [UIView animateWithDuration:.1f animations:^{
            CGRect frame = v.frame;
            frame.size.width += wDelta;
            frame.origin.x += oDelta;
            v.frame = frame;
        }];

    }
}

- (IBAction)addplayer:(UIButton *)sender
{
//    UIView* invitationPopup = [[[NSBundle mainBundle] loadNibNamed:@"InvitePopupScreen" owner:self options:nil] objectAtIndex:0];
//    [_selectedMenu addSubview:invitationPopup];
    [self openfb];
    
}



-(void)friendsselective{
    
    NSSet *fields = [NSSet setWithObjects:@"installed", nil];
    self.friendPickerController.fieldsForRequest = fields;
    [self.friendPickerController updateView];
    //   [self.friendPickerController loadData];
}



- (BOOL)friendPickerViewController:(FBFriendPickerViewController *)friendPicker
                 shouldIncludeUser:(id<FBGraphUser>)user
{
    NSLog(@"checking");
    if(self.friendPickerController.fieldsForRequest){
        NSLog(@"what:%@-%@",user[@"name"],user[@"installed"]);
        if (user[@"installed"]) {
            NSLog(@"hey");
            // If friend name matches partially, show the friend
            return YES;
        } else {
            NSLog(@"ho");
            // If no match, do not show the friend
            return NO;
        }
        
    }
    
    // If there is a search query, filter the friend list based on this.
    
    if (self.searchText && ![self.searchText isEqualToString:@""]) {
        NSRange result = [user.name
                          rangeOfString:self.searchText
                          options:NSCaseInsensitiveSearch];
        if (result.location != NSNotFound) {
            // If friend name matches partially, show the friend
            return YES;
        } else {
            // If no match, do not show the friend
            return NO;
        }
    } else {
        // If there is no search query, show all friends.
        return YES;
    }
    return YES;
}


- (void)facebookViewControllerDoneWasPressed:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)facebookViewControllerCancelWasPressed:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)friendPickerViewControllerSelectionDidChange:
(FBFriendPickerViewController *)friendPicker
{
    NSLog(@"clicked");
    _players = friendPicker.selection;
    UICollectionView* collection = (UICollectionView*)[[self.view viewWithTag:CREATE_VIEW] viewWithTag:INVITE_COLLECTION];
    [collection reloadData];
}

-(void)allfriends{
    
    NSLog(@"all");
    self.friendPickerController.fieldsForRequest = nil;
    self.searchText = @"";
    [self.friendPickerController updateView];
    //   [self.friendPickerController clearSelection];
    //   [self.friendPickerController loadData];
}

-(NSDictionary*) getPlayer:(NSString*) username
{
    
    NSMutableDictionary* playerAccount = [[NSMutableDictionary alloc] init];
    
    NSLog(@"userab-%@",username);
    if ([username rangeOfString:@"-"].location == NSNotFound)
    {
        NSString *userurl  = [NSString stringWithFormat:
                              @"https://sumowars.cloudant.com/profiles/_design/view/_search/users?q=username:%%22%@%%22",
                              username];
        NSData *usercheck = [NSData dataWithContentsOfURL:[NSURL URLWithString:userurl]];
        NSError *error = nil;
        id userresult = [NSJSONSerialization JSONObjectWithData:usercheck options:NSJSONReadingMutableContainers error:&error];
        NSLog(@"userresult-%@",userresult);
        if ([[userresult objectForKey:@"total_rows"] intValue]!=0) {
            NSString *userid = [[[userresult objectForKey:@"rows"]objectAtIndex:0]objectForKey:@"id"];
            
            [playerAccount setObject:userid forKey:DB_USER_ID];
            [playerAccount setObject:userresult[@"rows"][0][@"fields"][@"username"] forKey:DB_USER_NAME];
//            [playerAccount setObject:userresult[@"rows"][0][@"fields"][@"default_move"] forKey:DB_DEFAULT_MOVE];
        }
        
    }
    else
    {
        NSArray* foo = [username componentsSeparatedByString: @"fb-"];
        NSString *fburl = [NSString stringWithFormat:
                           @"https://sumowars.cloudant.com/profiles/_design/view/_search/users?q=facebook:%%22%@%%22",
                          [foo objectAtIndex:1]];
        NSData *fbcheck = [NSData dataWithContentsOfURL:[NSURL URLWithString:fburl]];
        NSError *error = nil;
        id fbresult = [NSJSONSerialization JSONObjectWithData:fbcheck options:NSJSONReadingMutableContainers error:&error];
        NSLog(@"userresult-%@,%@",fbresult,error);
        if ([[fbresult objectForKey:@"total_rows"] intValue]!=0){
            NSString *userid = [[[fbresult objectForKey:@"rows"]objectAtIndex:0]objectForKey:@"id"];
            
            [playerAccount setObject:userid forKey:DB_USER_ID];
            [playerAccount setObject:fbresult[@"rows"][0][@"fields"][@"fb_name"] forKey:DB_USER_NAME];
            [playerAccount setObject:fbresult[@"rows"][0][@"fields"][@"facebook"] forKey:DB_FB_ID];
     //       [playerAccount setObject:fbresult[@"rows"][0][@"fields"][@"default_move"] forKey:DB_DEFAULT_MOVE];
            
        }
    }
    
    [playerAccount setObject:[NSNumber numberWithBool:NO] forKey:DB_CONNECTED];
   // [playerAccount setObject:[[NSArray alloc] init] forKey:DB_TEAM_INVITES];
    
    return playerAccount;
}


- (NSDictionary*) getPlayerAccounts
{
    NSMutableDictionary* playerAccounts = [[NSMutableDictionary alloc]init];
   
   /*( NSMutableDictionary* userAccount = [[_gameServer.user getUserPlayer] mutableCopy];
    [userAccount setObject:[NSNumber numberWithBool:NO] forKey:DB_CONNECTED];
    [userAccount setObject:[[NSArray alloc] init] forKey:DB_TEAM_INVITES];
       
    [playerAccounts setObject:userAccount forKey:[userAccount objectForKey:DB_USER_ID]];
    
    for(id<FBGraphUser> userFB in _players)
    {
        NSString* user = [@"fb-" stringByAppendingString:userFB.id];
        NSDictionary* player = [self getPlayer:user];
        
        if([player count] == 0)
        {
            UIAlertView *myAlert1 = [[UIAlertView alloc]initWithTitle:nil
                                                              message:@"yo dog, someone you added doesn't fucking exist."
                                                             delegate:self
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            
            [myAlert1 show];
            break;
        }
        
        [playerAccounts setObject:player forKey:[player objectForKey:DB_USER_ID]];
    }
    */
    return playerAccounts;
}


- (void) sendRequests:(NSString*) gameId toPlayers:(NSDictionary*)players
{
    CouchDocument* gameRequest = [_gameServer createNewGameRequest:gameId];
    GameRequest* request = [[GameRequest alloc] init];
    request.game_id = gameId;
    request.hostuserid = _gameServer.user.userid;
    request.hostfbid= _gameServer.user.fb_id;
    request.hostname= _gameServer.user.username;
    NSDictionary* requestDoc = [request getRequest];
    
    RESTOperation* op24 = [gameRequest putProperties:requestDoc];
    if (![op24 wait]){}

    for (NSString* player in [players allKeys]) {
        
        GameInvitations* invites = [_gameServer getUserUpdate:player];
        
        if (invites.gameRequests)
        {
            NSMutableArray* existingRequests = [invites.gameRequests mutableCopy];
            
            [existingRequests addObject:requestDoc];
            
            invites.gameRequests = existingRequests;
        }
        else
        {
            invites.gameRequests = [NSArray arrayWithObject:requestDoc];
        }
        
        RESTOperation* op2 = [invites save];
        if (![op2 wait]){}
    }
    
}


- (IBAction)onCreateNewGame:(id)sender
{
    CFUUIDRef uuidObject = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidStr = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuidObject);
    CFRelease(uuidObject);
    
    GameInfo* newg = [_gameServer createNewGame:uuidStr];
    newg.gameName = uuidStr;

    [self startNewGame:newg];
}


-(void) startNewGame:(GameInfo*) newg
{
    newg.hostId = _gameServer.user.userid;
    newg.currentRound = [NSNumber numberWithInt:-1];
    newg.gameData = [[NSArray alloc] init];
    newg.roundBuffer = [NSNumber numberWithInt:5];
    newg.timeInterval = [NSNumber numberWithInt:10];
    
    NSDictionary* playerAccounts = [self getPlayerAccounts];
    newg.players = playerAccounts;
    
 //   [self sendRequests:newg.gameName toPlayers:playerAccounts];
    
    RESTOperation* op2 = [newg save];
    if (![op2 wait]){}
    
    [_gameServer saveCreatedGame:newg];
    
    UICollectionView* collection = (UICollectionView*)[[self.view viewWithTag:CREATE_VIEW] viewWithTag:SAVED_GAMES];
    [collection reloadData];
    
    self.gamewindow = [[GameViewController alloc] initWithGameInfo:newg playerId:_gameServer.user.userid];
                                          //     gameInfo:newg myid:_gameServer.user.userid];
    //self.gamewindow.delegate = self;
    
    [self.gamewindow setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    [self presentViewController:self.gamewindow animated:YES completion:nil];
}


-(void) recreateGame:(UIButton*) sender
{
    NSDictionary* game = [_gameServer.savedGames.savedGames objectAtIndex:sender.tag];
    _players = [game objectForKey:@"players"];
    
    CFUUIDRef uuidObject = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidStr = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuidObject);
    CFRelease(uuidObject);
    
    GameInfo* newg = [_gameServer createNewGame:uuidStr];
    newg.gameName = uuidStr;
    
    [self startNewGame:newg];
}


- (IBAction)gotodojo:(id)sender {
  //  self.gamewindow = [[GameView alloc] initWithNibName:@"GameView" bundle:nil gameid:@"002674AC-F9CB-4DD8-93E3-A541FA7339A6" myid:_myid];
  //  [self.gamewindow setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
  //  [self presentViewController:self.gamewindow animated:YES completion:nil];
}



- (void)viewDidUnload {
//    [self setCenterviewarea:nil];
//    [self setCreateaccountcenter:nil];
//    [self setAccountusername:nil];
//    [self setAccountemail:nil];
//    [self setGameinvitations:nil];
    [super viewDidUnload];
}


// UICollectionViewDataSource

// switch between invitees and saved games
// 1
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    switch (view.tag)
    {
        case INVITE_COLLECTION:
            return [_players count];
        case SAVED_GAMES:
            return [_gameServer.savedGames.savedGames count];
    }
    
    return 0;
}
// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
// 0
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch(cv.tag)
    {
        case INVITE_COLLECTION:
            return [self cellForInvites:cv atIndexPath:indexPath];
        case SAVED_GAMES:
            return [self cellForGames:cv atIndexPath:indexPath];
    }
    
    return [[UICollectionViewCell alloc] init];
}

-(UICollectionViewCell*)cellForGames:(UICollectionView*)cv atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"game_cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    UIButton* label;
    if([[cell.contentView subviews] count] == 0)
    {
        label = [[UIButton alloc] initWithFrame:CGRectMake(5,0,48,48)];
        cell.layer.borderColor = [[UIColor grayColor] CGColor];
        cell.layer.borderWidth = 1.5;
        label.tag = indexPath.row;
        label.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
        label.titleLabel.font = [UIFont systemFontOfSize:9.0];
        [label.titleLabel adjustsFontSizeToFitWidth];
        [label setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cell.contentView addSubview:label];
        [label addTarget:self action:@selector(recreateGame:) forControlEvents:UIControlEventTouchUpInside];
    }
    else{
        label = (UIButton*)[[cell.contentView subviews] objectAtIndex:0];
    }
    
    NSDictionary* game = [_gameServer.savedGames.savedGames objectAtIndex:indexPath.row];
    [label setTitle:[NSString stringWithFormat:@"Game ID: %@\n # of players:%d",
                               [game objectForKey:@"name"], [[game objectForKey:@"players"] count]] forState:UIControlStateNormal];
    return cell;
}

-(UICollectionViewCell*)cellForInvites:(UICollectionView*)cv atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"invite_cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    UILabel* label = (UILabel*)[cell.contentView viewWithTag:INVITE_COLLECTION];
    if(!label)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(5,0,48,48)];
        cell.layer.borderColor = [[UIColor grayColor] CGColor];
        cell.layer.borderWidth = 1.5;
        label.tag = INVITE_COLLECTION;
        label.lineBreakMode = UILineBreakModeWordWrap;
        label.font = [UIFont systemFontOfSize:12.0];
        [label adjustsFontSizeToFitWidth];
        label.numberOfLines = 2;
        label.textColor = [UIColor blackColor];
        [cell.contentView addSubview:label];
    }
    
    id<FBGraphUser> user = [_players objectAtIndex:indexPath.row];
    [label setText:user.name];
    return cell;
}

- (IBAction)sliderAction:(id)sender {
    NSLog(@"slide");
    NSString *newText = [[NSString alloc] initWithFormat:@"%f",_gridSlider.value];
    _gridVal.text = newText;
}
@end
