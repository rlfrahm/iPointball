//
//  LevelParser.h  <-- RENAME TemplateDataParser
//

@class Levels;  // <-- RENAME TemplateData (NOT to parser)

@interface LevelParser : NSObject {}  // <-- RENAME TemplateDataParser

+ (Levels *)loadLevelsForChapter:(int)chapter;  // <-- RENAME TemplateData
+ (void)saveData:(Levels *)saveData forChapter:(int)chapter;  // <-- RENAME TemplateData

@end