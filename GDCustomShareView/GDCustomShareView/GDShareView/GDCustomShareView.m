
//
//  GDCustomShareView.m
//  GDCustomShareView
//
//  Created by gdarkness on 16/5/26.
//  Copyright © 2016年 gdarkness. All rights reserved.
//

#import "GDCustomShareView.h"
#import "GDShareView.h"

#define CGMMainScreenWidth ([[UIScreen mainScreen] bounds].size.width)
#define CGMMainScreenHeight ([[UIScreen mainScreen] bounds].size.height)

static NSArray *shareWeiboArr = nil;
static NSArray *shareWeixinArr = nil;
static NSArray *shareQQArr = nil;
static NSArray *shareTaobaoArr = nil;
static NSArray *shareGuanjiaArr = nil;

@implementation GDCustomShareView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *maskView = [[UIView alloc] initWithFrame:frame];
        maskView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6];
        maskView.tag = 100;
        maskView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *myTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerAction:)];
        [maskView addGestureRecognizer:myTap];
        [self addSubview:maskView];
        
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 107)];
        _backView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.9];
        _backView.userInteractionEnabled = YES;
        [self addSubview:_backView];
        
        _boderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, _backView.frame.size.height)];
        _boderView.backgroundColor = [UIColor clearColor];
        _boderView.userInteractionEnabled = YES;
        [self addSubview:_boderView];
        
        _cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancleButton.frame = CGRectMake(0, 0, frame.size.width, 50);
        _cancleButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_cancleButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancleButton setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_cancleButton setBackgroundImage:[self imageWithColor:[UIColor whiteColor] size:CGSizeMake(1.0, 1.0)] forState:UIControlStateNormal];
        [_cancleButton setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1.0] size:CGSizeMake(1.0, 1.0)] forState:UIControlStateHighlighted];
        [_cancleButton addTarget:self action:@selector(cancleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancleButton];
    }
    return self;
}

-(void)setHeaderView:(UIView *)headerView {
    [_headerView removeFromSuperview];
    _headerView = headerView;
    [self addSubview:_headerView];
}

-(void)setFooterView:(UIView *)footerView {
    [_footerView removeFromSuperview];
    _footerView = footerView;
    [self addSubview:_footerView];
}

- (void)setShareAry:(NSArray *)shareAry delegate:(id)delegate {
    
    _delegate = delegate;
    
    if (_firstCount > shareAry.count || _firstCount == 0) {
        _firstCount = shareAry.count;
    }
    
    NSArray *firstArr = [shareAry subarrayWithRange:NSMakeRange(0,_firstCount)];
    NSArray *secondArr = [shareAry subarrayWithRange:NSMakeRange(_firstCount,shareAry.count-_firstCount)];
    
    GDShareView *shareScrollView = [[GDShareView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, [GDShareView getShareScrollViewHeight])];
    [shareScrollView setShareAry:firstArr delegate:self];
    shareScrollView.showsHorizontalScrollIndicator = _showsHorizontalScrollIndicator;
    [_boderView addSubview:shareScrollView];
    
    if (_firstCount < shareAry.count) {
        //分割线
        self.middleLineLabel.frame = CGRectMake(0, shareScrollView.frame.origin.y+shareScrollView.frame.size.height, self.frame.size.width, 0.5);
        
        shareScrollView = [[GDShareView alloc] initWithFrame:CGRectMake(0, _minddleLineLabel.frame.origin.y+_minddleLineLabel.frame.size.height, self.frame.size.width, [GDShareView getShareScrollViewHeight])];
        [shareScrollView setShareAry:secondArr delegate:self];
        shareScrollView.showsHorizontalScrollIndicator = _showsHorizontalScrollIndicator;
        [_boderView addSubview:shareScrollView];
    }
}

- (UILabel *)middleLineLabel {
    if (!_minddleLineLabel) {
        _minddleLineLabel = [UILabel new];
        _minddleLineLabel.backgroundColor = [UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1.0];
        [_boderView addSubview:_minddleLineLabel];
    }
    return _minddleLineLabel;
}

