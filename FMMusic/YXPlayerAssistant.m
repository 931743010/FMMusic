//
//  YXPlayerAssistant.m
//  FMMusic
//
//  Created by apple on 13-8-27.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#define kDownloadUrl @"http://www.douban.com/j/app/radio/people?  type=n&channel=3&version=83&app_name=radio_iphone"
#define kPath [NSHomeDirectory() stringByAppendingPathComponent:@"tmp/fmmusic"]

#import "YXPlayerAssistant.h"
#import "YXDataManager.h"
#import "YXDownloadAssistant.h"

@interface YXPlayerAssistant()
{
    NSArray *_musicList;
    AVAudioPlayer *_audioPlayer;
    NSInteger _channelId;
    NSInteger _songLength;
    NSTimer *_timer;
}
@end

@implementation YXPlayerAssistant

static YXPlayerAssistant *instance;
static  NSInteger playSeconds = 0;

- (void)dealloc
{
    [_musicList release];
    [super dealloc];
}

+ (YXPlayerAssistant *)defaultAssistant
{
    if (nil == instance) {
        instance = [[[self class] alloc] init];
    }
    return instance;
}

- (void)loadMusicWithChannelId:(NSInteger)channelId
{
    if (nil != _musicList) {
        [_musicList release];
    }
    
    if (nil != _audioPlayer) {
        [_audioPlayer stop];
        [_audioPlayer release];
        _audioPlayer = nil;
    }
    
    self.currentIndex = 0;
    self.readyCount = 0;
    
    [YXDownloadAssistant defaultAssistant].currentIndex = 0;
    [[YXDownloadAssistant defaultAssistant] clearResource];
    //======================================================
    
    [self clearTmpMusicDirectory];
    _channelId = channelId;
    
    // 设置等待动画
    if (_delegate && [_delegate respondsToSelector:@selector(waitForDownload)]) {
        [_delegate waitForDownload];
    }
    // 停止底部动画
    [self pauseControl];
    

    NSString *channelPath = [NSString stringWithFormat:@"http://www.douban.com/j/app/radio/people?type=n&channel=%d&version=83&app_name=radio_iphone", channelId];
    //NSLog(@"%@", channelPath);
    
    _musicList = [[YXDataManager defaultManager] songsOfChannelWithUrl:channelPath];
    [_musicList retain];
    
    [YXDownloadAssistant defaultAssistant].songList = _musicList;
    [YXDownloadAssistant defaultAssistant].delegate = self;
    //NSLog(@"songs%@", _musicList);
    
    // 启动下载
    [[YXDownloadAssistant defaultAssistant] prepareToDownload];
    
}

- (NSURL *)songUrl
{
    //第几首歌
    NSString *songPath = [self getSongPath:self.currentIndex];
    //NSLog(@"songPath:%@", songPath);
    
    //检查文件是否存在
    if (![self fileExistAtPaht:songPath]) {
        NSLog(@"--------本地歌曲不存在");
        return nil;
    }
    
    //播放
    NSLog(@"songPath:%@", songPath);
    NSURL *url = [NSURL URLWithString:songPath];
    
    return url;
}

- (NSString *)getSongPath:(NSInteger)index
{
    //从本地读取已经下载好的歌曲  下载好后存放在tmp下
    NSString *path = kPath;
    //取得要播放的歌曲名字
    NSString *fileName = [[[_musicList objectAtIndex:index] valueForKey:@"url"] lastPathComponent];
    NSLog(@"%@", fileName);
    //组合路径
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    return filePath;
}

- (Boolean)fileExistAtPaht:(NSString *)path
{
    NSLog(@"%@", path);
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

- (void)startPlay
{
    if (_delegate && [_delegate respondsToSelector:@selector(startToPlay)]) {
        [_delegate startToPlay];
    }

    // 判断能不能播放下一首
    if (self.currentIndex >= self.readyCount && self.readyCount < _musicList.count) {
        NSLog(@"--------歌曲还没有准备好------");
        //把歌曲图片重新设置回来
        if (self.currentIndex >= 1) {
            [self showSongInfo:self.currentIndex - 1];
        }
        return;
    }
    
       
    if (self.currentIndex >= _musicList.count) {
        NSLog(@"-----清单听完了，正在拼命刷新歌曲-----");
        [self loadMusicWithChannelId:_channelId];
        return;
    }
    
    if (nil != _audioPlayer) {
        [_audioPlayer stop];
        [_audioPlayer release];
        _audioPlayer = nil;
    }
    
    if (nil != _timer) {
        [_timer invalidate];
        _timer = nil;
    }
    
    NSLog(@"-----开始播放第%d首---", self.currentIndex);
    
    
    //NSLog(@"%@", kPath);
    NSURL *url = [self songUrl];

    
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    _audioPlayer.delegate = self;
//    //观察时间变化
//    [_audioPlayer addObserver:self forKeyPath:@"currentTime" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
    
    _songLength = [[[_musicList objectAtIndex:self.currentIndex] valueForKey:@"length"] integerValue];
    
    [_audioPlayer play];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeChanged) userInfo:nil repeats:YES];
    
    //底部动画
    [self playControl];
    
    playSeconds = 0;
    
    [self showSongInfo:self.currentIndex];
    
    self.currentIndex = self.currentIndex + 1;
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    NSInteger length = [[[_musicList objectAtIndex:self.currentIndex] valueForKey:@"length"] integerValue];
//    if ([keyPath isEqualToString:@"currentTime"] && object == _audioPlayer) {
//        NSInteger currentTime = _audioPlayer.currentTime;
//        NSString *leftTimeStr = [self generateLeftTimeString:(length - currentTime)];
//        NSLog(@"%@", leftTimeStr);
//    }
//}

