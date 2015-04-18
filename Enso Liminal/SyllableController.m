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

+(SyllableController *)sharedInstance {
    static SyllableController *syllableCounter;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        syllableCounter = [[SyllableController alloc] init];
    });
    
    return syllableCounter;
}

#pragma mark - Setup
//TODO: Need to work on porting over the Javascript library into the syllable counter.
-(void)setupHyphenationDictionary {
    _vm = [[JSVirtualMachine alloc] init];
    _hyphenationEngine = [[JSContext alloc] init];
    NSError *error = [[NSError alloc] init];
    
    NSData *hyperFile = [NSData dataWithContentsOfFile:@"js/noNode_hypher.js" options:NSDataReadingMappedIfSafe error:&error];
    if (error != nil) {
        NSLog(@"Error Reading File: %@", error.localizedDescription);
    }
    NSString *hypher = [NSString stringWithUTF8String:[hyperFile bytes]] ;
    [_hyphenationEngine evaluateScript:hypher];
    
    NSData *englishFile = [NSData dataWithContentsOfFile:@"js/english" options:NSDataReadingMappedIfSafe error:&error];
    if (error != nil) {
        NSLog(@"Error Reading File: %@", error.localizedDescription);
    }
    NSString *english = [NSString stringWithUTF8String:[englishFile bytes]];
    [_hyphenationEngine evaluateScript:english];
    
    NSString *initHyphenation = [NSString stringWithFormat:@""];
    
}
-(void)setupQueue {
    _syllableQueue = [[NSOperationQueue alloc] init];
    _syllableQueue.name = @"hyphenator";
    _syllableQueue.qualityOfService = NSQualityOfServiceUtility;
    _syllableQueue.maxConcurrentOperationCount = NSOperationQueueDefaultMaxConcurrentOperationCount;
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
