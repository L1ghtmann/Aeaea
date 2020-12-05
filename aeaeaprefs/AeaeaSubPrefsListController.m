//Sub-prefs from (Eva) NepetaDev (https://github.com/NepetaDev) -- w appropriately attached MIT license
#import "AeaeaSubPrefsListController.h"

@implementation AeaeaSubPrefsListController

- (NSArray *)specifiers {
    return _specifiers;
}

- (void)loadFromSpecifier:(PSSpecifier *)specifier {
    NSString *sub = [specifier propertyForKey:@"AeaeaSub"];
    NSString *title = [specifier name];

    _specifiers = [self loadSpecifiersFromPlistName:sub target:self];

    for (PSSpecifier *specifier in _specifiers) {
        if ([specifier.name isEqualToString:@"%SUB_NAME%"]) {
            specifier.name = title;
        }
    }

    [self setTitle:title];
    [self.navigationItem setTitle:title];
}

- (void)setSpecifier:(PSSpecifier *)specifier {
	[self loadFromSpecifier:specifier];
	[super setSpecifier:specifier];
}

- (bool)shouldReloadSpecifiersOnResume {
    return false;
}

//tints color of Switches
- (void)viewWillAppear:(BOOL)animated {
    [[UISwitch appearanceWhenContainedInInstancesOfClasses:@[self.class]] setOnTintColor:[UIColor colorWithRed:0.984 green:0.729 blue:0.051 alpha:1.0]];
    [super viewWillAppear:animated];
}

@end