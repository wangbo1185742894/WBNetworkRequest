//
//  UIViewController+Addition.m
//  CommunityPeople
//
//  Created by 彭睿 on 2019/7/16.
//  Copyright © 2019 彭睿. All rights reserved.
//

#import "UIViewController+Addition.h"
#import <objc/runtime.h>
#import "UIColor+Custom.h"


const char NavRightItemHandleKey;
const char NavLeftItemHandleKey;


@implementation UIViewController (Addition)



- (void)pop
{
    if (self.navigationController == nil) return ;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)popToRootVc
{
    if (self.navigationController == nil) return ;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)popToVc:(UIViewController *)vc
{
    if ([vc isKindOfClass:[UIViewController class]] == NO) return ;
    if (self.navigationController == nil) return ;
    [self.navigationController popToViewController:vc animated:YES];
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dismissWithCompletion:(void(^)(void))completion
{
    [self dismissViewControllerAnimated:YES completion:completion];
}

- (void)presentVc:(UIViewController *)vc
{
    if ([vc isKindOfClass:[UIViewController class]] == NO) return ;
    [vc setPresentVc:self];
    [self presentVc:vc completion:nil];
}

///通过present方法跳转到本类，持有本类对象的类
- (void)setPresentVc:(UIViewController *)presentVc {}

- (void)presentVc:(UIViewController *)vc completion:(void (^)(void))completion
{
    if ([vc isKindOfClass:[UIViewController class]] == NO) return ;
    [self presentViewController:vc animated:YES completion:completion];
}

- (void)pushVc:(UIViewController *)vc
{
    if ([vc isKindOfClass:[UIViewController class]] == NO) return ;
    if (self.navigationController == nil) return ;
    if (vc.hidesBottomBarWhenPushed == NO) {
        vc.hidesBottomBarWhenPushed = YES;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)removeChildVc:(UIViewController *)childVc
{
    if ([childVc isKindOfClass:[UIViewController class]] == NO) {
        return ;
    }
    [childVc.view removeFromSuperview];
    [childVc willMoveToParentViewController:nil];
    [childVc removeFromParentViewController];
}

- (void)addChildVc:(UIViewController *)childVc
{
    if ([childVc isKindOfClass:[UIViewController class]] == NO) {
        return ;
    }
    [childVc willMoveToParentViewController:self];
    [self addChildViewController:childVc];
    [self.view addSubview:childVc.view];
    childVc.view.frame = self.view.bounds;
}


+ (instancetype)viewControllerFromNib
{
    UIViewController *viewController = [[self alloc] initWithNibName:NSStringFromClass([self class]) bundle:nil];
    return viewController;
}

+ (instancetype)viewControllerFromStoryboardName:(NSString *)storyboardName Identifier:(NSString *)identifier
{
    return [[UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:identifier];
    
}

- (void)refreshData
{
    
}



/** 导航栏标题*/
- (void)setNavItemTitle:(NSString *)navItemTitle
{
    if ([navItemTitle isKindOfClass:[NSString class]] == NO) return ;
    self.navigationItem.title = navItemTitle;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = UIColor.gray333Color;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName :UIColor.gray333Color}];
    
    if (self.navigationController.viewControllers.count > 1) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_nav_back_blank"] style:UIBarButtonItemStyleDone target:self action:@selector(popGoBack)];
        [self.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -5,0, 0)];
    }
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return self.childViewControllers.count != 1;
}

- (void)popGoBack {
    if (self.navigationController.viewControllers.count > 1 ) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismiss];
    }
}

- (NSString *)navItemTitle
{
    return self.navigationItem.title;
}

/** 右边item*/
- (void)setNavRightItem:(UIBarButtonItem *)navRightItem
{
    self.navigationItem.rightBarButtonItem = navRightItem;
}

- (UIBarButtonItem *)navRightItem
{
    return self.navigationItem.rightBarButtonItem;
}

/** 左边item*/
- (void)setNavLeftItem:(UIBarButtonItem *)navLeftItem
{
    self.navigationItem.leftBarButtonItem = navLeftItem;
}

- (UIBarButtonItem *)navLeftItem
{
    return self.navigationItem.leftBarButtonItem;
}


- (void)rightItemImage:(UIImage *)itemImage handle:(void(^)(UIImage *itemImage))handle
{
    objc_setAssociatedObject(self, &NavRightItemHandleKey, handle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:itemImage style:UIBarButtonItemStylePlain target:self action:@selector(navItemBtnHandle:)];
    rightItem.tag = 1;
    rightItem.tintColor = UIColor.gray333Color;
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)rightItemTitle:(NSString *)itemTitle attributes:(NSDictionary * _Nullable)attributes handle:(void(^)(NSString *itemTitle))handle
{
    objc_setAssociatedObject(self, &NavRightItemHandleKey, handle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 44)];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:itemTitle attributes:attributes];
    [btn setAttributedTitle:str forState:UIControlStateNormal];
    [btn sizeToFit];
    btn.tag = 1;
    [btn addTarget:self action:@selector(navItemBtnHandle:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (void)leftItemImage:(UIImage *)itemImage handle:(void(^)(UIImage *itemImage))handle
{
    objc_setAssociatedObject(self, &NavLeftItemHandleKey, handle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:itemImage style:UIBarButtonItemStylePlain target:self action:@selector(navItemBtnHandle:)];
    leftItem.tintColor = UIColor.gray333Color;
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)leftItemTitle:(NSString *)itemTitle attributes:(NSDictionary * _Nullable)attributes handle:(void(^)(NSString *itemTitle))handle
{
    objc_setAssociatedObject(self, &NavLeftItemHandleKey, handle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 44)];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:itemTitle attributes:attributes];
    [btn setAttributedTitle:str forState:UIControlStateNormal];
    [btn sizeToFit];
    btn.tag = 0;
    [btn addTarget:self action:@selector(navItemBtnHandle:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (void)navItemBtnHandle:(UIButton *)item {
    
    void (^handle)(NSString *);
    if (item.tag == 0) {
        handle = objc_getAssociatedObject(self, &NavLeftItemHandleKey);
    } else {
        handle = objc_getAssociatedObject(self, &NavRightItemHandleKey);
    }
    
    if (handle) {
        handle(nil);
    }
}



@end
