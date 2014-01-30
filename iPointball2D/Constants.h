//
//  Constants.h
//  
//  This file is used for 'global' variables (constants).  
//  
//  Just ensure you import this header file to use the constants.
//


/*
 Used as a multiplier for calculating font size based on scren size.  Usage: 
 screenSize = [CCDirector sharedDirector].winSize
 fontsize = screenSize.height / kFontScaleLarge;)
*/
#define kFontScaleHuge 6;
#define kFontScaleLarge 9;
#define kFontScaleMedium 10;
#define kFontScaleSmall 12;
#define kFontScaleTiny 14;

#define kFontSizeTiny 12
#define kFontSizeSmall 14
#define kFontSizeMedium 22;

#define SCREEN [[CCDirector sharedDirector] winSize]
#define isIPad UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
#define DEVICESCALE (isIPad ? 2 : 1)

#define PTM_RATIO (isIPad ? 64 : 32)

#define random_range(low,high) (arc4random()%(high-low+1))+low
#define boris_random(smallNumber, bigNumber) ((((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * (bigNumber - smallNumber)) + smallNumber)

#define kCellOpacityDefault 100
#define kCellOpacitySelected 200

#define kProductShowroomSpriteDefaultScale 0.2
#define kLoadoutSpriteDefaultScale 0.1
#define kGameSpriteDefaultScale 1
#define kGameSpriteTenthScale 0.1
#define kGameSpriteTwentiethScale 0.05

#define kCategoryBitsWorld 0x0001
#define kCategoryBitsHumanPlayer 0x0002
#define kCategoryBitsAiPlayer 0x0004
#define kCategoryBitsBunker 0x0008
#define kCategoryBitsAiPaint 0x0016
#define kCategoryBitsHumanPaint 0x0032

#define MIN_NEXT_TO_BUNKER_DISTANCE 338