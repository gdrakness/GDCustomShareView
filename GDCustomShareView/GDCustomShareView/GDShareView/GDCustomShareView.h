//
//  GDCustomShareView.h
//  GDCustomShareView
//
//  Created by gdarkness on 16/5/26.
//  Copyright © 2016年 gdarkness. All rights reserved.
//

#import <UIKit/UIKit.h>

#define OriginX 15.0
#define OriginY 15.0

#define IconWidth 57.0
#define TitleSpace 10.0

#define TitleSize 10.0
#define TitleColor [UIColor colorWithRed:52/255.0f green:52/255.0f blue:50/255.0f alpha:1.0]

#define LastlySpace 15.0
#define HorizontalSpace 15.0

@class GDCustomShareView;

@protocol GDCustomShareViewDelegate <NSObject>

-(void)CustomShareViewButtonAction:(GDCustomShareView *)shareView title:(NSString *)title;

@end

@interface GDCustomShareView : UIView

//背景View
@property (nonatomic, strong) UIView *backView;
//头部分享标题
@property (nonatomic, strong) UIView *headerView;
//中间View，主要放分享
@property (nonatomic, strong) UIView *boderView;
//中间线
@property (nonatomic, strong) UILabel *minddleLineLabel;
//第一行分享媒介数量，分享媒体最多两行若显示一行就不显示两行
@property (nonatomic, assign) NSInteger firstCount;
//尾部其他自定义View
@property (nonatomic, strong) UIView *footerView;
//取消
@property (nonatomic, strong) UIButton *cancleButton;
//是否显示滚动条
@property (nonatomic, assign) BOOL showsHorizontalScrollIndicator;
//代理
@property (nonatomic, assign) id <GDCustomShareViewDelegate>delegate;

-(void)setShareAry:(NSArray *)shareAry delegate:(id)delegate;

-(float)getBoderViewHeight:(NSArray *)shareAry firstCount:(NSInteger)count;

+(NSArray *)shareWeiboArr;

+(NSArray *)shareWeixinArr;

+(NSArray *)shareQQArr;

+(NSArray *)shareTaobaoArr;

+(NSArray *)shareGuanjiaArr;

- (GDCustomShareView *)addWeiboShareView;

- (GDCustomShareView *)addWeixinShareView;

- (GDCustomShareView *)addQQShareView;

- (GDCustomShareView *)addTaobaoShareView;

- (GDCustomShareView *)addGuanjiaShareView;
@end
