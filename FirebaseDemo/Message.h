//
//  Message.h
//  FirebaseDemo
//
//  Created by Kshitij Limaye on 6/21/14.
//  Copyright (c) 2014 Praeses. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject {
    
}
-(id)initWithText:(NSString*)text from:(NSString*)from;
@property (nonatomic) NSString *from;
@property (nonatomic) NSString *text;

@end
