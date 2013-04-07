//
//  MainView.m
//  sumosmash
//
//  Created by Danny Witters on 10/03/2013.
//  Copyright (c) 2013 gutshotgames. All rights reserved.
//

//NOTE - ASLIVEQUERY is producing a castIf warning. Look into that.

#import "MainView.h"
#import <unistd.h>
#import "MBProgressHUD.h"

#import <CouchCocoa/CouchEmbeddedServer.h>
#import <QuartzCore/QuartzCore.h>

#import "GameInfo.h"
#include "DBDefs.h"

@interface MainView ()

@property (nonatomic, strong) NSMutableDictionary *gameinvitelist;

@property(nonatomic, strong)NSString *myid;

@property(nonatomic, strong)CouchLiveQuery *liveq;


@property (nonatomic, strong)createaccount *createaccount;
@property (nonatomic, strong)GameWindow *gamewindow;

@end

@interface CustomFriendsTableViewController : FBFriendPickerViewController

@end

@implementation MainView

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
    
    NSString* username; NSString* userId; NSData* userPic;
    UserType userType = [_gameServer.user GetUserName:&username Pic:&userPic Id:&userId];
    
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
            
            myImageView.frame = CGRectMake(20,self.view.frame.size.height-60,50,50);
            label1.frame = CGRectMake(85,self.view.frame.size.height-60,400,50);
            label1.font = [UIFont fontWithName:@"GillSans" size:24.0f];
            [self.view addSubview:myImageView];
            [self.view addSubview:label1];
        }
        case GSG:
        {
            UILabel* label1 = [[UILabel alloc] init];
            label1.textColor = [UIColor darkGrayColor];
            label1.backgroundColor = [UIColor clearColor];
            label1.text = username;
            label1.frame = CGRectMake(85,self.view.frame.size.height-60,400,50);
            label1.font = [UIFont fontWithName:@"GillSans" size:24.0f];
            [self.view addSubview:label1];
        }
    }
    
    _cab.hidden = userType == NONE ? YES : NO;
    
    _myid = userId;

    [NSTimer scheduledTimerWithTimeInterval: 30.0 target: self selector:@selector(checkforaccountupdates:) userInfo: nil repeats:YES];

    _players = [[NSMutableArray alloc] init];
    [_gameinvitations setContentSize:CGSizeMake(450,1400)];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft || interfaceOrientation==UIInterfaceOrientationLandscapeRight)
        return YES;
    
    return NO;
}

-(void)checkforaccountupdates:(NSTimer *)timer {
//    
//        NSArray *updates = [NSArray arrayWithObject:_myid];
//        CouchQuery* allDocs = [self.serverupdate getDocumentsWithIDs:updates];
//        
//        CouchQueryEnumerator* newRows = allDocs.rowsIfChanged;
//        if (newRows != nil) {
//            for (CouchQueryRow* row in newRows) {
//                
//                CouchDocument *doc = row.document;
//                
//                if ([[row.documentProperties objectForKey:@"update"] intValue]>0){
//                    
//                    NSMutableDictionary *newdoc = [row.documentProperties mutableCopy];
//                    
//                    if (![[row.documentProperties objectForKey:@"gamerequests"]isEqual:@""]){
//                        NSMutableDictionary *docContent = [[row.documentProperties objectForKey:@"gamerequests"] mutableCopy];
//                        NSDictionary *irupdates = [row.documentProperties objectForKey:@"gamerequests"];
//                        for (NSString* key in irupdates) {
//                            NSLog(@"key-%@",key);
//                            NSDictionary *stuff = [irupdates objectForKey:key];
//                            NSLog(@"stiff-%@",stuff);
//                            
//                            CouchDocument *nd = [_invites documentWithID:key];
//                            
//                            RESTOperation* operation = [nd putProperties:stuff];
//                            [operation onCompletion: ^{
//                                if (operation.isSuccessful){}
//                                else{}
//                            }];
//                            
//                            [docContent removeObjectForKey:key];
//
//                        }
//                        
//                        [newdoc setObject:docContent forKey:@"gamerequests"];
//                        
//                }
//                    
//                    [newdoc setObject:@"0" forKey:@"update"];
//                    
//                    RESTOperation* operation = [doc putProperties:newdoc];
//                    [operation onCompletion: ^{
//                        if (![operation wait])
//                            NSLog(@"%@ fdsafdsafdsa", [operation.error localizedDescription]);
//                    }];
//                    [operation start];
//                    
//                }
//            }
//            
//        }
//        else{
//            NSLog(@"nothing new");
//        }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
             /*NSDictionary *inDocument = [NSDictionary dictionaryWithObjectsAndKeys:
                                         @"createaccount", @"action",
                                         @"fb",@"type",
                                         user.id,@"fb_id",
                                         user.name,@"fb_name",
                                         [user objectForKey:@"email"],@"email",
                                         nil];
             
             MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
             hud.labelText = @"Creating Account";
             dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
             dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
             });
             */
             
             [self SaveAccountInfo:user];
             
              NSLog(@"hello");
             NSString *fb_id = user.id;
             
             NSString *path = @"http://graph.facebook.com/";
             path = [path stringByAppendingString:fb_id];
             path = [path stringByAppendingString:@"/picture?type=square"];
             
             NSURL *url = [NSURL URLWithString:path];
             NSData *data = [NSData dataWithContentsOfURL:url];
             
             UIImageView *myImageView = [[UIImageView alloc] init];
             
             UILabel* label1 = [[UILabel alloc] init];
             label1.textColor = [UIColor whiteColor];
             label1.backgroundColor = [UIColor clearColor];
             
             myImageView.image = [[UIImage alloc]initWithData:data];
             label1.text = user.name;
             
             myImageView.frame = CGRectMake(20,self.view.frame.size.height-100,80,80);
             label1.frame = CGRectMake(120,self.view.frame.size.height-110,400,100);
             label1.font = [UIFont fontWithName:@"GillSans" size:24.0f];

             
             [self.view addSubview:myImageView];
             [self.view addSubview:label1];
             
             _cab.hidden = YES;

         }];
    }
    
}

