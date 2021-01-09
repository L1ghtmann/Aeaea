#import "Headers.h"

//Lightmann
//Made during COVID-19 
//Aeaea

#pragma mark iOS12

%group Notifications_12

%hook NCNotificationShortLookView
//hides the contrasty background cell along with multiple icons showing up on LS when grouped and remains normal when ungrouped
//and yes, I know it's kinda jank, but modiying properties didn't yield favorable results
-(void)_configureBackgroundViewIfNecessary{										
	%orig;

	//Banner vs Notification check taken from Nepeta's Notifica (https://github.com/Baw-Appie/Notifica/blob/master/Tweak/Tweak.xm)
	//prevents instant safemode when longlookview is animated (pull down animation)
   	if (![[self _viewControllerForAncestor] respondsToSelector:@selector(delegate)]) %orig;

	else{
		BOOL pos = (location == 0 || ([((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 1) || (![((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 2));
		if(pos){
			for(UIView *view in self.subviews){
				if ([view isMemberOfClass:%c(MTMaterialView)]){
					[view setBackgroundColor:nil];
					[view setAlpha:notifTransparency/100];
					[MSHookIvar<_MTBackdropView *>(view, "_backdropView") setAlpha:notifTransparency/100];
				}
			}
		}
	}
}

//auto slim notif -- adjust content view 
-(void)_layoutNotificationContentView{	
	%orig;
	
   	if (![[self _viewControllerForAncestor] respondsToSelector:@selector(delegate)]) %orig;

	else{
		BOOL pos = (location == 0 || ([((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 1) || (![((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 2));
		if(pos && hideAppIcon && hideAppName && hideTimeLabel){
			UIView *header = MSHookIvar<UIView*>(self, "_headerContentView");
			
			[self.customContentView.topAnchor constraintEqualToAnchor:self.superview.topAnchor constant:-2].active = YES;
			[self.customContentView.heightAnchor constraintEqualToConstant:self.frame.size.height].active = YES;
			[self.customContentView.widthAnchor constraintEqualToConstant:header.frame.size.width].active = YES;
			[self.customContentView setTranslatesAutoresizingMaskIntoConstraints:NO];

			[header setFrame:CGRectZero];
		}
	}
}

//auto slim notif -- adjust shortlookview height
-(void)setFrame:(CGRect)frame{
   	if (![[self _viewControllerForAncestor] respondsToSelector:@selector(delegate)]) %orig;

	else{
		BOOL pos = (location == 0 || ([((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 1) || (![((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 2));
		if(pos && hideAppIcon && hideAppName && hideTimeLabel){
			%orig(CGRectMake(frame.origin.x,frame.origin.y,frame.size.width,frame.size.height-20));
		}
		else{
			%orig;
		}
	}
}
%end


//hides sub cells 
%hook NCNotificationViewControllerView
-(void)_configureStackedPlatters{
    %orig;

	if(location != 1){
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

	if(location != 1){
		[self.backgroundView setAlpha:notifTransparency/100];
	}
}

-(void)_layoutBackgroundOverlayView{
	%orig;

	if(location != 1){
		[self.backgroundOverlayView setAlpha:notifTransparency/100];
	}
}

//sets text color for labels in sections in sliderview of notification banners on lockscreen 
-(void)_layoutTitleLabel{
	%orig;

	//if simply changing color doesn't work, check for and remove filters -- https://gist.github.com/jakeajames/9c8890b20b69af585e66b30a501e6084
	if(location != 1 && textcolor < 2){
		if(MSHookIvar<UILabel *>(self, "_titleLabel").layer.filters.count) [MSHookIvar<UILabel *>(self, "_titleLabel").layer setFilters:nil];
		[MSHookIvar<UILabel *>(self, "_titleLabel") setTextColor:[UIColor colorWithWhite:textcolor alpha:0.8]];
	}
}
%end


//hides "Notification Center" text to prevent bug w axon where it would appear and overlap notifications
%hook NCNotificationListSectionHeaderView
-(void)didMoveToWindow{									
	%orig;

	if ((axonInstalled && ![((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 2) || (location == 0 && axonInstalled)){
		[self setHidden:YES];
	}	

	else{
		[self setHidden:NO];
	}
}
%end


//colors stack header titles and Notification center text
%hook NCNotificationListHeaderTitleView
-(void)adjustForLegibilitySettingsChange:(id)arg1{	
	%orig;

	if(location != 1 && textcolor < 2){
		_UILegibilitySettings *customColor = [[_UILegibilitySettings alloc] initWithStyle:1];

		[customColor setPrimaryColor:[UIColor colorWithWhite:textcolor alpha:1]];
		[self setLegibilitySettings:customColor];
		[self.titleLabel setLegibilitySettings:customColor];
		[self.titleLabel setTextColor:[UIColor colorWithWhite:textcolor alpha:1]];
	}
}
%end


%hook NCToggleControl
//sets transparency of background of drop down arrow and x above expanded stackview on LS
-(void)_configureOverlayMaterialViewIfNecessary{
	%orig;

	if(location != 1){
		[self.overlayMaterialView setAlpha:notifTransparency/100];
	}
}

-(void)_configureBackgroundMaterialViewIfNecessary{
	%orig;

	if(location != 1){
		[self.backgroundMaterialView setAlpha:notifTransparency/100];
	}
}

//text color of drop down label and glyphs in expanded stacked view
-(void)setExpanded:(BOOL)arg1{
    %orig;

	if(location != 1 && textcolor < 2){
		if(MSHookIvar<UILabel *>(self, "_titleLabel").layer.filters.count) [MSHookIvar<UILabel *>(self, "_titleLabel").layer setFilters:nil];
		[MSHookIvar<UILabel *>(self, "_titleLabel") setTextColor:[UIColor colorWithWhite:textcolor alpha:0.8]];
				
		if(MSHookIvar<UIImageView*>(self, "_glyphView").layer.filters.count) [MSHookIvar<UIImageView*>(self, "_glyphView").layer setFilters:nil];
		[MSHookIvar<UIImageView*>(self, "_glyphView") setTintColor:[UIColor colorWithWhite:textcolor alpha:0.8]];
	}
}
%end


//changes text color for content 
%hook NCNotificationContentView
-(void)setPrimaryText:(NSString *)arg1{							
	%orig;

	BOOL pos = (location == 0 || ([((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 1) || (![((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 2));
	if(pos && textcolor < 2){
		[self.primaryLabel setTextColor:[UIColor colorWithWhite:textcolor alpha:1]];
	}
}

-(void)setPrimarySubtitleText:(NSString *)arg1{								
	%orig;

	BOOL pos = (location == 0 || ([((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 1) || (![((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 2));
	if(pos && textcolor < 2){
		[self.primarySubtitleLabel setTextColor:[UIColor colorWithWhite:textcolor alpha:1]];
	}
}

-(void)setSecondaryText:(NSString *)arg1{								
	%orig;

	BOOL pos = (location == 0 || ([((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 1) || (![((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 2));
	if(pos && textcolor < 2){
		[self.secondaryLabel setTextColor:[UIColor colorWithWhite:textcolor alpha:1]];
	}
}
											
-(void)_updateStyleForSummaryLabel:(id)arg1 withStyle:(long long)arg2{		
	BOOL pos = (location == 0 || ([((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 1) || (![((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 2));
	if(pos && textcolor < 2){
		[self.summaryLabel setTextColor:[UIColor colorWithWhite:textcolor alpha:1]];
	}
}
%end


//hides the app name, delivery time, app icon, and colors header content 
%hook PLPlatterHeaderContentView
-(void)setTitle:(NSString *)arg1{						
	%orig;

	if(self.superview && self.superview.superview){
   		if (![[self _viewControllerForAncestor] respondsToSelector:@selector(delegate)]) %orig;

		else{
			BOOL pos = (location == 0 || ([((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 1) || (![((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 2));
			if(pos){
				if(hideAppName){
					[self.titleLabel setHidden:YES];
				}

				if(textcolor < 2){
					if(MSHookIvar<UILabel *>(self, "_titleLabel").layer.filters.count) [MSHookIvar<UILabel *>(self, "_titleLabel").layer setFilters:nil];
					[MSHookIvar<UILabel *>(self, "_titleLabel") setTextColor:[UIColor colorWithWhite:textcolor alpha:0.8]];
				}
			}
		}
	}
}

-(void)_configureDateLabel{										 
	%orig;

	if(self.superview && self.superview.superview){
   		if (![[self _viewControllerForAncestor] respondsToSelector:@selector(delegate)]) %orig;

		else{
			BOOL pos = (location == 0 || ([((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 1) || (![((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 2));
			if(pos){
				if(hideTimeLabel){
					[self.dateLabel setHidden:YES];
				}

				if(textcolor < 2){
					if(MSHookIvar<UILabel *>(self, "_dateLabel").layer.filters.count) [MSHookIvar<UILabel *>(self, "_dateLabel").layer setFilters:nil];
					[MSHookIvar<UILabel *>(self, "_dateLabel") setTextColor:[UIColor colorWithWhite:textcolor alpha:0.8]];
				}
			}
		}
	}
}

-(void)_configureIconButtonsForIcons:(id)arg1{
	%orig;

	if(self.superview && self.superview.superview){
   		if (![[self _viewControllerForAncestor] respondsToSelector:@selector(delegate)]) %orig;

		else{
			BOOL pos = (location == 0 || ([((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 1) || (![((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 2));
			if(pos && hideAppIcon){
				for(UIView *icon in self.iconButtons){
					[icon setHidden:YES];
				}
			}
		}
	}
}
%end


//colors and hides "no older notification text"
%hook NCNotificationListSectionRevealHintView
-(void)adjustForLegibilitySettingsChange:(id)arg1{						
	%orig;

	if(location != 1){
		if(hideNONT){
			[self.revealHintTitle setHidden:YES];
		}

		if(textcolor < 2){
			[self.legibilitySettings setPrimaryColor:[UIColor colorWithWhite:textcolor alpha:1]];
			[self.revealHintTitle setTextColor:[UIColor colorWithWhite:textcolor alpha:1]];
		}
	}
}
%end


//hides the charging indicator on LS (without full fade/flash)
%hook _SBLockScreenSingleBatteryChargingView					
-(void)_layoutBattery{
	%orig;

	if(hideChargingIndicator){
		[MSHookIvar<UIView *>(self, "_batteryContainerView") setHidden:YES];
		[MSHookIvar<UIView *>(self, "_batteryBlurView") setHidden:YES];
		[MSHookIvar<UIView *>(self, "_batteryFillView") setHidden:YES];
		[MSHookIvar<UILabel *>(self, "_chargePercentLabel") setHidden:YES];
	}

	else{
		[MSHookIvar<UIView *>(self, "_batteryContainerView") setHidden:NO];
		[MSHookIvar<UIView *>(self, "_batteryBlurView") setHidden:NO];
		[MSHookIvar<UIView *>(self, "_batteryFillView") setHidden:NO];
		[MSHookIvar<UILabel *>(self, "_chargePercentLabel") setHidden:NO];
	}
}
%end

//end of notifications_12

%end


%group Widgets_12

%hook WGWidgetPlatterView
//transparency for body
-(void)_configureMainOverlayViewIfNecessary{
	%orig;

	MTMaterialView *mainOverlay = MSHookIvar<MTMaterialView *>(self, "_mainOverlayView");
	[mainOverlay setAlpha:widgetTransparency/100];

	//auto slim widget -- hide weird overlay  
	if(hideWidgetIcon && hideWidgetLabel){
		[mainOverlay setHidden:YES];
	}
}

-(void)_configureBackgroundViewIfNecessary{
	%orig;

	UIView *background = MSHookIvar<UIView *>(self, "_backgroundView");
	[background setAlpha:widgetTransparency/100];

	//auto slim widget -- adjust height of background 
	if(hideWidgetIcon && hideWidgetLabel){
		CGRect frame = background.frame;
		frame.size.height = frame.size.height-20; //changes Y for some reason :/
		frame.origin.y = frame.origin.y+7; //adjust accordingly 
		[background setFrame:frame];
	}
}

//transparency for header
-(void)_configureHeaderOverlayViewIfNecessary{
	%orig;

	UIView *headerOverlay = MSHookIvar<UIView *>(self, "_headerOverlayView");
	[headerOverlay setAlpha:widgetTransparency/100];

	//auto slim widget -- hide extra header layer
	if(hideWidgetIcon && hideWidgetLabel){
		[headerOverlay setHidden:YES]; 
	}
}

//auto slim widget -- adjust content view 
-(void)layoutSubviews{
	%orig;

	if(hideWidgetIcon && hideWidgetLabel){
		CGRect frame = self.customContentView.frame;
		frame.origin.y = frame.origin.y-35;
		frame.size.height = frame.size.height+self.frame.size.height;
		[self.customContentView setFrame:frame];

		[MSHookIvar<UIView*>(self, "_headerContentView") setFrame:CGRectZero];
	}
}

//auto slim widget -- hide showmore button
-(void)setShowMoreButtonVisible:(BOOL)visible {
	%orig;

	if(hideWidgetIcon && hideWidgetLabel && visible){
		if(self.showingMoreContent) [self.showMoreButton sendActionsForControlEvents:UIControlEventTouchUpInside]; 
		[self.showMoreButton setAlpha:0]; 
	}
}
%end


//auto-expand 
%hook WGWidgetListItemViewController
-(void)viewWillAppear:(BOOL)appear{
	%orig;

	WGWidgetPlatterView *platterView = (WGWidgetPlatterView*)self.view;
	if(platterView.showMoreButtonVisible && !platterView.showingMoreContent && autoExpand){
		[platterView.showMoreButton sendActionsForControlEvents:UIControlEventTouchUpInside]; 
	}
}
%end


//hide background of "edit" button
%hook WGShortLookStyleButton
-(void)_configureBackgroundViewIfNecessary{
	%orig;

	[MSHookIvar<MTMaterialView *>(self, "_backgroundView") setAlpha:widgetTransparency/100];
}
%end


//hides "information provided by" text 
%hook WGWidgetAttributionView
-(void)_configureAttributedString{
	%orig;

	if(hideFooterText){
		[self setHidden:YES];
	}
}
%end


%hook PLPlatterHeaderContentView
//hide widget title
-(void)_configureTitleLabel:(id)arg1{
	%orig;

	if([self.superview.superview isMemberOfClass:%c(WGWidgetPlatterView)] && hideWidgetLabel){
		[arg1 setHidden:YES];
	}
}

//hide widget icon
-(void)_configureIconButtonsForIcons:(id)arg1{
	%orig;
	
	if([self.superview.superview isMemberOfClass:%c(WGWidgetPlatterView)] && hideWidgetIcon){
		[self.iconButtons.firstObject setHidden:YES];
	}
}
%end

//end of widgets_12

%end

#pragma mark iOS13

%group Notifications_13

//hides the contrasty background cell along with multiple icons showing up on LS when grouped; remains normal when ungrouped
%hook NCNotificationListView
-(void)setSubviewPerformingGroupingAnimation:(BOOL)arg1{
    %orig;

	//if its not springboard only, proceed
	if(location != 1){
		for(NSNumber *key in [self.visibleViews allKeys]){
			UIView *notif = [self.visibleViews objectForKey:key];
			
			//even just one notif is considered a 'stack' and is "grouped", so have to dictate only if grouped and count >= 2 
			if(self.grouped && self.visibleViews.count >= 2 && [key intValue] != 0){ // object associated with first key contains the notification content
				[notif setHidden:YES];
			}

			//if ungrouped or if only one notif is present
			else{			
				[notif setHidden:NO];
			}
		}
	}  
}   
%end


%hook NCNotificationListCellActionButton
//sets transparency for background of sections in sliderview of notification banners on lockscreen 
-(void)_configureBackgroundViewIfNecessary{
	%orig;

	if(location != 1){
		[self.backgroundView setAlpha:notifTransparency/100];
	}
}

//sets text color for labels in sections in sliderview of notification banners on lockscreen 
-(void)_layoutTitleLabel{
	%orig;

	if(location != 1 && textcolor < 2){
		if(MSHookIvar<UILabel *>(self, "_titleLabel").layer.filters.count) [MSHookIvar<UILabel *>(self, "_titleLabel").layer setFilters:nil];
		[MSHookIvar<UILabel *>(self, "_titleLabel") setTextColor:[UIColor colorWithWhite:textcolor alpha:0.8]];
	}
}
%end


%hook NCNotificationShortLookView						
//changes notification transparency
-(void)_configureBackgroundViewIfNecessary{
	%orig;

	if (![[self _viewControllerForAncestor] respondsToSelector:@selector(delegate)]) %orig;

	else{
		BOOL pos = (location == 0 || ([((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 1) || (![((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 2));
		if(pos){
			[self.backgroundView setAlpha:notifTransparency/100];
		}
	}
}

//auto slim notif - adjust content view 
-(void)_layoutNotificationContentView{	
	%orig;
	
   	if (![[self _viewControllerForAncestor] respondsToSelector:@selector(delegate)]) %orig;

	else{
		BOOL pos = (location == 0 || ([((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 1) || (![((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 2));
		if(pos && hideAppIcon && hideAppName && hideTimeLabel){
			UIView *header = MSHookIvar<UIView*>(self, "_headerContentView");
			
			CGRect frame = self.customContentView.frame;
			frame.origin.y = frame.origin.y-25; 
			frame.size.height = frame.size.height+self.frame.size.height;
			[self.customContentView setFrame:frame];
		
			[header setFrame:CGRectZero];
		}
	}
}

//auto slim notif -- adjust shortlookview height
-(void)setFrame:(CGRect)frame{
   	if (![[self _viewControllerForAncestor] respondsToSelector:@selector(delegate)]) %orig;

	else{
		BOOL pos = (location == 0 || ([((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 1) || (![((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 2));
		if(pos && hideAppIcon && hideAppName && hideTimeLabel){
			%orig(CGRectMake(frame.origin.x,frame.origin.y,frame.size.width,frame.size.height-20)); 
		}
		else{
			%orig;
		}
	}
}
%end


//hides "Notification Center" text to prevent bug w axon where it would appear and overlap notifications
%hook NCNotificationListSectionHeaderView
-(void)didMoveToWindow{								
	%orig;

	if ((axonInstalled && ![((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 2) || (location == 0 && axonInstalled)){
		[self setHidden:YES];
	}	

	else{
		[self setHidden:NO];
	}
}
%end


//colors stack header titles and Notification center text
%hook NCNotificationListHeaderTitleView
-(void)adjustForLegibilitySettingsChange:(id)arg1{
	%orig;

	if(location != 1 && textcolor < 2){
		_UILegibilitySettings *customColor = [[_UILegibilitySettings alloc] initWithStyle:1];

		[customColor setPrimaryColor:[UIColor colorWithWhite:textcolor alpha:1]];
		[self setLegibilitySettings:customColor];
		[self.titleLabel setLegibilitySettings:customColor];
		[self.titleLabel setTextColor:[UIColor colorWithWhite:textcolor alpha:1]];
	}
}
%end


%hook NCToggleControl
//sets transparency of background of drop down arrow and x above expanded stackview on LS
-(void)_configureBackgroundMaterialViewIfNecessary{
	%orig;

	if(location != 1){
		[self.backgroundMaterialView setAlpha:notifTransparency/100];
	}
}

//text color of drop down label and glyphs in expanded stacked view
-(void)setExpanded:(BOOL)arg1{
    %orig;

	if(location != 1 && textcolor < 2){
		if(MSHookIvar<UILabel *>(self, "_titleLabel").layer.filters.count) [MSHookIvar<UILabel *>(self, "_titleLabel").layer setFilters:nil];
		[MSHookIvar<UILabel *>(self, "_titleLabel") setTextColor:[UIColor colorWithWhite:textcolor alpha:0.8]];
				
		if(MSHookIvar<UIImageView*>(self, "_glyphView").layer.filters.count) [MSHookIvar<UIImageView*>(self, "_glyphView").layer setFilters:nil];
		[MSHookIvar<UIImageView*>(self, "_glyphView") setTintColor:[UIColor colorWithWhite:textcolor alpha:0.8]];
	}
}
%end


//changes text color for content 
%hook NCNotificationContentView
-(void)setPrimaryText:(NSString *)arg1{				
	%orig;

	BOOL pos = (location == 0 || ([((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 1) || (![((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 2));
	if(pos && textcolor < 2){
		[self.primaryLabel setTextColor:[UIColor colorWithWhite:textcolor alpha:1]];
	}
}

-(void)setPrimarySubtitleText:(NSString *)arg1{			
	%orig;

	BOOL pos = (location == 0 || ([((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 1) || (![((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 2));
	if(pos && textcolor < 2){
		[self.primarySubtitleLabel setTextColor:[UIColor colorWithWhite:textcolor alpha:1]];
	}
}

-(void)setSecondaryText:(NSString *)arg1{			
	%orig;

	BOOL pos = (location == 0 || ([((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 1) || (![((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 2));
	if(pos && textcolor < 2){
		[self.secondaryLabel setTextColor:[UIColor colorWithWhite:textcolor alpha:1]];
	}
}
											
-(void)_updateStyleForSummaryLabel:(id)arg1 withStyle:(long long)arg2{		
	BOOL pos = (location == 0 || ([((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 1) || (![((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 2));
	if(pos && textcolor < 2){
		[self.summaryLabel setTextColor:[UIColor colorWithWhite:textcolor alpha:1]];
	}
	else{
		%orig;
	}
}
%end


//hides the app name, delivery time, app icon, and colors header content 
%hook PLPlatterHeaderContentView
-(void)setTitle:(NSString *)arg1{												
	%orig;

	if(self.superview && self.superview.superview){
   		if (![[self _viewControllerForAncestor] respondsToSelector:@selector(delegate)]) %orig;

		else{
			BOOL pos = (location == 0 || ([((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 1) || (![((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 2));
			if(pos){
				if(hideAppName){
					[self.titleLabel setHidden:YES];
				}

				if(textcolor < 2){
					if(MSHookIvar<UILabel *>(self, "_titleLabel").layer.filters.count) [MSHookIvar<UILabel *>(self, "_titleLabel").layer setFilters:nil];
					[MSHookIvar<UILabel *>(self, "_titleLabel") setTextColor:[UIColor colorWithWhite:textcolor alpha:0.8]];
				}
			}
		}
	}
}

-(void)_configureDateLabel{												
	%orig;

	if(self.superview && self.superview.superview){
   		if (![[self _viewControllerForAncestor] respondsToSelector:@selector(delegate)]) %orig;

		else{
			BOOL pos = (location == 0 || ([((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 1) || (![((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 2));
			if(pos){
				if(hideTimeLabel){
					[self.dateLabel setHidden:YES];
				}

				if(textcolor < 2){
					if(MSHookIvar<UILabel *>(self, "_dateLabel").layer.filters.count) [MSHookIvar<UILabel *>(self, "_dateLabel").layer setFilters:nil];
					[MSHookIvar<UILabel *>(self, "_dateLabel") setTextColor:[UIColor colorWithWhite:textcolor alpha:0.8]];
				}
			}
		}
	}
}

-(void)_configureIconButtonsForIcons:(id)arg1{
	%orig;

	if(self.superview && self.superview.superview){
   		if (![[self _viewControllerForAncestor] respondsToSelector:@selector(delegate)]) %orig;

		else{
			BOOL pos = (location == 0 || ([((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 1) || (![((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)] && location == 2));
			if(pos && hideAppIcon){
				for(UIView *icon in self.iconButtons){
					[icon setHidden:YES];
				}
			}
		}
	}
}
%end


//colors and hides "no older notification text"
%hook NCNotificationListSectionRevealHintView
-(void)adjustForLegibilitySettingsChange:(id)arg1{
	%orig;

	if(location != 1){		
		if(hideNONT){
			[self.revealHintTitle setHidden:YES];
		}

		if(textcolor < 2){
			[self.legibilitySettings setPrimaryColor:[UIColor colorWithWhite:textcolor alpha:1]];
			[self.revealHintTitle setTextColor:[UIColor colorWithWhite:textcolor alpha:1]];
		}
	}
}
%end


//hides the charging indicator on LS (without full fade/flash)
%hook _CSSingleBatteryChargingView					
-(void)_layoutBattery{
	%orig;

	if(hideChargingIndicator){
		[MSHookIvar<UIView *>(self, "_batteryContainerView") setHidden:YES];
		[MSHookIvar<UIView *>(self, "_batteryBlurView") setHidden:YES];
		[MSHookIvar<UIView *>(self, "_batteryFillView") setHidden:YES];
		[MSHookIvar<UILabel *>(self, "_chargePercentLabel") setHidden:YES];
	}

	else{
		[MSHookIvar<UIView *>(self, "_batteryContainerView") setHidden:NO];
		[MSHookIvar<UIView *>(self, "_batteryBlurView") setHidden:NO];
		[MSHookIvar<UIView *>(self, "_batteryFillView") setHidden:NO];
		[MSHookIvar<UILabel *>(self, "_chargePercentLabel") setHidden:NO];
	}
}
%end

//end of notifications_13

%end


%group Widgets_13

%hook WGWidgetPlatterView
//transparency for body
-(void)_configureBackgroundMaterialViewIfNecessary{
	%orig;

	[MSHookIvar<MTMaterialView *>(self, "_backgroundView") setAlpha:widgetTransparency/100];
}

//transparency for header
-(void)_configureHeaderViewsIfNecessary{
	%orig;

	MTMaterialView *headerBackground = MSHookIvar<MTMaterialView *>(self, "_headerBackgroundView");
	[headerBackground setAlpha:widgetTransparency/100];

	//auto slim widget -- hide headerbackground 
	if(hideWidgetIcon && hideWidgetLabel){
		[headerBackground setFrame:CGRectZero];
	}
}

//auto slim widget -- adjust content view 
-(void)_layoutContentView{	
	%orig;

	if(hideWidgetIcon && hideWidgetLabel){
		UIView *header = MSHookIvar<UIView*>(self, "_headerContentView");
			
		CGRect frame = self.contentView.frame;
		frame.origin.y = frame.origin.y-35;
		frame.size.height = frame.size.height+self.frame.size.height;
		[self.contentView setFrame:frame];

		[header setFrame:CGRectZero];
	}
}

//auto slim widget -- adjust platterview
-(void)setFrame:(CGRect)frame{
	if(hideWidgetIcon && hideWidgetLabel){
		%orig(CGRectMake(frame.origin.x,frame.origin.y,frame.size.width,frame.size.height-40));
		[self layoutSubviews];
	}
	else{
		%orig;
	}
}

//auto slim widget -- hide showmore button
-(void)setShowMoreButtonVisible:(BOOL)visible {
	%orig;

	if(hideWidgetIcon && hideWidgetLabel && visible){
		if(self.showingMoreContent) [self.showMoreButton sendActionsForControlEvents:UIControlEventTouchUpInside]; 
		[self.showMoreButton setAlpha:0]; 
	}
}
%end


//auto-expand 
%hook WGWidgetListItemViewController
-(void)viewWillAppear:(BOOL)appear{
	%orig;

	WGWidgetPlatterView *platterView = (WGWidgetPlatterView*)self.view;
	if(platterView.showMoreButtonVisible && !platterView.showingMoreContent && autoExpand){
		[platterView.showMoreButton sendActionsForControlEvents:UIControlEventTouchUpInside]; 
	}
}
%end


//color widget contents (iOS 13 only)			
%hook WGWidgetHostingViewController
-(void)viewDidLoad{
	%orig;

	if(@available(iOS 13, *)){
		if(contentcolor == 0){
			[self setOverrideUserInterfaceStyle:UIUserInterfaceStyleLight];
		}
		else if(contentcolor == 1){
			[self setOverrideUserInterfaceStyle:UIUserInterfaceStyleDark];
		}
		else{
			[self setOverrideUserInterfaceStyle:UIUserInterfaceStyleUnspecified];
		}
    }
}
%end


//hide background of "edit" button
%hook WGShortLookStyleButton
-(void)_configureBackgroundViewIfNecessary{
	%orig;

	[MSHookIvar<MTMaterialView *>(self, "_backgroundView") setAlpha:widgetTransparency/100];
}
%end


//hides "information provided by" text 
%hook WGWidgetAttributionView
-(void)_configureAttributedString{
	%orig;

	if(hideFooterText){
		[self setHidden:YES];
	}
}
%end


%hook WGPlatterHeaderContentView
//hide widget title
-(void)_configureTitleLabel:(id)arg1{
	%orig;

	if(hideWidgetLabel){
		[arg1 setHidden:YES];
	}
}

//hide widget icon
-(void)_configureIconButtonsForIcons:(id)arg1{
	%orig;

	if(hideWidgetIcon){
		[self.iconButtons.firstObject setHidden:YES];
	}
}
%end

//end of widgets_13

%end

//	PREFERENCES
void preferencesChanged(){
	NSDictionary *prefs = [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"me.lightmann.aeaeaprefs"];
	if(prefs){
  	  	isEnabled = ([prefs objectForKey:@"isEnabled"] ? [[prefs valueForKey:@"isEnabled"] boolValue] : YES );

		//Notifs
		notifsEnabled = ([prefs objectForKey:@"notifsEnabled"] ? [[prefs valueForKey:@"notifsEnabled"] boolValue] : YES );
		location = ([prefs objectForKey:@"location"] ? [[prefs valueForKey:@"location"] integerValue] : 0 );
		notifTransparency = ([prefs objectForKey:@"notifTransparency"] ? [[prefs valueForKey:@"notifTransparency"] floatValue] : 0 );
		textcolor = ([prefs objectForKey:@"textcolor"] ? [[prefs valueForKey:@"textcolor"] integerValue] : 2 );
		hideAppIcon = ([prefs objectForKey:@"hideAppIcon"] ? [[prefs valueForKey:@"hideAppIcon"] boolValue] : NO );
		hideAppName = ([prefs objectForKey:@"hideAppName"] ? [[prefs valueForKey:@"hideAppName"] boolValue] : NO );
		hideTimeLabel = ([prefs objectForKey:@"hideTimeLabel"] ? [[prefs valueForKey:@"hideTimeLabel"] boolValue] : NO );
		hideNONT = ([prefs objectForKey:@"hideNONT"] ? [[prefs valueForKey:@"hideNONT"] boolValue] : YES );
		hideChargingIndicator = ([prefs objectForKey:@"hideChargingIndicator"] ? [[prefs valueForKey:@"hideChargingIndicator"] boolValue] : NO );

		//Widgets
		widgetsEnabled = ([prefs objectForKey:@"widgetsEnabled"] ? [[prefs valueForKey:@"widgetsEnabled"] boolValue] : YES );
		widgetTransparency = ([prefs objectForKey:@"widgetTransparency"] ? [[prefs valueForKey:@"widgetTransparency"] floatValue] : 0 );
		contentcolor = ([prefs objectForKey:@"contentcolor"] ? [[prefs valueForKey:@"contentcolor"] integerValue] : 2 );
		autoExpand = ([prefs objectForKey:@"autoExpand"] ? [[prefs valueForKey:@"autoExpand"] boolValue] : NO );
		hideWidgetIcon = ([prefs objectForKey:@"hideWidgetIcon"] ? [[prefs valueForKey:@"hideWidgetIcon"] boolValue] : NO );
		hideWidgetLabel = ([prefs objectForKey:@"hideWidgetLabel"] ? [[prefs valueForKey:@"hideWidgetLabel"] boolValue] : NO );
		hideFooterText = ([prefs objectForKey:@"hideFooterText"] ? [[prefs valueForKey:@"hideFooterText"] boolValue] : YES );
	}
}

%ctor{
	preferencesChanged();

	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)preferencesChanged, CFSTR("me.lightmann.aeaeaprefs-updated"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);

	//check if axon is installed
	axonInstalled = [[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/dpkg/info/me.nepeta.axon.list"];

	if(isEnabled){
		if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"13")){
			if(notifsEnabled) %init(Notifications_13);
			if(widgetsEnabled) %init(Widgets_13);
		} 
		else{
			if(notifsEnabled) %init(Notifications_12);
			if(widgetsEnabled) %init(Widgets_12);
		}
	}
}
