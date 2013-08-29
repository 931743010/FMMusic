//
//  YXDataManager.h
//  FMMusic
//
//  Created by apple on 13-8-27.
//  Copyright (c) 2013年 apple. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface YXDataManager : NSObject

+ (YXDataManager *)defaultManager;

- (NSArray *)channelsWithUrl:(NSString *)url;

- (NSArray *)songsOfChannelWithUrl:(NSString *)url;

@end
