//
//  LLSettingController.m
//  test
//
//  Created by fqb on 2017/12/15.
//  Copyright © 2017年 kevliule. All rights reserved.
//

#import "LLSettingController.h"
#import "WCRedEnvelopesHelper.h"
#import "LLRedEnvelopesMgr.h"
#import <objc/runtime.h>

static NSString * const kSettingControllerKey = @"SettingControllerKey";

@interface LLSettingController ()

@property (nonatomic, strong) LLSettingParam *settingParam; //设置参数

@end

@implementation LLSettingParam

@end

@implementation LLSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
    [self setNavigationBar];
    [self exchangeMethod];
    [self reloadTableData];
}

- (void)commonInit{
    _settingParam = [[LLSettingParam alloc] init];
    _settingParam.isOpenRedEnvelopesHelper = [LLRedEnvelopesMgr shared].isOpenRedEnvelopesHelper;
    _settingParam.isOpenSportHelper = [LLRedEnvelopesMgr shared].isOpenSportHelper;
    _settingParam.isOpenBackgroundMode = [LLRedEnvelopesMgr shared].isOpenBackgroundMode;
    _settingParam.isOpenRedEnvelopesAlert = [LLRedEnvelopesMgr shared].isOpenRedEnvelopesAlert;
    _settingParam.openRedEnvelopesDelaySecond = [LLRedEnvelopesMgr shared].openRedEnvelopesDelaySecond;
    _settingParam.wantSportStepCount = [LLRedEnvelopesMgr shared].wantSportStepCount;
}

- (void)setNavigationBar{
    self.title = @"微信助手设置";
    
    UIBarButtonItem *saveItem = [NSClassFromString(@"MMUICommonUtil") getBarButtonWithTitle:@"保存" target:self action:@selector(clickSaveItem) style:0 color:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = saveItem;
}

- (void)exchangeMethod{
    method_exchangeImplementations(class_getInstanceMethod(NSClassFromString(@"MMTableViewCellInfo"), @selector(actionEditorCell:)), class_getInstanceMethod([LLSettingController class], @selector(onTextFieldEditChanged:)));
}

- (void)reloadTableData{
    MMTableViewInfo *tableInfo = [[NSClassFromString(@"MMTableViewInfo") alloc] initWithFrame:[UIScreen mainScreen].bounds style:0];
    [self.view addSubview:[tableInfo getTableView]];
    [tableInfo setDelegate:self];
    
    MMTableViewCellInfo *openRedEnvelopesCell = [NSClassFromString(@"MMTableViewCellInfo") switchCellForSel:@selector(openRedEnvelopesSwitchHandler:) target:self title:@"是否开启红包助手" on:_settingParam.isOpenRedEnvelopesHelper];
    MMTableViewCellInfo *backgroundModeCell = [NSClassFromString(@"MMTableViewCellInfo") switchCellForSel:@selector(openBackgroundMode:) target:self title:@"是否开启后台模式" on:_settingParam.isOpenBackgroundMode];
    MMTableViewCellInfo *openAlertCell = [NSClassFromString(@"MMTableViewCellInfo") switchCellForSel:@selector(openRedEnvelopesAlertHandler:) target:self title:@"是否开启红包提醒" on:_settingParam.isOpenRedEnvelopesAlert];
    MMTableViewCellInfo *delayTimeCell = [NSClassFromString(@"MMTableViewCellInfo") editorCellForSel:nil target:nil title:@"延迟秒数" margin:120 tip:@"请输入延迟抢红包秒数" focus:NO autoCorrect:NO text:[NSString stringWithFormat:@"%.2f",_settingParam.openRedEnvelopesDelaySecond] isFitIpadClassic:YES];
    [delayTimeCell addUserInfoValue:@(UIKeyboardTypeDecimalPad) forKey:@"keyboardType"];
    [delayTimeCell addUserInfoValue:@"delayTimeCell" forKey:@"cellType"];
    objc_setAssociatedObject(delayTimeCell, &kSettingControllerKey, self, OBJC_ASSOCIATION_ASSIGN);

    MMTableViewSectionInfo *redEnvelopesSection = [NSClassFromString(@"MMTableViewSectionInfo") sectionInfoDefaut];
    [redEnvelopesSection setHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0,0,0,20)]];
    [redEnvelopesSection addCell:openRedEnvelopesCell];
    [redEnvelopesSection addCell:backgroundModeCell];
    [redEnvelopesSection addCell:openAlertCell];
    [redEnvelopesSection addCell:delayTimeCell];
    
    MMTableViewCellInfo *openStepCountCell = [NSClassFromString(@"MMTableViewCellInfo") switchCellForSel:@selector(openStepCountSwitchHandler:) target:self title:@"是否开启运动助手" on:_settingParam.isOpenSportHelper];
    MMTableViewCellInfo *stepCell = [NSClassFromString(@"MMTableViewCellInfo") editorCellForSel:@selector(stepCountHandler:) target:self title:@"运动步数" margin:120 tip:@"请输入想要的运动步数" focus:NO autoCorrect:NO text:[NSString stringWithFormat:@"%ld",(long)_settingParam.wantSportStepCount] isFitIpadClassic:YES];
    [stepCell addUserInfoValue:@(UIKeyboardTypeNumberPad) forKey:@"keyboardType"];
    [stepCell addUserInfoValue:@"stepCell" forKey:@"cellType"];
    objc_setAssociatedObject(stepCell, &kSettingControllerKey, self, OBJC_ASSOCIATION_ASSIGN);

    MMTableViewSectionInfo *stepCountSection = [NSClassFromString(@"MMTableViewSectionInfo") sectionInfoDefaut];
    [stepCountSection setHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0,0,0,20)]];
    [stepCountSection addCell:openStepCountCell];
    [stepCountSection addCell:stepCell];

    MMTableViewCellInfo *githubCell = [NSClassFromString(@"MMTableViewCellInfo") normalCellForSel:@selector(onGithubCellClicked) target:self title:@"我的Github" rightValue:@"欢迎Star" accessoryType:1];

    MMTableViewSectionInfo *aboutMeSection = [NSClassFromString(@"MMTableViewSectionInfo") sectionInfoDefaut];
    [aboutMeSection addCell:githubCell];
    
    [tableInfo addSection:redEnvelopesSection];
    [tableInfo addSection:stepCountSection];
    [tableInfo addSection:aboutMeSection];
    
    [[tableInfo getTableView] reloadData];
}

