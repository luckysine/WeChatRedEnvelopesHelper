//
//  LLSettingController.h
//  test
//
//  Created by fqb on 2017/12/15.
//  Copyright © 2017年 kevliule. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LLSettingParam : NSObject

@property (nonatomic, assign) BOOL isOpenRedEnvelopesHelper; //是否开启红包助手
@property (nonatomic, assign) BOOL isOpenSportHelper; //是否开启步数助手
@property (nonatomic, assign) BOOL isOpenBackgroundMode; //是否开启后台模式
@property (nonatomic, assign) BOOL isOpenRedEnvelopesAlert; //是否打卡红包提醒
@property (nonatomic, assign) CGFloat openRedEnvelopesDelaySecond; //打开红包延迟时间
@property (nonatomic, assign) NSInteger wantSportStepCount; //想要的运动步数

@end

@interface LLSettingController : UIViewController

@end
