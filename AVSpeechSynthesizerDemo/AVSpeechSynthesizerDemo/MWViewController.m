//
//  MWViewController.m
//  
//
//  Created by zhangqi on 25/8/2016.
//
//

#import "MWViewController.h"
#import "MWBubbleCell.h"

@interface MWViewController () <AVSpeechSynthesizerDelegate>
@property (nonatomic,strong) AVSpeechSynthesizer *synthesizer;
@property (strong, nonatomic) NSArray *voices;
@property (strong, nonatomic) NSMutableArray *speechStrings;
@end

@implementation MWViewController

- (AVSpeechSynthesizer *)synthesizer
{
    if (!_synthesizer) {
        _synthesizer = [[AVSpeechSynthesizer alloc] init];
    }
    return _synthesizer;
}

- (NSArray *)voices
{
    if (!_voices) {
        _voices = @[[AVSpeechSynthesisVoice voiceWithLanguage:@"en-US"],
                    [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-Hans-CN"]
                    ];
    }
    return _voices;
}

- (NSMutableArray *)speechStrings
{
    if (!_speechStrings) {
//        _speechStrings = @[@"Hello boys,How are you?",
//                           @"你好。",
//                           @"What are you doing?",
//                           @"我正在看书。",
//                           @"What's your favorite book?",
//                           @"AVFoundation",
//                           @"What's your favorite feature?",
//                           @"我什么都喜欢，我想我深深爱上了它。",
//                           @"OK,Have fun!"
//                           ];
        _speechStrings = [NSMutableArray arrayWithArray:@[@"Hello boys,How are you?",
                                                          @"你好。",
                                                          @"What are you doing?",
                                                          @"我正在看书。",
                                                          @"What's your favorite book?",
                                                          @"AVFoundation",
                                                          @"What's your favorite feature?",
                                                          @"我什么都喜欢，我想我深深爱上了它。",
                                                          @"OK,Have fun!"
                                                          ]];
    }
    return _speechStrings;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.contentInset = UIEdgeInsetsMake(20.0f, 0.0f, 20.0f, 0.0f);
    self.synthesizer.delegate = self;
    [self beginConversation];
}

- (void)beginConversation {
    for (NSUInteger i = 0; i < self.speechStrings.count; i++) {
        AVSpeechUtterance *utterance =
        [[AVSpeechUtterance alloc] initWithString:self.speechStrings[i]];
        utterance.voice = self.voices[i % 2];
        utterance.rate = 0.5f;
        utterance.pitchMultiplier = 0.8f;
        utterance.postUtteranceDelay = 0.1f;
        [self.synthesizer speakUtterance:utterance];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.speechStrings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = indexPath.row % 2 == 0 ? @"YouCell" : @"AVFCell";
    
    MWBubbleCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.messageLabel.text = self.speechStrings[indexPath.row];
    return cell;
}



#pragma mark -AVSpeechSynthesizerDelegate
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance
{
    [self.speechStrings addObject:utterance.speechString];
    [self.tableView reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.speechStrings.count - 1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

@end
