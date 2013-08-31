//
//  YXMusicPlayerView.m
//  FMMusic
//
//  Created by apple on 13-8-26.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#define kScreenWidth [UIScreen mainScreen].bounds.size.width

#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define kImageViewHeight 320

#define kAnimationDirectionHeightToTop 63


#import "YXMusicPlayerView.h"
#import "YXPlayerAssistant.h"

@interface YXMusicPlayerView()
{
    CGFloat _oldY;
    CGFloat _currentY;
    CGPoint _center;
    BOOL _isDrag;
    
    CGFloat _keyHeightToMove;
}
@end

@implementation YXMusicPlayerView


- (void)dealloc
{
    [_imageView release];
    [_labelTime release];
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
    _imageView.image = [UIImage imageNamed:@"bg_player_cover_default.png"];
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
    CGFloat heightY = controlView.frame.size.height - imageHeight - 10;

    
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
    CGFloat topMargin02 = 5.0f;
    CGFloat leftMargin02 = 100.0f;
    CGFloat height02 = 32.0f;
    CGFloat width02 = 120.0f;
    
    // 播放按钮 120 x 32
    _buttonPlay = [UIButton buttonWithType:UIButtonTypeCustom];
    _buttonPlay.frame = CGRectMake(leftMargin02, topMargin02, (kScreenWidth - leftMargin02 * 2), height02);
    [_buttonPlay setBackgroundImage:[UIImage imageNamed:@"ic_player_pause_off.png"] forState:UIControlStateNormal];
    [_buttonPlay setBackgroundImage:[UIImage imageNamed:@"ic_player_pause_off_highlight.png"] forState:UIControlStateHighlighted];
    [_buttonPlay setBackgroundImage:[UIImage imageNamed:@"ic_player_pause_on.png"] forState:UIControlStateSelected];
    [_buttonPlay addTarget:self action:@selector(buttonPlayClicked:) forControlEvents:UIControlEventTouchUpInside];
    [controlView addSubview:_buttonPlay];
    
    // 显示剩余时间的label
    _labelTime = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin02 + 10, topMargin02, width02 - 60, height02)];
    _labelTime.backgroundColor = [UIColor clearColor];
    _labelTime.text = @"00:00";
    _labelTime.textAlignment = NSTextAlignmentCenter;
    _labelTime.font = [UIFont systemFontOfSize:14.0f];
    [controlView addSubview:_labelTime];
    
    //显示歌手和歌曲名
    _labelSinger = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, 320, 20)];
    _labelSinger.backgroundColor = [UIColor clearColor];
    _labelSinger.textAlignment = NSTextAlignmentCenter;
    _labelSinger.textColor = [UIColor grayColor];
    _labelSinger.text = @"曲婉婷";
    [controlView addSubview:_labelSinger];
    
    _labelSongName = [[UILabel alloc] initWithFrame:CGRectMake(0, 65, 320, 20)];
    _labelSongName.backgroundColor = [UIColor clearColor];
    _labelSongName.textAlignment = NSTextAlignmentCenter;
    _labelSongName.textColor = [UIColor grayColor];
    _labelSongName.text = @"梦中只有你";
    [controlView addSubview:_labelSongName];
    
    // 底部bar显示隐藏的临界点
    _keyHeightToMove =  controlView.frame.size.height - 85 - (44 - 20) / 2;
    NSLog(@"%f", _keyHeightToMove);
    
    //KVO  无法监听运动中的view的属性
