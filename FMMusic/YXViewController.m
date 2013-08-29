//
//  YXViewController.m
//  FMMusic
//
//  Created by apple on 13-8-26.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kStatusBarHeight 20

#define kTopViewHeight 44
#define kBottonViewHeight 44

#define kCellViewMargin 10
#define kCellViewWidth  ((_scrollView.frame.size.width - kCellViewMargin * 3) / 2)
#define kCellViewHeight 88

#define kChannelUrl @"http://www.douban.com/j/app/radio/channels"



#define kLyricUrl @"http://geci.me/api/lyric/:song/:artist"


#import "YXViewController.h"
#import "YXCellView.h"
#import "YXMusicPlayerView.h"
#import "YXBottomView.h"
#import "YXDataManager.h"
#import "YXPlayerAssistant.h"

@interface YXViewController ()
{
    YXDataManager *_dataManager;
    YXPlayerAssistant *_playerAssistant;
}

@end

@implementation YXViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _dataManager = [YXDataManager defaultManager];
    _playerAssistant = [YXPlayerAssistant defaultAssistant];
    _playerAssistant.delegate = self;
    
    [self addTopBar];
    [self addScrollView];
    [self addMusicPlayerView];
    [self addBottomView];
}

- (void)addTopBar
{
    // 添加topview
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, kTopViewHeight)];
    _topView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_topView];
    
    // topview上的内容 | 先不做
    
}

- (void)addScrollView
{
    NSArray *channelArray = [_dataManager channelsWithUrl:kChannelUrl];
    //NSLog(@"%@", channelArray);
    // 添加scrollView
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, 320, kScreenHeight - kTopViewHeight - kStatusBarHeight)];
//    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    _scrollView.backgroundColor = [UIColor colorWithRed:0.7 green:0.3 blue:0.5 alpha:1];
    
    //计算高度
    NSInteger rows = (channelArray.count + 1) / 2;
    //NSLog(@"%d", rows);
    NSInteger contentHeight = rows * kCellViewHeight + (rows + 1) * kCellViewMargin + kBottonViewHeight;
   // NSLog(@"%d", contentHeight);
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, contentHeight);
    [self.view addSubview:_scrollView];
    
    // 再scrollView上添加内容
    
    for (int i = 0; i < rows; i++) {
        static int heightY = 0;
        YXCellView *leftCellView = [[YXCellView alloc] initWithFrame:CGRectMake(kCellViewMargin, kCellViewMargin + heightY, kCellViewWidth, kCellViewHeight)];
        leftCellView.label01.text = [[channelArray objectAtIndex:i * 2] valueForKey:@"name"];
        leftCellView.tag = 100 + (i * 2);  // 刚好和channel的seq_id + 100同步
        leftCellView.delegate = self;
        [_scrollView addSubview:leftCellView];
        [leftCellView release];
        if ((i * 2 + 1) >= channelArray.count) {
            //NSLog(@"%d", i * 2 + 1);
            break;
        }
        
        YXCellView *rightView = [[YXCellView alloc] initWithFrame:CGRectMake(kCellViewMargin * 2 + kCellViewWidth, kCellViewMargin + heightY, kCellViewWidth, kCellViewHeight)];
        rightView.label01.text = [[channelArray objectAtIndex:i * 2 + 1] valueForKey:@"name"];
        rightView.tag = 100 + (i * 2 + 1);
        [_scrollView addSubview:rightView];
        rightView.delegate = self;
        [rightView release];
        heightY += kCellViewMargin + kCellViewHeight;
    }
}

- (void)addMusicPlayerView
{
    _musicPlayerView = [[YXMusicPlayerView alloc] initWithFrame:CGRectMake(0, kScreenHeight - kStatusBarHeight, kScreenWidth, kScreenHeight - kStatusBarHeight)];
    _musicPlayerView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_musicPlayerView];
}

- (void)viewWillAppear:(BOOL)animated
{
    //_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height - kTopViewHeight)];
//    NSLog(@"self.view _%@", NSStringFromCGRect(self.view.frame));
//    NSLog(@"scrollView_%@", NSStringFromCGRect(_scrollView.frame));
//    NSLog(@"topview_%@", NSStringFromCGRect(_topView.frame));
//    NSLog(@"musicPlayView_%@", NSStringFromCGRect(_musicPlayerView.frame));
}

- (void)addBottomView
{
    YXBottomView *bottomView = [[YXBottomView alloc] initWithFrame:CGRectMake(0, kScreenHeight - kStatusBarHeight - 44, kScreenWidth, 44)];
    //bottomView.viewController = self;
    [self.view addSubview:bottomView];
    // 添加手势
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bottomViewTappd)];
    [bottomView addGestureRecognizer:tapGestureRecognizer];
    
}

- (void)bottomViewTappd
{
    //NSLog(@"tap");
    [_musicPlayerView animationUp];
    //palyerview上升到一定程度 bottonview隐藏

}

- (void)cellViewTapped:(id)sender
{
    //NSLog(@"哈哈哈");
    NSInteger channelIndex = ((YXCellView *)sender).tag - 100;
    //NSLog(@"%d", channelIndex);
    
    //弹出播放界面
    [_musicPlayerView animationUp];
    
    //下载...
    [_playerAssistant loadMusicWithChannelId:channelIndex];


}

#pragma mark - YXPlayerAssistantDelegate
- (void)showSongInfo:(NSDictionary *)songInfo
{
    _musicPlayerView.imageView.image = [songInfo valueForKey:@"image"];
    
    _musicPlayerView.timeLabel.text = [NSString stringWithFormat:@"%@",[songInfo valueForKey:@"length"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
