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
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kLeftMargin, kTopMargin, 16, 16)];
    imageView.image = [UIImage imageNamed:@"ic_player_nowplaying1.png"];
    [self addSubview:imageView];
    
    // 中建label显示歌名
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(120, kTopMargin, 80, 20)];
    label.text = @"testtesttest";
    [self addSubview:label];
}



@end
