//
//  WebblogViewController.h
// iCard
//



@interface WebblogViewController : UIViewController {
	IBOutlet UITextField *website;
	IBOutlet UITextField *blog;
	sqlite3 *db;
}

@property (nonatomic, retain)IBOutlet UITextField *website;
@property (nonatomic, retain)IBOutlet UITextField *blog;

- (IBAction)saveButton:(id)sender;
- (IBAction)cancelButton:(id)sender;
- (void)switchToFlip;

- (NSString *)filePath;
- (void)saveWebblog;
- (void)deleteWebblog;
@end
