//
//  ContactNoViewController.h
// iCard
//



@interface ContactNoViewController : UIViewController {
	IBOutlet UITextField *personalno;
	IBOutlet UITextField *office1no;
	IBOutlet UITextField *office2no;
	IBOutlet UITextField *faxno;	
	sqlite3 *db;
	IBOutlet UIScrollView *scrollView;
	CGFloat animatedDistance;
}

@property (nonatomic, retain)IBOutlet UITextField *personalno;
@property (nonatomic, retain)IBOutlet UITextField *office1no;
@property (nonatomic, retain)IBOutlet UITextField *office2no;
@property (nonatomic, retain)IBOutlet UITextField *faxno;

- (IBAction)saveButton:(id)sender;
- (IBAction)cancelButton:(id)sender;
- (void)switchToFlip;

- (NSString *)filePath;
- (void)saveNo;

@end
