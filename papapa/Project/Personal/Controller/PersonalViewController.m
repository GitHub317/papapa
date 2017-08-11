//
//  PersonalViewController.m
//  papapa
//
//  Created by 二师兄 on 2017/8/10.
//  Copyright © 2017年 Ershixiong. All rights reserved.
//

#import "PersonalViewController.h"
#import "PersonalPageInfoView.h"
#import "PersonalTableHeadView.h"
@interface PersonalViewController ()<UITableViewDelegate,UITableViewDataSource>{
    //个人中心标题数组
    NSArray                                     * _titleArray;
    //个人信息表头
    PersonalTableHeadView            *_infoView;
}

/**
 个人中心表格
 */
@property(nonatomic,strong)UITableView     * personalTableView;

@end
@implementation PersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)navigation{
    //置空左按钮
    [self barButtonItemImageName:@"" position:@"left"];
}
- (void)controlView{
    [self createPersonalTableView];
    _titleArray = @[@"会员充值",@"金币商城",@"礼物提现",@"应用设置"];
    [_personalTableView reloadData];
    _infoView = [[PersonalTableHeadView alloc]initWithFrame:RECT(0, 0, SCREEN_WIDTH, 350)];
    _personalTableView.tableHeaderView = _infoView;
    [_infoView showHeadViewWithModel:nil backGroundImage:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1502458182337&di=e11f347a7943165035515b2ad16e8a1b&imgtype=0&src=http%3A%2F%2Fimgs.aixifan.com%2Fcontent%2F2016_06_26%2F1466908873.jpg"];
}
-(void)createPersonalTableView{
    _personalTableView = [[UITableView alloc]init];
    [self.view addSubview:_personalTableView];
    [_personalTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);     make.bottom.offset(0);
        make.left.offset(0);    make.right.offset(0);
    }];
    _personalTableView.backgroundColor = [UIColor whiteColor];
    _personalTableView.delegate = self;
    _personalTableView.dataSource = self;
    _personalTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
#pragma mark -
#pragma mark - TableView Delegate/DataSource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ESX_InitCell(BaseCell, @"personalCell");
    [cell setFrame:RECT(0, 0, SCREEN_HEIGHT, 50)];
    [cell showTopSeparator:YES bottomSeparator:YES];
    [cell showIndicator:YES];
    [cell.labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);       make.centerY.offset(0);
    }];
    cell.labelTitle.textColor = COLORHex(COLOR_TEXTCOLOR);
    cell.labelTitle.font = FONT(14);
    cell.labelTitle.text = _titleArray[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
@end
