//
//  RootViewController.m
//  DDTagsCollectionViewLayoutDemo
//
//  Created by Poseidon on 17/2/9.
//  Copyright © 2017年 Poseidon. All rights reserved.
//

#import "RootViewController.h"
#import "DDTagsCollecionViewLayout.h"
#import "DDTagsCollectionViewCell.h"
#import "DDTagsHeaderCollectionReusableView.h"
#import "DDTagsFooterCollectionReusableView.h"

@interface RootViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, DDTagsCollecionViewLayoutDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation RootViewController

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 5;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DDTagsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DDTagsCollectionViewCell" forIndexPath:indexPath];
    cell.label.text = [NSString stringWithFormat:@"%ld=%ld",indexPath.section,indexPath.item];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        DDTagsHeaderCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        return header;
    }else{
        DDTagsFooterCollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
        return footer;
    }
}

//MyLayoutDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = 30*(indexPath.item%5+1);
    return CGSizeMake(width, 30);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceHeightForHeaderInSection:(NSInteger)section
{
    return 60;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceHeightForFooterInSection:(NSInteger)section
{
    return 20;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    DDTagsCollecionViewLayout *layout = [[DDTagsCollecionViewLayout alloc] init];
    layout.delegate = self;
//    layout.headerHeight = 20;
//    layout.footerHeight = 50;
//    layout.itemSize = CGSizeMake(50, 50);
    
    
    _collectionView.collectionViewLayout = layout;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"DDTagsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"DDTagsCollectionViewCell"];
    [_collectionView registerNib:[UINib nibWithNibName:@"DDTagsHeaderCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [_collectionView registerNib:[UINib nibWithNibName:@"DDTagsFooterCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    _collectionView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
