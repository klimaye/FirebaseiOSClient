
//
//  PRChatViewController.m
//  FirebaseDemo
//
//  Created by Kshitij Limaye on 6/21/14.
//  Copyright (c) 2014 Praeses. All rights reserved.
//

#import "PRChatViewController.h"
#import <Firebase/Firebase.h>
#import "Message.h"

@interface PRChatViewController ()
@property (nonatomic) Firebase *fbHandle;
@property (nonatomic) NSString *iosUserName;
@property (nonatomic) NSMutableArray *messages;
@property (nonatomic) FirebaseHandle registeredHandle;
@end

@implementation PRChatViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self =
        [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return self;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    Message *msg = [self.messages objectAtIndex:indexPath.row];
    [cell.textLabel setText:msg.text];
    [cell.detailTextLabel setText:msg.from];
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.messages count];
}

- (IBAction)sendTapped:(id)sender {

    NSDictionary *dict = @{@"name": self.iosUserName, @"text": self.messageText.text};
    [[self.fbHandle childByAutoId] setValue:dict];
    [self.messageText setText:@""];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.messages = [[NSMutableArray alloc] init];
    self.fbHandle = [[Firebase alloc] initWithUrl:@"https://YOUR_CHAT_APP_ID.firebaseio.com/chat"];
    self.iosUserName = @"iOS";
    self.registeredHandle =
    [self.fbHandle observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *msgData = snapshot.value;
            if (![msgData isKindOfClass:[NSDictionary class]])
                return;
            Message *msg = [[Message alloc] initWithText:msgData[@"text"] from:msgData[@"name"]];
            [self.messages addObject:msg];
            [self.tableView reloadData];
        });
    }];
}
-(void)viewWillAppear:(BOOL)animated {

    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification*)notification {
    [self moveView:[notification userInfo] up:YES];
}
-(void)keyboardWillHide:(NSNotification*)notification {
    [self moveView:[notification userInfo] up:NO];
}

-(void)moveView:(NSDictionary*)userInfo up:(BOOL)up {
    CGRect keyboardEndFrame;
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    UIViewAnimationCurve animationCurve;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey]
     getValue:&animationCurve];
    
    NSTimeInterval animationDuration;
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]
     getValue:&animationDuration];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    CGRect keyboardFrame = [self.view convertRect:keyboardEndFrame toView:nil];
    int y = keyboardFrame.size.height * (up ? -1 : 1);
    self.view.frame = CGRectOffset(self.view.frame, 0, y);
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.fbHandle removeObserverWithHandle:self.registeredHandle];
    [[NSNotificationCenter defaultCenter]
     removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]
     removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([self.messageText isFirstResponder]) {
        [self.messageText resignFirstResponder];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
