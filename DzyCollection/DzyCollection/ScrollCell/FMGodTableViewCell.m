//
//  ViewController.m
//  DzyCollection
//
//  Created by Dzy on 24/01/2017.
//  Copyright © 2017 Dzy. All rights reserved.
//

#import "FMGodTableViewCell.h"

@implementation FMGodTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _mainView.delegate = nil;
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self==[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createViews];
    }
    return self;
}

-(void)createViews{
    
    CGRect screen = [UIScreen mainScreen].bounds;
    _mainView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screen.size.width , self.bounds.size.height)];
    _mainView.showsHorizontalScrollIndicator = NO;
    _mainView.showsVerticalScrollIndicator = NO;
    _mainView.bounces = NO;
    _mainView.contentSize = CGSizeMake(2*_mainView.frame.size.width, self.bounds.size.height);
    _mainView.delegate = self;
    //_mainView.directionalLockEnabled = YES;
    [self.contentView addSubview:_mainView];
    NSArray * strings = @[@"左边标题",@"2",@"3",@"4",@"5"];
    float w = _mainView.contentSize.width / (strings.count);
    float x = _mainView.contentSize.width-w;
    int counts = (int)strings.count-1;
    for (int i=counts;i>=0;i--) {
   
        NSString *str = strings[i];
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, w, self.bounds.size.height)];
        [_mainView addSubview:l];
//        l.layer.borderColor = [UIColor colorWithRed:0.01 green:0.01 blue:0.01 alpha:0.3].CGColor;
//        l.layer.borderWidth = 0.5;
        l.backgroundColor = [UIColor whiteColor];
        l.text = str;
        l.textAlignment = NSTextAlignmentCenter;
        l = nil;
        x -= w;
        
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTap:)];
    [self.contentView addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollMove:) name:GodCellScrollNotification object:nil];
    
}

- (void)clickTap:(UITapGestureRecognizer *)tap {

    if (_clickTap) {
        _clickTap();
    }

}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _isNotification = NO;
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (!_isNotification) {
        // 发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:GodCellScrollNotification object:self userInfo:@{@"x":@(scrollView.contentOffset.x)}];
    }
    _isNotification = NO;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    // 避开自己发的通知，只有手指拨动才会是自己的滚动
    if (!_isNotification) {
        // 发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:GodCellScrollNotification object:self userInfo:@{@"x":@(scrollView.contentOffset.x)}];
    }
    // 控制第一个不发生变化
    NSArray *views = scrollView.subviews;
    UIView *first = views.lastObject;
    CGRect frame = first.frame;
    frame.origin.x = scrollView.contentOffset.x;
    first.frame = frame;
    //[scrollView bringSubviewToFront:first];
    _isNotification = NO;
    
}

-(void)scrollMove:(NSNotification*)notification{
    NSDictionary *xn = notification.userInfo;
    NSObject *obj = notification.object;
    float x = [xn[@"x"] floatValue];
    NSLog(@"%f",x);
    if (obj!=self) {
        _isNotification = YES;
        [_mainView setContentOffset:CGPointMake(x, 0) animated:NO];
    }else{
        _isNotification = NO;
    }
    obj = nil;
}

@end
