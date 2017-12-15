@interface CMessageWrap : NSObject

@property(nonatomic) unsigned int m_uiMessageType; // @synthesize m_uiMessageType;

@end

@interface CBaseContact : NSObject

@property(retain, nonatomic) NSString *m_nsAliasName; // @synthesize m_nsAliasName;
@property(retain, nonatomic) NSString *m_nsUsrName; // @synthesize m_nsUsrName;
@property(nonatomic) unsigned int m_uiSex; // @synthesize m_uiSex;
@property(retain, nonatomic) NSString *m_nsHeadImgUrl; // @synthesize m_nsHeadImgUrl;

@end

@interface CContact: CBaseContact

@end

@interface MMSessionInfo : NSObject

@property(retain, nonatomic) CMessageWrap *m_msgWrap; // @synthesize m_msgWrap;

@property(retain, nonatomic) CContact *m_contact; // @synthesize m_contact;

@end 

@interface BaseMsgContentViewController : UIViewController
{
	UITableView *m_tableView;
}

- (id)tableView:(id)arg1 cellForRowAtIndexPath:(id)arg2;
- (long long)numberOfSectionsInTableView:(id)arg1;
- (void)tapAppNodeView:(id)arg1;

@end

@interface NewMainFrameViewController : UIViewController
{
	UITableView *m_tableView;
}

- (void)tableView:(id)arg1 didSelectRowAtIndexPath:(id)arg2;

- (void)openRedEnvelopes;

@end

@interface UINavigationController (LogicController)

- (void)PushViewController:(id)arg1 animated:(_Bool)arg2;

@end

@interface WCRedEnvelopesReceiveHomeView : UIView

- (void)OnOpenRedEnvelopes;

@end

@interface MMUIViewController : UIViewController

@end

@interface MMTableViewInfo : NSObject

- (void)setDelegate:(id)delegate;
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;
- (id)getTableView;
- (void)clearAllSection;
- (void)addSection:(id)arg1;
- (void)insertSection:(id)arg1 At:(unsigned int)arg2;

@end

@interface MMTableViewSectionInfo : NSObject

+ (id)sectionInfoDefaut;
- (void)addCell:(id)arg1;
- (void)setHeaderView:(UIView *)headerView;
- (void)setFHeaderHeight:(CGFloat)height;

@end

@interface MMTableViewUserInfo : NSObject

- (id)getUserInfoValueForKey:(id)arg1;
- (void)addUserInfoValue:(id)arg1 forKey:(id)arg2;

@end

@interface MMTableViewCellInfo : MMTableViewUserInfo

+ (id)editorCellForSel:(SEL)arg1 target:(id)arg2 title:(id)arg3 margin:(double)arg4 tip:(id)arg5 focus:(_Bool)arg6 autoCorrect:(_Bool)arg7 text:(id)arg8 isFitIpadClassic:(_Bool)arg9;
+ (id)normalCellForSel:(SEL)arg1 target:(id)arg2 title:(id)arg3 accessoryType:(long long)arg4;
+ (id)switchCellForSel:(SEL)arg1 target:(id)arg2 title:(id)arg3 on:(_Bool)arg4;
+ (id)normalCellForSel:(SEL)arg1 target:(id)arg2 title:(id)arg3 rightValue:(id)arg4 accessoryType:(long long)arg5;
+ (id)normalCellForTitle:(id)arg1 rightValue:(id)arg2;
+ (id)urlCellForTitle:(id)arg1 url:(id)arg2;

@end

@interface MMTableView: UITableView

@end
