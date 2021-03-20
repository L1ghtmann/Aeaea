#import "AeaeaNotifSubPrefsListController.h"

@implementation AeaeaNotifSubPrefsListController

- (NSArray *)specifiers {
    return _specifiers;
}

- (void)loadFromSpecifier:(PSSpecifier *)specifier {
    NSString *sub = [specifier propertyForKey:@"AeaeaSub"];
    NSString *title = [specifier name];

    _specifiers = [self loadSpecifiersFromPlistName:sub target:self];

    [self setTitle:title];
    [self.navigationItem setTitle:title];
}

- (void)setSpecifier:(PSSpecifier *)specifier {
	[self loadFromSpecifier:specifier];
	[super setSpecifier:specifier];
}

- (BOOL)shouldReloadSpecifiersOnResume {
    return NO;
}

//tints color of Switches
- (void)viewWillAppear:(BOOL)animated {
    [[UISwitch appearanceWhenContainedInInstancesOfClasses:@[self.class]] setOnTintColor:[UIColor colorWithRed:0.984 green:0.729 blue:0.051 alpha:1.0]];
    [super viewWillAppear:animated];
}

-(void)localLSNotif:(id)sender{
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)@"me.lightmann.aeaea/testNotif", nil, nil, true);
}

-(void)localSBNotif:(id)sender{
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)@"me.lightmann.aeaea/testBanner", nil, nil, true);
}

@end