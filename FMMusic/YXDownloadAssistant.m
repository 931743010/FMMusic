//
//  YXDownloadAssistant.m
//  FMMusic
//
//  Created by apple on 13-8-28.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#define kPath  [NSHomeDirectory() stringByAppendingPathComponent:@"tmp"]


#import "YXDownloadAssistant.h"
#import "YXPlayerAssistant.h"

@interface YXDownloadAssistant()
{
    NSURLConnection *_connection;
    NSFileHandle *_fileHandle;
}
@end

@implementation YXDownloadAssistant

static YXDownloadAssistant *instance;

+ (YXDownloadAssistant *)defaultAssistant
{
    if  (nil == instance) {
        instance = [[YXDownloadAssistant alloc] init];
    }
    return instance;
}

// 下载前的准备
- (void)prepareToDownload
{
    if  (nil == _songList) {
        NSLog(@"下载列表为空");
        return;
    }
    if (self.currentIndex > _songList.count - 1) {
        //专辑歌曲已经下载完成
        NSLog(@"专辑歌曲已经下载完成");
        return;
    }
    
    //--------------
    
    NSLog(@"开始下载第%d首", self.currentIndex);
    NSString *urlStr = [[_songList objectAtIndex:self.currentIndex] valueForKey:@"url"];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    [self downloadWithUrl:url];
    
    self.currentIndex = self.currentIndex + 1;
}

// 开始下载
- (void)downloadWithUrl:(NSURL *)url
{
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [_connection start];
}

- (void)clearResource
{
    [_connection cancel];
    [_connection release];
    _connection = nil;
    
    [_fileHandle closeFile];
    [_fileHandle release];
    _fileHandle = nil;
}

//**********************异步下载的协议方法实现
// 连接失败
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self clearResource];
    
    NSLog(@"connent to %@ failed,%@", [[connection currentRequest] URL], error);
}

// 收到回应
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //NSLog(@"filehandel retainCount: %@",[(NSHTTPURLResponse *)response allHeaderFields]  );
    
    if ([(NSHTTPURLResponse *)response statusCode] == 200)
    {
        
        NSString *name = [(NSHTTPURLResponse *)response suggestedFilename];
        
//        NSString *name = [_urlPath lastPathComponent];
//        NSLog(@"suggestfilename:%@", name);
        NSString *filepath = [kPath stringByAppendingPathComponent:name];
        //NSLog(@"filepath:%@",filepath);
        
        NSFileManager *filemanager = [NSFileManager defaultManager];
        [filemanager createFileAtPath:filepath contents:nil attributes:nil];
        
        _fileHandle = [NSFileHandle fileHandleForWritingAtPath:filepath];
        [_fileHandle retain];
    } else {
        [self clearResource];
        NSLog(@"------网络请求出现问题----");
    }
}

// 收到下载数据
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_fileHandle writeData:data];
    
}

// 完成下载
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSURL *url = connection.currentRequest.URL;
    if (_delegate && [_delegate respondsToSelector:@selector(songDidFinishLoading:)]) {
        [_delegate songDidFinishLoading:url];
    }
    
    [self clearResource];
    // 继续下载
    [self prepareToDownload];
    
    //NSLog(@"connent to %@ finished", [[connection currentRequest] URL]);
}
//*******************************

@end
