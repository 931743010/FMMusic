//
//  YXBottomView.h
//  FMMusic
//
//  Created by apple on 13-8-27.
//  Copyright (c) 2013年 apple. All rights reserved.
//  底部的view 

#import <UIKit/UIKit.h>
#import "YXViewController.h"

@interface YXBottomView : UIView <UIGestureRecognizerDelegate>

//@property (nonatomic, assign) YXViewController *viewController;

@property (nonatomic, retain) UILabel *labelSongName;

@property (nonatomic, retain) UIImageView *imageView;

- (void)imageViewAnimationStart;

- (void)imageViewAnimationStop;



@end
