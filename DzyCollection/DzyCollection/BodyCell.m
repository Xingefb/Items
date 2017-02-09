//
//  BodyCell.m
//  DzyCollection
//
//  Created by Dzy on 24/01/2017.
//  Copyright © 2017 Dzy. All rights reserved.
//

#import "BodyCell.h"

#import "FMGodTableView.h"

#import <AFNetworking.h>
#import "BodyModel.h"

static NSString *LoadMessage = @"LoadMessage";

#define SWidth [UIScreen mainScreen].bounds.size.width
#define SHeight [UIScreen mainScreen].bounds.size.height

@interface BodyCell ()

<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ) UIScrollView *titleMenu;
@property (nonatomic,retain) FMGodTableView *tableView;
@property (nonatomic ) NSMutableArray *data;

@property (nonatomic ) NSInteger createNum;

@end

@implementation BodyCell

- (void)setIndexID:(NSString *)indexID {
    
    _indexID = indexID;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:GodCellScrollNotification object:self userInfo:@{@"x":@(0)}];
 
    [self loadData];
}

- (void)loadData {

    [self.data removeAllObjects];

    [[AFHTTPSessionManager manager] GET:@"https://testapp.youbicaifu.com/wealth/tape/getTapeList289?type=currentgains&sort=0&page_flag=1&req_num=10" parameters:@{@"type_id":self.indexID} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
        NSLog(@"%@",responseObject);

        for (NSDictionary *dic in responseObject[@"data"][@"tape_list"]) {
            BodyModel *model = [[BodyModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.data addObject:model];
        }
        
        [self.tableView reloadData];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadData];
    });
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HHmm"];
    NSDate * date = [NSDate date];
    NSString * dateString = [formatter stringFromDate:date];
    
    if ([dateString compare:@"0700"] == NSOrderedDescending && [dateString compare:@"0930"] == NSOrderedAscending) {


    }
    
    if ([dateString compare:@"1300"] == NSOrderedDescending && [dateString compare:@"1500"] == NSOrderedAscending) {

    }
    
    if ([dateString compare:@"1900"] == NSOrderedDescending && [dateString compare:@"2100"] == NSOrderedAscending) {

    }

}

- (UIScrollView *)titleMenu {

    if (!_titleMenu ) {
        UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SWidth, 60)];
        scroll.backgroundColor = [UIColor redColor];
        scroll.showsVerticalScrollIndicator = NO;
        scroll.showsHorizontalScrollIndicator = NO;
        scroll.bounces = NO;
        scroll.contentSize = CGSizeMake(SWidth / 2 * 3, 60);
        scroll.delegate = self;
        NSArray * strings = @[@"藏品名称",@"最新价格",@"涨跌幅",@"换手率",@"成交量"];
        float w = SWidth / 4;
        float x = scroll.contentSize.width-w;
        int counts = (int)strings.count-1;
        
        for (int i=counts;i>=0;i--) {

            NSString *str = strings[i];
            if (i == 0) {
                x = 0;
                w = SWidth / 2;
            }
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, w, 60)];
            [scroll addSubview:btn];
            //        l.layer.borderColor = [UIColor colorWithRed:0.01 green:0.01 blue:0.01 alpha:0.3].CGColor;
            //        l.layer.borderWidth = 0.5;
            btn.backgroundColor = [UIColor whiteColor];
            [btn setTitle:str forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            btn = nil;
            x -= w;
            
        }
        _titleMenu = scroll;
    }
    return _titleMenu;
}

-(void)createTableViews{

    self.data = [NSMutableArray arrayWithCapacity:10];
    
    [self.contentView addSubview:self.titleMenu];
    
    _tableView = [[FMGodTableView alloc] initWithFrame:CGRectMake(0, 60, SWidth, self.bounds.size.height - 60)];
    [self.contentView addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    
    // 注册一个
    extern NSString *GodCellScrollNotification;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollMove:) name:GodCellScrollNotification object:nil];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentify = @"cell";
    FMGodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        cell = [[FMGodTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
        
    }
    // 设置分割线顶头显示
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.separatorInset = UIEdgeInsetsZero;
    
    BodyModel *model = self.data[indexPath.item];
    cell.model = model;
    
    [cell setClickTap:^{
        NSLog(@" - %ld",(long)indexPath.row);
        
    }];
    
    return cell;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    // 控制第一个不发生变化
    NSArray *views = scrollView.subviews;
    UIView *first = views.lastObject;
    CGRect frame = first.frame;
    frame.origin.x = scrollView.contentOffset.x;
    first.frame = frame;
    
    if (scrollView == self.tableView) {
        // 发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:GodCellScrollNotification object:self userInfo:@{@"x":@(_CellLastScrollX)}];
    }else {
        [[NSNotificationCenter defaultCenter] postNotificationName:GodCellScrollNotification object:@"scroll" userInfo:@{@"x":@(scrollView.contentOffset.x)}];

    }
    
}

-(void)scrollMove:(NSNotification*)notification{
    NSDictionary *xn = notification.userInfo;
    NSObject *obj = notification.object;
    if (![obj isEqual:@"scroll"]) {
        float x = [xn[@"x"] floatValue];
        _CellLastScrollX = x;
        [_titleMenu setContentOffset:CGPointMake(x, 0) animated:NO];
    }

    obj = nil;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {

    if (self = [super initWithCoder:aDecoder]) {

        [self createTableViews];

        NSLog(@"init ");
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

        NSLog(@"init ");
        
        [self createTableViews];

    }
    return self;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    
    NSLog(@"dealloc");
}

-(void)awakeFromNib{
    [super awakeFromNib];
//    NSLog(@"666");
}

@end
