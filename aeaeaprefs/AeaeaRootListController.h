//Header image code from (Alexa) Litten (https://github.com/Litteeen)
#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSControlTableCell.h>

@interface AeaeaRootListController : PSListController {
    UITableView * _table;
}
@property (nonatomic, retain) UIView *headerView;
@property (nonatomic, retain) UIImageView *headerImageView;
@end
