//
//  ViewCell.m
//  DzyCollection
//
//  Created by Dzy on 24/01/2017.
//  Copyright © 2017 Dzy. All rights reserved.
//

#import "ViewCell.h"

#import "FMGodTableView.h"

@interface ViewCell ()

<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ) UIScrollView *titleMenu;
@property (nonatomic,retain) FMGodTableView *tableView;
@property (nonatomic ) NSMutableArray *data;
@end

@implementation ViewCell

- (void)loadDataWithIndex:(NSInteger)index {
    
    // if have data not load
    NSLog(@"will to load data %ld",(long)index);

}


- (UIScrollView *)titleMenu {

    if (!_titleMenu ) {
        UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 375, 60)];
        scroll.backgroundColor = [UIColor redColor];
        scroll.showsVerticalScrollIndicator = NO;
        scroll.showsHorizontalScrollIndicator = NO;
        scroll.bounces = NO;
        scroll.contentSize = CGSizeMake(375 * 2, 60);
        scroll.delegate = self;
        NSArray * strings = @[@"title1",@"title2",@"title3",@"title4",@"title5"];
        float w = scroll.contentSize.width / (strings.count);
        float x = scroll.contentSize.width-w;
        int counts = (int)strings.count-1;
        
        for (int i=counts;i>=0;i--) {

            NSString *str = strings[i];
            UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, w, 60)];
            [scroll addSubview:l];
            //        l.layer.borderColor = [UIColor colorWithRed:0.01 green:0.01 blue:0.01 alpha:0.3].CGColor;
            //        l.layer.borderWidth = 0.5;
            l.backgroundColor = [UIColor whiteColor];
            l.text = str;
            l.textAlignment = NSTextAlignmentCenter;
            l = nil;
            x -= w;
            
        }
        _titleMenu = scroll;
    }
    return _titleMenu;
}

-(void)createTableViews{

    [self.contentView addSubview:self.titleMenu];
    
    _tableView = [[FMGodTableView alloc] initWithFrame:CGRectMake(0, 60, 375, self.bounds.size.height - 60)];
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
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentify = @"cell";
    FMGodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        cell = [[FMGodTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
        
    }
    
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

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    
}

-(void)awakeFromNib{
    [super awakeFromNib];
//    NSLog(@"666");
}

@end
