#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

//Universal
@interface UIView (Private)
-(id)_viewControllerForAncestor; //used for notif position check 
@end

@interface MTMaterialView : UIView
@end

@interface PLPlatterView : UIView //and iOS 12 sub-cell
@property (nonatomic,retain) UIView * backgroundView; //for both notifs and widgets
@property (nonatomic,retain) MTMaterialView * mainOverlayView;  //for widgets (iOS 12 extra mtmaterialview)
@end

@interface PLPlatterHeaderContentView : UIView
@property (getter=_titleLabel, nonatomic, readonly) UILabel *titleLabel; 
@property (getter=_dateLabel, nonatomic, readonly) UILabel *dateLabel;
@property (nonatomic,readonly) NSArray * iconButtons; //for widgets
@end

static BOOL isEnabled;


//Notifications
@interface NCNotificationShortLookViewController : UIViewController
@property (nonatomic,readonly) UIView * viewForPreview;
@property (nonatomic, weak) id delegate;
@end

@interface NCNotificationListView : UIView 
@property (assign,getter=isGrouped,nonatomic) BOOL grouped; 
@property (nonatomic, strong, readwrite) NSMutableDictionary * visibleViews; 
@end

@interface NCNotificationShortLookView : PLPlatterView
@end

@interface PLPlatterCustomContentView : UIView
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
@end

@interface _UILegibilityView : UIView
@property (nonatomic,retain) _UILegibilitySettings * settings; 
@property (nonatomic,retain) UIImageView * imageView;        
@property (nonatomic,retain) UIImageView * shadowImageView;  
@end

@interface _UILegibilitySettings (Private)
-(id)initWithStyle:(long long)arg1;
@end

@interface SBUILegibilityLabel : UILabel
@property (nonatomic, retain) _UILegibilitySettings *legibilitySettings;
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

@interface NCNotificationViewControllerView : UIView {
	NSArray* _stackedPlatters;//contains PLPlatterViews (ONLY SUBVIEWS (STAND IN FOR SHORTLOOKVIEWS))
}
@end

@interface _MTBackdropView : MTMaterialView
@end

//Notification specific prefs 
static BOOL notifsEnabled;

static int location;

static CGFloat notifTransparency;

static int textcolor;

static BOOL hideAppName = NO;
static BOOL hideTimeLabel = NO;
static BOOL hideNONT;
static BOOL hideChargingIndicator = NO;

//compatibility
static BOOL axonInstalled = NO;


// Widgets
@interface WGWidgetHostingViewController : UIViewController
@end

@interface WGWidgetPlatterView : PLPlatterView {
	MTMaterialView* _headerBackgroundView; // iOS 13
	UIView* _headerOverlayView; // iOS 12
}
@end

@interface WGShortLookStyleButton : UIView{
	MTMaterialView* _backgroundView;
}
@end

@interface WGWidgetAttributionView : UIView
@end

@interface WGPlatterHeaderContentView : PLPlatterHeaderContentView
@end

// Widget specific prefs 
static BOOL widgetsEnabled;

static CGFloat widgetTransparency;

static int contentcolor;

static BOOL hideFooterText;
static BOOL hideWidgetIcon = NO;
static BOOL hideWidgetLabel = NO;
