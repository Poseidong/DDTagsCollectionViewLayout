//
//  DDTagsCollecionViewLayout.m
//  DDTagsCollectionViewLayoutDemo
//
//  Created by Poseidon on 17/2/9.
//  Copyright © 2017年 Poseidon. All rights reserved.
//

#import "DDTagsCollecionViewLayout.h"

#define kMaxShowWidth self.collectionView.frame.size.width - self.collectionView.contentInset.left - self.collectionView.contentInset.right//最大显示宽度
#define kItemSize CGSizeMake(30, 30)//默认item尺寸


@interface DDTagsCollecionViewLayout ()
@property(nonatomic, strong)NSMutableArray <UICollectionViewLayoutAttributes *> *attributesList;
@property(nonatomic, assign)CGFloat nextLineY;//下一行 坐标Y的值
@property(nonatomic, assign)CGFloat maxLineY;//当前行最大Y值(下一行的y坐标)

@end

@implementation DDTagsCollecionViewLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.nextLineY = 0;
        self.maxLineY = 0;
        self.lineSpace = 10;
        self.itemSpace = 10;
        self.itemSize = kItemSize;
        self.headerHeight = 0;
        self.footerHeight = 0;
        
    }
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];
    self.itemMaxWidth = kMaxShowWidth;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    CGRect oldBounds = self.collectionView.bounds;
    if (CGRectGetWidth(newBounds) != CGRectGetWidth(oldBounds)) {
        return YES;
    }
    return NO;
}

//内容区域
- (CGSize)collectionViewContentSize
{
    self.nextLineY = 0;
    self.maxLineY = 0;
    UICollectionViewLayoutAttributes *lastAttributes = [self.attributesList lastObject];
    return CGSizeMake(kMaxShowWidth, lastAttributes.frame.origin.y+lastAttributes.size.height);
}


//所有布局
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray<__kindof UICollectionViewLayoutAttributes *> *arr = [super layoutAttributesForElementsInRect:rect];
    if (arr.count > 0) {
        return arr;
    }
    if (self.attributesList) {
        self.attributesList = nil;
    }
    self.attributesList = [NSMutableArray arrayWithCapacity:2];
    
    //添加所有attributes
    for (int i = 0; i < [self.collectionView numberOfSections]; i++) {
        
        NSIndexPath *sectionIndex = [NSIndexPath indexPathForItem:0 inSection:i];
        
        //header
        UICollectionViewLayoutAttributes *headerAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:sectionIndex];
        [self calculateAttributes:headerAttributes];
        [self.attributesList addObject:headerAttributes];
        
        //item
        for (int j = 0; j < [self.collectionView numberOfItemsInSection:i]; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            [self.attributesList addObject:attributes];
        }
        
        //footer
        UICollectionViewLayoutAttributes *footerAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:sectionIndex];
        [self calculateAttributes:footerAttributes];
        [self.attributesList addObject:footerAttributes];
    }
    
    return self.attributesList;
}

//item布局(在创建item的时候,lastAttributes 只会出现representedElementKind==UICollectionElementKindSectionHeader和nil的情况)
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //添加到数组中的最后一个attributes
    UICollectionViewLayoutAttributes *lastAttributes;
    CGFloat lastCenterX = 0;
    CGFloat lastCenterY = 0;
    CGFloat lastWidth = 0;
    CGFloat lastHeight = 0;
    
    if (self.attributesList.count) {
        lastAttributes = [self.attributesList lastObject];
        lastCenterX = lastAttributes.center.x;
        lastCenterY = lastAttributes.center.y;
        lastWidth = lastAttributes.size.width;
        lastHeight = lastAttributes.size.height;
        if (lastAttributes.representedElementKind == nil) {
            self.maxLineY = MAX(self.maxLineY, lastCenterY+lastHeight/2.0+self.lineSpace);
        }else{
            self.maxLineY = MAX(self.maxLineY, lastCenterY+lastHeight/2.0);
        }
    }
    
    //当前attributes的size
    CGSize size;
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)]) {
        size = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
    }else{
        size = self.itemSize;
    }
    
    //当前要添加的attributes
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    //最大attributes限制宽度
    CGFloat maxWidth = MIN(size.width, self.itemMaxWidth);
    
    //当前要添加的attributes的size(item宽度要小于等于父视图的宽度)
    attributes.size = CGSizeMake(maxWidth, size.height);
    
    /*设置当前attributes的位置
     1.当前attributes的位置超出父视图 下一行显示
     2.前一个attributes为UICollectionElementKindSectionHeader 下一行显示
     3.当前attributes的indexPath.item == 0  下一行显示
     */
    if (lastCenterX+lastWidth/2.0+self.itemSpace+maxWidth>kMaxShowWidth || [lastAttributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader] || attributes.indexPath.item == 0) {
        //下一行增加attributes
        self.nextLineY = self.maxLineY;
        self.maxLineY = 0;
        attributes.center = CGPointMake(maxWidth/2.0, size.height/2.0+self.nextLineY);
    }else{
        //在当前行增加attributes
        attributes.center = CGPointMake(lastCenterX+lastWidth/2.0+self.itemSpace+maxWidth/2.0, size.height/2.0+self.nextLineY);
    }
    
    return attributes;
}

//UICollectionElementKindSectionHeader UICollectionElementKindSectionFooter 布局
- (void)calculateAttributes:(UICollectionViewLayoutAttributes *)att
{
    if ([att.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        //header高度
        CGFloat headerHeight;
        if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:referenceHeightForHeaderInSection:)]) {
            headerHeight = [self.delegate collectionView:self.collectionView layout:self referenceHeightForHeaderInSection:att.indexPath.section];
        }else{
            headerHeight = self.headerHeight;
        }
        
        if (self.attributesList.count) {
            UICollectionViewLayoutAttributes *lastAttributes = [self.attributesList lastObject];
            att.frame = CGRectMake(0, lastAttributes.frame.origin.y+lastAttributes.size.height, kMaxShowWidth, headerHeight);
        }else{
            att.frame = CGRectMake(0, 0, kMaxShowWidth, headerHeight);
        }
    }else if ([att.representedElementKind isEqualToString:UICollectionElementKindSectionFooter]){
        
        //footer高度
        CGFloat footerHeight;
        if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:referenceHeightForFooterInSection:)]) {
            footerHeight = [self.delegate collectionView:self.collectionView layout:self referenceHeightForFooterInSection:att.indexPath.section];
        }else{
            footerHeight = self.footerHeight;
        }
        
        UICollectionViewLayoutAttributes *lastAttributes = [self.attributesList lastObject];
        att.frame = CGRectMake(0, lastAttributes.frame.origin.y+lastAttributes.size.height, kMaxShowWidth, footerHeight);
    }
    
}


@end
