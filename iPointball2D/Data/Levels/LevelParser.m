//
//  LevelParser.m
//

#import "LevelParser.h"
#import "Level.h"
#import "Levels.h"
#import "GDataXMLNode.h"

@implementation LevelParser

+ (NSString *)dataFilePath:(BOOL)forSave forChapter:(int)chapter {

    NSString *xmlFileName = [NSString stringWithFormat:@"Levels-Chapter%i",chapter];
    
    /***************************************************************************
     This method is used to set up the specified xml for reading/writing.
     Specify the name of the XML file you want to work with above.
     You don't have to worry about the rest of the code in this method.
     ***************************************************************************/

    NSString *xmlFileNameWithExtension = [NSString stringWithFormat:@"%@.xml",xmlFileName];    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *documentsPath = [documentsDirectory stringByAppendingPathComponent:xmlFileNameWithExtension];
    if (forSave || [[NSFileManager defaultManager] fileExistsAtPath:documentsPath]) {
        return documentsPath;   
        NSLog(@"%@ opened for read/write",documentsPath);
    } else {
        NSLog(@"Created/copied in default %@",xmlFileNameWithExtension);
        return [[NSBundle mainBundle] pathForResource:xmlFileName ofType:@"xml"];
    }    
}

+ (Levels *)loadLevelsForChapter:(int)chapter { // <-- RENAME TemplateData

    /*************************************************************************** 
     This loadData method is used to load data from the xml file 
     specified in the dataFilePath method above.  

     MODIFY the list of variables below which will be used to create
     and return an instance of TemplateData at the end of this method.
     ***************************************************************************/
    
    NSString* name;
    int number;
    BOOL unlocked;
    int stars;
    NSString* data;
    NSMutableArray* enemies = [[[NSMutableArray alloc]init]autorelease];
    NSString* bunker;
    NSString* paint;
    Levels *levels = [[[Levels alloc]init]autorelease];

    // Create NSData instance from xml in filePath
    NSString *filePath = [self dataFilePath:FALSE forChapter:chapter];
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
    if (doc == nil) { return nil; NSLog(@"xml file is empty!");}
    NSLog(@"Loading %@", filePath);
    
    /*************************************************************************** 
     This next line will usually have the most customisation applied because 
     it will be a direct reflection of what you want out of the XML file.
     ***************************************************************************/
    
    NSArray *dataArray = [doc nodesForXPath:@"//Levels/Level" error:nil];
    NSLog(@"Array Contents = %@", dataArray);
    
    /*************************************************************************** 
     We use dataArray to populate variables created at the start of this 
     method. For each variable you will need to:
        1. Create an array based on the elements in the xml
        2. Assign the variable a value based on data in elements in the xml
     ***************************************************************************/
    
    for (GDataXMLElement *element in dataArray) {
        
        NSArray *nameArray = [element elementsForName:@"Name"];
        NSArray *numberArray = [element elementsForName:@"Number"];
        NSArray *unlockedArray = [element elementsForName:@"Unlocked"];
        NSArray *starsArray = [element elementsForName:@"Stars"];
        NSArray *dataArray = [element elementsForName:@"Data"];
        NSArray *enemiesArray = [element elementsForName:@"Enemies"];
        NSArray *bunkerArray = [element elementsForName:@"Bunker"];
        NSArray *paintArray = [element elementsForName:@"Paint"];
        
        // exampleInt
        if (nameArray.count > 0) {
            GDataXMLElement *nameElement = (GDataXMLElement *) [nameArray objectAtIndex:0];
            name = [nameElement stringValue];
        } 
   
        // exampleBool    
        if (numberArray.count > 0) {
            GDataXMLElement *numberElement = (GDataXMLElement *) [numberArray objectAtIndex:0];
            number = [[numberElement stringValue] intValue];
        }

        // exampleString
        if (unlockedArray.count > 0) {
            GDataXMLElement *unlockedElement = (GDataXMLElement *) [unlockedArray objectAtIndex:0];
            unlocked = [[unlockedElement stringValue] boolValue];
        }
        // exampleString
        if (starsArray.count > 0) {
            GDataXMLElement *starsElement = (GDataXMLElement *) [starsArray objectAtIndex:0];
            stars = [[starsElement stringValue] intValue];
        }
        // exampleString
        if (dataArray.count > 0) {
            GDataXMLElement *dataElement = (GDataXMLElement *) [dataArray objectAtIndex:0];
            data = [dataElement stringValue];
        }
        
        if (enemiesArray.count > 0) {
            int i = 0;
            for(GDataXMLElement* enemy in enemiesArray)
            {
                NSArray* enemyArray = [enemy elementsForName:@"Enemy"];
                
                if (enemyArray.count > 0) {
                    GDataXMLElement* enemyElement = (GDataXMLElement *) [enemyArray objectAtIndex:i];
                    [enemies addObject:[enemyElement stringValue]];
                }
                i++;
            }
        }
        
        if (bunkerArray.count > 0) {
            GDataXMLElement *bunkerElement = (GDataXMLElement *) [bunkerArray objectAtIndex:0];
            bunker = [bunkerElement stringValue];
        }
        
        if (paintArray.count > 0) {
            GDataXMLElement *paintElement = (GDataXMLElement *) [paintArray objectAtIndex:0];
            paint = [paintElement stringValue];
        }
        
        Level* level = [[Level alloc] initWithName:name number:number unlocked:unlocked stars:stars data:data enemies:enemies bunker:bunker withPaint:paint];
        
        [levels.levels addObject:level];
    }
    
    /*************************************************************************** 
     Now the variables are populated from xml data we create an instance of
     TemplateData to pass back to whatever called this method.
     
     The initWithExampleInt:exampleBool:exampleString will need to be replaced
     with whatever method you have updaed in the TemplateData class.
     ***************************************************************************/
    
    //NSLog(@"XML value read for exampleInt = %i", exampleInt);
    //NSLog(@"XML value read for exampleBool = %i", exampleBool);
    //NSLog(@"XML value read for exampleString = %@", exampleString);
    
    
                                                  
    [doc release];
    [xmlData release];
    return levels;
}

