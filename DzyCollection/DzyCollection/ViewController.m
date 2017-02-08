//
//  ViewController.m
//  DzyCollection
//
//  Created by Dzy on 24/01/2017.
//  Copyright © 2017 Dzy. All rights reserved.
//

#import "ViewController.h"
#import "BodyCell.h"
#import "TitleCell.h"

#import "ColumnView.h"

#define SWidth [UIScreen mainScreen].bounds.size.width
#define SHeight [UIScreen mainScreen].bounds.size.height

static NSString * cellId = @"BodyCell";
static NSString * titleCellId = @"TitleCell";

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,ColumnViewDelegate>
{
    UILongPressGestureRecognizer *longPress;
}

@property (nonatomic ) ColumnView *columnView;

@property (weak, nonatomic) IBOutlet UICollectionView *titleScroll;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic )NSMutableArray *data;
@property (nonatomic )NSMutableArray *data1;

@property (nonatomic ) NSInteger currentIndex;

@property (nonatomic ) BOOL isRemove;

@end

@implementation ViewController

- (void)backToLoadWith:(NSMutableArray *)data {

    self.data = data;
    [self.titleScroll reloadData];
    [self.collectionView reloadData];
    NSIndexPath *indexPath =[NSIndexPath indexPathForRow:self.currentIndex inSection:0];
    [self selectItemColorShowWith:indexPath];
    
}

#pragma mark ColumnViewDelegate
- (void)reloadingDataWithNumber:(NSInteger)number andData:(NSMutableArray *)data{
    
    self.currentIndex = number;
    [self backToLoadWith:data];

}

- (void)reloadingDataWith:(NSMutableArray *)data {
    
    [self backToLoadWith:data];
    
}

- (IBAction)clickEdit:(UIButton *)sender {

    self.columnView.hidden = NO;
    
}

- (void)deleteWithCollection:(UICollectionView *)collectionView andIndex:(NSInteger )index {
   
    NSLog(@"%ld  %lu",(long)index,(unsigned long)self.data.count);
    if (self.data.count != 1 && index < self.data.count) {
        
        NSIndexPath *indexPath =[NSIndexPath indexPathForRow:index inSection:0];
        
        [collectionView performBatchUpdates:^{
            [self.data removeObjectAtIndex:index];
            [collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
        } completion:^(BOOL finished) {
            if (finished) {
                
                [self.titleScroll reloadData];
                
                if (index == self.data.count) {
                    NSIndexPath *indexPath =[NSIndexPath indexPathForRow:index - 1 inSection:0];
                    [self selectItemColorShowWith:indexPath];

                }else {
                    [self selectItemColorShowWith:indexPath];

                }

            }
        }];
    }

}

- (void)addWithCollection:(UICollectionView *)collectionView andIndex:(NSInteger )index {
    
    [collectionView performBatchUpdates:^{
        [self.data insertObject:@"a" atIndex:index];
        NSIndexPath *indexPath =[NSIndexPath indexPathForRow:index inSection:0];
        [collectionView insertItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
    } completion:^(BOOL finished) {
        if (finished) {
            
            [self.titleScroll reloadData];
            
            NSIndexPath *indexPath =[NSIndexPath indexPathForRow:self.currentIndex inSection:0];
            [self selectItemColorShowWith:indexPath];
            
        }
    }];
    
}

- (void)moveWithCollection:(UICollectionView *)collectionView andOldIndex:(NSInteger )oldIndex andNewIndex:(NSInteger )newIndex {

    NSIndexPath *indexPath =[NSIndexPath indexPathForRow:self.currentIndex inSection:0];

    [collectionView performBatchUpdates:^{
        
        [self.data exchangeObjectAtIndex:oldIndex withObjectAtIndex:newIndex];
        
        NSIndexPath *oldNum =[NSIndexPath indexPathForRow:oldIndex inSection:0];
        NSIndexPath *newNum =[NSIndexPath indexPathForRow:newIndex inSection:0];
        [collectionView moveItemAtIndexPath:oldNum toIndexPath:newNum];

    } completion:^(BOOL finished) {
        if (finished) {
            
            [self.titleScroll reloadData];
            [self selectItemColorShowWith:indexPath];
            
        }
    }];
    
}

- (void)scrollWithCollection:(UICollectionView *)collectionView andIndex:(NSInteger )index andAnimation:(BOOL )animation {
    
    NSIndexPath *indexPath =[NSIndexPath indexPathForRow:index inSection:0];
    [collectionView performBatchUpdates:^{
        [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    } completion:^(BOOL finished) {
        if (finished) {
            [self selectItemColorShowWith:indexPath];

        }
    }];
    
}

- (IBAction)clickScroll:(UIButton *)sender {
    NSInteger random = arc4random() % 7;
    [self scrollWithCollection:self.collectionView andIndex:random andAnimation:NO];
    
}

- (IBAction)clickMove:(UIButton *)sender {

    [self moveWithCollection:self.collectionView andOldIndex:0 andNewIndex:3];
    
}

- (IBAction)clickAdd:(UIButton *)sender {

    NSInteger random = arc4random() % 7;
    [self addWithCollection:self.collectionView andIndex:random];
    
}

- (IBAction)clickDelete:(UIButton *)sender {
    
    NSInteger random = arc4random() % 7;
    [self deleteWithCollection:self.collectionView andIndex:random];
    
}

- (ColumnView *)columnView {

    if (!_columnView) {
        ColumnView *view = [[ColumnView alloc] initWithFrame:CGRectMake(0, 70, SWidth, 400) andSelectedArray:self.data andOptionalArray:self.data1];
        view.backgroundColor = [UIColor whiteColor];
        view.delegate = self;
        view.hidden = YES;
        _columnView = view;
    }
    return _columnView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.data =  [NSMutableArray arrayWithCapacity:10];
    self.data1 =  [NSMutableArray arrayWithCapacity:10];

    [self.data addObjectsFromArray:@[@"1",@"2",@"3",@"4",@"5",@"6",@"7"]];
    [self.data1 addObjectsFromArray:@[@"8",@"9",@"10",@"11",@"12",@"13",@"14"]];

    longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(clickLongPress:)];
    [self.titleScroll addGestureRecognizer:longPress];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickDoubleTap:)];
    [doubleTap setNumberOfTapsRequired:2];
    [self.titleScroll addGestureRecognizer:doubleTap];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    self.currentIndex = 0;
    [self selectItemColorShowWith:indexPath];
    
    //TODO: edit view
    [self.view addSubview:self.columnView];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)selectItemColorShowWith:(NSIndexPath *)indexPath {

    [self.titleScroll selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];

}

