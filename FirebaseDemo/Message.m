//
//  Message.m
//  FirebaseDemo
//
//  Created by Kshitij Limaye on 6/21/14.
//  Copyright (c) 2014 Praeses. All rights reserved.
//

#import "Message.h"

@implementation Message

-(id)initWithText:(NSString*)text from:(NSString*)from {
    self = [super init];
    if (self) {
        self.text = text;
        self.from = from;
    }
    return self;
}

@end
