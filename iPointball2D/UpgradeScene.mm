//
//  SceneName.m  <-- RENAME THIS
//  

#import "UpgradeScene.h"
#import "SWMultiColumnTableView.h"
#import "SkillsTable.h"

#define SCREEN [[CCDirector sharedDirector] winSize]
#define isIPad UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
#define DEVICESCALE (isIPad ? 2 : 1)

@implementation UpgradeScene {
    NSUserDefaults* defaults;
    CCLabelTTF *dollarsLabel;
    SWTableView* barrelTable;
    SWTableView* markerTable;
    SWTableView* skillsTable;
    SWTableView* upgradesTable;
    
    BarrelsTable* barrelTableData;
    MarkerTable* markerTableData;
    SkillsTable* skillsTableData;
    UpgradesTable* upgradesTableData;
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
        CCMenuItemImage *goBack = [CCMenuItemImage itemWithNormalImage:@"Arrow-Normal-iPad.png"  selectedImage:@"Arrow-Selected-iPad.png" target:self selector:@selector(onBack:)];
        // Add menu image to menu
        CCMenu *back = [CCMenu menuWithItems: goBack, nil];

        // position menu in the bottom left of the screen (0,0 starts bottom left)
        back.position = ccp(64, 64);
        
        // Add menu to this scene
        [self addChild: back z:1];
    }
    else {
        // Create a menu image button for iPhone / iPod Touch
        CCMenuItemImage *goBack = [CCMenuItemImage itemWithNormalImage:@"Arrow-Normal-iPhone.png"  selectedImage:@"Arrow-Selected-iPhone.png" target:self selector:@selector(onBack:)];
        // Add menu image to menu
        CCMenu *back = [CCMenu menuWithItems: goBack, nil];

        // position menu in the bottom left of the screen (0,0 starts bottom left)
        back.position = ccp(32, 32);

        // Add menu to this scene
        [self addChild: back z:1];
    }
}

#pragma mark Delegates

-(void)didSelectUpgradeAtIndex:(NSUInteger)idx fromUpgrades:(NSMutableArray *)upgrades {
    [productShowroom showUpgradeAtIndex:idx fromUpgrades:upgrades];
}

-(void)markerTableView:(SWTableView *)table didSelectCell:(SWTableViewCell *)cell atIndex:(NSUInteger)idx {
    // Fired from MarkerTable.h
    [productShowroom showMarkerWithIndex:idx];
}

-(void)barrelTableView:(SWTableView *)table didSelectCell:(SWTableViewCell *)cell atIndex:(NSUInteger)idx {
    // Fired from BarrelsTable.h
    [productShowroom showBarrelWithIndex:idx];
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
    // Upgrades table
    upgradesTableData = [[UpgradesTable alloc] init];
    upgradesTableData.delegate = self;
    CGSize tableSize = CGSizeMake(SCREEN.width/2, SCREEN.height*0.7);
    upgradesTable = [SWTableView viewWithDataSource:upgradesTableData size:tableSize];
    upgradesTable.position = ccp(0, SCREEN.height/2 - tableSize.height/2);
    upgradesTable.delegate = upgradesTableData;
    upgradesTable.verticalFillOrder = SWTableViewFillTopDown;
    upgradesTable.direction = SWScrollViewDirectionVertical;
    [self addChild:upgradesTable];
    [self reloadUpgradesTableWithKey:@"markers"];
    
    /*// Player table
    barrelTableData = [[BarrelsTable alloc] init];
    barrelTable = [SWTableView viewWithDataSource:barrelTableData size:tableSize];
    barrelTable.position = ccp(0, SCREEN.height/2 - tableSize.height/2);
    barrelTable.delegate = barrelTableData;
    barrelTable.verticalFillOrder = SWTableViewFillTopDown;
    barrelTable.direction = SWScrollViewDirectionVertical;
    [self addChild:barrelTable];
    [barrelTable reloadData];
    
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
    */
    
    // Tabs for the store
    CCMenuItemFont* marker = [CCMenuItemFont itemWithString:@"Marker" block:^(id sender) {
        [self reloadUpgradesTableWithKey:@"markers"];
    }];
    CCMenuItemFont* barrel = [CCMenuItemFont itemWithString:@"Barrels" block:^(id sender) {
        [self reloadUpgradesTableWithKey:@"barrels"];
    }];
    CCMenuItemFont* hoppers = [CCMenuItemFont itemWithString:@"Hoppers" block:^(id sender) {
        [self reloadUpgradesTableWithKey:@"hoppers"];
    }];
    CCMenuItemFont* pods = [CCMenuItemFont itemWithString:@"Pods" block:^(id sender) {
        [self reloadUpgradesTableWithKey:@"pods"];
    }];
    [barrel setFontSize:18];
    [marker setFontSize:18];
    [hoppers setFontSize:18];
    [pods setFontSize:18];
    
    CCMenu* menu = [CCMenu menuWithItems:marker,barrel,hoppers,pods, nil];
    [menu alignItemsHorizontallyWithPadding:10*DEVICESCALE];
    [menu setPosition:ccp(tableSize.width/2, SCREEN.height - 30)];
    [self addChild:menu z:1];
}

-(void)reloadUpgradesTableWithKey:(NSString*)key {
    NSURL* url = [[NSBundle mainBundle] URLForResource:@"upgrades" withExtension:@"plist"];
    NSDictionary* plistContent = [[NSDictionary alloc] initWithContentsOfURL:url];
    NSArray* content = [[NSArray alloc] initWithArray:[plistContent objectForKey:key]];
    upgradesTableData.upgrades = [content copy];
    [upgradesTable reloadData];
}

-(void)buildProductShowroom {
    productShowroom = [[ProductShowroomLayer alloc] init];
    productShowroom.delegate = self;
    productShowroom.position = ccp(SCREEN.width/2 + 100, 50);
    [productShowroom constructShowroom];
    //[productShowroom showMarkerWithIndex:0];
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
