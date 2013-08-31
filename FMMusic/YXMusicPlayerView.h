//
//  YXMusicPlayerView.h
//  FMMusic
//
//  Created by apple on 13-8-26.
//  Copyright (c) 2013年 apple. All rights reserved.
//  播放界面

#import <UIKit/UIKit.h>

@protocol  YXMusicPlayerViewDelegate;

@interface YXMusicPlayerView : UIView

// 显示图片
@property (nonatomic, retain) UIImageView *imageView;

@property (nonatomic, retain) UILabel *labelTime;

@property (nonatomic, retain) UILabel *labelSinger;

@property (nonatomic, retain) UILabel *labelSongName;

@property (nonatomic, retain) UIButton *buttonPlay;

// 用来被观察的属性，决定bottomview的显示与隐藏
@property (nonatomic, assign) CGFloat originY;

@property (nonatomic, retain) NSTimer *timer;

@property (nonatomic, assign) id<YXMusicPlayerViewDelegate> delegate;

//@property (nonatomic, assign) BOOL rotation;

- (void)animationUp;

- (void)animationDown;

- (void)imageAnimationStart;

- (void)imageAnimationStop;


@end

@protocol YXMusicPlayerViewDelegate <NSObject>

@optional
- (void)showBottomView:(BOOL)flag;

@end
