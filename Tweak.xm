//Lightmann
//Made during COVID-19 
//Aeaea

#import "Headers.h"

%group iOS13

#pragma mark Notifications

//hides the contrasty background cell along with multiple icons showing up on LS when grouped; remains normal when ungrouped
%hook NCNotificationListView
-(void)setSubviewPerformingGroupingAnimation:(BOOL)arg1 {
    %orig;

    if(notifsEnabled && isEnabled){
		//if its not springboard only, do code
		if(location != 1){
			//even just one notif is considered a 'stack' and is "grouped", so have to dictate only if grouped and count >= 2 to avoid conflict with subsquent statement V
			if(self.grouped && self.visibleViews.count >= 2){

				NSArray *keys = [self.visibleViews allKeys];
			
				for(NSNumber *key in keys){
					
					UIView *value =[self.visibleViews objectForKey:key];
					int keyInt = [key intValue];

					if(keyInt == 0){
						[value setHidden:NO];
					}

					else{
						[value setHidden:YES];
					}
				}
			}
			//if ungrouped or if only one notif appear normal
			if(!self.grouped || self.visibleViews.count < 2){

				NSArray *keys =[self.visibleViews allKeys];
			
				for(NSNumber *key in keys){
					
					UIView *value =[self.visibleViews objectForKey:key];
				
					[value setHidden:NO];
				}
			}
		}

		else{
			%orig;
		}
	}  
}   
%end


%hook NCNotificationListCellActionButton
//sets transparency for background of sections in sliderview of notification banners on lockscreen 
-(void)_configureBackgroundViewIfNecessary{
	%orig;

	if(notifsEnabled && isEnabled && location != 1){
		self.backgroundView.alpha = notifTransparency / 100;
	}
}

//sets text color for labels in sections in sliderview of notification banners on lockscreen 
-(void)_layoutTitleLabel{
	%orig;

	if(notifsEnabled && isEnabled && location != 1){
		if(textcolor == 1){
			if(MSHookIvar<UILabel *>(self, "_titleLabel").layer.filters.count) MSHookIvar<UILabel *>(self, "_titleLabel").layer.filters = nil;
			MSHookIvar<UILabel *>(self, "_titleLabel").textColor = [UIColor colorWithWhite:1 alpha:0.8];
		}
		if(textcolor == 2){
			if(MSHookIvar<UILabel *>(self, "_titleLabel").layer.filters.count) MSHookIvar<UILabel *>(self, "_titleLabel").layer.filters = nil;
			MSHookIvar<UILabel *>(self, "_titleLabel").textColor = [UIColor colorWithWhite:0 alpha:0.8];
		}
	}
}
%end


