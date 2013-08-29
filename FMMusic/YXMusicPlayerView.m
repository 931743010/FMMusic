//
//  YXMusicPlayerView.m
//  FMMusic
//
//  Created by apple on 13-8-26.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#define kScreenWidth [UIScreen mainScreen].bounds.size.width

#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define kImageViewHeight 300

#define kAnimationDirectionHeightToTop 80


#import "YXMusicPlayerView.h"
#import "YXPlayerAssistant.h"

@interface YXMusicPlayerView()
{
    CGFloat oldY;
    CGFloat currentY;
    CGPoint center;
    BOOL isDrag;
}
@end

@implementation YXMusicPlayerView


- (void)dealloc
{
    [_imageView release];
    [_timeLabel release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initView];
    }
    return self;
}

- (void)initView
{
    // 图片
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kImageViewHeight)];
    _imageView.backgroundColor = [UIColor brownColor];
    _imageView.userInteractionEnabled = YES;
    [self addSubview:_imageView];
    
    // 歌曲控制区
    UIView *controlView = [[UIView alloc] initWithFrame:CGRectMake(0, kImageViewHeight, kScreenWidth, self.frame.size.height - kImageViewHeight)];
    controlView.backgroundColor = [UIColor whiteColor];
    [self addSubview:controlView];
    
    // 控件 80 x 60  左边距40 中间60
    CGFloat leftMargin = 20.0f;
    CGFloat imageWidth = 80.0f;
    CGFloat imageHeight = 60.0f;
    CGFloat midMargin = (kScreenWidth - leftMargin * 2 - imageWidth * 3) / 2;
    CGFloat heightY = controlView.frame.size.height - imageHeight - 44;
    NSLog(@"%@", NSStringFromCGRect(self.frame));
    
    // 喜欢按钮
    UIButton *buttonLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonLeft.frame = CGRectMake(leftMargin, heightY, imageWidth, imageHeight);
    [buttonLeft setBackgroundImage:[UIImage imageNamed:@"ic_player_fav.png"] forState:UIControlStateNormal];
    [buttonLeft setBackgroundImage:[UIImage imageNamed:@"ic_player_fav_highlight.png"] forState:UIControlStateHighlighted];
    [buttonLeft setBackgroundImage:[UIImage imageNamed:@"ic_player_fav_disable.png"] forState:UIControlStateDisabled];
    [controlView addSubview:buttonLeft];
    
    // 垃圾桶
    UIButton *buttonMid = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonMid.frame = CGRectMake(leftMargin + imageWidth + midMargin, heightY, imageWidth, imageHeight);
    [buttonMid setBackgroundImage:[UIImage imageNamed:@"ic_player_ban.png"] forState:UIControlStateNormal];
    [buttonMid setBackgroundImage:[UIImage imageNamed:@"ic_player_ban_highlight.png"] forState:UIControlStateHighlighted];
    [buttonMid setBackgroundImage:[UIImage imageNamed:@"ic_player_ban_disable.png"] forState:UIControlStateDisabled];
    [controlView addSubview:buttonMid];
    
    // 下一首
    UIButton *buttonRight = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonRight.frame = CGRectMake(kScreenWidth - leftMargin - imageWidth, heightY, imageWidth, imageHeight);
    [buttonRight setBackgroundImage:[UIImage imageNamed:@"ic_player_next.png"] forState:UIControlStateNormal];
    [buttonRight setBackgroundImage:[UIImage imageNamed:@"ic_player_next_highlight.png"] forState:UIControlStateHighlighted];
    [buttonRight setBackgroundImage:[UIImage imageNamed:@"ic_player_next_disable.png"] forState:UIControlStateDisabled];
    [buttonRight addTarget:self action:@selector(buttonRightClicked) forControlEvents:UIControlEventTouchUpInside];
    [controlView addSubview:buttonRight];
    
    // 播放按钮
    CGFloat topMargin02 = 10.0f;
    CGFloat leftMargin02 = 100.0f;
    CGFloat height02 = 32.0f;
    CGFloat width02 = 120.0f;
    
    // 播放按钮 120 x 32
    UIButton *buttonPlay = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonPlay.frame = CGRectMake(leftMargin02, topMargin02, (kScreenWidth - leftMargin02 * 2), height02);
    [buttonPlay setBackgroundImage:[UIImage imageNamed:@"ic_player_pause_off.png"] forState:UIControlStateNormal];
    [buttonPlay setBackgroundImage:[UIImage imageNamed:@"ic_player_pause_off_highlight.png"] forState:UIControlStateHighlighted];
    [buttonPlay setBackgroundImage:[UIImage imageNamed:@"ic_player_pause_on.png"] forState:UIControlStateSelected];
    // 刚开始选中
    buttonPlay.selected = YES;
    [buttonPlay addTarget:self action:@selector(buttonPlayClicked:) forControlEvents:UIControlEventTouchUpInside];
    [controlView addSubview:buttonPlay];
    
    // 显示剩余时间的label
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin02 + 10, topMargin02, width02 - 60, height02)];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.text = @"流金岁月";
    _timeLabel.font = [UIFont systemFontOfSize:14.0f];
    [controlView addSubview:_timeLabel];
    //显示歌手和专辑名
    
}

- (void)buttonRightClicked
{
    [[YXPlayerAssistant defaultAssistant] nextSong];
}

- (void)buttonPlayClicked:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if (button.selected) {
        button.selected = NO;
        [[YXPlayerAssistant defaultAssistant] pauseControl];
    } else {
        button.selected = YES;
        [[YXPlayerAssistant defaultAssistant] playControl];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"开始");
    UITouch *touch = [[touches allObjects] objectAtIndex:0];
    CGPoint point = [touch locationInView:_imageView];
    //判断是否是imageView里面的点
    //判断点击位置在父视图的父视图的位置
    if (CGRectContainsPoint(_imageView.frame, point)) {
        CGPoint superPoint = [touch locationInView:self];
        oldY = superPoint.y;
        isDrag = YES;
    }
    
    // 背景色改变
    //[self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"移动");
    UITouch *touch = [[touches allObjects] objectAtIndex:0];
    CGPoint point = [touch locationInView:_imageView];
    //判断是否是imageView里面的点
    //判断点击位置在父视图的父视图的位置
    if (CGRectContainsPoint(_imageView.frame, point)) {
        CGPoint superPoint = [touch locationInView:self];
        currentY = superPoint.y;
    }
    if (isDrag) {
        self.center = CGPointMake(self.center.x, self.center.y + (currentY - oldY));
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"移动结束");
    isDrag = NO;
    if (self.frame.origin.y < kAnimationDirectionHeightToTop) {
        //往上运动
        [self animationUp];
    } else {
        //往下运动
        [self animationDown];
    }
}

- (void)animationUp
{
    //往上运动
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = self.superview.frame;
    } completion:nil];
}

- (void)animationDown
{
    //往下运动
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(0, kScreenHeight - 20 - 44, kScreenWidth, self.frame.size.height);
    } completion:^(BOOL finish) {
        //self.backgroundColor = [UIColor clearColor];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
