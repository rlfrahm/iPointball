//
//  SceneName.m
//  

#import "LoadoutScene.h"
#import "CollectionView.h"

@implementation LoadoutScene {
    NSUserDefaults* defaults;
}
@synthesize iPad;

- (void)onBack: (id) sender {
    /* 
     This is where you choose where clicking 'back' sends you.
     */
    [SceneManager goLevelSelect];
}

- (void)addBackButton {

    if (self.iPad) {
        // Create a menu image button for iPad
        CCMenuItemImage *goBack = [CCMenuItemImage itemFromNormalImage:@"Arrow-Normal-iPad.png" 
                                                         selectedImage:@"Arrow-Selected-iPad.png"
                                                                target:self 
                                                              selector:@selector(onBack:)];
        // Add menu image to menu
        CCMenu *back = [CCMenu menuWithItems: goBack, nil];

        // position menu in the bottom left of the screen (0,0 starts bottom left)
        back.position = ccp(64, 64);
        
        // Add menu to this scene
        [self addChild: back];
    }
    else {
        // Create a menu image button for iPhone / iPod Touch
        CCMenuItemImage *goBack = [CCMenuItemImage itemFromNormalImage:@"Arrow-Normal-iPhone.png" 
                                                         selectedImage:@"Arrow-Selected-iPhone.png"
                                                                target:self 
                                                              selector:@selector(onBack:)];
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
    CCMenuItemFont* marker = [CCMenuItemFont itemWithString:[defaults stringForKey:@"marker_title"] block:^(id sender){
        NSURL* file = [[NSBundle mainBundle] URLForResource:@"upgrades" withExtension:@"plist"];
        NSDictionary* d = [NSDictionary dictionaryWithContentsOfURL:file];
        CollectionView* collection = [[CollectionView alloc] initWithData:[d objectForKey:@"markers"]];
        [collection setPosition:ccp(SCREEN.width/4, SCREEN.height/5)];
        [collection setContentSize:CGSizeMake(SCREEN.width/2, SCREEN.height/2)];
        [self addChild:collection];
    }];
    [marker setFontSize:22];
    CCMenu* menu = [CCMenu menuWithItems:marker, nil];
    [menu setPosition:ccp(SCREEN.width/4, SCREEN.height/2)];
    [self addChild:menu];
}

-(void)buildBarrelLoadout {
    
}

-(void)buildHopperLoadout {
    
}

-(void)buildPodLoadout {
    
}

-(void)buildApparelLoadout {
    
}

- (id)init {
    
    if( (self=[super init])) {

        // Determine Device
        self.iPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;

        // Determine Screen Size
        CGSize screenSize = [CCDirector sharedDirector].winSize;  
        
        // Calculate Large Font Size
        int largeFont = screenSize.height / kFontScaleLarge; 
        
        // Create a label
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"Loadout Scene"
                                               fontName:@"Marker Felt" 
                                               fontSize:largeFont];  
		// Center label
		label.position = ccp( screenSize.width/2, screenSize.height/2);  
        
        // Add label to this scene
		[self addChild:label z:0]; 

        //  Put a 'back' button in the scene
        [self addBackButton];   
        //[self addPlayButton];
        
        defaults = [NSUserDefaults standardUserDefaults];
        [self buildMarkerLoadout];
        [self buildBarrelLoadout];
        [self buildHopperLoadout];
        [self buildPodLoadout];
        [self buildApparelLoadout];
    }
    return self;
}

@end
