#import "WCRedEnvelopesHelper.h"
#import "LLRedEnvelopesMgr.h"
#import "LLSettingController.h"
#import <AVFoundation/AVFoundation.h>
%hook WCDeviceStepObject

//- (unsigned long)m7StepCount{
 //   return 98800;
//}

%end

%hook UINavigationController

- (void)PushViewController:(UIViewController *)controller animated:(BOOL)animated{
	if ([LLRedEnvelopesMgr shared].isHongBaoPush && [controller isMemberOfClass:NSClassFromString(@"BaseMsgContentViewController")]) {
		[LLRedEnvelopesMgr shared].isHongBaoPush = NO;
		[LLRedEnvelopesMgr shared].isHiddenRedEnvelopesReceiveView = YES;
        [[LLRedEnvelopesMgr shared] handleRedEnvelopesPushVC:(BaseMsgContentViewController *)controller]; 
    } else {
    	%orig;
    }
}

%end

%hook UIViewController 

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion{
	if ([LLRedEnvelopesMgr shared].isHiddenRedEnvelopesReceiveView && [viewControllerToPresent isKindOfClass:NSClassFromString(@"MMUINavigationController")]){
		UINavigationController *navController = (UINavigationController *)viewControllerToPresent;
		if (navController.viewControllers.count > 0){
			if ([navController.viewControllers[0] isKindOfClass:NSClassFromString(@"WCRedEnvelopesRedEnvelopesDetailViewController")]){
				//模态红包详情视图
				return;
			}
		}
	} 
	%orig;	
}

%end

%hook CMessageMgr

- (void)MainThreadNotifyToExt:(NSDictionary *)ext{
	%orig;
	CMessageWrap *msgWrap = ext[@"3"];
    if (msgWrap && msgWrap.m_uiMessageType == 49){
        //红包消息
        [LLRedEnvelopesMgr shared].haveNewRedEnvelopes = YES;
    }
}

- (void)AsyncOnPreAddMsg:(id)ext MsgWrap:(id)msg{
	%orig;
}

- (void)onNewSyncShowPush:(NSDictionary *)message{
	%orig;
	if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground){
		//app在后台运行
		CMessageWrap *msgWrap = (CMessageWrap *)message;
	    if (msgWrap && msgWrap.m_uiMessageType == 49){
	        //红包消息
	        [LLRedEnvelopesMgr shared].haveNewRedEnvelopes = YES;
	        if([LLRedEnvelopesMgr shared].openRedEnvelopesBlock){
	        	[LLRedEnvelopesMgr shared].openRedEnvelopesBlock();
			}
	    }
	}
}

%end

%hook WCRedEnvelopesReceiveHomeView

- (id)initWithFrame:(CGRect)frame andData:(id)data delegate:(id)delegate{
	WCRedEnvelopesReceiveHomeView *view = %orig;
	if([LLRedEnvelopesMgr shared].isHiddenRedEnvelopesReceiveView){
		//打开红包
	    [view OnOpenRedEnvelopes]; 
	    view.hidden = YES;
	}
    return view;
}

- (void)showSuccessOpenAnimation{
	%orig;
	if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground){ 
		[[LLRedEnvelopesMgr shared] successOpenRedEnvelopesNotification];
	}
}

%end 

%hook MMUIWindow 

- (void)addSubview:(UIView *)subView{
	if ([subView isKindOfClass:NSClassFromString(@"WCRedEnvelopesReceiveHomeView")] && [LLRedEnvelopesMgr shared].isHiddenRedEnvelopesReceiveView){
		//隐藏弹出红包领取完成页面所在window
		((UIView *)self).hidden = YES;
	} else {
		%orig;
	}
}

- (void)dealloc{
	if ([LLRedEnvelopesMgr shared].isHiddenRedEnvelopesReceiveView){
		[LLRedEnvelopesMgr shared].isHiddenRedEnvelopesReceiveView = NO;
	} else {
		%orig;
	}
}

%end

%hook NewMainFrameViewController

- (void)viewDidLoad{
	%orig;
	//__weak typeof(self) weakself = self;
	[LLRedEnvelopesMgr shared].openRedEnvelopesBlock = ^{
		if([LLRedEnvelopesMgr shared].haveNewRedEnvelopes){
			[LLRedEnvelopesMgr shared].haveNewRedEnvelopes = NO;
			[LLRedEnvelopesMgr shared].isHongBaoPush = YES;
			[[LLRedEnvelopesMgr shared] openRedEnvelopes:self];
		}
	};
}

