//
//  ViewController.m
//  GDCustomShareView
//
//  Created by gdarkness on 16/5/26.
//  Copyright © 2016年 gdarkness. All rights reserved.
//

#import "ViewController.h"
#import "GDCustomShareView.h"

static NSString *Identifier = @"Identifier";


@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
//微博
@property (nonatomic, strong) GDCustomShareView *shareWeiboView;
//微信
@property (nonatomic, strong) GDCustomShareView *shareWeixinView;
//QQ
@property (nonatomic, strong) GDCustomShareView *shareQQView;
//淘宝
@property (nonatomic, strong) GDCustomShareView *shareTaobaoView;
//管家
@property (nonatomic, strong) GDCustomShareView *shareGuanjiaView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"GDCustomShareView";
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

#pragma mark -- UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"新浪分享";
            break;
        case 1:
            cell.textLabel.text = @"微信分享";
            break;
        case 2:
            cell.textLabel.text = @"QQ分享";
            break;
        case 3:
            cell.textLabel.text = @"淘宝分享";
            break;
        case 4:
            cell.textLabel.text = @"生日管家分享";
            break;
            
        default:
            break;
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            //微博
            [self.navigationController.view addSubview:self.shareWeiboView];
            break;
        case 1:
            //微信
            [self.navigationController.view addSubview:self.shareWeixinView];
            break;
        case 2:
            //QQ
            [self.navigationController.view addSubview:self.shareQQView];
            break;
        case 3:
            //淘宝
            [self.navigationController.view addSubview:self.shareTaobaoView];
            break;
        case 4:
            //生日管家
            [self.navigationController.view addSubview:self.shareGuanjiaView];
            break;
            
        default:
            break;
    }
}

#pragma mark GDCustomShareViewDelegate

- (void)CustomShareViewButtonAction:(GDCustomShareView *)shareView title:(NSString *)title {
    NSLog(@"当前点击的是:%@",title);
}

#pragma mark -- LazyLoad
/***********************懒加载************************/

-(GDCustomShareView *)shareWeiboView{
    if (_shareWeiboView) {
        _shareWeiboView = nil;
    }
    if (!_shareWeiboView) {
        _shareWeiboView = [[GDCustomShareView alloc]addWeiboShareView];
        [_shareWeiboView setShareAry: [GDCustomShareView shareWeiboArr] delegate:self];
    }return  _shareWeiboView;
}

-(GDCustomShareView *)shareWeixinView{
    if (_shareWeixinView) {
        _shareWeixinView = nil;
    }
    if (!_shareWeixinView) {
        _shareWeixinView = [[GDCustomShareView alloc]addWeixinShareView];
        [_shareWeixinView setShareAry:[GDCustomShareView shareWeixinArr]delegate:self];
    }return _shareWeixinView;
}

-(GDCustomShareView *)shareQQView{
    if (_shareQQView) {
        _shareQQView = nil;
    }
    if (!_shareQQView) {
        _shareQQView = [[GDCustomShareView alloc]addQQShareView];
        [_shareQQView setShareAry:[GDCustomShareView shareQQArr] delegate:self];
    }return _shareQQView;
}

-(GDCustomShareView *)shareTaobaoView{
    if (_shareTaobaoView) {
        _shareTaobaoView = nil;
    }
    if (!_shareTaobaoView) {
        _shareTaobaoView = [[GDCustomShareView alloc]addTaobaoShareView];
        [_shareTaobaoView setShareAry:[GDCustomShareView shareTaobaoArr] delegate:self];
    }return _shareTaobaoView;
}

-(GDCustomShareView *)shareGuanjiaView{
    if (_shareGuanjiaView) {
        _shareGuanjiaView = nil;
    }
    if (!_shareGuanjiaView) {
        _shareGuanjiaView = [[GDCustomShareView alloc]addGuanjiaShareView];
        [_shareGuanjiaView setShareAry:[GDCustomShareView shareGuanjiaArr] delegate:self];
    }return _shareGuanjiaView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
