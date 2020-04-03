//
//  UIViewController+Addition.h
//  CommunityPeople
//
//  Created by 彭睿 on 2019/7/16.
//  Copyright © 2019 彭睿. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface UIViewController (Addition) <UIGestureRecognizerDelegate>

- (void)pop;

- (void)popToRootVc;

- (void)popToVc:(UIViewController *)vc;

- (void)dismiss;

- (void)dismissWithCompletion:(void(^)(void))completion;

- (void)presentVc:(UIViewController *)vc;

- (void)presentVc:(UIViewController *)vc completion:(void (^)(void))completion;

- (void)pushVc:(UIViewController *)vc;

- (void)removeChildVc:(UIViewController *)childVc;

- (void)addChildVc:(UIViewController *)childVc;

- (void)refreshData;

/**
 从xib中加载控制器
 */
+ (instancetype)viewControllerFromNib;

/**
 从 storyboard 加载ViewController
 @param storyboardName storyboard  名字
 @param identifier 这个类的 storyboard ID（自己设置）
 */
+ (instancetype)viewControllerFromStoryboardName:(NSString *)storyboardName Identifier:(NSString *)identifier;



/**
 *  标题
 */
@property (nonatomic,copy) NSString *navItemTitle;

/**
 *  导航右边Item
 */
@property (nonatomic,strong) UIBarButtonItem *navRightItem;

/**
 *  导航左边Item
 */
@property (nonatomic,strong) UIBarButtonItem *navLeftItem;


/**
 *  设置导航栏右边的item (图片)
 *
 *  @param itemImage    图片
 *  @param handle       回调
 */
- (void)rightItemImage:(UIImage *)itemImage handle:(void(^)(UIImage *itemImage))handle;

/**
 *  设置导航栏右边的item (标题)
 *
 *  @param itemTitle    标题
 *  @param attributes   自定义
 *  @param handle       回调
 */
- (void)rightItemTitle:(NSString *)itemTitle attributes:(NSDictionary * _Nullable)attributes handle:(void(^)(NSString *itemTitle))handle;

/**
 *  设置导航栏左边的item (图片)
 *
 *  @param itemImage    图片
 *  @param handle       回调
 */
- (void)leftItemImage:(UIImage *)itemImage handle:(void(^)(UIImage *itemImage))handle;

/**
 *  设置导航栏左边的item (标题)
 *
 *  @param itemTitle    标题
 *  @param attributes   自定义
 *  @param handle       回调
 */
- (void)leftItemTitle:(NSString *)itemTitle attributes:(NSDictionary * _Nullable)attributes handle:(void(^)(NSString *itemTitle))handle;



@end

NS_ASSUME_NONNULL_END
