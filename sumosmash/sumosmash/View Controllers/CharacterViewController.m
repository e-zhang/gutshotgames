//
//  CharacterViewController.m
//  sumosmash
//
//  Created by Eric Zhang on 4/17/13.
//  Copyright (c) 2013 gutshotgames. All rights reserved.
//

#import "CharacterViewController.h"

@interface CharacterViewController ()
-(void) selectTarget:(UILongPressGestureRecognizer*) recognizer;

@end


@implementation CharacterViewController

@synthesize Display = _display, Char = _character;

- (id) initWithId:(NSString *)playerId name:(NSString*)name selfId:(NSString*)selfId
       onMoveTarget:(id)target onMoveSelect:(SEL)selector
{
    if([super init])
    {
        _character = [[Character alloc] initWithId:playerId andName:name];
        
        _characterDisplay = [[UILabel alloc] init];
        _characterDisplay.textColor = [UIColor whiteColor];
        _characterDisplay.backgroundColor = [UIColor clearColor];
        _characterDisplay.text = [_character getStats];
        
        _characterDisplay.font = [UIFont fontWithName:@"GillSans" size:14.0f];
        _characterDisplay.textColor = [UIColor redColor];
        _isSelf= [playerId isEqual:selfId];
        _submitMoveSelector = selector;
        _submitMoveTarget = target;
        
        
        [_character addObserver:self forKeyPath:@"IsConnected" options:NSKeyValueObservingOptionNew context:nil];
    }
    
    return self;
}

- (void) setUserPic:(NSString*) path
{
    NSURL *url = [NSURL URLWithString:path];
    NSData *data = [NSData dataWithContentsOfURL:url];
    _characterPic = [[UIImage alloc]initWithData:data];
    
    UIImageView *myImageView = [[UIImageView alloc] init];
    myImageView.userInteractionEnabled = YES;
    myImageView.image = _characterPic;
    [myImageView addSubview:_characterDisplay];
    _characterDisplay.frame = CGRectMake(0,-25,200,50);
   
    self.view = myImageView;
    
    _menuController = [[UIViewController alloc] init];
    _menuController.view = [[MoveMenu alloc] initWithFrame:CGRectMake(0,-75,150,150) andDelegate:self forPlayer:_character.Id isSelf:_isSelf];
    
    [self addChildViewController:_menuController];
    
    UILongPressGestureRecognizer* longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self action:@selector(selectTarget:)];
    [self.view addGestureRecognizer:longPress];
}

- (void) selectTarget:(UILongPressGestureRecognizer *)recognizer
{
    if(recognizer.state != UIGestureRecognizerStateEnded) return;
    
    if(![_menuController.view superview])
    {
        [self.view addSubview:_menuController.view];
    }
    else
    {
        [_menuController.view removeFromSuperview];
    }
    

}

// MoveMenuDelegates
- (void) selectedItemChanged:(Move *)move
{
    if(![_character UpdateNextMove:move])
    {
        UIAlertView *myAlert1 = [[UIAlertView alloc]initWithTitle:nil
                                                          message:@"Move you selected is not valid"
                                                         delegate:self
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [myAlert1 show];
        return;
    }
    
    [_submitMoveTarget performSelector:_submitMoveSelector withObject:move];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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
    if([keyPath isEqual:@"IsConnected"])
    {
        _characterDisplay.textColor = [change objectForKey:NSKeyValueChangeNewKey] ?
                                      [UIColor blackColor] : [UIColor redColor];
    }
}

@end
