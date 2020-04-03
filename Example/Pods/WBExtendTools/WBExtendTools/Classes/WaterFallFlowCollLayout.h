//
//  WaterFallFlowCollLayout.h
//  CommunityPeople
//  瀑布流自定义layout
//  Created by 彭睿 on 2019/10/29.
//  Copyright © 2019 彭睿. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class WaterFallFlowCollLayout;

@protocol WaterFallFlowCollLayoutDataSource <NSObject>

@required

/// 每个item的高度
/// @param waterFallLayout <#waterFallLayout description#>
/// @param indexPath <#indexPath description#>
/// @param itemWidth <#itemWidth description#>
- (CGFloat)waterFallLayout:(WaterFallFlowCollLayout *)waterFallLayout heightForItemAtIndexPath:(NSUInteger)indexPath itemWidth:(CGFloat)itemWidth;

@optional

/// 列数
/// @param waterFallLayout <#waterFallLayout description#>
- (NSUInteger)columnCountInWaterFallLayout:(WaterFallFlowCollLayout *)waterFallLayout;

/// 列间距
/// @param waterFallLayout <#waterFallLayout description#>
- (CGFloat)columnMarginInWaterFallLayout:(WaterFallFlowCollLayout *)waterFallLayout;

/// 行间距
/// @param waterFallLayout <#waterFallLayout description#>
- (CGFloat)rowMarginInWaterFallLayout:(WaterFallFlowCollLayout *)waterFallLayout;

/// item内边距
/// @param waterFallLayout <#waterFallLayout description#>
- (UIEdgeInsets)edgeInsetsInWaterFallLayout:(WaterFallFlowCollLayout *)waterFallLayout;

@end
        


@interface WaterFallFlowCollLayout : UICollectionViewLayout

@property (nonatomic, weak) id <WaterFallFlowCollLayoutDataSource> delegate;

@end

NS_ASSUME_NONNULL_END
