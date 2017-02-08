//
//  DzyCollectionViewController.m
//  DzyCollection
//
//  Created by Dzy on 08/02/2017.
//  Copyright © 2017 Dzy. All rights reserved.
//

#import "DzyCollectionViewController.h"

#import "ViewCell.h"
#import "TitleCell.h"

#import "ColumnView.h"

static NSString * cellId = @"ViewCell";
static NSString * titleCellId = @"TitleCell";

#define SWidth [UIScreen mainScreen].bounds.size.width
#define SHeight [UIScreen mainScreen].bounds.size.height

@interface DzyCollectionViewController ()
<UICollectionViewDelegate,
UICollectionViewDataSource>

@property (nonatomic ) UICollectionView *titleView;
@property (nonatomic ) UICollectionView *bodyView;

@property (nonatomic )NSMutableArray *data;
@property (nonatomic )NSMutableArray *sources;
@property (nonatomic ) NSInteger currentIndex;

@end

@implementation DzyCollectionViewController


- (void)selectItemColorShowWith:(NSIndexPath *)indexPath {
    
    [self.titleView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    [self.bodyView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    
}

- (UICollectionView *)titleView {

    if (!_titleView) {
        
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        flow.minimumLineSpacing = 0;
        flow.minimumInteritemSpacing = 0;
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flow.itemSize = CGSizeMake(60, 40);
        
        UICollectionView *v = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 20, SWidth-40, 40) collectionViewLayout:flow];
        v.backgroundColor = [UIColor whiteColor];
        v.showsVerticalScrollIndicator = NO;
        v.showsHorizontalScrollIndicator = NO;
        v.pagingEnabled = YES;
        v.delegate = self;
        v.dataSource = self;
        _titleView = v;
    }
    return _titleView;
}

- (UICollectionView *)bodyView {

    if (!_bodyView) {
        
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        flow.minimumLineSpacing = 0;
        flow.minimumInteritemSpacing = 0;
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flow.itemSize = CGSizeMake(SWidth, SHeight - 100);
        
        UICollectionView *v = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 60, SWidth, SHeight - 100) collectionViewLayout:flow];
        v.backgroundColor = [UIColor whiteColor];
        v.showsVerticalScrollIndicator = NO;
        v.showsHorizontalScrollIndicator = NO;
        v.pagingEnabled = YES;
        v.delegate = self;
        v.dataSource = self;
        _bodyView = v;
    }
    return _bodyView;
}

- (void)createUI {
    
    [self.view addSubview:self.titleView];
    [self.view addSubview:self.bodyView];
    
    [self.titleView registerClass:[TitleCell class] forCellWithReuseIdentifier:titleCellId];
    [self.bodyView registerClass:[ViewCell class] forCellWithReuseIdentifier:cellId];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    
    self.data =  [NSMutableArray arrayWithCapacity:10];
    self.sources =  [NSMutableArray arrayWithCapacity:10];
    
    [self.data addObjectsFromArray:@[@"1",@"2",@"3",@"4",@"5",@"6",@"7"]];
    [self.sources addObjectsFromArray:@[@"8",@"9",@"10",@"11",@"12",@"13",@"14"]];

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    self.currentIndex = 0;
    [self selectItemColorShowWith:indexPath];
    
    // Do any additional setup after loading the view.
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    int x = scrollView.contentOffset.x;
    int i = x /SWidth;
    self.currentIndex = i;
    int sw = SWidth;
    if (x % sw == 0 && self.bodyView == scrollView) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [self.titleView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        [self selectItemColorShowWith:indexPath];
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    self.currentIndex = indexPath.item;
    if (collectionView == self.titleView) {
        
        [self.bodyView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        [self.titleView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        
    }
    
}


// can add animation
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == self.bodyView) {
        
        [self.titleView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        
        ViewCell *viewCell =(ViewCell *)cell;
        [viewCell loadDataWithIndex:indexPath.item];
        
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == self.bodyView) {
        
        ViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
        cell.theMsg.text = [NSString stringWithFormat:@"%@",self.data[indexPath.item]];
        return cell;
        
    }else {
        
        TitleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:titleCellId forIndexPath:indexPath];
        cell.text.text = [NSString stringWithFormat:@"%@",self.data[indexPath.item]];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
