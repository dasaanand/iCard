//
//  MainViewController.h
// iCard 
//


@interface MainViewController : UIViewController <FlipsideViewControllerDelegate> {
	NSMutableArray *listOfNames;
	NSMutableArray *unsortedidKey;
	NSMutableArray *idKey;
	sqlite3 *db;
	UITableView *myTableView;
	NSMutableArray *dataSource;
	NSMutableArray *searchedData;//will be storing data matching with the search string
	UISearchBar *sBar;//search bar
	
}

- (IBAction)showInfo;
- (NSString *)filePath;
- (IBAction)orgButton;
- (IBAction)jobButton;
- (IBAction)scopeButton;
- (NSMutableArray *)sort:(NSMutableArray *)unsortedArray;

@end