- (void)reloadSessions{
	%orig;
	if([LLRedEnvelopesMgr shared].openRedEnvelopesBlock){
		[LLRedEnvelopesMgr shared].openRedEnvelopesBlock();
	}
}

%end

%hook WCRedEnvelopesControlLogic

- (void)startLoading{
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isHiddenRedEnvelopesReceiveView"]){
		//隐藏加载菊花
		//do nothing	
	} else {
		%orig;
	}
}

%end

%hook NewSettingViewController

- (void)reloadTableData{
	%orig;
    MMTableViewCellInfo *configCell = [%c(MMTableViewCellInfo) normalCellForSel:@selector(configHandler) target:self title:@"微信助手设置" accessoryType:1];
    MMTableViewSectionInfo *sectionInfo = [%c(MMTableViewSectionInfo) sectionInfoDefaut];
    [sectionInfo addCell:configCell];
    MMTableViewInfo *tableViewInfo = [self valueForKey:@"m_tableViewInfo"];
    [tableViewInfo insertSection:sectionInfo At:0];
    [[tableViewInfo getTableView] reloadData];
}

%new
- (void)configHandler{
    LLSettingController *settingVC = [[LLSettingController alloc] init];
    [((UIViewController *)self).navigationController PushViewController:settingVC animated:YES];
}

%end

%hook MicroMessengerAppDelegate

-(void)applicationDidEnterBackground:(UIApplication *)application{
  %orig;
  objc_msgSend(self,@selector(comeToBackgroundMode));
}

%new
-(void)comeToBackgroundMode{
    //初始化一个后台任务BackgroundTask，这个后台任务的作用就是告诉系统当前app在后台有任务处理，需要时间
    UIApplication *app = [UIApplication sharedApplication];
    [LLRedEnvelopesMgr shared].bgTaskIdentifier = [app beginBackgroundTaskWithExpirationHandler:^{
    [app endBackgroundTask:[LLRedEnvelopesMgr shared].bgTaskIdentifier];
    	[LLRedEnvelopesMgr shared].bgTaskIdentifier = UIBackgroundTaskInvalid;
    }];
    //开启定时器 不断向系统请求后台任务执行的时间
    [LLRedEnvelopesMgr shared].bgTaskTimer = [NSTimer scheduledTimerWithTimeInterval:25.0 target:self selector:@selector(applyForMoreTime) userInfo:nil repeats:YES];
    [[LLRedEnvelopesMgr shared].bgTaskTimer fire];
}

%new
-(void)applyForMoreTime{
    //如果系统给的剩余时间小于60秒 就终止当前的后台任务，再重新初始化一个后台任务，重新让系统分配时间，这样一直循环下去，保持APP在后台一直处于active状态。
    if ([UIApplication sharedApplication].backgroundTimeRemaining < 60) {
	    [[UIApplication sharedApplication] endBackgroundTask:[LLRedEnvelopesMgr shared].bgTaskIdentifier];
	    [LLRedEnvelopesMgr shared].bgTaskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
	        [[UIApplication sharedApplication] endBackgroundTask:[LLRedEnvelopesMgr shared].bgTaskIdentifier];
	        [LLRedEnvelopesMgr shared].bgTaskIdentifier = UIBackgroundTaskInvalid;
	    }];
    }
}

- (void)application:(id)application didReceiveRemoteNotification:(id)notification fetchCompletionHandler:(id)handler{
	%orig;
	dispatch_async(dispatch_get_main_queue(), ^{
        [LLRedEnvelopesMgr shared].openRedEnvelopesBlock();
   	});
}

- (void)application:(id)application didReceiveRemoteNotification:(id)notification{
	%orig;
}

%new
- (void)userNotificationCenter:(id)center willPresentNotification:(id)notification withCompletionHandler:(id)completionHandler{

}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
	NSError *setCategoryErr = nil;
    NSError *activationErr  = nil;
    [[AVAudioSession sharedInstance]
     setCategory: AVAudioSessionCategoryPlayback
     error: &setCategoryErr];
    [[AVAudioSession sharedInstance]
     setActive: YES
     error: &activationErr];
	return %orig;
}

%end
