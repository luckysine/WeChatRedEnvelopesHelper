//
//  LLSettingController.m
//  test
//
//  Created by fqb on 2017/12/15.
//  Copyright © 2017年 kevliule. All rights reserved.
//

#import "LLSettingController.h"
#import "WCRedEnvelopesHelper.h"

@interface LLSettingController ()

@end

@implementation LLSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBar];
    [self reloadTableData];
}

- (void)setNavigationBar{
    self.title = @"微信助手设置";
    
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(clickSaveItem)];
    saveItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = saveItem;
}

- (void)reloadTableData{
    MMTableViewInfo *tableInfo = [[NSClassFromString(@"MMTableViewInfo") alloc] initWithFrame:[UIScreen mainScreen].bounds style:0];
    [self.view addSubview:[tableInfo getTableView]];
    [tableInfo setDelegate:self];
    
    MMTableViewCellInfo *openRedEnvelopesCell = [NSClassFromString(@"MMTableViewCellInfo") switchCellForSel:@selector(openRedEnvelopesSwitchHandler:) target:self title:@"是否开启红包助手" on:YES];
    MMTableViewCellInfo *backgroundModeCell = [NSClassFromString(@"MMTableViewCellInfo") switchCellForSel:@selector(openBackgroundMode:) target:self title:@"是否开启后台模式" on:YES];
    MMTableViewCellInfo *delayTimeCell = [NSClassFromString(@"MMTableViewCellInfo") editorCellForSel:@selector(delayTimeHandler:) target:self title:@"延迟秒数" margin:120 tip:@"请输入延迟抢红包秒数" focus:NO autoCorrect:NO text:@"0" isFitIpadClassic:YES];
    [delayTimeCell addUserInfoValue:@(UIKeyboardTypeDecimalPad) forKey:@"keyboardType"];
    MMTableViewSectionInfo *redEnvelopesSection = [NSClassFromString(@"MMTableViewSectionInfo") sectionInfoDefaut];
    [redEnvelopesSection setHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0,0,0,20)]];
    [redEnvelopesSection addCell:openRedEnvelopesCell];
    [redEnvelopesSection addCell:backgroundModeCell];
    [redEnvelopesSection addCell:delayTimeCell];
    
    MMTableViewCellInfo *openStepCountCell = [NSClassFromString(@"MMTableViewCellInfo") switchCellForSel:@selector(openStepCountSwitchHandler:) target:self title:@"是否开启运动助手" on:YES];
    MMTableViewCellInfo *stepCell = [NSClassFromString(@"MMTableViewCellInfo") editorCellForSel:@selector(stepCountHandler:) target:self title:@"延迟秒数" margin:120 tip:@"请输入想要的运动步数" focus:NO autoCorrect:NO text:@"0" isFitIpadClassic:YES];
    [stepCell addUserInfoValue:@(UIKeyboardTypeNumberPad) forKey:@"keyboardType"];
    MMTableViewSectionInfo *stepCountSection = [NSClassFromString(@"MMTableViewSectionInfo") sectionInfoDefaut];
    [stepCountSection setHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0,0,0,20)]];
    [stepCountSection addCell:openStepCountCell];
    [stepCountSection addCell:stepCell];
    
    [tableInfo addSection:redEnvelopesSection];
    [tableInfo addSection:stepCountSection];
    
    [[tableInfo getTableView] reloadData];
}

- (void)openRedEnvelopesSwitchHandler:(UISwitch *)openSwitch{
    UILabel *lbl = [UILabel new];
    lbl.text = [NSString stringWithFormat:@"%@",openSwitch.class];
    lbl.frame = CGRectMake(10,300,300,200);
    lbl.textColor = [UIColor blueColor];
    lbl.numberOfLines = 0;
    [[UIApplication sharedApplication].windows[0] addSubview:lbl];
}

//点击保存
- (void)clickSaveItem{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)openBackgroundMode:(UISwitch *)backgroundMode{
    
}

- (void)delayTimeHandler:(UITextField *)textField{
    
}

- (void)openStepCountSwitchHandler:(UISwitch *)openSwitch{
    
}

- (void)stepCountHandler:(UITextField *)textField{
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

@end