//点击保存
- (void)clickSaveItem{
    [LLRedEnvelopesMgr shared].isOpenRedEnvelopesHelper = _settingParam.isOpenRedEnvelopesHelper;
    [LLRedEnvelopesMgr shared].isOpenSportHelper = _settingParam.isOpenSportHelper;
    [LLRedEnvelopesMgr shared].isOpenBackgroundMode = _settingParam.isOpenBackgroundMode;
    [LLRedEnvelopesMgr shared].isOpenRedEnvelopesAlert = _settingParam.isOpenRedEnvelopesAlert;
    [LLRedEnvelopesMgr shared].openRedEnvelopesDelaySecond = _settingParam.openRedEnvelopesDelaySecond;
    [LLRedEnvelopesMgr shared].wantSportStepCount = _settingParam.wantSportStepCount;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)openRedEnvelopesSwitchHandler:(UISwitch *)openSwitch{
    _settingParam.isOpenRedEnvelopesHelper = openSwitch.on;
}

- (void)openBackgroundMode:(UISwitch *)backgroundMode{
    _settingParam.isOpenBackgroundMode = backgroundMode.on;
}

- (void)openRedEnvelopesAlertHandler:(UISwitch *)openSwitch{
    _settingParam.isOpenRedEnvelopesAlert = openSwitch.on;
}

- (void)onTextFieldEditChanged:(UITextField *)textField{
    LLSettingController *settingController = objc_getAssociatedObject(self, &kSettingControllerKey);
    MMTableViewCellInfo *cellInfo = (MMTableViewCellInfo *)self;
    NSString *cellType = [cellInfo getUserInfoValueForKey:@"cellType"];
    if([cellType isEqualToString:@"delayTimeCell"]){
        settingController.settingParam.openRedEnvelopesDelaySecond = [textField.text floatValue];
    } else if ([cellType isEqualToString:@"stepCell"]){
        settingController.settingParam.wantSportStepCount = [textField.text integerValue];
    }
}

- (void)openStepCountSwitchHandler:(UISwitch *)openSwitch{
    _settingParam.isOpenSportHelper = openSwitch.on;
}

- (void)onGithubCellClicked{
    NSURL *myGithubURL = [NSURL URLWithString:@"https://github.com/kevll/WeChatRedEnvelopesHelper"];
    MMWebViewController *githubWebVC = [[NSClassFromString(@"MMWebViewController") alloc] initWithURL:myGithubURL presentModal:NO extraInfo:nil delegate:nil];
    [self.navigationController PushViewController:githubWebVC animated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self exchangeMethod]; //reset
}

@end
