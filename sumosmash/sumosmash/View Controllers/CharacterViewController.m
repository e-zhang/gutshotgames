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

- (id) initWithId:(NSString *)playerId name:(NSString*)name selfId:(NSString*)selfId delegate:(id<CharacterDelegate>)target
{
    if([super init])
    {
        _character = [[Character alloc] initWithId:playerId andName:name];
        
        _characterDisplay = [[UILabel alloc] init];
        _characterDisplay.textColor = [UIColor whiteColor];
        _characterDisplay.backgroundColor = [UIColor clearColor];
        _characterDisplay.text = [_character getStats];
        
        _characterDisplay.font = [UIFont fontWithName:@"GillSans" size:12.0f];
        _characterDisplay.textColor = [UIColor redColor];
        _characterDisplay.numberOfLines = 2;
        _isSelf= [playerId isEqual:selfId];
        _delegate = target;
        
        self.view = [[UIView alloc] init];
        
        [_character addObserver:self forKeyPath:@"IsConnected" options:NSKeyValueObservingOptionNew context:nil];
        [_character addObserver:self forKeyPath:@"IsTarget" options:NSKeyValueObservingOptionNew context:nil];
        [_character addObserver:self forKeyPath:@"Life" options:NSKeyValueObservingOptionNew context:nil];
        [_character addObserver:self forKeyPath:@"Points" options:NSKeyValueObservingOptionNew context:nil];
    }
    
    return self;
}

- (void) setUserPic:(NSString*) path
{
    NSURL *url = [NSURL URLWithString:path];
    NSData *data = [NSData dataWithContentsOfURL:url];
    _characterPic = [[UIImage alloc]initWithData:data];
    
    UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 70, 35, 35)];
    myImageView.userInteractionEnabled = YES;
    myImageView.image = _characterPic;
    
    [self.view addSubview: myImageView];
    [self.view addSubview:_characterDisplay];
    _characterDisplay.frame = CGRectMake(0, 60,200,30);
   
    _menuController = [[UIViewController alloc] init];
    _menuController.view = [[MoveMenu alloc] initWithFrame:CGRectMake(0,0,75,75) andDelegate:self forPlayer:_character.Id isSelf:_isSelf];
    
    [self addChildViewController:_menuController];
    
    UITapGestureRecognizer* longPress = [[UITapGestureRecognizer alloc]
                                               initWithTarget:self action:@selector(selectTarget:)];
    [myImageView addGestureRecognizer:longPress];
}

- (void) setCharacterImage:(int) type
{
    
    UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 100)];
    myImageView.userInteractionEnabled = YES;
    
    if(type==0){
        myImageView.image = [UIImage imageNamed:@"golf wars normal 1.png"];
    }else{
        myImageView.image = [UIImage imageNamed:@"golf wars front swing.png"];
    }
  //  myImageView.backgroundColor = [UIColor greenColor];
    [self.view addSubview: myImageView];
    [self.view addSubview:_characterDisplay];
    _characterDisplay.frame = CGRectMake(0, 100,200,30);

    _menuController = [[UIViewController alloc] init];
    _menuController.view = [[MoveMenu alloc] initWithFrame:CGRectMake(0,0,50,100) andDelegate:self forPlayer:_character.Id isSelf:_isSelf];
    _menuController.view.backgroundColor = [UIColor whiteColor];
    
    [self addChildViewController:_menuController];

    UITapGestureRecognizer* longPress = [[UITapGestureRecognizer alloc]
                                         initWithTarget:self action:@selector(selectTarget:)];
    [myImageView addGestureRecognizer:longPress];
}

- (void) selectTarget:(UITapGestureRecognizer *)recognizer
{
    if(recognizer.state != UIGestureRecognizerStateEnded) return;
    
    if(![_menuController.view superview])
    {
        [self.view addSubview:_menuController.view];
        [self.view bringSubviewToFront:_menuController.view];
        self.view.userInteractionEnabled = YES;
        [_delegate onPressSelect:_character.Id];
    }
    else
    {
        [_menuController.view removeFromSuperview];
    }
    
}

// MoveMenuDelegates
- (BOOL) selectedItemChanged:(Move *)move
{
    return [_delegate onMoveSelect:move];
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
        _characterDisplay.textColor = [[change objectForKey:NSKeyValueChangeNewKey] boolValue] ?
                                      [UIColor blackColor] : [UIColor redColor];
    }
    
    if([keyPath isEqual:@"IsTarget"])
    {
        BOOL value =[[change objectForKey:NSKeyValueChangeNewKey] boolValue];
        if(!value && [_menuController.view superview])
        {
            [((MoveMenu*)_menuController.view) clearMove];
            [_menuController.view removeFromSuperview];
        }
    }
    
    if([keyPath isEqual:@"Life"] || [keyPath isEqual:@"Points"])
    {
        _characterDisplay.text = [_character getStats];
    }
}

@end
