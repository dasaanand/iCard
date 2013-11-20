//
//  CallSmsMailViewController.h
// iCard

#import <MessageUI/MessageUI.h>

@interface CallSmsMailViewController : UIViewController<MFMailComposeViewControllerDelegate,UINavigationControllerDelegate> {
	sqlite3 *db;
	NSMutableArray *buttonTitles;
	IBOutlet UIButton *btn1;
	IBOutlet UIButton *btn2;
	IBOutlet UIButton *btn3;
	IBOutlet UILabel *title1;
	IBOutlet UILabel *lab1;
	IBOutlet UILabel *lab2;
	IBOutlet UILabel *lab3;
}

@property (nonatomic, retain) IBOutlet UILabel *title1;
@property (nonatomic, retain) IBOutlet UILabel *lab1;
@property (nonatomic, retain) IBOutlet UILabel *lab2;
@property (nonatomic, retain) IBOutlet UILabel *lab3;

- (IBAction)back;
- (IBAction)toolButtons:(id)sender;
- (IBAction)contactButton:(id)sender;
- (NSString *)filePath;

@end
