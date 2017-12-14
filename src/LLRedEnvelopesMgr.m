//
//  LLRedEnvelopesMgr.m
//  test
//
//  Created by fqb on 2017/12/12.
//  Copyright © 2017年 kevliule. All rights reserved.
//

#import "LLRedEnvelopesMgr.h"


@implementation LLRedEnvelopesMgr

+ (LLRedEnvelopesMgr *)shared{
    static LLRedEnvelopesMgr *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LLRedEnvelopesMgr alloc] init];
    });
    return manager;
}

#pragma mark SET METHOD

- (void)setHaveNewRedEnvelopes:(BOOL)haveNewRedEnvelopes{
    _haveNewRedEnvelopes = haveNewRedEnvelopes;
}

- (void)setIsHongBaoPush:(BOOL)isHongBaoPush{
    _isHongBaoPush = isHongBaoPush;
}

- (void)setIsHiddenRedEnvelopesReceiveView:(BOOL)isHiddenRedEnvelopesReceiveView{
    _isHiddenRedEnvelopesReceiveView = isHiddenRedEnvelopesReceiveView;
}

- (void)setBgTaskIdentifier:(UIBackgroundTaskIdentifier)bgTaskIdentifier{
    _bgTaskIdentifier = bgTaskIdentifier;
}

- (void)setBgTaskTimer:(NSTimer *)bgTaskTimer{
    _bgTaskTimer = bgTaskTimer;
}

- (void)setOpenRedEnvelopesBlock:(void (^)(void))openRedEnvelopesBlock{
    _openRedEnvelopesBlock = [openRedEnvelopesBlock copy];
}

- (void)openRedEnvelopes:(NewMainFrameViewController *)mainVC{
    NSArray *controllers = mainVC.navigationController.viewControllers;
    UIViewController *msgContentVC = nil;
    for (UIViewController *aController in controllers) {
        if ([aController isMemberOfClass:NSClassFromString(@"BaseMsgContentViewController")]) {
            msgContentVC = aController;
            break;
        }
    }
    if (msgContentVC) {
        [mainVC.navigationController PushViewController:msgContentVC animated:YES];
    } else {
        [mainVC tableView:[mainVC valueForKey:@"m_tableView"] didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    }
}

- (void)handleRedEnvelopesPushVC:(BaseMsgContentViewController *)baseMsgVC{
    //红包push
    if (!baseMsgVC.view){
        return;
    }
    
    UITableView *tableView = [baseMsgVC valueForKey:@"m_tableView"];
    
    NSInteger rowCount = [baseMsgVC numberOfSectionsInTableView:tableView] - 1;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:rowCount<0?0:rowCount];
    UITableViewCell *cell = [baseMsgVC tableView:tableView cellForRowAtIndexPath:indexPath];
    
    for (UIView *subView in [cell.contentView subviews]) {
        if ([subView isKindOfClass:NSClassFromString(@"WCPayC2CMessageCellView")]) {
            [baseMsgVC tapAppNodeView:subView];
            break;
        }
    }
}

- (void)successOpenRedEnvelopesNotification{
    // 1.创建通知
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    // 2.设置通知的必选参数
    // 设置通知显示的内容
    localNotification.alertBody = @"帮您领了一个大红包！快去查看吧~";
    // 设置通知的发送时间,单位秒
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:10];
    //解锁滑动时的事件
    localNotification.alertAction = @"别磨蹭了!";
    //收到通知时App icon的角标
    //localNotification.applicationIconBadgeNumber = 1;
    //推送是带的声音提醒，设置默认的字段为UILocalNotificationDefaultSoundName
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    // 3.发送通知(🐽 : 根据项目需要使用)
    // 方式一: 根据通知的发送时间(fireDate)发送通知
    //[[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    // 方式二: 立即发送通知
     [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
}

@end
