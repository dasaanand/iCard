//
//  EmailViewController.h
// iCard
//



@interface EmailViewController : UIViewController {
	
	IBOutlet UITextField *pers;
	IBOutlet UITextField *office1;
	IBOutlet UITextField *office2;
	sqlite3 *db;
	CGFloat animatedDistance;	
}

@property (nonatomic, retain)IBOutlet UITextField *pers;
@property (nonatomic, retain)IBOutlet UITextField *office1;
@property (nonatomic, retain)IBOutlet UITextField *office2;


- (IBAction)saveButton:(id)sender;
- (IBAction)cancelButton:(id)sender;
- (void)switchToFlip;

- (NSString *)filePath;
- (void)saveEmail;
- (void)deleteEmail;

@end
