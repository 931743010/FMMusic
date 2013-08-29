//
//  YXCellView.m
//  FMMusic
//
//  Created by apple on 13-8-26.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#define kMarginWidth 10
#define kHeight01 25
#define kHeight02 16

#import "YXCellView.h"
#import <QuartzCore/QuartzCore.h>

@implementation YXCellView

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
    self.layer.cornerRadius = 3;
    self.backgroundColor = [UIColor greenColor];

    self.label01 = [[UILabel alloc] initWithFrame:CGRectMake(kMarginWidth, kMarginWidth, self.frame.size.width - kMarginWidth * 2, kHeight01)];
    //self.label01.text = @"测试";
    self.label01.backgroundColor = [UIColor clearColor];
    self.label01.font = [UIFont systemFontOfSize:20];
    [self addSubview:self.label01];
    
    self.label02 = [[UILabel alloc] initWithFrame:CGRectMake(kMarginWidth, self.frame.size.height - kMarginWidth - kHeight02, (self.frame.size.width - kMarginWidth * 2) / 2, kHeight02)];
    //self.label02.text = @"测试";
    self.label02.backgroundColor = [UIColor clearColor];
    self.label02.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.label02];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - kMarginWidth - 16, self.frame.size.height - kMarginWidth - kHeight02, 16, 16)];
    [self addSubview:self.imageView];
    
    [self addTarget:self action:@selector(cellViewTapped) forControlEvents:UIControlEventTouchUpInside];
}

- (void)cellViewTapped
{
    if (_delegate && [_delegate respondsToSelector:@selector(cellViewTapped:)]) {
        [_delegate cellViewTapped:self];
    }
}

//// 处理频道的选择
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [super touchesBegan:touches withEvent:event];
//    UITouch *myTouch = [[touches allObjects] objectAtIndex:0];
//    UIView *view = myTouch.view;
//    NSInteger channelIndex = view.tag;
//    //NSLog(@"%d", channelIndex);
//    
//    //获取频道开始下载
//    
//    //弹出播放界面播放歌曲
//    [self.viewController.musicPlayerView animationUp];
//}
//- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
//{}
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{}
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{}
//

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
