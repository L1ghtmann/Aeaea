#import "AeaeaWidgetSubPrefsListController.h"

@implementation AeaeaWidgetSubPrefsListController

-(NSArray *)specifiers{
	return _specifiers;
}

-(void)loadFromSpecifier:(PSSpecifier *)specifier{
	NSString *sub = [specifier propertyForKey:@"AeaeaSub"];
	NSString *title = [specifier name];

	_specifiers = [self loadSpecifiersFromPlistName:sub target:self];

	[self setTitle:title];
	[self.navigationItem setTitle:title];
}

-(void)viewDidLoad{
	if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"14")){
		UIAlertController * alert = [UIAlertController
								 alertControllerWithTitle:@"Aeaea"
								 message:@"Does NOT support widgets on iOS 14+"
								 preferredStyle:UIAlertControllerStyleAlert];

		UIAlertAction *ok = [UIAlertAction
								actionWithTitle:@"Ok"
								style:UIAlertActionStyleDefault
								handler:^(UIAlertAction * action){
									[self dismissViewControllerAnimated:YES completion:nil];
									[self.navigationController popToRootViewControllerAnimated:YES];
								}];

		[alert addAction:ok];

 		[self presentViewController:alert animated:YES completion:nil];
	}
}

-(void)setSpecifier:(PSSpecifier *)specifier{
	[self loadFromSpecifier:specifier];
	[super setSpecifier:specifier];
}

-(BOOL)shouldReloadSpecifiersOnResume{
	return NO;
}

-(void)viewWillAppear:(BOOL)animated{
	[[UISwitch appearanceWhenContainedInInstancesOfClasses:@[self.class]] setOnTintColor:[UIColor colorWithRed:0.984 green:0.729 blue:0.051 alpha:1.0]];
	[super viewWillAppear:animated];
}

@end