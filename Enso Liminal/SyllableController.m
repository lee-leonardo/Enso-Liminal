//
//  SyllableController.m
//  Enso Liminal
//
//  Created by Leonardo Lee on 4/7/15.
//  Copyright (c) 2015 Leonardo Lee. All rights reserved.
//

#import "SyllableController.h"

@protocol SyllableControllerDelegate <NSObject>

-(void)sendStringToHyphenate:(NSString *)toHyphenate;
-(void)listenForSyllableCount;

@end

@implementation SyllableController

#pragma mark - Init
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupQueue];
        [self setupHyphenationDictionary];
    }
    return self;
}

+(id)sharedInstance {
    static SyllableController *syllableCounter;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        syllableCounter = [[self alloc] init];
    });
    
    return syllableCounter;
}

#pragma mark - Setup
//TODO: The files for the hyphenation dictory needs to be adjusted to look for the right filepaths.
-(void)setupHyphenationDictionary {
    _vm = [[JSVirtualMachine alloc] init];
    _hyphenationEngine = [[JSContext alloc] init];
    
    NSBundle *main = [NSBundle mainBundle];
    NSString *bundlePath = main.bundlePath;
    NSLog(@"%@", bundlePath);
    
    NSLog(@"%@", [main pathsForResourcesOfType:nil inDirectory:@"."]);
    
    
    
    NSString *hypherFile = [[NSBundle mainBundle] pathForResource:@"noNodehypher" ofType:@"js" inDirectory:@"."];
    NSLog(@"%@", hypherFile);
    
    NSString *englishLanguage = [[NSBundle mainBundle] pathForResource:@"english" ofType:@"js" inDirectory:@"."];
    
    NSLog(@"%@", englishLanguage);
    
    //Refactor this out.
//    NSError *error = [[NSError alloc] init];
//    NSData *hyperFile = [NSData dataWithContentsOfFile:@"js/noNode_hypher.js" options:NSDataReadingMappedIfSafe error:&error];
//    if (error != nil) {
//        NSLog(@"Error Reading File: %@", error.localizedDescription);
//    }
//    NSString *hypher = [NSString stringWithUTF8String:[hyperFile bytes]] ;
//    [_hyphenationEngine evaluateScript:hypher];
//    
//    NSData *englishFile = [NSData dataWithContentsOfFile:@"js/english" options:NSDataReadingMappedIfSafe error:&error];
//    if (error != nil) {
//        NSLog(@"Error Reading File: %@", error.localizedDescription);
//    }
//    NSString *english = [NSString stringWithUTF8String:[englishFile bytes]];
//    [_hyphenationEngine evaluateScript:english];
    
}
-(void)setupQueue {
    _syllableQueue = [[NSOperationQueue alloc] init];
    _syllableQueue.name = @"hyphenator";
    _syllableQueue.qualityOfService = NSQualityOfServiceUtility;
    _syllableQueue.maxConcurrentOperationCount = NSOperationQueueDefaultMaxConcurrentOperationCount;
}
-(void)loadScriptWithPath:(NSString *)path {
    NSError *error;
    NSData *file = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:&error];
    
    if (error != NULL) {
        NSLog(@"Error Reading File: %@", error.localizedDescription);
    } else {
//        file
        NSString *js = [NSString stringWithUTF8String:[file bytes]];
        [_hyphenationEngine evaluateScript: js];
    }

}

#pragma mark - Hyphenation and Syllables
#pragma mark External Interface
-(void)receivedText:(NSString *)toHyphenate {
    [_syllableQueue cancelAllOperations];
    [_syllableQueue addOperationWithBlock:^{
        [self hyphenateText:toHyphenate];
    }];
}

-(void)broadCastSyllableCount {
//    [self performSelector:@(getSyllableCount) withObject:nil afterDelay:2.0];
}

#pragma mark Interacts with JavascriptCore
-(void)hyphenateText:(NSString *)haiku {
    NSString *jsMethod = [NSString stringWithFormat:@"var output = h.hyphenateText(%@)", haiku];
    [_hyphenationEngine evaluateScript:jsMethod];
    
}

-(NSUInteger)getSyllableCount {
    JSValue *retrieveString = _hyphenationEngine[@"output"];
    NSString *hyphenatedString = [retrieveString toString];
    hyphenatedString = [hyphenatedString stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    NSArray *syllables = [hyphenatedString componentsSeparatedByString:@"-"];
    
    return syllables.count;
}


@end
