//
//  AddressViewController.h
// iCard
//



@interface AddressViewController : UIViewController {
	IBOutlet UITextField *off1add;
	IBOutlet UITextField *off1city;
	IBOutlet UITextField *off1state;
	IBOutlet UITextField *off1country;
	IBOutlet UITextField *off1pin;
	IBOutlet UITextField *off2add;
	IBOutlet UITextField *off2city;
	IBOutlet UITextField *off2state;
	IBOutlet UITextField *off2country;
	IBOutlet UITextField *off2pin;
	sqlite3 *db;
	IBOutlet UIScrollView *scrollView;
	CGFloat animatedDistance;
}

@property (nonatomic, retain)IBOutlet UITextField *off1add;
@property (nonatomic, retain)IBOutlet UITextField *off1city;
@property (nonatomic, retain)IBOutlet UITextField *off1state;
@property (nonatomic, retain)IBOutlet UITextField *off1country;
@property (nonatomic, retain)IBOutlet UITextField *off1pin;
@property (nonatomic, retain)IBOutlet UITextField *off2add;
@property (nonatomic, retain)IBOutlet UITextField *off2city;
@property (nonatomic, retain)IBOutlet UITextField *off2state;
@property (nonatomic, retain)IBOutlet UITextField *off2country;
@property (nonatomic, retain)IBOutlet UITextField *off2pin;


- (IBAction)saveButton:(id)sender;
- (IBAction)cancelButton:(id)sender;
- (void)switchToFlip;

- (NSString *)filePath;
- (void)saveAddress;
- (void)deleteAddress;

@end
