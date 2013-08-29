//
//  YXPlayerAssistant.h
//  FMMusic
//
//  Created by apple on 13-8-27.
//  Copyright (c) 2013年 apple. All rights reserved.
//  播放处理



#import "YXDownloadAssistant.h"
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol YXPlayerAssistantDelegate;

@interface YXPlayerAssistant : NSObject <YXDownloadAssistantDelegate, AVAudioPlayerDelegate>

//@property (nonatomic, retain) NSArray *musicList;
// 当前播放位置
@property (nonatomic, assign) NSUInteger  currentIndex;
// 已经下载好的歌曲数目
@property (nonatomic, assign) NSInteger readyCount;

@property (nonatomic,assign) NSTimeInterval  pauseTime;

@property (nonatomic, assign) id<YXPlayerAssistantDelegate> delegate;


+ (YXPlayerAssistant *)defaultAssistant;

- (void)loadMusicWithChannelId:(NSInteger)channelId;

- (void)nextSong;

- (void)playControl;

- (void)pauseControl;

@end

//-----
@protocol YXPlayerAssistantDelegate <NSObject>

- (void)showSongInfo:(NSDictionary *)songInfo;

@end