+ (void)saveData:(Levels *)saveData forChapter:(int)chapter{  // <-- RENAME TemplateData
    
   
    /*************************************************************************** 
     This method writes data to the xml based on a TemplateData instance
     You will have to be very aware of the intended xml contents and structure
     as you will be wiping and re-writing the whole xml file.
     
     We write an xml by creating elements and adding 'children' to them.
     
     You'll need to write a line for each element to build the hierarchy // <-- MODIFY CODE ACCORDINGLY
     ***************************************************************************/
    GDataXMLElement *levelsElement = [GDataXMLNode elementWithName:@"Levels"];
    
    for(Level* level in saveData.levels)
    {
        GDataXMLElement *levelElement = [GDataXMLNode elementWithName:@"Level"];
        
        GDataXMLElement *nameElement = [GDataXMLNode elementWithName:@"Name" stringValue:level.name];
        
        GDataXMLElement *numberElement = [GDataXMLNode elementWithName:@"Number"
                                                                stringValue:[[NSNumber numberWithInt:level.number] stringValue]];
        
        GDataXMLElement *unlockedElement = [GDataXMLNode elementWithName:@"Unlocked"
                                                                  stringValue:[[NSNumber numberWithBool:level.unlocked]stringValue]];
        GDataXMLElement *starsElement = [GDataXMLNode elementWithName:@"Stars" stringValue:[[NSNumber numberWithInt:level.stars]stringValue]];
        
        GDataXMLElement *dataElement = [GDataXMLNode elementWithName:@"Data" stringValue:level.data];
        
        GDataXMLElement *enemiesElement = [GDataXMLNode elementWithName:@"Enemies"];
        
        GDataXMLElement *bunkerElement = [GDataXMLNode elementWithName:@"Bunker"];
        
        GDataXMLElement *paintElement = [GDataXMLNode elementWithName:@"Paint"];
        
        for(id enemy in level.enemies)
        {
            GDataXMLElement *enemyElement = [GDataXMLNode elementWithName:@"Enemy"];
            [enemiesElement addChild:enemyElement];
        }
        
        // Using the elements just created, set up the hierarchy
        [levelElement addChild:nameElement];
        [levelElement addChild:numberElement];
        [levelElement addChild:unlockedElement];
        [levelElement addChild:starsElement];
        [levelElement addChild:dataElement];
        [levelElement addChild:bunkerElement];
        [levelElement addChild:paintElement];
        [levelsElement addChild:levelElement];
    }
    
    
    
    
    GDataXMLDocument *document = [[[GDataXMLDocument alloc] 
                                   initWithRootElement:levelsElement] autorelease];
   
    NSData *xmlData = document.XMLData;
    
    NSString *filePath = [self dataFilePath:TRUE forChapter:chapter];
    NSLog(@"Saving data to %@...", filePath);
    [xmlData writeToFile:filePath atomically:YES];
}

@end