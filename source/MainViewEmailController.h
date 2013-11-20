//
//  MainViewEmailController.h
// iCard

@interface MainViewEmailController : UIViewController <FlipsideViewControllerDelegate,UIActionSheetDelegate>{
	NSMutableArray *listOfNames;
	NSMutableArray *idKey;
	NSMutableArray *unsortedidKey;
	sqlite3 *db;
	UITableView *myTableView;
	NSMutableArray *dataSource;
	NSMutableArray *searchedData;//will be storing data matching with the search string
	
	UISearchBar *sBar;//search bar
}

- (IBAction)showInfo;
- (NSString *)filePath;
- (IBAction)nameButton;
- (IBAction)jobButton;
- (IBAction)orgButton;
- (IBAction)changeScope;
- (void)initname:(NSInteger)i;
- (NSMutableArray *)sort:(NSMutableArray *)unsortedArray;

@end
