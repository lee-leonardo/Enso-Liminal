//
//  SyllableController.m
//  Enso Liminal
//
//  Created by Leonardo Lee on 4/7/15.
//  Copyright (c) 2015 Leonardo Lee. All rights reserved.
//

#import "SyllableController.h"

@interface SyllableController ()

@property (nonatomic, strong) JSVirtualMachine *vm;
@property (nonatomic, strong) JSValue *hyphenatedText;

@end

@implementation SyllableController

#pragma mark - Init
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupQueue];
        [self setupJavascriptExceptionHandler];
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
-(void)setupJavascriptExceptionHandler {
    void (^exceptionHandler)(JSContext*, JSValue*) = ^void(JSContext *context, JSValue *exception) {
        NSLog(@"A javascript error occurred.");
        NSLog(@"Javascript Error: %@", exception);
    };
    
    self.hyphenationEngine.exceptionHandler = exceptionHandler;
}

//TODO: The files for the hyphenation dictory needs to be adjusted to look for the right filepaths.
-(void)setupHyphenationDictionary {
    _vm = [[JSVirtualMachine alloc] init];
    _hyphenationEngine = [[JSContext alloc] init];

    NSBundle *main = [NSBundle mainBundle];
    NSString *hypherPath = [main pathForResource:@"noNodehyper" ofType:@"js"];
    
    //TODO: Do localization.
    NSString *englishLanguagePath = [main pathForResource:@"english" ofType:@"js"];
    
    NSString *hypherScript = [self getScriptWithPath:hypherPath];
    NSString *englishScript = [self getScriptWithPath:englishLanguagePath];
    
    NSString *concatScript = [NSString stringWithFormat:@"%@" "%@", hypherScript, englishScript];
    NSLog(@"%@", concatScript);
    [self loadScript:concatScript];
    
    
    //This demonstrates that even though my script is valid input, there's something wrong in the translation of it into code that the engine can use....
    // Hyphenation
    
    JSValue *hypher = _hyphenationEngine[@"Hyper"];
    JSValue *trie = _hyphenationEngine[@"Hyper.prototype.createTrie"];
    JSValue *hyphenate = _hyphenationEngine[@"Hyper.prototype.hyphenateText"];
    JSValue *english = _hyphenationEngine[@"english"];
    JSValue *h = _hyphenationEngine[@"h"];
    NSLog(@"Context: %@", [_hyphenationEngine.globalObject toObject]);
    NSLog(@"Hyper: %@", hypher);
    NSLog(@"Trie: %@", trie);
    NSLog(@"Hyphenate: %@", hyphenate);
    NSLog(@"English: %@", english);
    NSLog(@"h: %@", h);
    
//    _hyphenationEngine[@"output"] = @"";
    //Listen in on output?
    
    
    //Testing to see if the engine is working... It's receiving the script as text... so it should be working right... I might just pull out the VM and make it a singleton with references to the scripts and create the hyphenation engines as objects owned by the text views, it would simplify the flow a lot.
    
    //Can treat contexts like dictionaries.
    _hyphenationEngine[@"a"] = @5;
    NSLog(@"%d", [_hyphenationEngine[@"a"] toInt32]);
    
    //With scripting
    [_hyphenationEngine evaluateScript:@"a = 10"];
    JSValue *newValue = _hyphenationEngine[@"a"];
    NSLog(@"%d", [newValue toUInt32]);
    
    // Creating a variable.
    [_hyphenationEngine evaluateScript:@"var square = function(x){returnx*x};"];
    JSValue *squareFunc = _hyphenationEngine[@"square"];
    NSLog(@"%@", squareFunc);
    
    // Calling a function with C-level arguments.
    JSValue *fourSquared = [squareFunc callWithArguments:@[@4]];
    NSLog(@"4^2=%@", fourSquared);
    
    
    //Creating a function with a block.
    _hyphenationEngine[@"factorial"] = ^(int x) {
        int factorial = 1;
        for (; x > 1; x--) {
            factorial *= x;
        }
        return factorial;
    };
    [_hyphenationEngine evaluateScript:@"var fiveFactorial = factorial(5)"];
    JSValue *fiveFactorial = _hyphenationEngine[@"fiveFactorial"];
    NSLog(@"5! = %@", fiveFactorial);
    
    
    _hyphenationEngine[@"moduloFive"] = @"function (givenInt) { return givenInt % 5 };";
    NSLog(@"%@", _hyphenationEngine[@"moduloFive"]);
    JSValue *sixteenMod = [_hyphenationEngine evaluateScript:@"var mod5Effect =  moduloFive(16);"]; //This is incorrect
    NSLog(@"16 mod 5 = %@", sixteenMod);
    sixteenMod = _hyphenationEngine[@"mod5Effect"];
    NSLog(@"16 mod 5 = %@", sixteenMod);
    
    //This is my method.
    [self hyphenateText:@"Leonardo Lee"];
    
    
    
}
-(void)setupQueue {
    _syllableQueue = [[NSOperationQueue alloc] init];
    _syllableQueue.name = @"hyphenator";
    _syllableQueue.qualityOfService = NSQualityOfServiceUtility;
    _syllableQueue.maxConcurrentOperationCount = NSOperationQueueDefaultMaxConcurrentOperationCount;
}
-(NSString *)getScriptWithPath:(NSString *)path {
    NSError *error;
    NSData *file = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:&error];
    
    if (error != NULL) {
        NSLog(@"Unlable to load file path: %@\nError Reading File: %@", path, error.localizedDescription);
    } else {
        NSString *js = [NSString stringWithUTF8String:[file bytes]];
        return js;
    }
    return NULL;
}
-(void)loadScript:(NSString *)script {
    [_hyphenationEngine evaluateScript:script];
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
    
    JSValue *script = _hyphenationEngine[@"h"];
    NSString *hyper = [script toString];
    NSLog(@"This should be hyper:\n%@", hyper);
    
    
    NSString *jsMethod = [NSString stringWithFormat:@"var output = h.hyphenateText(%@);", haiku];
    JSValue *output = [_hyphenationEngine evaluateScript:jsMethod];
    
    NSLog(@"Text: %@", haiku);
    NSLog(@"Hyphenated: %@", [output toString]);
}

-(NSUInteger)getSyllableCount {
    _hyphenatedText = _hyphenationEngine[@"output"];
    NSString *hyphenatedString = [_hyphenatedText toString];
    hyphenatedString = [hyphenatedString stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    NSArray *syllables = [hyphenatedString componentsSeparatedByString:@"-"];
    
    return syllables.count;
}


@end
