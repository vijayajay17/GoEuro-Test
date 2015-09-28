//
//  ViewController.m
//  EuroTest
//
//  Created by Vijay on 9/25/15.
//  Copyright (c) 2015 Vijay. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"


#define BASE_URL @"https://api.goeuro.com/api/v2/position/suggest"

@interface ViewController ()
@property (nonatomic,readwrite)IBOutlet UITextField *m_startTextField;
@property (nonatomic,readwrite)IBOutlet UITextField *m_endTextField;
@property (nonatomic,readwrite)IBOutlet UIButton *dateButton;
@property (nonatomic,readwrite)IBOutlet UIButton *searchButton;
@property (nonatomic) DataListView *dataListView;
@property (nonatomic) UITableView *l_tableView;
@property (nonatomic) UIDatePicker *picker;
@property (nonatomic) UIToolbar *toolbarPicker;
@property (nonatomic, readwrite) NSInteger tagValue;
@property (nonatomic) NSMutableArray *dataListArray;

-(IBAction)dateAction:(id)sender;
-(IBAction)searchAction:(id)sender;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.dataListView = [[DataListView alloc] initWithListArray:nil];
    self.dataListView.backgroundColor = [UIColor clearColor];
    self.dataListView.layer.cornerRadius = 10.0;
    self.dataListView.printValue = self;
    self.dataListView.layer.borderColor = [[UIColor blackColor]CGColor];
    self.dataListView.layer.borderWidth = 1;
    [self.view addSubview:self.dataListView];
    self.dataListView.hidden = YES;
    
    self.searchButton.enabled = NO;
}

#pragma mark DatePicker Action

-(IBAction)dateAction:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM/dd/yyyy";
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    self.picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, screenHeight-204 , screenWidth, screenHeight/2 + 35)];
    [self.view addSubview:self.picker];
    
    [self.picker setDatePickerMode:UIDatePickerModeDate];
    [self.picker addTarget:self action:@selector(pickerChanged) forControlEvents:UIControlEventValueChanged];
    
   self.toolbarPicker = [[UIToolbar alloc] initWithFrame:CGRectMake(0, screenHeight-268, 320, 44)];
    self.toolbarPicker.barStyle=UIBarStyleBlackOpaque;
    [self.toolbarPicker sizeToFit];
    NSMutableArray *itemsBar = [[NSMutableArray alloc] init];
    //calls DoneClicked
    UIBarButtonItem *bbitem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(DoneClicked)];
    [itemsBar addObject:bbitem];
    [self.toolbarPicker setItems:itemsBar animated:YES];
    [self.view addSubview:self.toolbarPicker];
    
    [self.dateButton setTitle:[dateFormatter stringFromDate:[NSDate date]] forState:UIControlStateNormal];
}

-(void)DoneClicked
{
    [self.picker removeFromSuperview];
    [self.toolbarPicker removeFromSuperview];
    if(self.m_startTextField.text.length!=0 && self.m_endTextField.text.length!=0 && ![[[self.dateButton titleLabel] text] isEqualToString:@"Select Date"])
    {
        self.searchButton.enabled = YES;
    }
    else
    {
        self.searchButton.enabled = NO;
    }
}

-(void)pickerChanged {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM/dd/yyyy";
    
    [self.dateButton setTitle:[dateFormatter stringFromDate:self.picker.date] forState:UIControlStateNormal];
    if(self.dataListView)
    {
    [self.dataListView setHidden:YES];
    [self.dataListView reloadTableView:@[]];
    }

}
#pragma mark DatePicker Action end



#pragma mark Search Action

//***********************************************
//Implementing Search Function
//***********************************************

-(IBAction)searchAction:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"GoEuro" message:@"Search is not yet implemented" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];

}

#pragma mark Search Action end

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TextField Delegates

//***********************************************
//Implementing TextField Delegates
//***********************************************

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.tagValue = textField.tag;
    self.dataListView.hidden = NO;
    self.dataListView.frame = CGRectMake(textField.frame.origin.x, textField.frame.origin.y + textField.frame.size.height + 10, textField.frame.size.width, 100);
    [self.dataListView reloadTableView:@[]];
}

//***********************************************
//Calling Service When User changes text
//***********************************************

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if( textField.text.length + string.length - range.length > 2)
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSLocale *currentLocale = [NSLocale currentLocale];  // get the current locale.
            NSString *countryCode = [[currentLocale objectForKey:NSLocaleCountryCode] lowercaseString];
            NSURL * url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/%@/%@",BASE_URL,countryCode,textField.text]];
            NSData * results = [NSData dataWithContentsOfURL:url];
            if(results)
            {
            NSArray * parsedResults = [NSJSONSerialization JSONObjectWithData: results options: NSJSONReadingMutableContainers error: nil];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.dataListView reloadTableView:parsedResults];
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            });
            }
            else
            {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                [self.dataListView reloadTableView:@[]];
            }
        });
        
        
    }
    else
    {
        [self.dataListView reloadTableView:@[]];
    }
    
    if(self.m_startTextField.text.length!=0 && self.m_endTextField.text.length!=0 && ![[[self.dateButton titleLabel] text] isEqualToString:@"Select Date"])
    {
        self.searchButton.enabled = YES;
    }
    else
    {
        self.searchButton.enabled = NO;
    }
    
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.dataListView setHidden:YES];
    [self.dataListView reloadTableView:@[]];
    
}


//
//***********************************************
//Printing the selected value from the list tableview
//***********************************************

-(void)printSelectedValue:(NSString *)selectedName
{
    if(self.tagValue==1)
    {
        self.m_startTextField.text = selectedName;
        [self.m_startTextField resignFirstResponder];
    }
   else if(self.tagValue==2)
    {
        self.m_endTextField.text = selectedName;
        [self.m_endTextField resignFirstResponder];
    }
    [self.dataListView reloadTableView:@[]];
    [self.dataListView setHidden:YES];

    
}


@end
