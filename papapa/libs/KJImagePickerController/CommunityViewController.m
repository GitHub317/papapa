//
//  CommunityViewController.m
//  Grass
//
//  Created by 王振 on 15/11/19.
//  Copyright © 2015年 王振. All rights reserved.
//

#import "CommunityViewController.h"
#import "KJImagePickerController.h"
#define K_CYCLE_COLOR @"0280da"
#define COLOR_TEXTCOLOR_333333 @"333333"
#define COLOR_BACKGROUND_F2F2F2 @"f2f2f2"
#define COLOR_TEXTCOLOR_515151 @"515151"
#define COLOR_LINE_DBDBDB @"dbdbdb"
@interface CommunityViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *arrayDataSource;
@property (strong, nonatomic) UIImageView *headView;
@end

@implementation CommunityViewController

#pragma mark - life Cycle Method

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithHexString:COLOR_TEXTCOLOR_333333]];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrayDataSource = [[NSMutableArray alloc] initWithCapacity:0];
    self.navigationItem.title = @"图片选择器";
    [self getDataWithCurrentPage:1];
    [self.view addSubview:self.tableView];
}

#pragma mark - DataSource Method

- (void)getDataWithCurrentPage:(NSInteger)page {
    for (int i = 0; i < 10; i ++) {
        NSString * string = [NSString stringWithFormat:@"模块%d.",i + 1];
        [self.arrayDataSource addObject:string];
    }
}

#pragma mark - GET Method

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithHexString:COLOR_BACKGROUND_F2F2F2];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = self.headView;
    }
    return _tableView;
}

- (UIImageView *)headView {
    if (!_headView) {
        _headView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300)];
        _headView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _headView;
}

#pragma mark - Delegate Method: UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayDataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * identifier = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        CALayer * layer = [[CALayer alloc] init];
        layer.frame = CGRectMake(0, cell.frame.size.height - 0.5, SCREEN_WIDTH, 0.5);
        layer.backgroundColor = [UIColor colorWithHexString:COLOR_LINE_DBDBDB].CGColor;
        [cell.layer addSublayer:layer];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.arrayDataSource [indexPath.row];
    cell.textLabel.textColor = [UIColor colorWithHexString:COLOR_TEXTCOLOR_515151];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [KJImagePickerController showImagePickControllerIn:self sourceType:SourceTypePhotoLibrary image:^(UIImage *image) {
            self.headView.image = image;
        } imagePickerControllerDidCancel:^{
            
        }];
    }else if (indexPath.row == 1) {
        [KJImagePickerController showImagePickControllerIn:self sourceType:SourceTypeCamera image:^(UIImage *image) {
            self.headView.image = image;
        } imagePickerControllerDidCancel:^{
            
        }];
    }else if (indexPath.row == 2) {
        [KJImagePickerController showRSKCircleImagePickControllerIn:self sourceType:SourceTypePhotoLibrary image:^(UIImage *image) {
            self.headView.image = image;
        } imagePickerControllerDidCancel:^{
            
        }];
    }else if (indexPath.row == 3) {
        [KJImagePickerController showRSKCircleImagePickControllerIn:self sourceType:SourceTypeCamera image:^(UIImage *image) {
            self.headView.image = image;
        } imagePickerControllerDidCancel:^{
            
        }];
    }else if (indexPath.row == 4) {
        [KJImagePickerController showRSKSquareImagePickControllerIn:self sourceType:SourceTypePhotoLibrary image:^(UIImage *image) {
            self.headView.image = image;
        } imagePickerControllerDidCancel:^{
            
        }];
    }else if (indexPath.row == 5) {
        [KJImagePickerController showRSKSquareImagePickControllerIn:self sourceType:SourceTypeCamera image:^(UIImage *image) {
            self.headView.image = image;
        } imagePickerControllerDidCancel:^{
            
        }];
    }else if (indexPath.row == 6) {
        [KJImagePickerController showRSKCustomImagePickControllerIn:self sourceType:SourceTypePhotoLibrary withRatio:0.5 image:^(UIImage *image) {
            self.headView.image = image;
        } imagePickerControllerDidCancel:^{
            
        }];
    }else if (indexPath.row == 7) {
        [KJImagePickerController showRSKCustomImagePickControllerIn:self sourceType:SourceTypeCamera withRatio:0.2 image:^(UIImage *image) {
            self.headView.image = image;
        } imagePickerControllerDidCancel:^{
            
        }];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
