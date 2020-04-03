//
//  NSNotification+Custom.h
//  CommunityPeople
//
//  Created by 彭睿 on 2019/7/17.
//  Copyright © 2019 彭睿. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSNotificationCenter+Addition.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSNotification (Custom)


/**
 微信绑定后(微信登录)，appDelegate发送通知
 @param code 微信回调code
 */
+ (void)sendNotiWechatLoginCode:(NSString *)code;
+ (void)receiveNotiWechatLoginObserver:(id)observer;


/**
 订单操作后，订单模块刷新
 */
+ (void)sendNotiRefreshOrder;
+ (void)receiveNotiRefreshOrderObserver:(id)observer;


/**
 app冷启动或从挂起回到前台
 */
+ (void)sendNotiForeground;
+ (void)receiveNotiForegroundObserver:(id)observer;


/**
 手机网络环境发生变化
 @param status Unknown/NotReachable/ViaWWAN/ViaWiFi 未知网络/没有网络/移动流量/Wi-Fi
 */
+ (void)sendNotiChangeNetWorkStatus:(NSString *)status;
+ (void)receiveNotiChangeNetWorkStatusObserver:(id)observer;


/**
 加入或退出邻里圈
 @param status 0/1 退出/加入
 */
+ (void)sendNotiJoinQuitCircleStatus:(NSString *)status;
+ (void)receiveNotiJoinQuitCircleObserver:(id)observer;


/**
 邻里圈发表动态
 */
+ (void)sendNotiPublishDynamic;
+ (void)receiveNotiPublishDynamicObserver:(id)observer;


/**
 商品加入购物车
 */
+ (void)sendNotiAddShoppingCart;
+ (void)receiveNotiAddShoppingCartObserver:(id)observer;


/**
 积分商品兑换成功
 */
+ (void)sendNotiCreditsExchange;
+ (void)receiveNotiCreditsExchangeObserver:(id)observer;


/**
 定位成功通知
 */
+ (void)sendNotiLocation;
+ (void)receiveNotiLocationObserver:(id)observer;


/**
 刷新tabbar图标设置
 */
+ (void)sendNotiTabBarRefresh;
+ (void)receiveNotiTabBarRefreshnObserver:(id)observer;


/**
 商品评价成功，通知相关 订单列表页面 或 订单详情页面 刷新
 */
+ (void)sendNotiOrderEvaluate;
+ (void)receiveNotiOrderEvaluateObserver:(id)observer;



/**
 身份认证上传成功，通知相关页面刷新
 */
+ (void)sendNotiUserIdUpDate;
+ (void)receiveNotiUserIdUpDateObserver:(id)observer;



/**
 登录成功，发送通知让需要更新的页面更新数据
 */
+ (void)sendNotiForLoginSucceed;
+ (void)receiveNotiForLoginSucceedObserver:(id)observer;


@end

NS_ASSUME_NONNULL_END
