//
//  LLRedEnvelopesMgr.m
//  test
//
//  Created by fqb on 2017/12/12.
//  Copyright © 2017年 kevliule. All rights reserved.
//

#import "LLRedEnvelopesMgr.h"

static NSString * const isOpenRedEnvelopesHelperKey = @"isOpenRedEnvelopesHelperKey";
static NSString * const isOpenSportHelperKey = @"isOpenSportHelperKey";
static NSString * const isOpenBackgroundModeKey = @"isOpenBackgroundMode";
static NSString * const openRedEnvelopesDelaySecondKey = @"openRedEnvelopesDelaySecondKey";
static NSString * const wantSportStepCountKey = @"wantSportStepCountKey";

@implementation LLRedEnvelopesMgr

+ (LLRedEnvelopesMgr *)shared{
    static LLRedEnvelopesMgr *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LLRedEnvelopesMgr alloc] init];
    });
    return manager;
}

- (id)init{
    if(self = [super init]){
        _isOpenRedEnvelopesHelper = [[NSUserDefaults standardUserDefaults] boolForKey:isOpenRedEnvelopesHelperKey];
        _isOpenSportHelper = [[NSUserDefaults standardUserDefaults] boolForKey:isOpenSportHelperKey];
        _isOpenBackgroundMode = [[NSUserDefaults standardUserDefaults] boolForKey:isOpenBackgroundModeKey];
        _openRedEnvelopesDelaySecond = [[NSUserDefaults standardUserDefaults] floatForKey:openRedEnvelopesDelaySecondKey];
        _wantSportStepCount = [[NSUserDefaults standardUserDefaults] integerForKey:wantSportStepCountKey];
    }
    return self;
}

- (void)reset{
    _haveNewRedEnvelopes = NO;
    _isHiddenRedEnvelopesReceiveView = NO;
    _isHongBaoPush = NO;
}

#pragma mark SET GET METHOD

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

- (void)setIsOpenRedEnvelopesHelper:(BOOL)isOpenRedEnvelopesHelper{
    _isOpenRedEnvelopesHelper = isOpenRedEnvelopesHelper;
    [[NSUserDefaults standardUserDefaults] setBool:isOpenRedEnvelopesHelper forKey:isOpenRedEnvelopesHelperKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setIsOpenSportHelper:(BOOL)isOpenSportHelper{
    _isOpenSportHelper = isOpenSportHelper;
    [[NSUserDefaults standardUserDefaults] setBool:isOpenSportHelper forKey:isOpenSportHelperKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setIsOpenBackgroundMode:(BOOL)isOpenBackgroundMode{
    _isOpenBackgroundMode = isOpenBackgroundMode;
    [[NSUserDefaults standardUserDefaults] setBool:isOpenBackgroundMode forKey:isOpenBackgroundModeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setOpenRedEnvelopesDelaySecond:(CGFloat)openRedEnvelopesDelaySecond{
    _openRedEnvelopesDelaySecond = openRedEnvelopesDelaySecond;
    [[NSUserDefaults standardUserDefaults] setFloat:openRedEnvelopesDelaySecond forKey:openRedEnvelopesDelaySecondKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setWantSportStepCount:(NSInteger)wantSportStepCount{
    _wantSportStepCount = wantSportStepCount;
    [[NSUserDefaults standardUserDefaults] setInteger:wantSportStepCount forKey:wantSportStepCountKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark HANDLER METHOD

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
        [self reset];
        return;
    }
    
    UITableView *tableView = [baseMsgVC valueForKey:@"m_tableView"];
    
    NSInteger section = [baseMsgVC numberOfSectionsInTableView:tableView] - 1;
    
    if(section < 0){
        [self reset];
        return;
    }

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    UITableViewCell *cell = [baseMsgVC tableView:tableView cellForRowAtIndexPath:indexPath];
    
    BOOL isFindWCPayC2CView = NO;
    for (UIView *subView in [cell.contentView subviews]) {
        if ([subView isKindOfClass:NSClassFromString(@"WCPayC2CMessageCellView")]) {
            isFindWCPayC2CView = YES;
            [baseMsgVC tapAppNodeView:subView];
            break;
        }
    }
    if(!isFindWCPayC2CView){
        [self reset];
    }
}

- (void)successOpenRedEnvelopesNotification{
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.alertBody = @"帮您领了一个大红包！快去查看吧~";
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
}

@end
