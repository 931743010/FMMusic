//
//  YXDownloadAssistant.h
//  FMMusic
//
//  Created by apple on 13-8-28.
//  Copyright (c) 2013年 apple. All rights reserved.
//  下载处理

#import <Foundation/Foundation.h>

@protocol YXDownloadAssistantDelegate;

@interface YXDownloadAssistant : NSObject

// 数组里面是字典 包含每首歌的具体信息
@property (nonatomic, retain) NSArray *songList;
@property (nonatomic, assign) NSInteger currentIndex;

+ (YXDownloadAssistant *)defaultAssistant;

- (void)prepareToDownload;

- (void)clearResource;

@property (nonatomic, retain) id<YXDownloadAssistantDelegate> delegate;

@end

@protocol YXDownloadAssistantDelegate <NSObject>

- (void)songDidFinishLoading:(NSURL *)songUrl;

@end
