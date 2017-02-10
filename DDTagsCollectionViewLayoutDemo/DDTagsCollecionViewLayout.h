//
//  DDTagsCollecionViewLayout.h
//  DDTagsCollectionViewLayoutDemo
//
//  Created by Poseidon on 17/2/9.
//  Copyright © 2017年 Poseidon. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DDTagsCollecionViewLayoutDelegate <NSObject>

@optional
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceHeightForHeaderInSection:(NSInteger)section;

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceHeightForFooterInSection:(NSInteger)section;

@end

@interface DDTagsCollecionViewLayout : UICollectionViewLayout
@property(nonatomic, weak)id<DDTagsCollecionViewLayoutDelegate> delegate;

//item的size default is CGSizeMake(30, 30)
@property(nonatomic, assign)CGSize itemSize;
//item间距 default is 10
@property(nonatomic, assign)CGFloat itemSpace;
//行间距 default is 10
@property(nonatomic, assign)CGFloat lineSpace;
//header高度 default is 0
@property(nonatomic, assign)CGFloat headerHeight;
//footer高度 default is 0
@property(nonatomic, assign)CGFloat footerHeight;
//item最大显示宽度 default is kMaxShowWidth
@property(nonatomic, assign)CGFloat itemMaxWidth;

@end
