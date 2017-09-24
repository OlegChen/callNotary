//
//  SDGroupCellDelegate.h
//  notary
//
//  Created by 肖 喆 on 13-5-21.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SDGroupCellDelegate <NSObject>

-(void)notificationExpendButtonClick:(NSInteger)index isExpend:(BOOL)isExpend;

@end
