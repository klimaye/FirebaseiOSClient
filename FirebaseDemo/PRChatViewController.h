//
//  PRChatViewController.h
//  FirebaseDemo
//
//  Created by Kshitij Limaye on 6/21/14.
//  Copyright (c) 2014 Praeses. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PRChatViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
    
}

@property (nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) IBOutlet UITextField *messageText;
@property (nonatomic) IBOutlet UIButton *sendButton;
-(IBAction)sendTapped:(id)sender;
@end