- (void)timeChanged
{
    if (playSeconds > _songLength) {
        [_timer invalidate];
        _timer = nil;
        return;
    }
    NSInteger currentTime = _audioPlayer.currentTime;
    NSString *leftTimeStr = [self generateLeftTimeString:(_songLength - currentTime)];
    //NSLog(@"%@", leftTimeStr);
    if (_delegate && [_delegate respondsToSelector:@selector(showLeftTime:)]) {
        [_delegate showLeftTime:leftTimeStr];
    }
    playSeconds++;
}

// 剩余时间
- (NSString *)generateLeftTimeString:(NSInteger)leftTime
{
    NSInteger min = leftTime / 60;
    NSInteger second = leftTime % 60;
    
    NSString *leftMin = min < 10 ? [NSString stringWithFormat:@"0%d", min] : [NSString stringWithFormat:@"%d", min];
    NSString *leftSecond = second < 10 ? [NSString stringWithFormat:@"0%d", second] :[NSString stringWithFormat:@"%d", second];
    
    return [NSString stringWithFormat:@"%@:%@", leftMin, leftSecond];
}

- (void)showSongInfo:(NSInteger)currentIndex
{
    NSDictionary *dic = [_musicList objectAtIndex:currentIndex];
    //图片信息
    NSString *imageUrl = [dic valueForKey:@"picture"];
    
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]];
    
    NSString *songName = [dic valueForKey:@"title"];
    
    NSString *singer = [dic valueForKey:@"artist"];
    
    //加入字典
    NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:image, @"image", singer, @"artist", songName, @"title",  nil];
    
    if (_delegate && [_delegate respondsToSelector:@selector(showSongInfo:)]) {
        [_delegate showSongInfo:infoDic];
    }
}

- (void)nextSong
{
    if (_delegate && [_delegate respondsToSelector:@selector(nextSongButtonClicked)]) {
        [_delegate nextSongButtonClicked];
    }
    
    if (self.readyCount < 1) {
        NSLog(@"----第一首歌还没加载完哦---");
    } else {
        [self startPlay];
    }
}

- (void)playControl
{
    if (_delegate && [_delegate respondsToSelector:@selector(play)]) {
        [_delegate play];
    }
    
    [_audioPlayer play];
}

- (void)pauseControl
{
    if (_delegate && [_delegate respondsToSelector:@selector(pause)]) {
        [_delegate pause];
    }

    [_audioPlayer pause];
}

//- (void)addTimeObserver
//{
//    [_audioPlayer addObserver:self forKeyPath:@"currentTime" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
//}
//
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    if ([keyPath isEqualToString:@"currentTime"] && object == _audioPlayer) {
//        
//    }
//}

#pragma mark - YXDownloadAssistantDelegate
- (void)songDidFinishLoading:(NSURL *)songUrl
{
    NSLog(@"%@（下载完成）", songUrl.path);
    self.readyCount = self.readyCount + 1;
    
    // 如果是第一首歌下载完成，则自动启动播放
    if (self.readyCount == 1) {
        [self startPlay];
    }
}

/*********************AVAudioPlayerDelegate代理协议的方法实现******************/
#pragma mark AVAudioPlayerDelegate代理协议的方法实现
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (flag) {
        NSLog(@"%@ 播放成功完成.",player);
    }
    
    // 接着播放下一首
    [self nextSong];
}

/* if an error occurs while decoding it will be reported to the delegate. */
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    NSLog(@"播放出现解码错误,无法对文件文件进行解码.%@",error);
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
    NSLog(@"播放被开始打断,可能来了电话");
    NSLog(@"%f", _audioPlayer.currentTime);
    self.pauseTime = _audioPlayer.currentTime;
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags
{
    NSLog(@"打断结束.");
    if(flags == AVAudioSessionInterruptionOptionShouldResume)
    {
        NSLog(@"谢天谢地,我还可以继续恢复播放");
        _audioPlayer.currentTime = self.pauseTime;
        [_audioPlayer play];
    }
}

// 清空音乐文件夹
- (void)clearTmpMusicDirectory
{
    if ([self fileExistAtPaht:kPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:kPath error:nil];
    }
}

@end