- (float)getBoderViewHeight:(NSArray *)shareAry firstCount:(NSInteger)count {
    _firstCount = count;
    float height = [GDShareView getShareScrollViewHeight];
    
    if (_firstCount > shareAry.count || _firstCount == 0) {
        return height;
    }
    
    if (_firstCount < shareAry.count) {
        return height*2+1;
    }
    return 0;
}

#pragma mark GDShareViewDelegate

- (void)shareScrollViewButtonAction:(GDShareView *)shareScrollView title:(NSString *)title {
    if (_delegate && [_delegate respondsToSelector:@selector(CustomShareViewButtonAction:title:)]) {
        [_delegate CustomShareViewButtonAction:self title:title];
    }
}

- (void)cancleButtonAction:(UIButton *)sender {
    [self tappedCancel];
}

- (void)tapGestureRecognizerAction:(UITapGestureRecognizer *)sender {
    [self tappedCancel];
}

- (void)tappedCancel {
    [UIView animateWithDuration:0.5 animations:^{
        UIView *maskView = (UIView *)[self viewWithTag:100];
        maskView.alpha = 0;
        
        if (_backView) {
            _backView.frame = CGRectMake(0, self.frame.size.height, _backView.frame.size.width, _backView.frame.size.height);
        }
        
        if (_cancleButton) {
            _cancleButton.frame = CGRectMake(0, _cancleButton.frame.origin.y + _backView.frame.size.height, _cancleButton.frame.size.width, _cancleButton.frame.size.height);
        }
        
        if (_footerView) {
            _footerView.frame = CGRectMake(0, _footerView.frame.origin.y + _backView.frame.size.height, _footerView.frame.size.width, _footerView.frame.size.height);
        }
        
        if (_boderView) {
            _boderView.frame = CGRectMake(0, _boderView.frame.origin.y + _backView.frame.size.height, _boderView.frame.size.width, _boderView.frame.size.height);
        }
        
        if (_headerView) {
            _headerView.frame = CGRectMake(0, _headerView.frame.origin.y + _backView.frame.size.height, _headerView.frame.size.width, _headerView.frame.size.height);
        }
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    float height = 0;
    
    if (_cancleButton) {
        height += _cancleButton.frame.size.height;
        _cancleButton.frame = CGRectMake(0, self.frame.size.height-height, _cancleButton.frame.size.width, _cancleButton.frame.size.height);
        _cancleButton.hidden = YES;
    }
    
    if (_footerView) {
        height += _footerView.frame.size.height;
        _footerView.frame = CGRectMake(0, self.frame.size.height-height, _footerView.frame.size.width, _footerView.frame.size.height);
        _footerView.hidden = YES;
    }
    
    if (_boderView) {
        height += _boderView.frame.size.height;
        _boderView.frame = CGRectMake(0, self.frame.size.height-height, _boderView.frame.size.width, _boderView.frame.size.height);
        _boderView.hidden = YES;
    }
    
    if (_headerView) {
        height += _headerView.frame.size.height;
        _headerView.frame = CGRectMake(0, self.frame.size.height-height, _headerView.frame.size.width, _headerView.frame.size.height);
        _headerView.hidden = YES;
    }
    
    if (_backView) {
        _backView.frame = CGRectMake(0, self.frame.size.height-height, _backView.frame.size.width, height);
        _backView.hidden = YES;
    }
    
    if (_cancleButton) {
        _cancleButton.frame = CGRectMake(0, _cancleButton.frame.origin.y + _backView.frame.size.height, _cancleButton.frame.size.width, _cancleButton.frame.size.height);
        _cancleButton.hidden = NO;
    }
    
    if (_footerView) {
        _footerView.frame = CGRectMake(0, _footerView.frame.origin.y + _backView.frame.size.height, _footerView.frame.size.width, _footerView.frame.size.height);
        _footerView.hidden = NO;
    }
    
    if (_boderView) {
        _boderView.frame = CGRectMake(0, _boderView.frame.origin.y + _backView.frame.size.height, _boderView.frame.size.width, _boderView.frame.size.height);
        _boderView.hidden = NO;
    }
    
    if (_headerView) {
        _headerView.frame = CGRectMake(0, _headerView.frame.origin.y + _backView.frame.size.height, _headerView.frame.size.width, _headerView.frame.size.height);
        _headerView.hidden = NO;
    }
    
    if (_backView) {
        _backView.frame = CGRectMake(0, self.frame.size.height, _backView.frame.size.width, _backView.frame.size.height);
        _backView.hidden = NO;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        
        if (_cancleButton) {
            _cancleButton.frame = CGRectMake(0, _cancleButton.frame.origin.y - _backView.frame.size.height, _cancleButton.frame.size.width, _cancleButton.frame.size.height);
        }
        
        if (_footerView) {
            _footerView.frame = CGRectMake(0, _footerView.frame.origin.y - _backView.frame.size.height, _footerView.frame.size.width, _footerView.frame.size.height);
        }
        
        if (_boderView) {
            _boderView.frame = CGRectMake(0, _boderView.frame.origin.y - _backView.frame.size.height, _boderView.frame.size.width, _boderView.frame.size.height);
        }
        
        if (_headerView) {
            _headerView.frame = CGRectMake(0, _headerView.frame.origin.y - _backView.frame.size.height, _headerView.frame.size.width, _headerView.frame.size.height);
        }
        
        if (_backView) {
            _backView.frame = CGRectMake(0, self.frame.size.height - _backView.frame.size.height, _backView.frame.size.width, _backView.frame.size.height);
        }
        
        UIView *maskView = (UIView *)[self viewWithTag:100];
        maskView.alpha = 0.9;
        
    } completion:^(BOOL finished) {
        
    }];
}

//颜色生成图片方法
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context,color.CGColor);
    
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