//changes notification transparency
%hook NCNotificationShortLookView						
-(void)_configureBackgroundViewIfNecessary{
	%orig;

	//Banner vs Notification check taken from Nepeta's Notifica (https://github.com/Baw-Appie/Notifica/blob/master/Tweak/Tweak.xm)
	//prevents instant safemode when longlookview is animated (pull down animation)
	if (![[self _viewControllerForAncestor] respondsToSelector:@selector(delegate)]) %orig;

	else{
		BOOL pos = (location == 0 || ([((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 1) || (![((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 2));
		if(notifsEnabled && isEnabled && pos){
			self.backgroundView.alpha = notifTransparency/100;
		}
	}
}
%end


//hides "Notification Center" text to prevent bug w axon where it would appear and overlap notifications
%hook NCNotificationListSectionHeaderView
-(void)didMoveToWindow{								
	%orig;

	//Banner vs Notification check taken from Nepeta's Notifica (https://github.com/Baw-Appie/Notifica/blob/master/Tweak/Tweak.xm)
	if (((notifsEnabled && isEnabled) && (axonInstalled) && (![((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 2)) || ((location == 0) && (axonInstalled))) {
		self.hidden = YES;
	}	

	if (((!notifsEnabled && isEnabled) || (!axonInstalled)) || ([((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 1)){
		self.hidden = NO;
	}
}
%end


//colors stack header titles and Notification center text
%hook NCNotificationListHeaderTitleView
-(void)adjustForLegibilitySettingsChange:(id)arg1 {
	%orig;

	if(notifsEnabled && isEnabled && location != 1){
		_UILegibilitySettings *customColor = [[_UILegibilitySettings alloc] initWithStyle:1];

		if(textcolor == 1){
			customColor.primaryColor = [UIColor whiteColor];
			[self setLegibilitySettings:customColor];
			self.titleLabel.legibilitySettings = customColor;
			self.titleLabel.textColor = [UIColor whiteColor];
		}
		if(textcolor == 2){
			customColor.primaryColor = [UIColor blackColor];
			[self setLegibilitySettings:customColor];
			self.titleLabel.legibilitySettings = customColor;
			self.titleLabel.textColor = [UIColor blackColor];
		}
	}
}
%end


%hook NCToggleControl
//sets transparency of background of drop down arrow and x above expanded stackview on LS
-(void)_configureBackgroundMaterialViewIfNecessary{
	%orig;

	if(notifsEnabled && isEnabled && location != 1){
		self.backgroundMaterialView.alpha = notifTransparency/100;
	}
}

//text color of drop down label and glyphs in expanded stacked view
-(void)setExpanded:(BOOL)arg1 {
    %orig;

	if(notifsEnabled && isEnabled && location != 1){
		if(textcolor == 1){
			if(MSHookIvar<UILabel *>(self, "_titleLabel").layer.filters.count) MSHookIvar<UILabel *>(self, "_titleLabel").layer.filters = nil;
			MSHookIvar<UILabel *>(self, "_titleLabel").textColor = [UIColor colorWithWhite:1 alpha:0.8];
				
			if(MSHookIvar<UIImageView*>(self, "_glyphView").layer.filters.count) MSHookIvar<UIImageView*>(self, "_glyphView").layer.filters = nil;
			MSHookIvar<UIImageView*>(self, "_glyphView").tintColor = [UIColor colorWithWhite:1 alpha:0.8];
		}
		if(textcolor == 2){
			if(MSHookIvar<UILabel *>(self, "_titleLabel").layer.filters.count) MSHookIvar<UILabel *>(self, "_titleLabel").layer.filters = nil;
			MSHookIvar<UILabel *>(self, "_titleLabel").textColor = [UIColor colorWithWhite:0 alpha:0.8];
			
			if(MSHookIvar<UIImageView*>(self, "_glyphView").layer.filters.count) MSHookIvar<UIImageView*>(self, "_glyphView").layer.filters = nil;
			MSHookIvar<UIImageView*>(self, "_glyphView").tintColor = [UIColor colorWithWhite:0 alpha:0.8];
		}
	}
}
%end


//changes text color for content 
%hook NCNotificationContentView
-(void)setPrimaryText:(NSString *)arg1 {				
	%orig;

	//Banner vs Notification check taken from Nepeta's Notifica (https://github.com/Baw-Appie/Notifica/blob/master/Tweak/Tweak.xm)
	BOOL pos = (location == 0 || ([((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 1) || (![((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 2));
	if(notifsEnabled && isEnabled && pos){
		if(textcolor == 1){		
			self.primaryLabel.textColor = [UIColor whiteColor];
		}
		if(textcolor == 2){		
			self.primaryLabel.textColor = [UIColor blackColor];
		}
	}
}

-(void)setPrimarySubtitleText:(NSString *)arg1 {			
	%orig;

	//Banner vs Notification check taken from Nepeta's Notifica (https://github.com/Baw-Appie/Notifica/blob/master/Tweak/Tweak.xm)
	BOOL pos = (location == 0 || ([((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 1) || (![((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 2));
	if(notifsEnabled && isEnabled && pos){
		if(textcolor == 1){		
			self.primarySubtitleLabel.textColor = [UIColor whiteColor];
		}
		if(textcolor == 2){		
			self.primarySubtitleLabel.textColor = [UIColor blackColor];
		}
	}
}

-(void)setSecondaryText:(NSString *)arg1 {			
	%orig;

	//Banner vs Notification check taken from Nepeta's Notifica (https://github.com/Baw-Appie/Notifica/blob/master/Tweak/Tweak.xm)
	BOOL pos = (location == 0 || ([((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 1) || (![((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 2));
	if(notifsEnabled && isEnabled && pos){
		if(textcolor == 1){		
			self.secondaryLabel.textColor = [UIColor whiteColor];
		}
		if(textcolor == 2){		
			self.secondaryLabel.textColor = [UIColor blackColor];
		}
	}
}
											
-(void)_updateStyleForSummaryLabel:(id)arg1 withStyle:(long long)arg2 {		
	//Banner vs Notification check taken from Nepeta's Notifica (https://github.com/Baw-Appie/Notifica/blob/master/Tweak/Tweak.xm)
	BOOL pos = (location == 0 || ([((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 1) || (![((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 2));
	if(notifsEnabled && isEnabled && pos){
		if(textcolor == 1){		
			self.summaryLabel.textColor = [UIColor whiteColor];
		}
		if(textcolor == 2){		
			self.summaryLabel.textColor = [UIColor blackColor];
		}
	}
	else{
		%orig;
	}
}
%end


//hides the app name and delivery time on notifications and color header content 
%hook PLPlatterHeaderContentView
-(void)setTitle:(NSString *)arg1 {												
	%orig;

	if(self.superview && self.superview.superview) {
		//Banner vs Notification check taken from Nepeta's Notifica (https://github.com/Baw-Appie/Notifica/blob/master/Tweak/Tweak.xm)
		//prevents instant safemode when longlookview is animated (pull down animation)
   		if (![[self _viewControllerForAncestor] respondsToSelector:@selector(delegate)]) %orig;

		else{
			BOOL pos = (location == 0 || ([((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 1) || (![((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 2));
			if(notifsEnabled && isEnabled && pos) {
				if(hideAppName) {
					[self.titleLabel setHidden:YES];
				}

				//neat fix from https://gist.github.com/jakeajames/9c8890b20b69af585e66b30a501e6084
				if(textcolor == 1){
					if(MSHookIvar<UILabel *>(self, "_titleLabel").layer.filters.count) MSHookIvar<UILabel *>(self, "_titleLabel").layer.filters = nil;
					MSHookIvar<UILabel *>(self, "_titleLabel").textColor = [UIColor colorWithWhite:1 alpha:0.8];
				}

				if(textcolor == 2){
					if(MSHookIvar<UILabel *>(self, "_titleLabel").layer.filters.count) MSHookIvar<UILabel *>(self, "_titleLabel").layer.filters = nil;
					MSHookIvar<UILabel *>(self, "_titleLabel").textColor = [UIColor colorWithWhite:0 alpha:0.8];
				}
			}
		}
	}
}

-(void)_configureDateLabel{												
	%orig;

	if(self.superview && self.superview.superview) {
		//Banner vs Notification check taken from Nepeta's Notifica (https://github.com/Baw-Appie/Notifica/blob/master/Tweak/Tweak.xm)
		//prevents instant safemode when longlookview is animated (pull down animation)
   		if (![[self _viewControllerForAncestor] respondsToSelector:@selector(delegate)]) %orig;

		else{
			BOOL pos = (location == 0 || ([((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 1) || (![((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 2));
			if(notifsEnabled && isEnabled && pos) {
				if(hideTimeLabel) {
					[self.dateLabel setHidden:YES];
				}

				//neat fix from https://gist.github.com/jakeajames/9c8890b20b69af585e66b30a501e6084
				if(textcolor == 1){
					if(MSHookIvar<UILabel *>(self, "_dateLabel").layer.filters.count) MSHookIvar<UILabel *>(self, "_dateLabel").layer.filters = nil;
					MSHookIvar<UILabel *>(self, "_dateLabel").textColor = [UIColor colorWithWhite:1 alpha:0.8];
				}

				if(textcolor == 2){
					if(MSHookIvar<UILabel *>(self, "_dateLabel").layer.filters.count) MSHookIvar<UILabel *>(self, "_dateLabel").layer.filters = nil;
					MSHookIvar<UILabel *>(self, "_dateLabel").textColor = [UIColor colorWithWhite:0 alpha:0.8];
				}
			}
		}
	}
}
%end


//colors and hides "no older notification text"
%hook NCNotificationListSectionRevealHintView
-(void)adjustForLegibilitySettingsChange:(id)arg1 {
	%orig;

	if(notifsEnabled && isEnabled && location != 1){
		if(textcolor == 1){
			self.legibilitySettings.primaryColor = [UIColor whiteColor];
			self.revealHintTitle.textColor = [UIColor whiteColor];
		}
		if(textcolor == 2){
			self.legibilitySettings.primaryColor = [UIColor blackColor];
			self.revealHintTitle.textColor = [UIColor blackColor];
		}
		if(hideNONT){
			[self.revealHintTitle setHidden:YES];
		}
	}
}
%end


//hides the charging indicator on LS (without full fade/flash)
%hook _CSSingleBatteryChargingView					
-(void)_layoutBattery{
	%orig;

	if(notifsEnabled && isEnabled && hideChargingIndicator){
		MSHookIvar<UIView *>(self, "_batteryContainerView").hidden = YES;
		MSHookIvar<UIView *>(self, "_batteryBlurView").hidden = YES;
		MSHookIvar<UIView *>(self, "_batteryFillView").hidden = YES;
		MSHookIvar<UILabel *>(self, "_chargePercentLabel").hidden = YES;
	}

	else{
		MSHookIvar<UIView *>(self, "_batteryContainerView").hidden = NO;
		MSHookIvar<UIView *>(self, "_batteryBlurView").hidden = NO;
		MSHookIvar<UIView *>(self, "_batteryFillView").hidden = NO;
		MSHookIvar<UILabel *>(self, "_chargePercentLabel").hidden = NO;
	}
}
%end

#pragma mark Widgets

// Transparent Widgets
%hook WGWidgetPlatterView
//Body
-(void)_configureBackgroundMaterialViewIfNecessary{
	%orig;

	if(widgetsEnabled && isEnabled){
		MSHookIvar<MTMaterialView *>(self, "_backgroundView").alpha = widgetTransparency/100;
	}
}

//Header
-(void)_configureHeaderViewsIfNecessary{
	%orig;

	if(widgetsEnabled && isEnabled){
		MSHookIvar<MTMaterialView *>(self, "_headerBackgroundView").alpha = widgetTransparency/100;
	}
}
%end


//Color for widget contents (iOS 13 only)			
%hook WGWidgetHostingViewController
-(void)viewDidLoad{
	%orig;

	if(widgetsEnabled && isEnabled){
		if(@available(iOS 13, *)) {
			if(contentcolor == 0){
				[self setOverrideUserInterfaceStyle:UIUserInterfaceStyleUnspecified];
			}
			if(contentcolor == 1){
				[self setOverrideUserInterfaceStyle:UIUserInterfaceStyleDark];
			}
			if(contentcolor == 2){
				[self setOverrideUserInterfaceStyle:UIUserInterfaceStyleLight];
			}
        }
	}
}
%end


//hide background of "edit" button
%hook WGShortLookStyleButton
-(void)_configureBackgroundViewIfNecessary{
	%orig;

	if(widgetsEnabled && isEnabled){
		MSHookIvar<MTMaterialView *>(self, "_backgroundView").alpha = widgetTransparency/100;
	}
}
%end


//hides "information provided by" text 
%hook WGWidgetAttributionView
-(void)_configureAttributedString{
	%orig;

	if(widgetsEnabled && isEnabled && hideFooterText){
		[self setHidden:YES];
	}
}
%end


%hook WGPlatterHeaderContentView
//hide widget title
-(void)_configureTitleLabel:(id)arg1 {
	%orig;

	if(widgetsEnabled && isEnabled && hideWidgetLabel){
		[arg1 setHidden:YES];
	}
}

//hide widget icon
-(void)_configureIconButtonsForIcons:(id)arg1 {
	%orig;

	if(widgetsEnabled && isEnabled && hideWidgetIcon){
		[self.iconButtons.firstObject setHidden:YES];
	}
}
%end

//end of iOS 13 group

%end



%group iOS12

#pragma mark Notifications

//hides the contrasty background cell along with multiple icons showing up on LS when grouped; remains normal when ungrouped
//and yes, i know it's kinda jank, but modiying properties didn't yield favorable results
%hook NCNotificationShortLookView
-(void)_configureBackgroundViewIfNecessary{										
	%orig;

	//Banner vs Notification check taken from Nepeta's Notifica (https://github.com/Baw-Appie/Notifica/blob/master/Tweak/Tweak.xm)
	//prevents instant safemode when longlookview is animated (pull down animation)
   	if (![[self _viewControllerForAncestor] respondsToSelector:@selector(delegate)]) %orig;

	else{
		BOOL pos = (location == 0 || ([((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 1) || (![((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 2));
		if(notifsEnabled && isEnabled && pos) {
			for(UIView *view in self.subviews){
				if ([view isMemberOfClass:%c(MTMaterialView)]) {
					view.backgroundColor = nil;
					view.alpha = notifTransparency/100;
					MSHookIvar<_MTBackdropView *>(view, "_backdropView").alpha = notifTransparency/100;
				}
			}
		}
	}
}
%end


//hides sub cells 
%hook NCNotificationViewControllerView
-(void)_configureStackedPlatters{
    %orig;

	if(notifsEnabled && isEnabled && location != 1){
		for(PLPlatterView *background in MSHookIvar<NSArray *>(self, "_stackedPlatters")){
			[background setHidden:YES];
		}
	}
}   
%end	


%hook NCNotificationListCellActionButton
//sets transparency for background of sections in sliderview of notification banners on lockscreen 
-(void)_layoutBackgroundView{
	%orig;

	if(notifsEnabled && isEnabled && location != 1){
		self.backgroundView.alpha = notifTransparency / 100;
	}
}

-(void)_layoutBackgroundOverlayView{
	%orig;

	if(notifsEnabled && isEnabled && location != 1){
		self.backgroundOverlayView.alpha = notifTransparency / 100;
	}
}

//sets text color for labels in sections in sliderview of notification banners on lockscreen 
-(void)_layoutTitleLabel{
	%orig;

	if(notifsEnabled && isEnabled && location != 1){
		if(textcolor == 1){
			if(MSHookIvar<UILabel *>(self, "_titleLabel").layer.filters.count) MSHookIvar<UILabel *>(self, "_titleLabel").layer.filters = nil;
			MSHookIvar<UILabel *>(self, "_titleLabel").textColor = [UIColor colorWithWhite:1 alpha:0.8];
		}
		if(textcolor == 2){
			if(MSHookIvar<UILabel *>(self, "_titleLabel").layer.filters.count) MSHookIvar<UILabel *>(self, "_titleLabel").layer.filters = nil;
			MSHookIvar<UILabel *>(self, "_titleLabel").textColor = [UIColor colorWithWhite:0 alpha:0.8];
		}
	}
}
%end


//hides "Notification Center" text to prevent bug w axon where it would appear and overlap notifications
%hook NCNotificationListSectionHeaderView
-(void)didMoveToWindow{									
	%orig;

	//Banner vs Notification check taken from Nepeta's Notifica (https://github.com/Baw-Appie/Notifica/blob/master/Tweak/Tweak.xm)
	if (((notifsEnabled && isEnabled) && (axonInstalled) && (![((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 2)) || ((location == 0) && (axonInstalled))) {
		self.hidden = YES;
	}	

	if (((!notifsEnabled && isEnabled) || (!axonInstalled)) || ([((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 1)){
		self.hidden = NO;
	}
}
%end


//colors stack header titles and Notification center text
%hook NCNotificationListHeaderTitleView
-(void)adjustForLegibilitySettingsChange:(id)arg1 {	
	%orig;

	if(notifsEnabled && isEnabled && location != 1){
		_UILegibilitySettings *customColor = [[_UILegibilitySettings alloc] initWithStyle:1];

		if(textcolor == 1){
			customColor.primaryColor = [UIColor whiteColor];
			[self setLegibilitySettings:customColor];
			self.titleLabel.legibilitySettings = customColor;
			self.titleLabel.textColor = [UIColor whiteColor];
		}
		if(textcolor == 2){
			customColor.primaryColor = [UIColor blackColor];
			[self setLegibilitySettings:customColor];
			self.titleLabel.legibilitySettings = customColor;
			self.titleLabel.textColor = [UIColor blackColor];
		}
	}
}
%end


%hook NCToggleControl
//sets transparency of background of drop down arrow and x above expanded stackview on LS
-(void)_configureOverlayMaterialViewIfNecessary{
	%orig;

	if(notifsEnabled && isEnabled && location != 1){
		self.overlayMaterialView.alpha = notifTransparency/100;
	}
}

-(void)_configureBackgroundMaterialViewIfNecessary{
	%orig;

	if(notifsEnabled && isEnabled && location != 1){
		self.backgroundMaterialView.alpha = notifTransparency/100;
	}
}

//text color of drop down label and glyphs in expanded stacked view
-(void)setExpanded:(BOOL)arg1 {
    %orig;

	if(notifsEnabled && isEnabled && location != 1){
		if(textcolor == 1){
			if(MSHookIvar<UILabel *>(self, "_titleLabel").layer.filters.count) MSHookIvar<UILabel *>(self, "_titleLabel").layer.filters = nil;
			MSHookIvar<UILabel *>(self, "_titleLabel").textColor = [UIColor colorWithWhite:1 alpha:0.8];
				
			if(MSHookIvar<UIImageView*>(self, "_glyphView").layer.filters.count) MSHookIvar<UIImageView*>(self, "_glyphView").layer.filters = nil;
			MSHookIvar<UIImageView*>(self, "_glyphView").tintColor = [UIColor colorWithWhite:1 alpha:0.8];
		}
		if(textcolor == 2){
			if(MSHookIvar<UILabel *>(self, "_titleLabel").layer.filters.count) MSHookIvar<UILabel *>(self, "_titleLabel").layer.filters = nil;
			MSHookIvar<UILabel *>(self, "_titleLabel").textColor = [UIColor colorWithWhite:0 alpha:0.8];
				
			if(MSHookIvar<UIImageView*>(self, "_glyphView").layer.filters.count) MSHookIvar<UIImageView*>(self, "_glyphView").layer.filters = nil;
			MSHookIvar<UIImageView*>(self, "_glyphView").tintColor = [UIColor colorWithWhite:0 alpha:0.8];
		}
	}
}
%end


//changes text color for content 
%hook NCNotificationContentView
-(void)setPrimaryText:(NSString *)arg1 {							
	%orig;

	//Banner vs Notification check taken from Nepeta's Notifica (https://github.com/Baw-Appie/Notifica/blob/master/Tweak/Tweak.xm)
	BOOL pos = (location == 0 || ([((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 1) || (![((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 2));
	if(notifsEnabled && isEnabled && pos) {
		if(textcolor == 1){		
			self.primaryLabel.textColor = [UIColor whiteColor];
		}
		if(textcolor == 2){		
			self.primaryLabel.textColor = [UIColor blackColor];
		}
	}
}

-(void)setPrimarySubtitleText:(NSString *)arg1 {								
	%orig;

	//Banner vs Notification check taken from Nepeta's Notifica (https://github.com/Baw-Appie/Notifica/blob/master/Tweak/Tweak.xm)
	BOOL pos = (location == 0 || ([((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 1) || (![((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 2));
	if(notifsEnabled && isEnabled && pos) {
		if(textcolor == 1){		
			self.primarySubtitleLabel.textColor = [UIColor whiteColor];
		}
		if(textcolor == 2){		
			self.primarySubtitleLabel.textColor = [UIColor blackColor];
		}
	}
}

-(void)setSecondaryText:(NSString *)arg1 {								
	%orig;

	//Banner vs Notification check taken from Nepeta's Notifica (https://github.com/Baw-Appie/Notifica/blob/master/Tweak/Tweak.xm)
	BOOL pos = (location == 0 || ([((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 1) || (![((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 2));
	if(notifsEnabled && isEnabled && pos) {
		if(textcolor == 1){		
			self.secondaryLabel.textColor = [UIColor whiteColor];
		}
		if(textcolor == 2){		
			self.secondaryLabel.textColor = [UIColor blackColor];
		}
	}
}
											
-(void)_updateStyleForSummaryLabel:(id)arg1 withStyle:(long long)arg2 {		
	//Banner vs Notification check taken from Nepeta's Notifica (https://github.com/Baw-Appie/Notifica/blob/master/Tweak/Tweak.xm)
	BOOL pos = (location == 0 || ([((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 1) || (![((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 2));
	if(notifsEnabled && isEnabled && pos) {
		if(textcolor == 1){		
			self.summaryLabel.textColor = [UIColor whiteColor];
		}
		if(textcolor == 2){		
			self.summaryLabel.textColor = [UIColor blackColor];
		}
	}
}
%end


//hides the app name and delivery time on notifications and color header content 
%hook PLPlatterHeaderContentView
-(void)setTitle:(NSString *)arg1 {						
	%orig;

	if(self.superview && self.superview.superview) {
		//Banner vs Notification check taken from Nepeta's Notifica (https://github.com/Baw-Appie/Notifica/blob/master/Tweak/Tweak.xm)
		//prevents instant safemode when longlookview is animated (pull down animation)
   		if (![[self _viewControllerForAncestor] respondsToSelector:@selector(delegate)]) %orig;

		else{
			BOOL pos = (location == 0 || ([((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 1) || (![((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 2));
			if(notifsEnabled && isEnabled && pos) {
				if(hideAppName) {
					[self.titleLabel setHidden:YES];
				}

				//neat fix from https://gist.github.com/jakeajames/9c8890b20b69af585e66b30a501e6084
				if(textcolor == 1){
					if(MSHookIvar<UILabel *>(self, "_titleLabel").layer.filters.count) MSHookIvar<UILabel *>(self, "_titleLabel").layer.filters = nil;
					MSHookIvar<UILabel *>(self, "_titleLabel").textColor = [UIColor colorWithWhite:1 alpha:0.8];
				}

				if(textcolor == 2){
					if(MSHookIvar<UILabel *>(self, "_titleLabel").layer.filters.count) MSHookIvar<UILabel *>(self, "_titleLabel").layer.filters = nil;
					MSHookIvar<UILabel *>(self, "_titleLabel").textColor = [UIColor colorWithWhite:0 alpha:0.8];
				}
			}
			else{
				%orig;
			}
		}
	}
}

-(void)_configureDateLabel{										 
	%orig;

	if(self.superview && self.superview.superview) {
		//Banner vs Notification check taken from Nepeta's Notifica (https://github.com/Baw-Appie/Notifica/blob/master/Tweak/Tweak.xm)
		//prevents instant safemode when longlookview is animated (pull down animation)
   		if (![[self _viewControllerForAncestor] respondsToSelector:@selector(delegate)]) %orig;

		else{
			BOOL pos = (location == 0 || ([((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 1) || (![((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 2));
			if(notifsEnabled && isEnabled && pos) {
				if(hideTimeLabel) {
					[self.dateLabel setHidden:YES];
				}

				//neat fix from https://gist.github.com/jakeajames/9c8890b20b69af585e66b30a501e6084
				if(textcolor == 1){
					if(MSHookIvar<UILabel *>(self, "_dateLabel").layer.filters.count) MSHookIvar<UILabel *>(self, "_dateLabel").layer.filters = nil;
					MSHookIvar<UILabel *>(self, "_dateLabel").textColor = [UIColor colorWithWhite:1 alpha:0.8];
				}

				if(textcolor == 2){
					if(MSHookIvar<UILabel *>(self, "_dateLabel").layer.filters.count) MSHookIvar<UILabel *>(self, "_dateLabel").layer.filters = nil;
					MSHookIvar<UILabel *>(self, "_dateLabel").textColor = [UIColor colorWithWhite:0 alpha:0.8];
				}
			}
			else{
				%orig;
			}
		}
	}
}
%end


//colors and hides "no older notification text"
%hook NCNotificationListSectionRevealHintView
-(void)adjustForLegibilitySettingsChange:(id)arg1 {						
	%orig;

	if(notifsEnabled && isEnabled && location != 1){
		if(textcolor == 1){
			self.legibilitySettings.primaryColor = [UIColor whiteColor];
			self.revealHintTitle.textColor = [UIColor whiteColor];
		}
		if(textcolor == 2){
			self.legibilitySettings.primaryColor = [UIColor blackColor];
			self.revealHintTitle.textColor = [UIColor blackColor];
		}
		if(hideNONT){
			[self.revealHintTitle setHidden:YES];
		}
	}
}
%end


//hides the charging indicator on LS (without full fade/flash)
%hook _SBLockScreenSingleBatteryChargingView					
-(void)_layoutBattery{
	%orig;

	if(notifsEnabled && isEnabled && hideChargingIndicator){
		MSHookIvar<UIView *>(self, "_batteryContainerView").hidden = YES;
		MSHookIvar<UIView *>(self, "_batteryBlurView").hidden = YES;
		MSHookIvar<UIView *>(self, "_batteryFillView").hidden = YES;
		MSHookIvar<UILabel *>(self, "_chargePercentLabel").hidden = YES;
	}

	else{
		MSHookIvar<UIView *>(self, "_batteryContainerView").hidden = NO;
		MSHookIvar<UIView *>(self, "_batteryBlurView").hidden = NO;
		MSHookIvar<UIView *>(self, "_batteryFillView").hidden = NO;
		MSHookIvar<UILabel *>(self, "_chargePercentLabel").hidden = NO;
	}
}
%end

#pragma mark Widgets

// Transparent Widgets
%hook WGWidgetPlatterView
//Body
-(void)_configureMainOverlayViewIfNecessary{
	%orig;

	if(widgetsEnabled && isEnabled){
		MSHookIvar<MTMaterialView *>(self, "_mainOverlayView").alpha = widgetTransparency/100;
	}
}

-(void)_configureBackgroundViewIfNecessary{
	%orig;

	if(widgetsEnabled && isEnabled){
		MSHookIvar<UIView *>(self, "_backgroundView").alpha = widgetTransparency/100;
	}
}

//Header
-(void)_configureHeaderOverlayViewIfNecessary{
	%orig;

	if(widgetsEnabled && isEnabled){
		MSHookIvar<UIView *>(self, "_headerOverlayView").alpha = widgetTransparency/100;
	}
}
%end


//hide background of "edit" button
%hook WGShortLookStyleButton
-(void)_configureBackgroundViewIfNecessary{
	%orig;

	if(widgetsEnabled && isEnabled){
		MSHookIvar<MTMaterialView *>(self, "_backgroundView").alpha = widgetTransparency/100;
	}
}
%end


//hides "information provided by" text 
%hook WGWidgetAttributionView
-(void)_configureAttributedString{
	%orig;

	if(widgetsEnabled && isEnabled && hideFooterText){
		[self setHidden:YES];
	}
}
%end


%hook PLPlatterHeaderContentView
//hide widget title
-(void)_configureTitleLabel:(id)arg1 {
	%orig;

	if(widgetsEnabled && isEnabled && [self.superview.superview isMemberOfClass:%c(WGWidgetPlatterView)] && hideWidgetLabel){
		[arg1 setHidden:YES];
	}
}

//hide widget icon
-(void)_configureIconButtonsForIcons:(id)arg1 {
	%orig;
	
	if(widgetsEnabled && isEnabled && [self.superview.superview isMemberOfClass:%c(WGWidgetPlatterView)] && hideWidgetIcon){
		[self.iconButtons.firstObject setHidden:YES];
	}
}
%end

//end of iOS 12 group

%end



static void loadPrefs() {
  NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/me.lightmann.aeaeaprefs.plist"];

  if(prefs){
    isEnabled = ( [prefs objectForKey:@"isEnabled"] ? [[prefs objectForKey:@"isEnabled"] boolValue] : YES );

	//Notifs
	notifsEnabled = ( [prefs objectForKey:@"notifsEnabled"] ? [[prefs objectForKey:@"notifsEnabled"] boolValue] : YES );
	location = ( [prefs valueForKey:@"location"] ? [[prefs valueForKey:@"location"] integerValue] : 0 );
	notifTransparency = ( [prefs valueForKey:@"notifTransparency"] ? [[prefs valueForKey:@"notifTransparency"] floatValue] : 0 );
	textcolor = ( [prefs valueForKey:@"textcolor"] ? [[prefs valueForKey:@"textcolor"] integerValue] : 0 );
	hideAppName = ( [prefs objectForKey:@"hideAppName"] ? [[prefs objectForKey:@"hideAppName"] boolValue] : NO );
	hideTimeLabel = ( [prefs objectForKey:@"hideTimeLabel"] ? [[prefs objectForKey:@"hideTimeLabel"] boolValue] : NO );
	hideNONT = ( [prefs objectForKey:@"hideNONT"] ? [[prefs objectForKey:@"hideNONT"] boolValue] : YES );
	hideChargingIndicator = ( [prefs objectForKey:@"hideChargingIndicator"] ? [[prefs objectForKey:@"hideChargingIndicator"] boolValue] : NO );

	//Widgets
	widgetsEnabled = ( [prefs objectForKey:@"widgetsEnabled"] ? [[prefs objectForKey:@"widgetsEnabled"] boolValue] : YES );
	widgetTransparency = ( [prefs valueForKey:@"widgetTransparency"] ? [[prefs valueForKey:@"widgetTransparency"] floatValue] : 0 );
	contentcolor = ( [prefs valueForKey:@"contentcolor"] ? [[prefs valueForKey:@"contentcolor"] integerValue] : 0 );
	hideFooterText = ( [prefs objectForKey:@"hideFooterText"] ? [[prefs objectForKey:@"hideFooterText"] boolValue] : YES );
	hideWidgetIcon = ( [prefs objectForKey:@"hideWidgetIcon"] ? [[prefs objectForKey:@"hideWidgetIcon"] boolValue] : NO );
	hideWidgetLabel = ( [prefs objectForKey:@"hideWidgetLabel"] ? [[prefs objectForKey:@"hideWidgetLabel"] boolValue] : NO );
  }
}

static void initPrefs() {
  // Copy the default preferences file when the actual preference file doesn't exist
  NSString *path = @"/User/Library/Preferences/me.lightmann.aeaeaprefs.plist";
  NSString *pathDefault = @"/Library/PreferenceBundles/AeaeaPrefs.bundle/defaults.plist";
  NSFileManager *fileManager = [NSFileManager defaultManager];
  if(![fileManager fileExistsAtPath:path]) {
    [fileManager copyItemAtPath:pathDefault toPath:path error:nil];
  }
}

%ctor {
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("me.lightmann.aeaeaprefs-updated"), NULL, CFNotificationSuspensionBehaviorCoalesce);
	initPrefs();
	loadPrefs();

	//check if axon is installed
	axonInstalled = [[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/dpkg/info/me.nepeta.axon.list"];

	if(kCFCoreFoundationVersionNumber < 1600) {
        %init(iOS12);
    } 
    else {
        %init(iOS13);
    }
}
