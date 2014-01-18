//
//  SceneName.m
//  

#import "LoadoutScene.h"

@implementation LoadoutScene {
    NSUserDefaults* defaults;
    NSDictionary* plistContents;
}
@synthesize iPad, marker, barrel, hopper, pod;

- (void)onBack: (id) sender {
    /* 
     This is where you choose where clicking 'back' sends you.
     */
    [SceneManager goLevelSelect];
}

- (void)addBackButton {

    if (isIPad) {
        // Create a menu image button for iPad
        CCMenuItemImage *goBack = [CCMenuItemImage itemWithNormalImage:@"Arrow-Normal-iPad.png"  selectedImage:@"Arrow-Selected-iPad.png" target:self selector:@selector(onBack:)];
        // Add menu image to menu
        CCMenu *back = [CCMenu menuWithItems: goBack, nil];

        // position menu in the bottom left of the screen (0,0 starts bottom left)
        back.position = ccp(64, 64);
        
        // Add menu to this scene
        [self addChild: back];
    }
    else {
        // Create a menu image button for iPhone / iPod Touch
        CCMenuItemImage *goBack = [CCMenuItemImage itemWithNormalImage:@"Arrow-Normal-iPhone.png"  selectedImage:@"Arrow-Selected-iPhone.png" target:self selector:@selector(onBack:)];
        // Add menu image to menu
        CCMenu *back = [CCMenu menuWithItems: goBack, nil];

        // position menu in the bottom left of the screen (0,0 starts bottom left)
        back.position = ccp(32, 32);

        // Add menu to this scene
        [self addChild: back];        
    }
}

-(void)addPlayButton {
    CCMenuItemFont* play = [CCMenuItemFont itemWithString:@"Play" block:^(id sender){
        [SceneManager goGameScene];
    }];
    CCMenu* menu = [CCMenu menuWithItems:play, nil];
    [menu setPosition:ccp(SCREEN.height - 50, 20)];
    [self addChild:menu];
}

-(void)buildMarkerLoadout {
    marker = [CCMenuItemFont itemWithString:[defaults stringForKey:@"marker_title"] block:^(id sender){
        CollectionView* collection = [[CollectionView alloc] initWithData:[[self loadPlistData] objectForKey:@"markers"]];
        collection.delegate = self;
        collection.type = @"markers";
        [collection setPosition:ccp(SCREEN.width/4, SCREEN.height/5)];
        [collection setContentSize:CGSizeMake(SCREEN.width/2, SCREEN.height/2)];
        [self addChild:collection];
        marker.isEnabled = NO;
        barrel.isEnabled = NO;
        hopper.isEnabled = NO;
        pod.isEnabled = NO;
    }];
    [marker setFontSize:22];
    CCMenu* menu = [CCMenu menuWithItems:marker, nil];
    [menu setPosition:ccp(SCREEN.width/6, SCREEN.height/2)];
    [self addChild:menu];
}

-(void)buildBarrelLoadout {
    barrel = [CCMenuItemFont itemWithString:@"Barrel 1" block:^(id sender){
        CollectionView* collection = [[CollectionView alloc] initWithData:[[self loadPlistData] objectForKey:@"barrels"]];
        collection.delegate = self;
        collection.type = @"barrels";
        [collection setPosition:ccp(SCREEN.width/4, SCREEN.height/5)];
        [collection setContentSize:CGSizeMake(SCREEN.width/2, SCREEN.height/2)];
        [self addChild:collection];
        marker.isEnabled = NO;
        barrel.isEnabled = NO;
        hopper.isEnabled = NO;
        pod.isEnabled = NO;
    }];
    [barrel setFontSize:22];
    CCMenu* menu = [CCMenu menuWithItems:barrel, nil];
    [menu setPosition:ccp(SCREEN.width/2.5, SCREEN.height/2)];
    [self addChild:menu];
}

-(void)buildHopperLoadout {
    hopper = [CCMenuItemFont itemWithString:[defaults stringForKey:@"hopper_title"] block:^(id sender){
        CollectionView* collection = [[CollectionView alloc] initWithData:[[self loadPlistData] objectForKey:@"hoppers"]];
        collection.delegate = self;
        collection.type = @"hoppers";
        [collection setPosition:ccp(SCREEN.width/4, SCREEN.height/5)];
        [collection setContentSize:CGSizeMake(SCREEN.width/2, SCREEN.height/2)];
        [self addChild:collection];
        marker.isEnabled = NO;
        barrel.isEnabled = NO;
        hopper.isEnabled = NO;
        pod.isEnabled = NO;
    }];
    [hopper setFontSize:22];
    CCMenu* menu = [CCMenu menuWithItems:hopper, nil];
    [menu setPosition:ccp(SCREEN.width/1.5, SCREEN.height/2)];
    [self addChild:menu];
}

-(void)buildPodLoadout {
    pod = [CCMenuItemFont itemWithString:[defaults stringForKey:@"pods_title"] block:^(id sender){
        CollectionView* collection = [[CollectionView alloc] initWithData:[[self loadPlistData] objectForKey:@"pods"]];
        collection.delegate = self;
        collection.type = @"pods";
        [collection setPosition:ccp(SCREEN.width/4, SCREEN.height/5)];
        [collection setContentSize:CGSizeMake(SCREEN.width/2, SCREEN.height/2)];
        [self addChild:collection];
        marker.isEnabled = NO;
        barrel.isEnabled = NO;
        hopper.isEnabled = NO;
        pod.isEnabled = NO;
    }];
    [pod setFontSize:22];
    CCMenu* menu = [CCMenu menuWithItems:pod, nil];
    [menu setPosition:ccp(SCREEN.width/1.1, SCREEN.height/2)];
    [self addChild:menu];
}

-(void)buildApparelLoadout {
    
}

-(void)cellTouchedAtIndex:(NSUInteger)idx andType:(NSString *)type{
    defaults = [NSUserDefaults standardUserDefaults];
    if([type isEqualToString:@"markers"]) {
        NSLog(@"%@", [defaults stringForKey:@"marker_title"]);
        [marker setString:[defaults stringForKey:@"marker_title"]];
    } else if([type isEqualToString:@"barrels"]) {
        [barrel setString:[defaults stringForKey:@"barrel_title"]];
    } else if([type isEqualToString:@"hoppers"]) {
        [hopper setString:[defaults stringForKey:@"hopper_title"]];
    } else if([type isEqualToString:@"pods"]) {
        [pod setString:[defaults stringForKey:@"pods_title"]];
    }
    marker.isEnabled = YES;
    barrel.isEnabled = YES;
    hopper.isEnabled = YES;
    pod.isEnabled = YES;
}

-(NSDictionary*)loadPlistData {
    NSURL* url = [[NSBundle mainBundle] URLForResource:@"upgrades" withExtension:@"plist"];
    return [NSDictionary dictionaryWithContentsOfURL:url];
}

- (id)init {
    
    if( (self=[super initWithColor:ccc4(97, 180, 207, 255)])) {

        // Determine Device
        self.iPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;

        //  Put a 'back' button in the scene
        [self addBackButton];   
        //[self addPlayButton];
        
        defaults = [NSUserDefaults standardUserDefaults];
        plistContents = [self loadPlistData];
        [self buildMarkerLoadout];
        [self buildBarrelLoadout];
        [self buildHopperLoadout];
        [self buildPodLoadout];
        [self buildApparelLoadout];
    }
    return self;
}

@end
