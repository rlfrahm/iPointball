//
//  Levels.m  // <-- RENAME TemplateData
//

#import "Levels.h"  // <-- RENAME TemplateData

@implementation Levels  // <-- RENAME TemplateData

// Synthesize your variables here, for example: 
@synthesize levels = _levels;

// put your custom init method here which takes a variable 
// for each class instance variable
-(id)init {

    if ((self = [super init])) {

        // Set class instance variables based on values 
        // given to this method
        self.levels = [[[NSMutableArray alloc]init]autorelease];
    }
    return self;
}

- (void) dealloc {
    [super dealloc];
}

@end