//
//  HaikuTextView.m
//  Enso Liminal
//
//  Created by Leonardo Lee on 4/25/15.
//  Copyright (c) 2015 Leonardo Lee. All rights reserved.
//

#import "HaikuTextView.h"

@implementation HaikuTextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (HaikuTextView *)init
{
    self = [super init];
    if (self) {
        self.count = 0;
    }
    return self;
}

-(HaikuTextView *)initWithFrame:(CGRect)frame {
    self = [self init];
    
    CGFloat ratio = frame.size.height / frame.size.width;
    CGFloat golden = ratio / (5/7); //This is just an experiment.
    
    self.frame = frame;
    self.layer.cornerRadius = golden;
    self.layer.masksToBounds = YES;
    
    return self;
}

@end
