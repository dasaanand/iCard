//
//  JobTitleViewController.h
// iCard 



@interface JobTitleViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
	IBOutlet UILabel *mlabel;
    NSMutableArray *arrayNo;
    IBOutlet UIPickerView *pickerView;
	IBOutlet UITextField *newGroup;
	sqlite3 *db;
	IBOutlet UIScrollView *scrollView;
}

@property (nonatomic, retain) UILabel *mlabel;
@property (nonatomic, retain) UITextField *newGroup;

- (IBAction)addGroup;
- (IBAction)saveButton:(id)sender;
- (IBAction)cancelButton:(id)sender;
- (void)switchToFlip;
- (void)saveGroup;
- (NSString *)filePath;

@end
