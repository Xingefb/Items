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
{
    UIScrollView *titleMenu;
}
@property (nonatomic,retain) FMGodTableView *tableView;
@property (nonatomic ) NSMutableArray *data;
@end

@implementation ViewCell

- (void)loadDataWithIndex:(NSInteger)index {
    
    // if have data not load 
    NSLog(@"will to load data %ld",(long)index);

}

-(void)createTableViews{
    
    titleMenu = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 375, 60)];
    titleMenu.backgroundColor = [UIColor redColor];
    titleMenu.contentSize = CGSizeMake(500, 80);
    [self.contentView addSubview:titleMenu];
    
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
    // 发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:GodCellScrollNotification object:self userInfo:@{@"x":@(_CellLastScrollX)}];
    
}

-(void)scrollMove:(NSNotification*)notification{
    NSDictionary *xn = notification.userInfo;
    NSObject *obj = notification.object;
    float x = [xn[@"x"] floatValue];
    _CellLastScrollX = x;
    [titleMenu setContentOffset:CGPointMake(x, 0) animated:NO];
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
