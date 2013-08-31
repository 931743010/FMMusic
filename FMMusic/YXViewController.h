//
//  YXViewController.h
//  FMMusic
//
//  Created by apple on 13-8-26.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "YXCellView.h"
#import "YXPlayerAssistant.h"
#import "YXMusicPlayerView.h"
#import <UIKit/UIKit.h>

@class YXMusicPlayerView;
@interface YXViewController : UIViewController <YXCellViewDelegate, YXPlayerAssistantDelegate, YXMusicPlayerViewDelegate>

@property(nonatomic, retain) UIScrollView *scrollView;
@property(nonatomic, retain) UIView *topView;
@property(nonatomic, retain) YXMusicPlayerView *musicPlayerView;


@end
