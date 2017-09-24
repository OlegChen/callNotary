//
//  OSCNotice.m
//  notary
//
//  Created by 肖 喆 on 13-3-6.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import "OSCNotice.h"

@implementation OSCNotice

- (id)initWithParameters:(int)natmeCount andMsg:(int)nmsgCount andReview:(int)nreviewCount andFans:(int)nnewFansCount
{
    OSCNotice *notice = [[OSCNotice alloc] init];
    notice.atmeCount = natmeCount;
    notice.msgCount = nmsgCount;
    notice.reviewCount = nreviewCount;
    notice.newFansCount = nnewFansCount;
    return notice;
}

@end
