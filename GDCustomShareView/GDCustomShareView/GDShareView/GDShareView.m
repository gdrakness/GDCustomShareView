

//
//  GDShareView.m
//  GDCustomShareView
//
//  Created by gdarkness on 16/5/26.
//  Copyright © 2016年 gdarkness. All rights reserved.
//

#import "GDShareView.h"
#import "GDCustomShareView.h"

@implementation GDShareView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.showsHorizontalScrollIndicator = YES;
        self.showsVerticalScrollIndicator = YES;
        self.backgroundColor = [UIColor clearColor];
        
        _originX = OriginX;
        _originY = OriginY;
        _iconWidth = IconWidth;
        _titleSize = TitleSize;
        _titleColor = TitleColor;
        _titleSpace = TitleSpace;
        _lastySpace = LastlySpace;
        _horizontalSpace = HorizontalSpace;
        
        //设置当前ScrollView的高度
        if (self.frame.size.height <= 0) {
            self.frame = CGRectMake(CGRectGetMidX([self frame]), CGRectGetMidY([self frame]), CGRectGetWidth([self frame]), _originY + _iconWidth + _titleSpace + _titleSize + _lastySpace);
        }else {
            self.frame = frame;
        }
    }
    return self;
}

+(float)getShareScrollViewHeight{
    
    float height = OriginY + IconWidth + TitleSize + TitleSpace + LastlySpace;
    return height;
}

-(void)setShareAry:(NSArray *)shareAry delegate:(id)delegate{
    
    //先移除之前的view
    if (self.subviews.count > 0) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    //设置代理
    _myDelegate = delegate;
    
    //设置当前ScrollView的contentSize
    if (shareAry.count > 0) {
        //单行
        self.contentSize = CGSizeMake(_originX + shareAry.count * (_iconWidth + _horizontalSpace), self.frame.size.height);
    }
    
    //遍历标签数组，将标签显示在界面上，并给每个标签上打tag区分
    for (NSDictionary *shareDir in shareAry) {
        NSUInteger i = [shareAry indexOfObject:shareDir];
        
        CGRect frame = CGRectMake(_originX + i * (_iconWidth + _horizontalSpace), _originY, _iconWidth, _iconWidth + _titleSpace + _titleSize);
        UIView *view = [self itemShareViewWithFrame:frame Dictionary:shareDir];
        [self addSubview:view];
    }
}

-(UIView *)itemShareViewWithFrame:(CGRect)frame Dictionary:(NSDictionary *)dic{
    
    NSString *image = dic[@"image"];
    NSString *highlightedImage = dic[@"highlightedImage"];
    NSString *title = [dic[@"title"]length] > 0? dic[@"title"] : @"";
    
    UIImage *iconImage = [UIImage imageNamed:image];
    
    UIView *view =[[UIView alloc]initWithFrame:frame];
    view.backgroundColor = [UIColor clearColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((view.frame.size.width - iconImage.size.width)/2, 0,iconImage.size.width ,iconImage.size.height);
    button.titleLabel.font = [UIFont systemFontOfSize:_titleSize];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    
    if (image.length > 0) {
        [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    }
    if (highlightedImage.length > 0) {
        [button setImage:[UIImage imageNamed:highlightedImage] forState:UIControlStateHighlighted];
    }
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, button.frame.origin.y +button.frame.size.height + _lastySpace, view.frame.size.width, _titleSize)];
    label.textColor = _titleColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:_titleSize];
    label.text = title;
    [view addSubview:label];
    
    return view;
}

-(void)buttonAction:(UIButton *)sender{
    
    if (_myDelegate && [_myDelegate respondsToSelector:@selector(shareScrollViewButtonAction:title:)]) {
        [_myDelegate shareScrollViewButtonAction:self title:sender.titleLabel.text];
    }
}
@end
