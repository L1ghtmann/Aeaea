#import <UIKit/UIKit.h>

//https://stackoverflow.com/a/5337804
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

//Universal
@interface UIView (Private)
-(id)_viewControllerForAncestor; //used for notif position check 
@end

@interface MTMaterialView : UIView
@end

@interface PLPlatterView : UIView //and iOS 12 sub-cell
@property (nonatomic,retain) UIView * backgroundView; //for both notifs and widgets
@property (nonatomic,retain) MTMaterialView * mainOverlayView;  //for widgets (iOS 12 extra mtmaterialview)
@property (nonatomic,readonly) UIView * customContentView;                                   
@end

@interface PLPlatterHeaderContentView : UIView
@property (getter=_titleLabel, nonatomic, readonly) UILabel *titleLabel; 
@property (getter=_dateLabel, nonatomic, readonly) UILabel *dateLabel;
@property (nonatomic,readonly) NSArray * iconButtons; 
@end

//Notifications
@interface PLPlatterCustomContentView : UIView
@end

@interface PLTitledPlatterView : PLPlatterView{
	PLPlatterHeaderContentView* _headerContentView;
}
@end

@interface NCNotificationShortLookView : PLTitledPlatterView 
@end

@interface NCNotificationShortLookViewController : UIViewController
@property (nonatomic,readonly) NCNotificationShortLookView * viewForPreview;
@property (nonatomic, weak) id delegate;
@end

@interface NCNotificationViewControllerView : UIView {
	NSArray* _stackedPlatters;//contains PLPlatterViews (ONLY SUBVIEWS (STAND IN FOR SHORTLOOKVIEWS))
}
@end

@interface _MTBackdropView : MTMaterialView
@end

@interface BSUIEmojiLabelView : UIView
@property (nonatomic, assign) UIColor *textColor;
@end

@interface NCNotificationContentView : UIView
@property (setter=_setPrimaryLabel:,getter=_primaryLabel,nonatomic,retain) UILabel * primaryLabel;  
@property (setter=_setPrimarySubtitleLabel:,getter=_primarySubtitleLabel,nonatomic,retain) UILabel * primarySubtitleLabel; 
@property (getter=_secondaryLabel,nonatomic,readonly) UILabel * secondaryLabel;   
@property (setter=_setSummaryLabel:,getter=_summaryLabel,nonatomic,retain) BSUIEmojiLabelView * summaryLabel;    
@property (nonatomic,retain) UIImageView * thumbnail;  
@end

@interface _UILegibilitySettings : NSObject
@property (nonatomic, retain) UIColor *primaryColor;
-(id)initWithStyle:(long long)arg1;
@end

@interface _UILegibilityView : UIView
@property (nonatomic,retain) _UILegibilitySettings * settings; 
@property (nonatomic,retain) UIImageView * imageView;        
@property (nonatomic,retain) UIImageView * shadowImageView;  
@end

@interface SBUILegibilityLabel : UILabel
@property (nonatomic, retain) _UILegibilitySettings *legibilitySettings;
@end

@interface NCNotificationListView : UIView
@property (nonatomic,retain) NSMutableDictionary * visibleViews;                                                                     
@property (assign,getter=isGrouped,nonatomic) BOOL grouped;                                                                          
@end

@interface NCNotificationListSectionRevealHintView : UIView
@property (nonatomic,retain) SBUILegibilityLabel * revealHintTitle; 
@property (nonatomic,retain) _UILegibilitySettings * legibilitySettings;     
@end

@interface NCNotificationListHeaderTitleView : UIView
@property (nonatomic,retain) SBUILegibilityLabel * titleLabel;                               
@property (nonatomic,retain) _UILegibilitySettings * legibilitySettings;       
@end

@interface NCNotificationListSectionHeaderView : UIView 
@property (nonatomic,retain) NCNotificationListHeaderTitleView * headerTitleView;     
@property (nonatomic,retain) _UILegibilitySettings * legibilitySettings;             
@end

