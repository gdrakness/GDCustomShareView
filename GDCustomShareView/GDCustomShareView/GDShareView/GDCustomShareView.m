
//
//  GDCustomShareView.m
//  GDCustomShareView
//
//  Created by gdarkness on 16/5/26.
//  Copyright © 2016年 gdarkness. All rights reserved.
//

#import "GDCustomShareView.h"
#import "GDShareView.h"

@implementation GDCustomShareView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        UIView *maskView = [[UIView alloc]initWithFrame:frame];
        maskView.backgroundColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.5];
        maskView.tag = 100;
        //用户交互开启
        maskView.userInteractionEnabled = YES;
        
        //创建关闭手势
        UITapGestureRecognizer *TapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapGestureRecognizerAction:)];
        [maskView addGestureRecognizer:TapGesture];
        [self addSubview:maskView];
        
        //背景View
        self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 107)];
        self.backView.backgroundColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:0.9];
        //用户交互开启
        self.backView.userInteractionEnabled = YES;
        [self addSubview:self.backView];
        
        //分享View
        self.boderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, _boderView.frame.size.height)];
        self.boderView.backgroundColor = [UIColor clearColor];
        //用户交互开启
        self.boderView.userInteractionEnabled = YES;
        [self addSubview:self.boderView];
        
        //取消按钮
        self.cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancleButton.frame = CGRectMake(0, 0, frame.size.width, 50);
        self.cancleButton.titleLabel.font = [UIFont systemFontOfSize: 17];
        [self.cancleButton setTitleColor:[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0]forState:UIControlStateNormal];
        [self.cancleButton setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancleButton setBackgroundImage:[self imageWithColor:[UIColor whiteColor] size:CGSizeMake(1.0, 1.0)] forState:UIControlStateNormal];
        [self.cancleButton setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:234/255.0f green:234/255.0f blue:234/255.0f alpha:1.0] size:CGSizeMake(1.0, 1.0)] forState:UIControlStateHighlighted];
        [self.cancleButton addTarget:self action:@selector(cancleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.cancleButton];
    }
    return self;
}



/**
 *  颜色生成图片方法
 */
-(UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size{
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark -- ShareScrollView Delegate

-(void)shareScrollViewButtonAction:(GDShareView *)shareScrollView title:(NSString *)title{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(CustomShareViewButtonAction:title:)]) {
        [self.delegate CustomShareViewButtonAction:self title:title];
    }
}

-(void)cancleButtonAction:(UIButton *)sender{
    
    [self tappedCancel];
}

-(void)TapGestureRecognizerAction:(UITapGestureRecognizer *)sender{
    
    [self tappedCancel];
}

