//
//  YXMusicPlayerView.h
//  FMMusic
//
//  Created by apple on 13-8-26.
//  Copyright (c) 2013年 apple. All rights reserved.
//  播放界面

#import <UIKit/UIKit.h>

@interface YXMusicPlayerView : UIView

// 显示图片
@property (nonatomic, retain) UIImageView *imageView;

@property (nonatomic, retain) UILabel *timeLabel;

// 用来被观察的属性，决定bottomview的显示与隐藏
@property (nonatomic, assign) CGFloat originY;

- (void)animationUp;

- (void)animationDown;


@end
