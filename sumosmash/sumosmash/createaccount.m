//
//  createaccount.m
//  Wipe
//
//  Created by Danny Witters on 05/02/2013.
//  Copyright (c) 2013 Danny Witters. All rights reserved.
//
#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad

#import "createaccount.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@interface createaccount ()

@end

@implementation createaccount

//@synthesize loggedInUser = _loggedInUser;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSString *pewPewPath = [[NSBundle mainBundle] pathForResource:@"button-50" ofType:@"mp3"];
        NSURL *pewPewURL = [NSURL fileURLWithPath:pewPewPath];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)pewPewURL, &click);
        
        NSString *b = [[NSBundle mainBundle] pathForResource:@"back" ofType:@"mp3"];
        NSURL *b1 = [NSURL fileURLWithPath:b];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)b1, &back);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _username.delegate = self;
    _email.delegate = self;
    
    CALayer *leftline = [CALayer layer];
    leftline.frame = CGRectMake(0, 250, self.view.frame.size.width/2-14, 1.0f);
    leftline.backgroundColor = [UIColor grayColor].CGColor;

    CALayer *rightline = [CALayer layer];
    rightline.frame = CGRectMake(self.view.frame.size.width/2+14, 250, self.view.frame.size.width/2-14, 1.0f);
    rightline.backgroundColor = [UIColor grayColor].CGColor;
    
    UIView *bottombar = [[UIView alloc]init];
    bottombar.backgroundColor = [UIColor darkGrayColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setTitle:@"Create Account" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(createaccount:) forControlEvents:UIControlEventTouchUpInside];
    
    
    if(IDIOM==IPAD){
        leftline.frame = CGRectMake(0, 250, self.view.frame.size.width/2-14, 1.0f);
        rightline.frame = CGRectMake(self.view.frame.size.width/2+14, 250, self.view.frame.size.width/2-14, 1.0f);
         bottombar.frame = CGRectMake(0,self.view.frame.size.height - 55,self.view.frame.size.width,55);
        button.titleLabel.font = [UIFont fontWithName:@"GillSans" size:17.0f];
        button.frame=CGRectMake(0, 0, bottombar.frame.size.width, 55.0);
    }
    else{
        leftline.frame = CGRectMake(0, 195, self.view.frame.size.width/2-14, 1.0f);
        rightline.frame = CGRectMake(self.view.frame.size.width/2+14, 195, self.view.frame.size.width/2-14, 1.0f);
        bottombar.frame = CGRectMake(0,[UIScreen mainScreen].bounds.size.height - 45,self.view.frame.size.width,45);
        button.titleLabel.font = [UIFont fontWithName:@"GillSans" size:16.0f];
        button.frame=CGRectMake(0, 0, bottombar.frame.size.width, 45.0);
    }
    [self.view.layer addSublayer:leftline];
    [self.view.layer addSublayer:rightline];
    [bottombar addSubview:button];
    [self.view addSubview:bottombar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)returntap:(id)sender {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"sound"]==YES) {
        AudioServicesPlaySystemSound(back);
    }
    [self.delegate secondViewControllerDismissed:0];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft || interfaceOrientation==UIInterfaceOrientationLandscapeRight)
        return YES;
    
    return NO;
}

- (void)createaccount:(id)sender {
    
    NSCharacterSet *s = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_"];
    s = [s invertedSet];
    
    NSRange r = [_username.text rangeOfCharacterFromSet:s];
    
    if ([_email.text rangeOfString:@"@"].location == NSNotFound) {
                UIAlertView *myAlert1 = [[UIAlertView alloc]initWithTitle:nil
                                                                  message:@"Please Enter a Valid E-mail Address"
                                                                 delegate:self
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil];
                
                [myAlert1 show];
                _email.text = @"";

            }
    else if (r.location != NSNotFound) {
                UIAlertView *myAlert1 = [[UIAlertView alloc]initWithTitle:nil
                                                                  message:@"Username Should Only Contain Alphanumerical and Underscore Values"
                                                                 delegate:self
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil];
                
                [myAlert1 show];
                _username.text = @"";
            }
            
    else if (![_email.text isEqual:@""] && ![_username.text isEqual:@""]){
    
        NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:@"createaccount", @"action",
                              @"user",@"type",
                              _username.text,@"username",
                              _email.text,@"email",
                              nil];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Loading";
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.delegate secondViewControllerDismissed:data];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        
    }
    else{
        UIAlertView *myAlert1 = [[UIAlertView alloc]initWithTitle:nil
                                                          message:@"Username And E-mail Both Need To Be Entered"
                                                         delegate:self
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [myAlert1 show];
    }
}

- (IBAction)loginfacebook:(id)sender {
    // get the app delegate so that we can access the session property
 
    // AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    
    // this button's job is to flip-flop the session from open to closed
    if (FBSession.activeSession.isOpen) {
        // if a user logs out explicitly, we delete any cached token information, and next
        // time they run the applicaiton they will be presented with log in UX again; most
        // users will simply close the app or switch away, without logging out; this will
        // cause the implicit cached-token login to occur on next launch of the application
        
        [self updateView];
        
    } else {
        
        NSArray *permissions = [NSArray arrayWithObjects:@"email", nil];
        
        [FBSession openActiveSessionWithReadPermissions:permissions
                                           allowLoginUI:YES
                                            completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                                    [self updateView];
                                                }];
    }
   

}

- (void)updateView {
    // get the app delegate, so that we can reference the session property
   
    //AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    
    if (FBSession.activeSession.isOpen) {
        // valid account UI is shown whenever the session is open
        
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
                          
             NSDictionary *inDocument = [NSDictionary dictionaryWithObjectsAndKeys:
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
                 [self.delegate secondViewControllerDismissed:inDocument];
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
             });
             
         }];
        
    } else {

    }
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.placeholder = nil;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ( [textField isEqual: _email] ){
        textField.placeholder = @"E-mail";
    }
    if ( [textField isEqual: _username] ){
        textField.placeholder = @"Username";
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ( [textField isEqual: _email] )
    {
        if ([_email.text rangeOfString:@"@"].location == NSNotFound) {
            UIAlertView *myAlert1 = [[UIAlertView alloc]initWithTitle:nil
                                                              message:@"Please Enter a Valid E-mail Address"
                                                             delegate:self
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            
            [myAlert1 show];
            _email.text = @"";
        }
        [_email resignFirstResponder];
    }
    if ( [textField isEqual: _username] )
    {
        NSCharacterSet *s = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_"];
        s = [s invertedSet];
        
        NSRange r = [_username.text rangeOfCharacterFromSet:s];
        if (r.location != NSNotFound) {
            UIAlertView *myAlert1 = [[UIAlertView alloc]initWithTitle:nil
                                                              message:@"Username Should Only Contain Alphanumerical and Underscore Values"
                                                             delegate:self
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            
            [myAlert1 show];
            _username.text = @"";
        }
        
        [_username resignFirstResponder];
        
    }
    
    return YES;
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
