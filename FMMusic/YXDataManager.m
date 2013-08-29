//
//  YXDataManager.m
//  FMMusic
//
//  Created by apple on 13-8-27.
//  Copyright (c) 2013年 apple. All rights reserved.
//  数据提供和管理





#import "YXDataManager.h"
#import "JSONKit.h"

@interface YXDataManager()
{
    NSData *_channelData;
}
@end

@implementation YXDataManager

static YXDataManager *instance;

+ (YXDataManager *)defaultManager
{
    if (nil == instance) {
        instance = [[[self class] alloc] init];
    }
    return instance;
}

- (NSArray *)channelsWithUrl:(NSString *)url
{
    if (nil == _channelData) {
        _channelData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        [_channelData retain];
    }
    NSString *content = [[NSString alloc] initWithData:_channelData encoding:NSUTF8StringEncoding];
    NSArray *array = [[content objectFromJSONString] valueForKey:@"channels"];
    [content release];
    return  array;
}

- (NSArray *)songsOfChannelWithUrl:(NSString *)url
{
    NSLog(@"%@", url);
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];

    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"str");
    NSArray *array = [[str objectFromJSONString] valueForKey:@"song"];
    [str release];
    return array;
}





@end
