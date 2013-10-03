//
//  Chapters.h
//

#import <Foundation/Foundation.h>

@interface Chapters : NSObject {  // <-- RENAME TemplateData

    // Declare variables with an underscore in front, for example:
    NSMutableArray* _chapters;
}

// Declare your variable properties without an underscore, for example:
@property (nonatomic, retain) NSMutableArray* chapters;

@end
