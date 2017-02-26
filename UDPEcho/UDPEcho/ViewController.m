//
//  ViewController.m
//  UDPEcho
//
//  Created by Artem Abramov on 25/02/2017.
//  Copyright © 2017 Artem Abramov. All rights reserved.
//

#import "ViewController.h"
#import "UDPEchoClient.h"

@interface Message : NSObject
@property (nonatomic, assign) BOOL isReceived;
@property (nonatomic, copy) NSString *text;
@end

@implementation Message

+ (instancetype)message:(NSString *)text isRecived:(BOOL)isReceived{
    Message *message = [[self alloc] init];
    message.isReceived = isReceived;
    message.text = text;
    return message;
}

@end

@interface ViewController () <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UDPEchoClient *client;

@property (nonatomic, strong) NSMutableArray<Message*> *messages;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.messages = [NSMutableArray array];
    self.client = [UDPEchoClient new];
    
    NSError *error;
    [self.client setupUDPClient:&error];
    if (error) {
        [self showError:error];
    }
    
    __weak typeof(self) weakSelf = self;
    self.client.receivedMessage = ^(NSString *text) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf.messages addObject:[Message message:text isRecived:true]];
        [strongSelf.tableView reloadData];
    };
    
    [self sendText:@"Hello!"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Please make sure that the python.py from the project folder is being run" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    [self presentViewController:alertController animated:true completion:nil];
}

- (IBAction)sendButtonPressed:(id)sender {
    [self sendText:self.textField.text];
}

- (void)sendText:(NSString *)text {
    NSError *error;
    [self.client sendString:text error:&error];
    if (error) {
        [self showError:error];
        return;
    }
    [self.messages addObject:[Message message:text isRecived:false]];
}

- (void)showError:(NSError *)error {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    [self presentViewController:alertController animated:true completion:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Message *message = self.messages[(self.messages.count - 1) - indexPath.row];
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"cell"];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = message.text;
    cell.textLabel.textColor = message.isReceived ? [UIColor redColor] : [UIColor greenColor];
    
    return cell;
}

@end
