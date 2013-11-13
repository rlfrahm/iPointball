//
//  GameDataParser.m
//

#import "GameDataParser.h"
#import "GameData.h"
#import "GDataXMLNode.h"

@implementation GameDataParser

+ (NSString *)dataFilePath:(BOOL)forSave {

    NSString *xmlFileName = @"GameData";
    
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

+ (GameData *)loadData {

    /*************************************************************************** 
     This loadData method is used to load data from the xml file 
     specified in the dataFilePath method above.  

     MODIFY the list of variables below which will be used to create
     and return an instance of TemplateData at the end of this method.
     ***************************************************************************/
    
    int selectedChapter;
    int selectedLevel;
    BOOL sound;
    BOOL music;
    NSString* player;
    NSString* marker;
    int fps;
    int cash;
    int paint;

    // Create NSData instance from xml in filePath
    NSString *filePath = [self dataFilePath:FALSE];
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
    if (doc == nil) { return nil; NSLog(@"xml file is empty!");}
    NSLog(@"Loading %@", filePath);
    
    /*************************************************************************** 
     This next line will usually have the most customisation applied because 
     it will be a direct reflection of what you want out of the XML file.
     ***************************************************************************/
    
    NSArray *dataArray = [doc nodesForXPath:@"//GameData" error:nil];
    NSLog(@"Array Contents = %@", dataArray);
    
    /*************************************************************************** 
     We use dataArray to populate variables created at the start of this 
     method. For each variable you will need to:
        1. Create an array based on the elements in the xml
        2. Assign the variable a value based on data in elements in the xml
     ***************************************************************************/
    
    for (GDataXMLElement *element in dataArray) {
        
        NSArray *selectedChapterArray = [element elementsForName:@"SelectedChapter"];
        NSArray *selectedLevelArray = [element elementsForName:@"SelectedLevel"];
        NSArray *soundArray = [element elementsForName:@"Sound"];
        NSArray *musicArray = [element elementsForName:@"Music"];
        NSArray *playerArray = [element elementsForName:@"Player"];
        NSArray *markerArray = [element elementsForName:@"Marker"];
        NSArray *fpsArray = [element elementsForName:@"FPS"];
        NSArray *cashArray = [element elementsForName:@"Cash"];
        NSArray *paintArray = [element elementsForName:@"Paint"];
        
        // exampleInt
        if (selectedChapterArray.count > 0) {
            GDataXMLElement *selectedChapterElement = (GDataXMLElement *) [selectedChapterArray objectAtIndex:0];
            selectedChapter = [[selectedChapterElement stringValue] intValue];
        } 
   
        // exampleBool    
        if (selectedLevelArray.count > 0) {
            GDataXMLElement *selectedLevelElement = (GDataXMLElement *) [selectedLevelArray objectAtIndex:0];
            selectedLevel = [[selectedLevelElement stringValue] intValue];
        }

        // exampleString
        if (soundArray.count > 0) {
            GDataXMLElement *soundElement = (GDataXMLElement *) [soundArray objectAtIndex:0];
            sound = [[soundElement stringValue] boolValue];
        }
        
        // Music Bool
        if(musicArray.count > 0) {
            GDataXMLElement *musicElement = (GDataXMLElement *) [musicArray objectAtIndex:0];
            music = [[musicElement stringValue] boolValue];
        }
        
        // Player file string
        if(playerArray.count > 0) {
            GDataXMLElement *playerElement = (GDataXMLElement *) [playerArray objectAtIndex:0];
            player = [playerElement stringValue];
        }
        
        // Marker file string
        if(markerArray.count > 0) {
            GDataXMLElement *markerElement = (GDataXMLElement *) [markerArray objectAtIndex:0];
            marker = [markerElement stringValue];
        }
        
        // Marker FPS
        if(fpsArray.count > 0) {
            GDataXMLElement *fpsElement = (GDataXMLElement *) [fpsArray objectAtIndex:0];
            fps = [[fpsElement stringValue] intValue];
        }
        
        if(cashArray.count > 0) {
            GDataXMLElement *cashElement = (GDataXMLElement *) [cashArray objectAtIndex:0];
            fps = [[cashElement stringValue] intValue];
        }
        
        if(paintArray.count > 0) {
            GDataXMLElement *paintElement = (GDataXMLElement *) [paintArray objectAtIndex:0];
            paint = [[paintElement stringValue] intValue];
        }
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
    
    GameData *Data = [[GameData alloc] initWithSelectedChapter:selectedChapter selectedLevel:selectedLevel sound:sound music:music player:player marker:marker fps:fps cash:cash paint:paint];
                                                  
    [doc release];
    [xmlData release];
    return Data;
    [Data release];
}

+ (void)saveData:(GameData *)saveData {
    
   
    /*************************************************************************** 
     This method writes data to the xml based on a TemplateData instance
     You will have to be very aware of the intended xml contents and structure
     as you will be wiping and re-writing the whole xml file.
     
     We write an xml by creating elements and adding 'children' to them.
     
     You'll need to write a line for each element to build the hierarchy // <-- MODIFY CODE ACCORDINGLY
     ***************************************************************************/
    
    GDataXMLElement *gameDataElement = [GDataXMLNode elementWithName:@"GameData"];
   
    GDataXMLElement *selectedChapterElement = [GDataXMLNode elementWithName:@"SelectedChapter"
                                                           stringValue:[[NSNumber numberWithInt:saveData.selectedChapter] stringValue]];

    GDataXMLElement *selectedLevelElement = [GDataXMLNode elementWithName:@"SelectedLevel"
                                                            stringValue:[[NSNumber numberWithBool:saveData.selectedLevel] stringValue]];
    
    GDataXMLElement *soundElement = [GDataXMLNode elementWithName:@"Sound"
                                                              stringValue:[[NSNumber numberWithBool:saveData.sound] stringValue]];
    
    GDataXMLElement *musicElement = [GDataXMLNode elementWithName:@"Music"
                                                      stringValue:[[NSNumber numberWithBool:saveData.music] stringValue]];
    
    GDataXMLElement *playerElement = [GDataXMLNode elementWithName:@"Player" stringValue:saveData.player];
    
    GDataXMLElement *markerElement = [GDataXMLNode elementWithName:@"Marker" stringValue:saveData.marker];
    
    GDataXMLElement *fpsElement = [GDataXMLNode elementWithName:@"FPS" stringValue:[[NSNumber numberWithInt:saveData.fps] stringValue]];
    
    GDataXMLElement *cashElement = [GDataXMLNode elementWithName:@"Cash" stringValue:[[NSNumber numberWithInt:saveData.cash] stringValue]];
    
    GDataXMLElement *paintElement = [GDataXMLNode elementWithName:@"Paint" stringValue:[[NSNumber numberWithInt:saveData.paint] stringValue]];
    
    // Using the elements just created, set up the hierarchy
    [gameDataElement addChild:selectedChapterElement];
    [gameDataElement addChild:selectedLevelElement];
    [gameDataElement addChild:soundElement];
    [gameDataElement addChild:musicElement];
    [gameDataElement addChild:playerElement];
    [gameDataElement addChild:markerElement];
    [gameDataElement addChild:fpsElement];
    [gameDataElement addChild:cashElement];
    [gameDataElement addChild:paintElement];
    GDataXMLDocument *document = [[[GDataXMLDocument alloc] 
                                   initWithRootElement:gameDataElement] autorelease];
   
    NSData *xmlData = document.XMLData;
    
    NSString *filePath = [self dataFilePath:TRUE];
    NSLog(@"Saving data to %@...", filePath);
    [xmlData writeToFile:filePath atomically:YES];
}

@end