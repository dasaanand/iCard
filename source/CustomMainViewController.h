//
//  CustomMainViewController.h
// iCard

#import <UIKit/UIKit.h>


@interface CustomMainViewController : UIViewController <FlipsideViewControllerDelegate,UIActionSheetDelegate>{
	NSMutableArray *listOfNames;
	NSMutableArray *sections;
	NSMutableArray *uniqueSections;
	NSMutableArray *contentsArray;
	sqlite3 *db;
	NSMutableArray *idKey;
	NSMutableArray *idKeyTemp;
	NSMutableArray *unsortedidKey;
	IBOutlet UIView *Contents;
}

- (IBAction)showInfo;
- (NSString *)filePath;
- (IBAction)nameButton;
- (IBAction)orgButton;
- (IBAction)scopeButton;
- (NSMutableArray *)sort:(NSMutableArray *)unsortedArray:(int)row;

@end