//    [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
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
    //NSLog(@"开始");
    UITouch *touch = [[touches allObjects] objectAtIndex:0];
    CGPoint point = [touch locationInView:_imageView];
    //NSLog(@"---%@", NSStringFromCGPoint(point));
    //判断是否是imageView里面的点
    //判断点击位置在父视图的父视图的位置
    if (CGRectContainsPoint(_imageView.bounds, point)) {
        CGPoint superPoint = [touch locationInView:self];
        _oldY = superPoint.y;
        _isDrag = YES;
    }
    
    // 背景色改变
    //[self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"移动");
    UITouch *touch = [[touches allObjects] objectAtIndex:0];
    CGPoint point = [touch locationInView:_imageView];
    //判断是否是imageView里面的点
    //判断点击位置在父视图的父视图的位置
    CGPoint superPoint;
    if (CGRectContainsPoint(_imageView.bounds, point)) {
        superPoint = [touch locationInView:self];
        _currentY = superPoint.y;
    }
   // NSLog(@"point:%@  superPoint:%@", NSStringFromCGPoint(point), NSStringFromCGPoint(superPoint));
    
    //判断是否隐藏底部bar
    [self shouldBottomViewShow];
    
    if (_isDrag) {
              
        //判断拖动是否移动的判断
        if (self.frame.origin.y <= 0 && (_currentY - _oldY) < 0) {
            self.frame = self.superview.bounds;
            //NSLog(@"%@", NSStringFromCGRect(self.frame));
            //return;
        } else {
            self.center = CGPointMake(self.center.x, self.center.y + (_currentY - _oldY));
        }
    }
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"移动结束");
    
    _isDrag = NO;
    
    //判断是否隐藏底部bar
    [self shouldBottomViewShow];
  
    
    if (self.frame.origin.y < kAnimationDirectionHeightToTop) {
        //往上运动
        [self animationUp];
    } else {
        //往下运动
        [self animationDown];
    }
}

- (void)shouldBottomViewShow
{
    //判断是否隐藏底部bar
    if (self.frame.origin.y > _keyHeightToMove) {
        [self showBottomBar:YES];
    } else {
        [self showBottomBar:NO];
    }

}

- (void)animationUp
{
    //延迟时间计算
    CGFloat delayTime = (self.frame.size.height - kAnimationDirectionHeightToTop) * 1.0f / self.frame.size.height * 0.5;
    
    if  (self.frame.origin.y > kAnimationDirectionHeightToTop) {
        [UIView animateWithDuration:0 delay:delayTime options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            self.alpha = 0.99f;
        } completion:^(BOOL finish) {
            [self showBottomBar:NO];
            self.alpha = 1.0f;
        }];
    }

    //往上运动
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = self.superview.frame;
    } completion:nil];
}

- (void)animationDown
{
    //往下运动
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(0, kScreenHeight - 20, kScreenWidth, self.frame.size.height);
    } completion:^(BOOL finish) {
        //self.backgroundColor = [UIColor clearColor];
    }];
    NSLog(@"%@", NSStringFromCGRect(self.frame));
}

// 运动到某个临界点
- (void)showBottomBar:(BOOL)flag
{
    if (_delegate && [_delegate respondsToSelector:@selector(showBottomView:)]) {
        [_delegate showBottomView:flag];
    }
}


// 缓冲等待时间动画
- (void)imageAnimationStart
{
//    static int i = 0;
//    //让一张图片旋转
//    NSLog(@"%d", i);
//    [UIView animateWithDuration:0.1 animations:^{
//        self.imageView.transform = CGAffineTransformMakeRotation(i * (M_PI / 180.0f));
//    }completion:^(BOOL finish) {
//        if (_rotation) {
//            i += 10;
//            [self imageAnimationStart];
//        } else {
//            i = 0;
//            self.imageView.transform = CGAffineTransformMakeRotation(0);
//        }
//    }];
    
    self.imageView.image = [UIImage imageNamed:@"bg_player_cover_loading.png"];

    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(imageAnimation) userInfo:nil repeats:YES];
    //NSLog(@"timerRetainCount:%d", _timer.retainCount);
}

- (void)imageAnimation
{
    static int i = 0;
    [UIView animateWithDuration:0.1 animations:^{
        self.imageView.transform = CGAffineTransformMakeRotation(i * (M_PI / 180.0f));
     }];
    i += 10;
}

- (void)imageAnimationStop
{
    [_timer invalidate];
    _timer = nil;
    self.imageView.transform = CGAffineTransformMakeRotation(0);
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
