//
//  UITableViewCell+Custom.m
//  CommunityPeople
//
//  Created by 彭睿 on 2019/7/29.
//  Copyright © 2019 彭睿. All rights reserved.
//

#import "UITableViewCell+Custom.h"

@implementation UITableViewCell (Custom)


+ (instancetype)cellWithTableView:(UITableView *)tableView {
    if (tableView == nil) {
        return [[self alloc] init];
    }
    NSString *classname = NSStringFromClass([self class]);
    NSString *identifier = [classname stringByAppendingString:@"CellID"];
    [tableView registerClass:[self class] forCellReuseIdentifier:identifier];
    return [tableView dequeueReusableCellWithIdentifier:identifier];
}

+ (instancetype)nibCellWithTableView:(UITableView *)tableView {
    if (tableView == nil) {
        return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
    }
    NSString *classname = NSStringFromClass([self class]);
    NSString *identifier = [classname stringByAppendingString:@"nibCellID"];
    UINib *nib = [UINib nibWithNibName:classname bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:identifier];
    return [tableView dequeueReusableCellWithIdentifier:identifier];
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
