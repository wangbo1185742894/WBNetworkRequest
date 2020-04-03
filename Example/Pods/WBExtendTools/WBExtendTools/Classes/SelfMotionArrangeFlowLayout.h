//
//  EqualSpaceFlowLayoutEvolve.h
//  UICollectionViewDemo
//
//  Created by sks on 17/5/26.
//  Copyright © 2017年 CHC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,AlignType){
    AlignWithLeft,
    AlignWithCenter,
    AlignWithRight
};

@interface SelfMotionArrangeFlowLayout : UICollectionViewFlowLayout
//两个Cell之间的距离
@property (nonatomic,assign)CGFloat betweenOfCell;
//cell对齐方式
@property (nonatomic,assign)AlignType cellType;
//计算完毕之后返回行数
@property (nonatomic,strong) void(^returnSectionNumbersBlock)(NSInteger sectionNumber);

- (instancetype)initWthType:(AlignType)cellType;


@end