/**
 *  仿新浪微博分享界面
 */
- (GDCustomShareView *)addWeiboShareView {
    
//    id object = [self nextResponder];
//    
//    while (![object isKindOfClass:[UIViewController class]] && object != nil) {
//        
//        object = [object nextResponder];
//        
//    }
//    UIViewController *vc=(UIViewController*)object;
    
    //自定义头部
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGMMainScreenWidth, 36)];
    headerView.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 21, headerView.frame.size.width-32, 15)];
    label.textColor = [UIColor colorWithRed:94/255.0 green:94/255.0 blue:94/255.0 alpha:1.0];;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15];
    label.text = @"分享到";
    [headerView addSubview:label];
    
    //实例化
    GDCustomShareView *shareView = [[GDCustomShareView alloc] initWithFrame:CGRectMake(0, 0, CGMMainScreenWidth, CGMMainScreenHeight)];
    //设置头部View 如果不设置则不显示头部
    shareView.headerView = headerView;
    //计算高度 根据第一行显示的数量和总数,可以确定显示一行还是两行,最多显示2行
    float height = [shareView getBoderViewHeight:[GDCustomShareView shareWeiboArr] firstCount:9];
    shareView.boderView.frame = CGRectMake(0, 0, shareView.frame.size.width, height);
    shareView.firstCount = 9;
//    [shareView setShareAry:[GDCustomShareView shareWeiboArr] delegate:self];
//    [vc.navigationController.view addSubview:shareView];
    return shareView;
}

/**
 *  仿微信分享界面
 */
