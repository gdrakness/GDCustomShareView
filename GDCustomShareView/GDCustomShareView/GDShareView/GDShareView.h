//
//  GDShareView.h
//  GDCustomShareView
//
//  Created by gdarkness on 16/5/26.
//  Copyright © 2016年 gdarkness. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GDShareView;

@protocol GDShareViewDelegate <NSObject>

-(void)shareScrollViewButtonAction:(GDShareView *)shareScrollView title:(NSString *)title;

@end

@interface GDShareView : UIScrollView

//icon起点X坐标
@property (nonatomic, assign) float originX;
//icon起点Y坐标
@property (nonatomic, assign) float originY;
//正方形图标宽度
@property (nonatomic, assign) float iconWidth;
//图标和标题的间隔
@property (nonatomic, assign) float titleSpace;
//标签字体大小
@property (nonatomic, assign) float titleSize;
//标签字体大小
@property (nonatomic, strong) UIColor *titleColor;
//尾部间隔
@property (nonatomic, assign) float lastySpace;
//横向间距
@property (nonatomic, assign) float horizontalSpace;

@property (nonatomic, assign) id <GDShareViewDelegate>myDelegate;

-(void)setShareAry:(NSArray *)shareAry delegate:(id)delegate;

+(float)getShareScrollViewHeight;

@end