@interface NCNotificationListCellActionButton : UIView{
    UILabel* _titleLabel; // property doesnt work for changing text color for some reason; ivar works
}     
@property (nonatomic,retain) MTMaterialView * backgroundView;   
@property (nonatomic,retain) MTMaterialView * backgroundOverlayView; //extra mtmaterialview in iOS 12
@end

@interface PLGlyphControl : UIView
@property (getter=_backgroundMaterialView,nonatomic,retain) MTMaterialView * backgroundMaterialView;
@property (getter=_overlayMaterialView,nonatomic,retain) MTMaterialView * overlayMaterialView;    //extra mtmaterialview in iOS 12
@end

@interface NCToggleControl : PLGlyphControl
@end

@interface _UIBackdropView : UIView
@end

@interface CSBatteryFillView : UIView
@end

@interface _CSSingleBatteryChargingView : UIView{
    UIView* _batteryContainerView;
	_UIBackdropView* _batteryBlurView;
	CSBatteryFillView* _batteryFillView;
	SBUILegibilityLabel* _chargePercentLabel;
}
@end

@interface SBLockScreenBatteryFillView : UIView
@end

@interface _SBLockScreenSingleBatteryChargingView : UIView{
    UIView* _batteryContainerView;
	_UIBackdropView* _batteryBlurView;
	SBLockScreenBatteryFillView* _batteryFillView;
	SBUILegibilityLabel* _chargePercentLabel;
}
@end

// Test Notifications
@interface SBLockScreenManager : NSObject
+(id)sharedInstance;
-(void)lockUIFromSource:(int)arg1 withOptions:(id)arg2;
@end

@interface BBBulletin : NSObject
@property (nonatomic, copy) NSString* sectionID;
@property (nonatomic, copy) NSString* bulletinID;
@property (nonatomic, copy) NSString* recordID;
@property (nonatomic, copy) NSString* publisherBulletinID;
@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* message;
@property (nonatomic, retain) NSDate* date;
@property (assign, nonatomic) BOOL clearable;
@property (nonatomic) BOOL showsMessagePreview;
@end

@interface BBServer : NSObject
-(void)publishBulletin:(id)arg1 destinations:(unsigned long long)arg2;
-(id)initWithQueue:(id)arg1;
-(void)dealloc;
@end

// Widgets
@interface WGWidgetHostingViewController : UIViewController
@end

@interface WGWidgetListItemViewController : UIViewController
@end

@interface WGWidgetPlatterView : PLPlatterView {
	MTMaterialView* _headerBackgroundView; // iOS 13
	UIView* _headerOverlayView; // iOS 12
	UIView* _headerContentView; //contains app icon and label
}
@property (setter=_setContentView:,nonatomic,retain) UIView * contentView; // iOS 13
@property (nonatomic,readonly) UIView * customContentView; // iOS 12                                           
@property (nonatomic,readonly) UIButton * showMoreButton; 
@property (assign,getter=isShowingMoreContent,nonatomic) BOOL showingMoreContent;                      
@property (assign,getter=isShowMoreButtonVisible,nonatomic) BOOL showMoreButtonVisible; 
@end

@interface WGPlatterHeaderContentView : PLPlatterHeaderContentView
@end

@interface WGShortLookStyleButton : UIView{
	MTMaterialView* _backgroundView;
}
@end

@interface WGWidgetAttributionView : UIView
@end

//Test notifs
extern dispatch_queue_t __BBServerQueue;
static BBServer* bbServer;

//prefs
static BOOL isEnabled;

//Notification specific 
static BOOL notifsEnabled;

static int location;

static CGFloat notifTransparency;

static int textcolor;

static BOOL hideAppIcon;
static BOOL hideAppName;
static BOOL hideTimeLabel;
static BOOL hideNONT;
static BOOL hideChargingIndicator;

//Widget specific 
static BOOL widgetsEnabled;

static CGFloat widgetTransparency;

static int contentcolor;

static BOOL autoExpand;
static BOOL hideWidgetIcon;
static BOOL hideWidgetLabel;
static BOOL hideFooterText;

//compatibility
static BOOL axonInstalled;
