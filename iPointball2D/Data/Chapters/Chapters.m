//
//  Chapters.m
//

#import "Chapters.h"

@implementation Chapters

// Synthesize your variables here, for example: 
@synthesize chapters = _chapters;

// put your custom init method here which takes a variable 
// for each class instance variable
-(id)init {

    if ((self = [super init])) {

        // Set class instance variables based on values 
        // given to this method
        self.chapters = [[[NSMutableArray alloc]init]autorelease];
    }
    return self;
}

- (void) dealloc {
    [super dealloc];
}

@end