-(void)openfb{
    if (!FBSession.activeSession.isOpen) {
        FBSession *session =
        [[FBSession alloc] initWithAppID:nil
                             permissions:nil
                         urlSchemeSuffix:@"freeapp"
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
    if (nil == self.facebook) {
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
    [self.friendPickerController clearSelection];
    
    [self presentViewController:self.friendPickerController animated:YES completion:nil];

    
    CGFloat searchBarHeight = 44.0;
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,searchBarHeight)];
    self.searchBar.autoresizingMask = self.searchBar.autoresizingMask |
    UIViewAutoresizingFlexibleWidth;
    self.searchBar.delegate = self;
    self.searchBar.showsCancelButton = YES;
    
    [self.friendPickerController.canvasView addSubview:self.searchBar];
    
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
    newFrame.size.height -= searchBarHeight;
    newFrame.origin.y = searchBarHeight;
    self.friendPickerController.canvasView.backgroundColor =  [UIColor blackColor];
    
        library.frame = CGRectMake(0, 0, 180, 55);
        library.titleLabel.font = [UIFont fontWithName:@"GillSans" size:20.0f];
        web.titleLabel.font = [UIFont fontWithName:@"GillSans" size:20.0f];
        bottombar.frame = CGRectMake(0,self.friendPickerController.canvasView.frame.size.height-55,self.view.frame.size.width,55);
        web.frame = CGRectMake(self.friendPickerController.canvasView.frame.size.width-180, 0, 180, 55);
        self.friendPickerController.tableView.frame = CGRectMake(0,44,self.view.frame.size.width,self.view.frame.size.height-55);
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
        userAccount.password = @"";
        userAccount.username = _accountusername.text;
        userAccount.email = _accountemail.text;
        
        op = [userAccount save];
        
        serverAccount.password = @"";
        serverAccount.username = _accountusername.text;
        serverAccount.email = _accountemail.text;
        
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
    
    if(![op wait] || ![op1 wait])
    {
        
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

- (IBAction)accessgi:(id)sender {
    
    [[_gameinvitations subviews]
     makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [_centerviewarea setHidden:YES];
    [_createaccountcenter setHidden:YES];
    [_gameinvitations setHidden:NO];

    NSArray* gameInvites = [_gameServer GetInvitationList];
    int x=0;
    for (GameInfo* game in gameInvites)
    {
        UIButton *web = [[UIButton alloc] init];
        web.tag = x;
        web.frame = CGRectMake(15,15+(x*50),450,30);
        [web setTitle:game.gameName forState:UIControlStateNormal];
        [web setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [web addTarget:self action:@selector(gotogame:) forControlEvents:UIControlEventTouchUpInside];
        web.backgroundColor = [UIColor clearColor];
        
        [_gameinvitations addSubview:web];
        ++x;
    }
}

-(void)gotogame:(UIButton *)sender{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading";
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        GameInfo* game = [[_gameServer GetInvitationList] objectAtIndex:sender.tag];
        [game joinGame:_gameServer.user.userid];
        self.gamewindow = [[GameWindow alloc] initWithNibName:@"GameWindow" bundle:nil gameInfo:game myid:_myid];
        //self.gamewindow.delegate = self;
        
        [self.gamewindow setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        
        [self presentViewController:self.gamewindow animated:YES completion:nil];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
    

}


- (IBAction)creategame:(id)sender {
    _createaccountcenter.hidden = YES;
    _centerviewarea.hidden = NO;
}

- (IBAction)addplayer:(UIButton *)sender {
    //blackoverlay with 2 buttons
    if(sender.tag==1){
        [self openfb];
    }
    if(sender.tag==2){
        
        user = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-300,self.view.frame.size.height/2-50,600,100)];
        user.backgroundColor = [UIColor blackColor];
        
        UILabel *username = [[UILabel alloc]initWithFrame:CGRectMake(40,40,100,30)];
        username.text = @"Username:";
        username.textColor = [UIColor whiteColor];
        username.backgroundColor = [UIColor clearColor];
        
        player1 = [[UITextField alloc] init];
        player1.delegate = self;
        player1.textColor = [UIColor grayColor];
        player1.borderStyle = UITextBorderStyleBezel;
        player1.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        player1.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
        player1.autocorrectionType = UITextAutocorrectionTypeNo;
        player1.autocapitalizationType = UITextAutocapitalizationTypeNone;
        player1.leftViewMode = UITextFieldViewModeAlways;
        player1.frame = CGRectMake(155, 40, 200, 30);
        player1.textColor = [UIColor whiteColor];
                
        UIButton *submit = [UIButton buttonWithType:UIButtonTypeCustom];
        [[submit layer] setBackgroundColor:[UIColor whiteColor].CGColor];
        [submit setTitle:@"Add User" forState:UIControlStateNormal];
        [submit setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [submit addTarget:self action:@selector(submituser:) forControlEvents:UIControlEventTouchUpInside];
        submit.frame = CGRectMake(390,40,90,30);
        
        [user addSubview:username];
        [user addSubview:player1];
        [user addSubview:submit];
        
        [self.view addSubview:user];
    
    }
}

-(void)submituser:(id)sender{
    
    [user removeFromSuperview];
    
    [_players addObject:player1.text];
    int number = [_players count];
    
    UILabel *user1 = [[UILabel alloc]init];
    user1.frame = CGRectMake(400,240+(number*30),200,30);
    user1.text = player1.text;
    user1.textColor = [UIColor whiteColor];
    user1.backgroundColor = [UIColor clearColor];
    
    [_centerviewarea addSubview:user1];
    
}

- (IBAction)createaccount:(id)sender {
   
    
    _createaccountcenter.hidden = NO;
    _centerviewarea.hidden = YES;
    _gameinvitations.hidden = YES;
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
    // we pick up the users from the selection, and create a string that we use to update the text view
    // at the bottom of the display; note that self.selection is a property inherited from our base class
    //UIImage *img = self.image;

    
    for (id<FBGraphUser> userx in self.friendPickerController.selection)
    {

        
        NSString *hi = [@"fb-" stringByAppendingString:userx.id];

        if (userx[@"installed"]) {

                [_players addObject:hi];
                
                int number = [_players count];
                
                UILabel *user1 = [[UILabel alloc]init];
                user1.frame = CGRectMake(400,240+(number*30),200,30);
                user1.text = userx.name;
                user1.textColor = [UIColor whiteColor];
                user1.backgroundColor = [UIColor clearColor];
                
                [_centerviewarea addSubview:user1];
                NSLog(@"where you at georges?");
            }
            
        /*    NSArray *updates1 = [NSArray arrayWithObject:userid];
            
            CouchQuery* allDocs1 = [self.serverupdate getDocumentsWithIDs:updates1];
            
            for (CouchQueryRow* row in allDocs1.rows) {
                CouchDocument* doc = row.document;
                NSMutableDictionary *newdoc = [row.documentProperties mutableCopy];
                
                [newdoc setObject:@"1" forKey:@"update"];
                
                NSDictionary *impd = [NSDictionary dictionaryWithObjectsAndKeys:
                                      uuidStr1, @"game_id",
                                      [doc.properties objectForKey:@"fb_id"], @"hostfb_id",
                                      [doc.properties objectForKey:@"fb_name"], @"hostname",
                                      nil];
                
                [newdoc setObject:impd forKey:@"gamerequests"];
                
                RESTOperation* op2 = [doc putProperties:newdoc];
                if (![op2 wait]){}*/
       //     }
            
    //    }
    }
  /*
    [newg setObject:[NSString stringWithFormat:@"%d",x] forKey:@"totalnumberofplayers"];
    NSLog(@"newg-%@",newg);
    
    CouchDocument *doc12 = [self.games documentWithID:uuidStr1];
    RESTOperation* op2 = [doc12 putProperties:newg];
    if (![op2 wait]){}

    self.gamewindow = [[GameWindow alloc] initWithNibName:@"GameWindow" bundle:nil gameid:uuidStr1 myid:_myid];
    //       self.gamewindow.delegate = self;
    
    [self.gamewindow setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    [self dismissViewControllerAnimated:YES completion:^{[self presentViewController:self.gamewindow animated:YES completion:nil];}];
   */
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)facebookViewControllerCancelWasPressed:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)friendPickerViewControllerSelectionDidChange:
(FBFriendPickerViewController *)friendPicker
{
    NSLog(@"clicked");
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
        NSLog(@"userresult-%@",fbresult);
        if ([[fbresult objectForKey:@"total_rows"] intValue]!=0){
            NSString *userid = [[[fbresult objectForKey:@"rows"]objectAtIndex:0]objectForKey:@"id"];
            
            [playerAccount setObject:userid forKey:DB_USER_ID];
            [playerAccount setObject:fbresult[@"rows"][0][@"fields"][@"fb_name"] forKey:DB_USER_NAME];
            [playerAccount setObject:fbresult[@"rows"][0][@"fields"][@"facebook"] forKey:DB_FB_ID];
            
        }
    }
    
    [playerAccount setObject:[NSNumber numberWithBool:NO] forKey:DB_CONNECTED];
    
    return playerAccount;
}


- (NSDictionary*) getPlayerAccounts
{
    NSMutableDictionary* playerAccounts = [[NSMutableDictionary alloc]init];
   
    NSDictionary* userAccount = [_gameServer.user getUserPlayer];
       
    [playerAccounts setObject:userAccount forKey:[userAccount objectForKey:DB_USER_ID]];
    
    for(int i=0;i<_players.count;i++)
    {
        NSString *userab =[_players objectAtIndex:i];
        NSDictionary* player = [self getPlayer:userab];
        
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
    
    RESTOperation* op24 = [gameRequest putProperties:[request getRequest]];
    if (![op24 wait]){}
    
    for (CouchQueryRow* row in [_gameServer getUserUpdates:players].rows) {
        
        CouchDocument* doc = row.document;
        NSMutableDictionary *newdoc = [row.documentProperties mutableCopy];
        
        [newdoc setObject:@"1" forKey:@"update"];
        
        
        if (![row.documentProperties objectForKey:@"gamerequests"])
        {
            NSMutableDictionary *existingRequests = [[row.documentProperties objectForKey:@"gamerequests"] mutableCopy];
            
            [existingRequests setObject:gameRequest.properties forKey:gameId];
            
            [newdoc setObject:existingRequests forKey:@"gamerequests"];
        }
        else
        {
            NSDictionary *newRequest = [NSDictionary dictionaryWithObjectsAndKeys:
                                        gameRequest.properties, gameId,
                                        nil];
            
            [newdoc setObject:newRequest forKey:@"gamerequests"];
        }
        
        RESTOperation* op2 = [doc putProperties:newdoc];
        if (![op2 wait]){}
    }
    
}


- (IBAction)startgame:(id)sender
{
    
    CFUUIDRef uuidObject = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidStr = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuidObject);
    CFRelease(uuidObject);
    
    GameInfo* newg = [_gameServer createNewGame:uuidStr];
    newg.gameName = uuidStr;
    newg.hostId = _gameServer.user.userid;
 
    NSDictionary* playerAccounts = [self getPlayerAccounts];
    
    [self sendRequests:uuidStr toPlayers:playerAccounts];
    
    newg.currentRound = [NSNumber numberWithInt:-1];
    newg.gameData = [[NSArray alloc] init];
    newg.players = playerAccounts;

    RESTOperation* op2 = [newg save];
    if (![op2 wait]){}
    
    [newg joinGame:_gameServer.user.userid];
    
    self.gamewindow = [[GameWindow alloc] initWithNibName:@"GameWindow" bundle:nil gameInfo:newg myid:_myid];
    //self.gamewindow.delegate = self;
    
    [self.gamewindow setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    [self presentViewController:self.gamewindow animated:YES completion:nil];


}

- (IBAction)gotodojo:(id)sender {
  //  self.gamewindow = [[GameWindow alloc] initWithNibName:@"GameWindow" bundle:nil gameid:@"002674AC-F9CB-4DD8-93E3-A541FA7339A6" myid:_myid];
  //  [self.gamewindow setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
  //  [self presentViewController:self.gamewindow animated:YES completion:nil];
}


- (void)viewDidUnload {
    [self setCenterviewarea:nil];
    [self setCreateaccountcenter:nil];
    [self setAccountusername:nil];
    [self setAccountemail:nil];
    [self setGameinvitations:nil];
    [super viewDidUnload];
}
@end