- (GDCustomShareView *)addWeixinShareView {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGMMainScreenWidth, 30)];
    headerView.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 9, headerView.frame.size.width, 11)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:99/255.0 green:98/255.0 blue:98/255.0 alpha:1.0];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:11];
    label.text = @"网页由 mp.weixin.qq.com 提供";
    [headerView addSubview:label];
    
    GDCustomShareView *shareView = [[GDCustomShareView alloc] initWithFrame:CGRectMake(0, 0, CGMMainScreenWidth, CGMMainScreenHeight)];
    shareView.backView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.9];
    shareView.headerView = headerView;
    float height = [shareView getBoderViewHeight:[GDCustomShareView shareWeixinArr] firstCount:6];
    shareView.boderView.frame = CGRectMake(0, 0, shareView.frame.size.width, height);
    shareView.minddleLineLabel.frame = CGRectMake(10, shareView.minddleLineLabel.frame.origin.y, shareView.frame.size.width-20, shareView.minddleLineLabel.frame.size.height);
    shareView.showsHorizontalScrollIndicator = NO;
//    [self.navigationController.view addSubview:shareView];
    return shareView;
}

/**
 *  仿QQ分享界面
 */
- (GDCustomShareView *)addQQShareView {
    
    GDCustomShareView *shareView = [[GDCustomShareView alloc] initWithFrame:CGRectMake(0, 0, CGMMainScreenWidth, CGMMainScreenHeight)];
    shareView.backView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0];
    float height = [shareView getBoderViewHeight:[GDCustomShareView shareQQArr] firstCount:5];
    shareView.boderView.frame = CGRectMake(0, 0, shareView.frame.size.width, height);
    shareView.cancleButton.frame = CGRectMake(shareView.cancleButton.frame.origin.x, shareView.cancleButton.frame.origin.y, shareView.cancleButton.frame.size.width, 54);
    shareView.cancleButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [shareView.cancleButton setTitleColor:[UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
//    [self.navigationController.view addSubview:shareView];
    return shareView;
}

/**
 *  仿淘宝分享界面
 */
- (GDCustomShareView *)addTaobaoShareView {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGMMainScreenWidth, 30)];
    headerView.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 17, headerView.frame.size.width, 15)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:51/255.0 green:68/255.0 blue:79/255.0 alpha:1.0];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15];
    label.text = @"分享";
    [headerView addSubview:label];
    
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGMMainScreenWidth, 120)];
    footerView.backgroundColor = [UIColor clearColor];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, footerView.frame.size.width-20, 0.5)];
    lineLabel.backgroundColor = [UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1.0];
    [footerView addSubview:lineLabel];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(12, 13, headerView.frame.size.width-24, 12)];
    label.textColor = [UIColor colorWithRed:5/255.0 green:27/255.0 blue:40/255.0 alpha:1.0];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:12];
    label.text = @"手机联系人和淘友";
    [footerView addSubview:label];
    
    UIImageView *icoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(label.frame.origin.x, label.frame.origin.y+label.frame.size.height+12, 57, 57)];
    icoImageView.image = [UIImage imageNamed:@"taobao_lianxiren"];
    [footerView addSubview:icoImageView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(icoImageView.frame.origin.x+icoImageView.frame.size.width, icoImageView.frame.origin.y, headerView.frame.size.width-24-icoImageView.frame.size.width, icoImageView.frame.size.height)];
    view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [footerView addSubview:view];
    
    NSString *content = @"分享给淘友或手机联系人,好友可在手机淘宝【消息中心】或【短信】中看到你的分享";
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:content];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:5];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, content.length)];
    //调节高度
    CGSize size = CGSizeMake(headerView.frame.size.width-24-icoImageView.frame.size.width, 500000);
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(icoImageView.frame.origin.x+icoImageView.frame.size.width+10, icoImageView.frame.origin.y, headerView.frame.size.width-24-icoImageView.frame.size.width-10, icoImageView.frame.size.height)];
    label.textColor = [UIColor colorWithRed:107/255.0 green:107/255.0 blue:107/255.0 alpha:1.0];
    label.numberOfLines = 0;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:12];
    label.attributedText = attributedString;
    [footerView addSubview:label];
    [label sizeThatFits:size];
    
    GDCustomShareView *shareView = [[GDCustomShareView alloc] initWithFrame:CGRectMake(0, 0, CGMMainScreenWidth, CGMMainScreenHeight)];
    shareView.backView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.9];
    shareView.headerView = headerView;
    float height = [shareView getBoderViewHeight:[GDCustomShareView shareTaobaoArr] firstCount:3];
    shareView.boderView.frame = CGRectMake(0, 0, shareView.frame.size.width, height);
    shareView.footerView = footerView;
