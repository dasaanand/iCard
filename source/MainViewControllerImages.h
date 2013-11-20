//
//  MainViewControllerImages.h
// iCard


@interface MainViewControllerImages : UIViewController <FlipsideViewControllerDelegate,UIActionSheetDelegate,UIScrollViewDelegate>{
	NSMutableArray *listOfNames;
	NSMutableArray *idKey;
	NSMutableArray *idref;
	sqlite3 *db;
	IBOutlet UIScrollView *scrollView;
	IBOutlet UIButton *card1;
	IBOutlet UIButton *card2;
	IBOutlet UIButton *card3;
	IBOutlet UIButton *card4;
	int endCardIndex;
	IBOutlet UIBarButtonItem *nextSet;
	IBOutlet UIBarButtonItem *previousSet;
}

@property(nonatomic,retain) IBOutlet UIButton *card1; 
@property(nonatomic,retain) IBOutlet UIButton *card2; 
@property(nonatomic,retain) IBOutlet UIButton *card3; 
@property(nonatomic,retain) IBOutlet UIButton *card4; 
@property(nonatomic,retain) IBOutlet UIBarButtonItem *nextSet;
@property(nonatomic,retain) IBOutlet UIBarButtonItem *previousSet;

- (IBAction)showInfo;
- (IBAction)changeScope;
- (IBAction)next;
- (IBAction)previous;
- (IBAction)cardClicked:(id)sender;
- (void)dispImage:(int) start;
- (void)checkCount;
- (NSString *)filePath;

@end
