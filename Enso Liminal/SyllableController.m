//
//  SyllableController.m
//  Enso Liminal
//
//  Created by Leonardo Lee on 4/7/15.
//  Copyright (c) 2015 Leonardo Lee. All rights reserved.
//

#import "SyllableController.h"

@implementation SyllableController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _vm = [[JSVirtualMachine alloc] init];
        _hyphenationEngine = [[JSContext alloc] init];

        [self setupHyphenationDictionary];
    }
    return self;
}

+(SyllableController *)sharedInstance {
    static SyllableController *syllableCounter;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        syllableCounter = [[SyllableController alloc] init];
    });
    
    return syllableCounter;
}

//TODO: Need to work on porting over the Javascript library into the syllable counter.
-(void)setupHyphenationDictionary {
//    _hyphenationEngine[@"hyphenation"] =
    
    NSError *error = [[NSError alloc] init];
    NSData *hyperFile = [NSData dataWithContentsOfFile:@"js/noNode_hypher.js" options:NSDataReadingMappedIfSafe error:&error];
    if (error != nil) {
        NSLog(@"Error Reading File: %@", error.localizedDescription);
    }
    
    NSString *hypher = [NSString stringWithUTF8String:[hyperFile bytes]] ;
    [_hyphenationEngine evaluateScript:hypher];
    
    //
    NSData *englishFile = [NSData dataWithContentsOfFile:@"js/english" options:NSDataReadingMappedIfSafe error:&error];
    if (error != nil) {
        NSLog(@"Error Reading File: %@", error.localizedDescription);
    }
    NSString *english = [NSString stringWithUTF8String:[englishFile bytes]];
    [_hyphenationEngine evaluateScript:english];
    
}

-(void)hyphenateText:(NSString *)haiku {
    
    NSString *jsMethod = [NSString stringWithFormat:@"var hyphenated = hyphenation.hyphenateString(%@)", haiku];
    [_hyphenationEngine evaluateScript:jsMethod];
    
}



@end
