//
//  SceneName.m  <-- RENAME THIS
//  

#import "UpgradeScene.h"
#import "SWMultiColumnTableView.h"
#import "PlayerTable.h"
#import "MarkerTable.h"
#import "SkillsTable.h"
#import "ProductShowroomLayer.h"

#define SCREEN [[CCDirector sharedDirector] winSize]
#define isIPad UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
#define DEVICESCALE (isIPad ? 2 : 1)

@implementation UpgradeScene {
    NSUserDefaults* defaults;
    CCLabelTTF *dollarsLabel;
    SWTableView* playerTable;
    SWTableView* markerTable;
    SWTableView* skillsTable;
    
    PlayerTable* playerTableData;
    MarkerTable* markerTableData;
    SkillsTable* skillsTableData;
    
    ProductShowroomLayer* productShowroom;
}
@synthesize iPad;

- (void)onBack: (id) sender {
    /* 
     This is where you choose where clicking 'back' sends you.
     */
    //[SceneManager goMainMenu];
    [SceneManager goMainMenu];
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
        [self addChild: back z:1];
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
        [self addChild: back z:1];
    }
}

#pragma mark Delegates

-(void)markerTableView:(SWTableView *)table didSelectCell:(SWTableViewCell *)cell atIndex:(NSUInteger)idx {
    // Fired from MarkerTable.h
    [productShowroom showMarkerWithIndex:idx];
}

-(void)buyItemAtIndex:(NSUInteger)idx andNetDollars:(int)dollars {
    // Fired from ProductShowroomLayer.h
    [dollarsLabel setString:[NSString stringWithFormat:@"$%i", dollars]];
    [markerTable reloadData];
}

-(void)sellItemAtIndex:(NSUInteger)idx andNetDollars:(int)dollars {
    [dollarsLabel setString:[NSString stringWithFormat:@"$%i", dollars]];
    [markerTable reloadData];
}

#pragma mark Initialization

- (void)buildUpgradeMenu {
    // Player table
    playerTableData = [[PlayerTable alloc] init];
    CGSize tableSize = CGSizeMake(SCREEN.width/2, SCREEN.height*0.7);
    playerTable = [SWTableView viewWithDataSource:playerTableData size:tableSize];
    playerTable.position = ccp(0, SCREEN.height/2 - tableSize.height/2);
    playerTable.delegate = playerTableData;
    playerTable.verticalFillOrder = SWTableViewFillTopDown;
    playerTable.direction = SWScrollViewDirectionVertical;
    [self addChild:playerTable];
    [playerTable reloadData];
    
    // Marker table
    markerTableData = [[MarkerTable alloc] init];
    markerTableData.delegate = self;
    markerTable = [SWTableView viewWithDataSource:markerTableData size:tableSize];
    markerTable.position = ccp(0, SCREEN.height/2 - tableSize.height/2);
    markerTable.delegate = markerTableData;
    markerTable.verticalFillOrder = SWTableViewFillTopDown;
    markerTable.direction = SWScrollViewDirectionVertical;
    [self addChild:markerTable];
    [markerTable reloadData];
    markerTable.visible = NO;
    
    // Skills table
    skillsTableData = [[SkillsTable alloc] init];
    skillsTable = [SWTableView viewWithDataSource:skillsTableData size:tableSize];
    skillsTable.position = ccp(0, SCREEN.height/2 - tableSize.height/2);
    skillsTable.delegate = skillsTableData;
    skillsTable.verticalFillOrder = SWTableViewFillTopDown;
    skillsTable.direction = SWScrollViewDirectionVertical;
    [self addChild:skillsTable];
    [skillsTable reloadData];
    skillsTable.visible = NO;
    
    // Tabs for the store
    CCMenuItemFont* player = [CCMenuItemFont itemWithString:@"Apparel" block:^(id sender) {
        playerTable.visible = YES;
        markerTable.visible = NO;
        skillsTable.visible = NO;
    }];
    CCMenuItemFont* marker = [CCMenuItemFont itemWithString:@"Marker" block:^(id sender) {
        playerTable.visible = NO;
        markerTable.visible = YES;
        skillsTable.visible = NO;
    }];
    CCMenuItemFont* skills = [CCMenuItemFont itemWithString:@"Skills" block:^(id sender) {
        playerTable.visible = NO;
        markerTable.visible = NO;
        skillsTable.visible = YES;
    }];
    [player setFontSize:22];
    [marker setFontSize:22];
    [skills setFontSize:22];
    
    CCMenu* menu = [CCMenu menuWithItems:player,marker,skills, nil];
    [menu alignItemsHorizontallyWithPadding:20*DEVICESCALE];
    [menu setPosition:ccp(tableSize.width/2, SCREEN.height - 30)];
    [self addChild:menu z:1];
}

-(void)buildProductShowroom {
    productShowroom = [[ProductShowroomLayer alloc] init];
    productShowroom.delegate = self;
    productShowroom.position = ccp(SCREEN.width/2 + 100, 50);
    [productShowroom constructShowroom];
    [productShowroom showMarkerWithIndex:0];
    [self addChild:productShowroom z:2];
}

- (id)init {
    
    if( (self=[super initWithColor:ccc4(97, 180, 207, 255)])) {
        
        // Determine Screen Size
        CGSize screenSize = [CCDirector sharedDirector].winSize;  
        
        // Calculate Large Font Size
        int largeFont = screenSize.height / kFontScaleTiny;
        
        defaults = [NSUserDefaults standardUserDefaults];
        
        // Create a label
        dollarsLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"$%i",[defaults integerForKey:@"player_dollars"]] fontName:@"Marker Felt" fontSize:largeFont];
        
		// Center label
		dollarsLabel.position = ccp( screenSize.width - 100, screenSize.height - 15);
        // Add label to this scene
		[self addChild:dollarsLabel z:0];

        [self buildUpgradeMenu];
        [self buildProductShowroom];
        //  Put a 'back' button in the scene
        [self addBackButton];
    }
    return self;
}

@end