//    [self.navigationController.view addSubview:shareView];
    return shareView;
}

/**
 *  仿生日管家分享界面
 */
- (GDCustomShareView *)addGuanjiaShareView {
   
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGMMainScreenWidth, 54)];
    headerView.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, headerView.frame.size.width, 15)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15];
    label.text = @"分享到";
    [headerView addSubview:label];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, headerView.frame.size.height-0.5, headerView.frame.size.width, 0.5)];
    lineLabel.backgroundColor = [UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1.0];
    [headerView addSubview:lineLabel];
    
    UILabel *lineLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, headerView.frame.size.width, 0.5)];
    lineLabel1.backgroundColor = [UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1.0];
    
    GDCustomShareView *shareView = [[GDCustomShareView alloc] initWithFrame:CGRectMake(0, 0, CGMMainScreenWidth, CGMMainScreenHeight)];
    shareView.backView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    shareView.headerView = headerView;
    float height = [shareView getBoderViewHeight:[GDCustomShareView shareGuanjiaArr] firstCount:7];
    shareView.boderView.frame = CGRectMake(0, 0, shareView.frame.size.width, height);
    shareView.minddleLineLabel.hidden = YES;
    [shareView.cancleButton addSubview:lineLabel1];
    shareView.cancleButton.frame = CGRectMake(shareView.cancleButton.frame.origin.x, shareView.cancleButton.frame.origin.y, shareView.cancleButton.frame.size.width, 54);
    shareView.cancleButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [shareView.cancleButton setTitleColor:[UIColor colorWithRed:184/255.0 green:184/255.0 blue:184/255.0 alpha:1.0] forState:UIControlStateNormal];
//    [self.navigationController.view addSubview:shareView];
    return shareView;
}

#pragma mark -- shareDataSource
/**
 *      分享微博媒介数据源
 *
 */
+(NSArray *)shareWeiboArr{
    return shareWeiboArr = @[@{@"image":@"more_chat",
                               @"highlightedImage":@"more_chat_highlighted",
                               @"title":@"私信和群"},
                             @{@"image":@"more_weixin",
                               @"highlightedImage":@"more_weixin_highlighted",
                               @"title":@"微信好友"},
                             @{@"image":@"more_circlefriends",
                               @"highlightedImage":@"more_circlefriends_highlighted",
                               @"title":@"朋友圈"},
                             @{@"image":@"more_icon_zhifubao",
                               @"highlightedImage":@"more_icon_zhifubao_highlighted",
                               @"title":@"支付宝好友"},
                             @{@"image":@"more_icon_zhifubao_friend",
                               @"highlightedImage":@"more_icon_zhifubao_friend_highlighted",
                               @"title":@"生活圈"},
                             @{@"image":@"more_icon_qq",
                               @"highlightedImage":@"more_icon_qq_highlighted",
                               @"title":@"QQ"},
                             @{@"image":@"more_icon_qzone",
                               @"highlightedImage":@"more_icon_qzone_highlighted",
                               @"title":@"QQ空间"},
                             @{@"image":@"more_mms",
                               @"highlightedImage":@"more_mms_highlighted",
                               @"title":@"短信"},
                             @{@"image":@"more_email",
                               @"highlightedImage":@"more_email_highlighted",
                               @"title":@"邮件分享"},
                             @{@"image":@"more_icon_cardbackground",
                               @"highlightedImage":@"more_icon_cardbackground_highlighted",
                               @"title":@"设卡片背景"},
                             @{@"image":@"more_icon_collection",
                               @"title":@"收藏"},
                             @{@"image":@"more_icon_topline",
                               @"title":@"帮上头条"},
                             @{@"image":@"more_icon_link",
                               @"title":@"复制链接"},
                             @{@"image":@"more_icon_report",
                               @"title":@"举报"},
                             @{@"image":@"more_icon_back",
                               @"title":@"返回首页"}];
}
/**
 *      分享微信媒介数据源
 *
 */
