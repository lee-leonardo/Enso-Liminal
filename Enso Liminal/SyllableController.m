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
    NSString *hypherPath = [main pathForResource:@"noNodehyper" ofType:@"js"];
    
    //TODO: Do localization.
    NSString *englishLanguagePath = [main pathForResource:@"english" ofType:@"js"];
    
    [self loadScriptWithPath:hypherPath];
    [self loadScriptWithPath:englishLanguagePath];
    
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
