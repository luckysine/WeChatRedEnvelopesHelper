//
//  LLRedEnvelopesMgr.h
//  test
//
//  Created by fqb on 2017/12/12.
//  Copyright © 2017年 kevliule. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WCRedEnvelopesHelper.h"

@interface LLRedEnvelopesMgr : NSObject

@property (nonatomic, assign) BOOL haveNewRedEnvelopes; //是否有新的红包
@property (nonatomic, assign) BOOL isHiddenRedEnvelopesReceiveView; //是否隐藏红包接受页面
@property (nonatomic, assign) BOOL isHongBaoPush; //是否是红包push
@property (nonatomic, assign) UIBackgroundTaskIdentifier bgTaskIdentifier; //后台任务标识符
@property (nonatomic, strong) NSTimer *bgTaskTimer; //后台任务定时器

@property (nonatomic, copy) void(^openRedEnvelopesBlock)(void); //打开红包block

+ (LLRedEnvelopesMgr *)shared;

- (void)openRedEnvelopes:(NewMainFrameViewController *)mainVC;

- (void)handleRedEnvelopesPushVC:(BaseMsgContentViewController *)baseMsgVC;

- (void)successOpenRedEnvelopesNotification;

@end