+(NSArray *)shareWeixinArr{
    return   shareWeixinArr = @[@{@"image":@"Action_Share",
                            @"title":@"发送给朋友"},
                          @{@"image":@"Action_Moments",
                            @"title":@"朋友圈"},
                          @{@"image":@"Action_MyFavAdd",
                            @"title":@"收藏"},
                          @{@"image":@"AS_safari",
                            @"title":@"Safari打开"},
                          @{@"image":@"AS_Email",
                            @"title":@"邮件"},
                          @{@"image":@"AS_QQ",
                            @"title":@"QQ"},
                          @{@"image":@"Action_Verified",
                            @"title":@"查看公众号"},
                          @{@"image":@"Action_Copy",
                            @"title":@"复制链接"},
                          @{@"image":@"Action_Font",
                            @"title":@"调整字体"},
                          @{@"image":@"Action_Refresh",
                            @"title":@"刷新"},
                          @{@"image":@"Action_Expose",
                            @"title":@"举报"}];
}
/**
 *      分享QQ媒介数据源
 *
 */
+(NSArray *)shareQQArr{
    return  shareQQArr = @[@{@"image":@"qq_haoyou",
                                @"title":@"好友"},
                              @{@"image":@"qq_kongjian",
                                @"title":@"QQ空间"},
                              @{@"image":@"qq_weixin",
                                @"title":@"微信"},
                              @{@"image":@"qq_pengyouquan",
                                @"title":@"朋友圈"},
                              @{@"image":@"qq_safari",
                                @"title":@"Safari打开"},
                              @{@"image":@"qq_ziliao",
                                @"title":@"查看资料"},
                              @{@"image":@"qq_shoucang",
                                @"title":@"收藏"},
                              @{@"image":@"qq_fuzhi",
                                @"title":@"复制链接"},
                              @{@"image":@"qq_jubao",
                                @"title":@"举报"}];
}
/**
 *      分享淘宝媒介数据源
 *
 */
+(NSArray *)shareTaobaoArr{
    return  shareTaobaoArr =  @[@{@"image":@"taobao_fuzhi",
                                  @"title":@"复制"},
                                @{@"image":@"taobao_erweima",
                                  @"title":@"二维码"},
                                @{@"image":@"taobao_songli",
                                  @"title":@"送礼"},
                                @{@"image":@"taobao_weixin",
                                  @"title":@"微信"},
                                @{@"image":@"taobao_qq",
                                  @"title":@"QQ好友"},
                                @{@"image":@"taobao_weibo",
                                  @"title":@"微博"},
                                @{@"image":@"taobao_guangjie",
                                  @"title":@"爱逛街"},
                                @{@"image":@"taobao_zhifu",
                                  @"title":@"支付宝好友"}];
}
/**
 *      分享管家媒介数据源
 *
 */
+(NSArray *)shareGuanjiaArr{
    return  shareGuanjiaArr = @[@{@"image":@"shareView_wx",
                                   @"title":@"微信"},
                                 @{@"image":@"shareView_friend",
                                   @"title":@"朋友圈"},
                                 @{@"image":@"shareView_qq",
                                   @"title":@"QQ"},
                                 @{@"image":@"shareView_wb",
                                   @"title":@"新浪微博"},
                                 @{@"image":@"shareView_rr",
                                   @"title":@"人人网"},
                                 @{@"image":@"shareView_qzone",
                                   @"title":@"QQ空间"},
                                 @{@"image":@"shareView_msg",
                                   @"title":@"短信"},
                                 @{@"image":@"share_copyLink",
                                   @"title":@"复制链接"}];
}
@end
