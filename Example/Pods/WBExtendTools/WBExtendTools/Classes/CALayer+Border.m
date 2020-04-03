//
//  CALayer+Border.m
//  CommunityPeople
//
//  Created by 彭睿 on 2019/11/5.
//  Copyright © 2019 彭睿. All rights reserved.
//

#import "CALayer+Border.h"

@implementation CALayer (Border)

- (void)setBorderUIColor:(UIColor *)color {
    self.borderColor = color.CGColor;
}

@end
