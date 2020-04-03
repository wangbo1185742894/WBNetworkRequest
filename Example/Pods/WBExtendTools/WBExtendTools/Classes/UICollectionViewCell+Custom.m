//
//  UICollectionViewCell+Custom.m
//  CommunityPeople
//
//  Created by 彭睿 on 2019/7/30.
//  Copyright © 2019 彭睿. All rights reserved.
//

#import "UICollectionViewCell+Custom.h"

@implementation UICollectionViewCell (Custom)

+ (instancetype)cellWithUICollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    if (collectionView == nil) {
        return [[self alloc] init];
    }
    NSString *classname = NSStringFromClass([self class]);
    NSString *identifier = [classname stringByAppendingString:@"CollCellID"];
    [collectionView registerClass:[self class] forCellWithReuseIdentifier:identifier];
    return [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
}

+ (instancetype)nibCellWithUICollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    if (collectionView == nil) {
        return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
    }
    NSString *classname = NSStringFromClass([self class]);
    NSString *identifier = [classname stringByAppendingString:@"nibCollCellID"];
    UINib *nib = [UINib nibWithNibName:classname bundle:nil];
    [collectionView registerNib:nib forCellWithReuseIdentifier:identifier];
    return [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
}

+ (NSString *)getCellReuserIdentifer {
    
    NSString *className = NSStringFromClass([self class]);
    NSString *reuseID = [className stringByAppendingString:@"CellID"];
    UINib *nib = [UINib nibWithNibName:className bundle:nil];
    if (nib) {
        reuseID = [className stringByAppendingString:@"nibCellID"];
    }
    return reuseID;
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

@end
