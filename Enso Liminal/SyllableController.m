//
//  SyllableController.m
//  Enso Liminal
//
//  Created by Leonardo Lee on 4/7/15.
//  Copyright (c) 2015 Leonardo Lee. All rights reserved.
//

#import "SyllableController.h"

@interface SyllableController ()

@property (nonatomic, strong) JSValue *hyphenatedText;

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
    
    
    //TODO: Fix
    JSValue *result = [_hyphenationEngine evaluateScript:@"var kumon = h.hyphenateText('Architeryles')"];
    NSLog(@"Returned Result: %i", [result toInt32]);
    NSLog(@"Kumon Text: %@", _hyphenationEngine[@"kumon"]);
    
    JSValue *huh = [_hyphenationEngine evaluateScript:@"h"];
    NSLog(@"%@", huh);
    
    
    result = [_hyphenationEngine evaluateScript:@"h.hyphenateText('Architeryles')"];
    NSLog(@"Returned Result: %@", [result toString]);
    
    
    [_hyphenationEngine evaluateScript:@"a = 10"];
    JSValue *newVal = _hyphenationEngine[@"a"];
    NSLog(@"New Value Integer: %i", [newVal toInt32]);
    
    
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
    NSLog(@"Loading Script: %@\n%@", path, [file bytes]);
    
    if (error != NULL) {
        NSLog(@"Unlable to load file path: %@\nError Reading File: %@", path, error.localizedDescription);
    } else {
        NSString *js = [NSString stringWithUTF8String:[file bytes]];
        [_hyphenationEngine evaluateScript: js];
    }
}

#pragma mark - Notification Center
-(void)startListeningForPosts {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserverForName:EL_Haiku_Post object:self queue:_syllableQueue usingBlock:^(NSNotification *note) {
        NSDictionary *latestPost = [note userInfo];
        NSString *haikuPosted = latestPost[@"haiku"];
        
        [self hyphenateText:haikuPosted];
    }];
    
}

-(void)stopListeningForPosts {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self name:EL_Haiku_Post object:nil];
}

#pragma mark - Hyphenation and Syllables
#pragma mark External Interface
-(void)receivedText:(NSString *)toHyphenate {
    [_syllableQueue cancelAllOperations];
    [_syllableQueue addOperationWithBlock:^{
        [self hyphenateText:toHyphenate];
    }];
}

#pragma mark Interacts with JavascriptCore
-(void)hyphenateText:(NSString *)haiku {
    NSString *jsMethod = [NSString stringWithFormat:@"var output = h.hyphenateText(%@)", haiku];
    [_hyphenationEngine evaluateScript:jsMethod];
    
}

-(NSUInteger)getSyllableCount {
    _hyphenatedText = _hyphenationEngine[@"output"];
    NSString *hyphenatedString = [_hyphenatedText toString];
    hyphenatedString = [hyphenatedString stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    NSArray *syllables = [hyphenatedString componentsSeparatedByString:@"-"];
    
    return syllables.count;
}


@end
