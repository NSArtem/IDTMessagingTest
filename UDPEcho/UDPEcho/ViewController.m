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
    // Do any additional setup after loading the view, typically from a nib.
    self.client = [UDPEchoClient new];
    NSError *error;

    [self.client setupUDPClient:&error];
    self.client.receivedMessage = ^(NSString *text) {
        [self.messages addObject:[Message message:text isRecived:true]];
        [self.tableView reloadData];
    };
    
    [self.client sendString:@"Hello!" error:&error];
    [self.messages addObject:[Message message:@"Hello" isRecived:false]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sendButtonPressed:(id)sender {
    NSError *error;

    [self.client sendString:self.textField.text error:&error];
    [self.messages addObject:[Message message:self.textField.text isRecived:false]];
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
