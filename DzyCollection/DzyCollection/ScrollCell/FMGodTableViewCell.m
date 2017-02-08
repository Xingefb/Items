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

- (UILabel *)name {
    if (!_name) {
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 375 / 2, self.bounds.size.height/2)];
        l.backgroundColor = [UIColor whiteColor];
        l.text = @"name";
        l.textAlignment = NSTextAlignmentLeft;
        l.textColor = [UIColor blackColor];
        l.font = [UIFont systemFontOfSize:16];
        
        _name = l;
    }
    return _name;
}

- (UILabel *)code {
    if (!_code) {
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height/2, 375 / 2, self.bounds.size.height/2)];
        l.backgroundColor = [UIColor whiteColor];
        l.text = @"code";
        l.textAlignment = NSTextAlignmentLeft;
        l.textColor = [UIColor grayColor];
        l.font = [UIFont systemFontOfSize:12];
        _code = l;
    }
    return _code;
}

- (UILabel *)price {
    if (!_price) {
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(375 / 2, 0, 375 / 4, self.bounds.size.height)];
        l.text = @"price";
        l.textAlignment = NSTextAlignmentCenter;
        l.textColor = [UIColor grayColor];
        l.font = [UIFont systemFontOfSize:14];
        _price = l;
    }
    return _price;
}

- (UILabel *)quoteChange {
    if (!_quoteChange) {
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(375 / 4 * 3, 5, 375 / 4, self.bounds.size.height - 10)];
        l.text = @"29.55%";
        l.backgroundColor = [UIColor greenColor];
        [l adjustsFontSizeToFitWidth];
        l.layer.cornerRadius = 5;
        l.layer.masksToBounds = YES;
        l.textAlignment = NSTextAlignmentCenter;
        l.textColor = [UIColor grayColor];
        l.font = [UIFont systemFontOfSize:14];

        _quoteChange = l;
    }
    return _quoteChange;
}

- (UILabel *)turnoverRate {

    if (!_turnoverRate) {
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(375 , 0, 375 / 4, self.bounds.size.height)];
        l.text = @"turnoverRate";
        [l adjustsFontSizeToFitWidth];
        l.textAlignment = NSTextAlignmentCenter;
        l.textColor = [UIColor grayColor];
        l.font = [UIFont systemFontOfSize:14];

        _turnoverRate = l;
    }
    return _turnoverRate;

}

- (UILabel *)volume {
    if (!_volume) {
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(375 / 4 * 5, 0, 375 / 4, self.bounds.size.height)];
        l.text = @"volume";
        [l adjustsFontSizeToFitWidth];
        l.textAlignment = NSTextAlignmentCenter;
        l.textColor = [UIColor grayColor];
        l.font = [UIFont systemFontOfSize:14];

        _volume = l;
    }
    return _volume;
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
    _mainView.contentSize = CGSizeMake(375 / 2 * 3, self.bounds.size.height);
    _mainView.delegate = self;
    //_mainView.directionalLockEnabled = YES;
    [self.contentView addSubview:_mainView];

    [_mainView addSubview:self.price];
    [_mainView addSubview:self.quoteChange];
    [_mainView addSubview:self.turnoverRate];
    [_mainView addSubview:self.volume];
    
    [_mainView addSubview:self.code];
    [_mainView addSubview:self.name];

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
    UIView *first1 = views[views.count-2];
    [self fixedView:first andScrollView:scrollView];
    [self fixedView:first1 andScrollView:scrollView];
    
    //[scrollView bringSubviewToFront:first];
    _isNotification = NO;
    
}
// set fixed view
- (void)fixedView:(UIView *)view andScrollView:(UIScrollView *)scrollView {

    CGRect frame = view.frame;
    frame.origin.x = scrollView.contentOffset.x;
    view.frame = frame;

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
