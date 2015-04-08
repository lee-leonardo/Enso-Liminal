//
//  SyllableController.h
//  Enso Liminal
//
//  Created by Leonardo Lee on 4/7/15.
//  Copyright (c) 2015 Leonardo Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface SyllableController : NSObject
@property (nonatomic, strong) JSContext *hyphenationEngine;

@end