- (void)clickDoubleTap:(UITapGestureRecognizer *)tap {
    
    NSIndexPath *selectIndexPath = [self.titleScroll indexPathForItemAtPoint:[tap locationInView:self.titleScroll]];
    NSLog(@"delete %ld",(long)selectIndexPath.item);
    if (_isRemove) {
        
        [self deleteWithCollection:self.collectionView andIndex:selectIndexPath.item];
        _isRemove = NO;
    }
    
}

- (void)clickLongPress:(UILongPressGestureRecognizer *)sender {
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan: {
            {
                NSIndexPath *selectIndexPath = [self.titleScroll indexPathForItemAtPoint:[sender locationInView:self.titleScroll]];
                // 找到当前的cell 如果上边有button 覆盖的话隐藏
                //TitleCell *cell = (TitleCell *)[self.titleScroll cellForItemAtIndexPath:selectIndexPath];
                // 定义cell的时候btn是隐藏的, 在这里设置为NO
                [_titleScroll beginInteractiveMovementForItemAtIndexPath:selectIndexPath];
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            [self.titleScroll updateInteractiveMovementTargetPosition:[sender locationInView:_titleScroll]];
            break;
        }
        case UIGestureRecognizerStateEnded: {

            [self.titleScroll endInteractiveMovement];
            break;
        }
        default: [self.titleScroll cancelInteractiveMovement];
            break;
    }

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    int x = scrollView.contentOffset.x;
    int i = x /SWidth;
    self.currentIndex = i;
    int sw = SWidth;
    if (x % sw == 0 && self.collectionView == scrollView) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [self.titleScroll scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        [self selectItemColorShowWith:indexPath];
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {

    //取出源item数据
    id objc = [self.data objectAtIndex:sourceIndexPath.item];
    //从资源数组中移除该数据
    [self.data removeObject:objc];
    //将数据插入到资源数组中的目标位置上
    [self.data insertObject:objc atIndex:destinationIndexPath.item];
    
    [self.titleScroll reloadData];
    [self.collectionView reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.currentIndex inSection:0];
    [self selectItemColorShowWith:indexPath];
//    NSLog(@"%@",self.data);

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    self.currentIndex = indexPath.item;
    if (collectionView == self.titleScroll) {
        
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        [self.titleScroll scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        
        self.isRemove = YES;
    }
    
}

// can add animation 
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == self.collectionView) {

        [self.titleScroll scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        
        BodyCell *viewCell =(BodyCell *)cell;
        [viewCell loadDataWithIndex:indexPath.item];
        
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == self.collectionView) {
        
        BodyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
        cell.theMsg.text = [NSString stringWithFormat:@"%@",self.data[indexPath.item]];
        return cell;
        
    }else {

        TitleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:titleCellId forIndexPath:indexPath];
        cell.msg.text = [NSString stringWithFormat:@"%@",self.data[indexPath.item]];
        return cell;
        
    }

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.data.count;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
