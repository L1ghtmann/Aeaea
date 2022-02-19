#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>

//https://stackoverflow.com/a/5337804
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface AeaeaWidgetSubPrefsListController : PSListController
@end
