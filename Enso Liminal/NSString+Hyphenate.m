//
//  NSString+Hyphenate.m
//  Enso Liminal
//
//  Created by Leonardo Lee on 5/30/15.
//  Copyright (c) 2015 Leonardo Lee. All rights reserved.
//

#import "NSString+Hyphenate.h"
#include "hyphen.h"

@implementation NSString (Hyphenate)

-(NSString *)hyphenateStringWithLocale:(NSLocale *)locale {
    
    //Right now just copying tupil's work
    //    https://github.com/tupil/hyphenate/blob/master/NSString%2BHyphenate.m
    static HyphenDict *dict;
    static NSString *localeIdentifier;
    static NSBundle *bundle;
    
    CFStringRef language;
    if (locale == nil
        &&
        (language = CFStringTokenizerCopyBestStringLanguage((CFStringRef)self, CFRangeMake(0, [self length])))) {
        locale = [[NSLocale alloc] initWithLocaleIdentifier:localeIdentifier];
        CFRelease(language);
    }
    
    if (locale == nil) {
        return self;
    }
    
    if ([localeIdentifier isEqualToString:[locale localeIdentifier]] && dict != NULL) {
        hnj_hyphen_free(dict);
    }
    
    localeIdentifier = [locale localeIdentifier];
    
    if (bundle == nil) {
        NSString *bundleOath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"languages"];
    }
    
    if (dict == NULL) {
        return self;
    }
    
    //TODO: This Code should go into another method, follow the design of the example.c included with the library proper.
    
    //Weird number... I am going to have a hard cap at 140, so I should set a constant to 140 * 1.2
    NSMutableString * result =  [[NSMutableString alloc] initWithCapacity:[self length] * 1.2];
    
    //String Tokenation
    CFStringTokenizerRef tokenizer;
    CFStringTokenizerTokenType tokenType;
    CFRange tokenRange;
    NSString * token;
    
    //C Level var for hyphenation
    char * hyphens;
    char ** rep;
    int * pos;
    int * cut;
    int wordLength;
    int i;
    
    tokenizer = CFStringTokenizerCreate(kCFAllocatorDefault,
                                        (CFStringRef)self,
                                        CFRangeMake(0, [self length]),
                                        kCFStringTokenizerUnitWordBoundary,
                                        (CFLocaleRef) locale);
    
    while ((tokenType = CFStringTokenizerAdvanceToNextToken(tokenizer)) != kCFStringTokenizerTokenNone) {
        tokenRange = CFStringTokenizerGetCurrentTokenRange(tokenizer);
        token = [self substringWithRange:NSMakeRange(tokenRange.location, tokenRange.length)];
        
        if (tokenType & kCFStringTokenizerTokenHasNonLettersMask) {
            [result appendString:token];
        } else {
            char const * tokenChars = [[token lowercaseString] UTF8String];
            wordLength = strlen(tokenChars);
            
            hyphens = (char *)malloc(wordLength + 5);
            rep = NULL;
            pos = NULL;
            cut = NULL;
            
            hnj_hyphen_hyphenate2(dict, tokenChars, wordLength, hyphens, NULL, &rep, &pos, &cut);
            
            NSUInteger loc = 0;
            NSUInteger len = 0;
            for (i = 0; i < wordLength; i++) {
                if (hyphens[i] & 1) {
                    [result appendString:[token substringWithRange:NSMakeRange(loc, len)]];
                    [result appendString:@""]; //
                    loc = loc + len;
                }
            }
            if (loc < wordLength) {
                [result appendString:[token substringWithRange:NSMakeRange(loc, wordLength - loc)]];
            }
            
            //Clean up
            free(hyphens);
            if (rep) {
                for (i = 0; i < wordLength; i++) {
                    if (rep[i]) free(rep[i]);
                }
                free(rep);
                free(pos);
                free(cut);
                
            }
        }
        
    }
    CFRelease(tokenizer);
    
    return result;
}

@end