-(void)tappedCancel{
    
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
            _footerView.frame = CGRectMake(0, _footerView.frame.origin.y + _backView.frame.size.height, _footerView.frame.size.width, _boderView.frame.size.height);
        }
        if (_boderView) {
            _boderView.frame = CGRectMake(0, _boderView.frame.origin.y +_backView.frame.size.height, _boderView.frame.size.width, _boderView.frame.size.height);
        }
        if (_headerView) {
            _headerView.frame = CGRectMake(0, _headerView.frame.origin.y + _backView.frame.size.height, _headerView.frame.size.width, _headerView.frame.size.height);
        }
    }completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    float height = 0;
    
    if (_cancleButton) {
        height += _cancleButton.frame.size.height;
        _cancleButton.frame = CGRectMake(0, self.frame.size.height - height, _cancleButton.frame.size.width, _cancleButton.frame.size.height);
        _cancleButton.hidden = YES;
    }
    if (_footerView) {
        height += _footerView.frame.size.height;
        _footerView.frame = CGRectMake(0, self.frame.size.height - height, _footerView.frame.size.width, _footerView.frame.size.height);
        _footerView.hidden = YES;
    }
    if (_boderView) {
        height += _boderView.frame.size.height;
        _boderView.frame = CGRectMake(0, self.frame.size.height - height, _boderView.frame.size.width, _boderView.frame.size.height);
        _boderView.hidden = YES;
    }
    if (_headerView) {
        height += _headerView.frame.size.height;
        _headerView.frame = CGRectMake(0, self.frame.size.height - height, _headerView.frame.size.width, _headerView.frame.size.height);
        _headerView.hidden = YES;
    }
    if (_backView) {
        _backView.frame = CGRectMake(0, self.frame.size.height - height, _backView.frame.size.width,height);
        _backView.hidden = YES;
    }
    if (_cancleButton) {
        _cancleButton.frame = CGRectMake(0, _cancleButton.frame.origin.y + _backView.frame.size.height, _cancleButton.frame.size.width, _cancleButton.frame.size.height);
        _cancleButton.hidden = NO;
    }
    if (_footerView) {
        _footerView.frame = CGRectMake(0, _footerView.frame.origin.y + _backView.frame.size.height, _footerView.frame.size.width, _footerView.frame.size.height);
    }
    if (_boderView) {
        _boderView.frame = CGRectMake(0, _boderView.frame.origin.y + _backView.frame.size.height, _boderView.frame.size.width, _boderView.frame.size.height);
    }
    if (_headerView) {
        _headerView.frame = CGRectMake(0, _headerView.frame.origin.y + _backView.frame.size.height, _headerView.frame.size.width, _headerView.frame.size.height);
        _headerView.hidden = NO;
    }
    if (_backView) {
        _backView.frame =CGRectMake(0, self.frame.size.height, _backView.frame.size.width, _backView.frame.size.height);
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

/***********************懒加载************************/
#pragma mark -- Lazy Load
-(void)setHeaderView:(UIView *)headerView{
    
    [_headerView removeFromSuperview];
    _headerView = headerView;
    [self addSubview:_headerView];
}

-(void)setFooterView:(UIView *)footerView{
    
    [_footerView removeFromSuperview];
    _footerView = footerView;
    [self addSubview:_footerView];
}

-(void)setShareAry:(NSArray *)shareAry delegate:(id)delegate{
    
    _delegate = delegate;
    
    if (_firstCount > shareAry.count || _firstCount == 0) {
        _firstCount = shareAry.count;
    }
   
    NSArray *firstArr = [shareAry subarrayWithRange:NSMakeRange(0, _firstCount)];
    NSArray *secondArr = [shareAry subarrayWithRange:NSMakeRange(_firstCount, shareAry.count - _firstCount)];
    
    GDShareView *shareView = [[GDShareView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width,0)];
    [shareView setShareAry:firstArr delegate:self];
    shareView.showsHorizontalScrollIndicator = _showHorizontalScrollIndicator;
    [_boderView addSubview:shareView];
    
    if (_firstCount < shareAry.count) {
        //分割线
        self.minddleLineLabel.frame = CGRectMake(0, shareView.frame.origin.y + shareView.frame.size.height, self.frame.size.width, 0.5);
        
        shareView = [[GDShareView alloc]initWithFrame:CGRectMake(0, _minddleLineLabel.frame.origin.y + _minddleLineLabel.frame.size.height, self.frame.size.width, 0)];
        [shareView setShareAry:secondArr delegate:self];
        shareView.showsHorizontalScrollIndicator = _showHorizontalScrollIndicator;
        [_boderView addSubview:shareView];
        
        if (_firstCount < shareAry.count) {
            //分割线
            self.minddleLineLabel.frame = CGRectMake(0, shareView.frame.origin.y + shareView.frame.size.height, self.frame.size.width, 0.5);
            
            shareView = [[GDShareView alloc]initWithFrame:CGRectMake(0, _minddleLineLabel.frame.origin.y + _minddleLineLabel.frame.size.height, self.frame.size.width, [GDShareView getShareScrollViewHeight])];
            [shareView setShareAry:secondArr delegate:self];
            shareView.showsHorizontalScrollIndicator = _showHorizontalScrollIndicator;
            [_boderView addSubview:shareView];
        }
    }
}

-(UILabel *)minddleLineLabel{
    
    if (!_minddleLineLabel) {
        _minddleLineLabel = [[UILabel alloc]init];
        _minddleLineLabel.backgroundColor = [UIColor colorWithRed:208/255.0f green:208/255.0f blue:208/255.0f alpha:1.0];
        [_boderView addSubview:_minddleLineLabel];
    }
    return _minddleLineLabel;
}

-(float)getBoderViewHeight:(NSArray *)shareAry firstCount:(NSInteger)count{
    
    _firstCount = count;
    float height = [GDShareView getShareScrollViewHeight];
    
    if (_firstCount > shareAry.count || _firstCount == 0) {
        
        return height;
    }
    if (_firstCount < shareAry.count) {
        
        return height * 2 + 1;
    }
    return 0;
}




@end
