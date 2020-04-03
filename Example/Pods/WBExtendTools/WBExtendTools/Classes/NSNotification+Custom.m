//
//  NSNotification+Custom.m
//  CommunityPeople
//
//  Created by 彭睿 on 2019/7/17.
//  Copyright © 2019 彭睿. All rights reserved.
//

#import "NSNotification+Custom.h"

@implementation NSNotification (Custom)

+ (void)sendNotiWechatLoginCode:(NSString *)code {
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"weiChatLogin" object:nil userInfo:@{@"weiChatLoginCode":code}]];
}

+ (void)receiveNotiWechatLoginObserver:(id)observer {
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:@selector(weiChatLogin:) name:@"weiChatLogin" object:nil];
}



+ (void)sendNotiRefreshOrder {
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"orderHomeVCRefresh" object:nil userInfo:nil]];
}

+ (void)receiveNotiRefreshOrderObserver:(id)observer {
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:@selector(orderHomeVCRefresh) name:@"orderHomeVCRefresh" object:nil];
}



+ (void)sendNotiForeground {
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"after_entering" object:nil userInfo:nil]];
}

+ (void)receiveNotiForegroundObserver:(id)observer {
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:@selector(after_entering_void) name:@"after_entering" object:nil];
}



+ (void)sendNotiChangeNetWorkStatus:(NSString *)status {
     [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"netWork_change_wifi" object:nil userInfo:@{@"NetWork_Stauts":status}]];
}

+ (void)receiveNotiChangeNetWorkStatusObserver:(id)observer {
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:@selector(netWork_change_wifi:) name:@"netWork_change_wifi" object:nil];
}



+ (void)sendNotiJoinQuitCircleStatus:(NSString *)status {
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"circle_addOrOut" object:nil userInfo:@{@"isAdd":status}]];
}
+ (void)receiveNotiJoinQuitCircleObserver:(id)observer {
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:@selector(circle_addOrOut:) name:@"circle_addOrOut" object:nil];
}



+ (void)sendNotiPublishDynamic {
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"send_bolg" object:nil userInfo:nil]];
}

+ (void)receiveNotiPublishDynamicObserver:(id)observer {
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:@selector(send_bolg) name:@"send_bolg" object:nil];
}



+ (void)sendNotiAddShoppingCart {
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"addShopingCart" object:nil userInfo:nil]];
}

+ (void)receiveNotiAddShoppingCartObserver:(id)observer {
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:@selector(refreshShopingCartData) name:@"addShopingCart" object:nil];
}



+ (void)sendNotiCreditsExchange {
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"INTEGRAL_BUYSUCCESS" object:nil userInfo:nil]];
}

+ (void)receiveNotiCreditsExchangeObserver:(id)observer {
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:@selector(integralBuySuccess) name:@"INTEGRAL_BUYSUCCESS" object:nil];
}



+ (void)sendNotiLocation {
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"city_positioning" object:nil userInfo:nil]];
}

+ (void)receiveNotiLocationObserver:(id)observer {
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:@selector(city_positioning) name:@"city_positioning" object:nil];
}



+ (void)sendNotiTabBarRefresh {
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"city_positioning" object:nil userInfo:nil]];
}

+ (void)receiveNotiTabBarRefreshnObserver:(id)observer {
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:@selector(tab_positioning) name:@"city_positioning" object:nil];
}



+ (void)sendNotiOrderEvaluate {
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"EvaluateGoodsSuccess" object:nil userInfo:nil]];
}

+ (void)receiveNotiOrderEvaluateObserver:(id)observer {
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:@selector(evaGoodsSuccess) name:@"EvaluateGoodsSuccess" object:nil];
}



+ (void)sendNotiUserIdUpDate {
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"UserEditIDCardSuccess" object:nil userInfo:nil]];
}

+ (void)receiveNotiUserIdUpDateObserver:(id)observer {
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:@selector(userEditIDCardSuccess) name:@"UserEditIDCardSuccess" object:nil];
}



+ (void)sendNotiForLoginSucceed {
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"LoginSucceed" object:nil userInfo:nil]];
}

+ (void)receiveNotiForLoginSucceedObserver:(id)observer {
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:@selector(LoginSucceedNoti) name:@"LoginSucceed" object:nil];
}



#pragma mark -- 主类去实现

- (void)weiChatLogin:(NSNotification *)noti {}

- (void)orderHomeVCRefresh {}

- (void)after_entering_void {}

- (void)netWork_change_wifi:(NSNotification *)noti {}

- (void)circle_addOrOut:(NSNotification *)noti {}

- (void)send_bolg {}

- (void)refreshShopingCartData {}

- (void)integralBuySuccess {}

- (void)city_positioning {}

- (void)tab_positioning {}

- (void)evaGoodsSuccess {}

- (void)userEditIDCardSuccess {}

- (void)LoginSucceedNoti{}

@end
