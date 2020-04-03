//
//  UITableViewCell+Custom.h
//  CommunityPeople
//
//  Created by 彭睿 on 2019/7/29.
//  Copyright © 2019 彭睿. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableViewCell (Custom)

/**
 *  快速创建一个不是从xib中加载的tableview cell
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

/**
 *  快速创建一个从xib中加载的tableview cell
 */
+ (instancetype)nibCellWithTableView:(UITableView *)tableView;

/**
 *  获取cell的复用ID
 */
+ (NSString *)getCellReuserIdentifer;

@end

NS_ASSUME_NONNULL_END
