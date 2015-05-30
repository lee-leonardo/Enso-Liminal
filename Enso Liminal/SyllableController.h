//
//  SyllableController.h
//  Enso Liminal
//
//  Created by Leonardo Lee on 4/7/15.
//  Copyright (c) 2015 Leonardo Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface SyllableController : NSObject

@property (nonatomic, strong) NSOperationQueue *syllableQueue;

+(SyllableController *)sharedInstance;

//-(NSUInteger)getSyllableCount;
-(void)startListeningForPosts;
-(void)stopListeningForPosts;

@end
