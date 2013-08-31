//
//  YXBottomView.m
//  FMMusic
//
//  Created by apple on 13-8-27.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#define kLeftMargin 20
#define kTopMargin 15

#import "YXBottomView.h"

@interface YXBottomView()
{

}
@end

@implementation YXBottomView

- (void)dealloc
{
    [_labelSongName release];
    [_imageView release];
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
    self.backgroundColor = [UIColor whiteColor];
    //左边有一个小图片 16 x 16
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kLeftMargin, kTopMargin, 16, 16)];
    _imageView.image = [UIImage imageNamed:@"ic_player_nowplaying1.png"];
    [self addSubview:_imageView];
    
    // 中建label显示歌名
    _labelSongName = [[UILabel alloc] initWithFrame:CGRectMake(0, kTopMargin, 320, 20)];
    //_labelSongName.text = @"testtesttest";
    _labelSongName.backgroundColor = [UIColor clearColor];
    _labelSongName.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_labelSongName];
}

- (void)imageViewAnimationStart
{
    NSArray *imageArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"ic_player_nowplaying1.png"], [UIImage imageNamed:@"ic_player_nowplaying2.png"], [UIImage imageNamed:@"ic_player_nowplaying3.png"], [UIImage imageNamed:@"ic_player_nowplaying4.png"], nil];
    
    self.imageView.animationImages = imageArray;
    self.imageView.animationDuration = 0.5;
    [self.imageView startAnimating];
}

- (void)imageViewAnimationStop
{
    [self.imageView stopAnimating];
}



@end
