//
//  YXCellView.h
//  FMMusic
//
//  Created by apple on 13-8-26.
//  Copyright (c) 2013年 apple. All rights reserved.
//  显示频道列表的单元

#import <UIKit/UIKit.h>

@protocol YXCellViewDelegate;
@interface YXCellView : UIControl

@property (nonatomic, retain) UILabel *label01;

@property (nonatomic, retain) UILabel *label02;

@property (nonatomic, retain) UIImageView *imageView;

@property (nonatomic, assign) id<YXCellViewDelegate> delegate;

@end

@protocol YXCellViewDelegate <NSObject>

- (void)cellViewTapped:(id)sender;

@end
