//
//  SIListing.m
//  HLA Ipad
//
//  Created by Md. Nazmus Saadat on 10/2/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import "SIListing.h"
#import "ColorHexCode.h"
#import "NewLAViewController.h"
#import "MainScreen.h"
#import "AppDelegate.h"
#import "FSVerticalTabBarController.h"
#import "EverLifeViewController.h"
#import "MasterMenuEApp.h"
#import "MBProgressHUD.h"

#define kPageSize 10

@interface SIListing ()
@property(nonatomic, readwrite) int kPageIndex;
@property(nonatomic, readwrite) int kPageModulo;
@property(nonatomic, readwrite) BOOL isLoading;
@end

@implementation SIListing
@synthesize outletGender;
@synthesize outletEdit;
@synthesize lblSINO, DBDateTo, DBDateFrom,OrderBy;
@synthesize lblDateCreated;
@synthesize lblName;
@synthesize lblPlan;
@synthesize lblBasicSA;
@synthesize outletDateFrom;
@synthesize outletDelete;
@synthesize myTableView;
@synthesize outletDone;
@synthesize btnSortBy;
@synthesize outletDateTo;
@synthesize txtSINO,CustomerCode;
@synthesize txtLAName, SINO,FilteredBasicSA,FilteredDateCreated,FilteredName;
@synthesize FilteredSINO,FilteredPlanName,FilteredSIStatus,SIStatus,FilteredCustomerCode;
@synthesize BasicSA,Name,PlanName, DateCreated, TradOrEver, SIVersion, FilteredSIVersion, SIValidStatus, FilteredSIValidStatus, PDFCreator;
@synthesize SortBy = _SortBy;
@synthesize Popover = _Popover;
@synthesize SIDate = _SIDate;
@synthesize SIDatePopover = _SIDatePopover;



//@synthesize NewLAViewController =_NewLAViewController;
int DateOption;
int deleteOption; // 101 = SI and eApps, 102 = delete Si only, 103 = combination of 101 + 102

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
	AppDelegate *appDel= (AppDelegate*)[[UIApplication sharedApplication] delegate ];
	appDel.MhiMessage = Nil;
	appDel = Nil;
	
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg10.jpg"]];
    outletDelete.hidden = TRUE;
    
    outletDone.hidden = true;
    DBDateFrom = @"";
    DBDateTo = @"";
    
    ColorHexCode *CustomColor = [[ColorHexCode alloc]init ];
    
    CGRect frame=CGRectMake(0,234, 170, 50);
    lblSINO.frame = frame;
    lblSINO.textAlignment = UITextAlignmentCenter;
    lblSINO.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
    lblSINO.backgroundColor = [CustomColor colorWithHexString:@"4F81BD"];
    
    CGRect frame2=CGRectMake(170,234, 150, 50);
    lblDateCreated.frame = frame2;
    lblDateCreated.textAlignment = UITextAlignmentCenter;
    lblDateCreated.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
    lblDateCreated.backgroundColor = [CustomColor colorWithHexString:@"4F81BD"];
    
    CGRect frame3=CGRectMake(320,234, 180, 50);
    lblName.frame = frame3;
    lblName.textAlignment = UITextAlignmentCenter;
    lblName.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
    lblName.backgroundColor = [CustomColor colorWithHexString:@"4F81BD"];
    
    CGRect frame4=CGRectMake(500,234, 150, 50);
    lblPlan.frame = frame4;
    lblPlan.textAlignment = UITextAlignmentCenter;
    lblPlan.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
    lblPlan.backgroundColor = [CustomColor colorWithHexString:@"4F81BD"];
    
    CGRect frame5=CGRectMake(650,234, 150, 50);
    lblBasicSA.frame = frame5;
    lblBasicSA.textAlignment = UITextAlignmentCenter;
    lblBasicSA.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
    lblBasicSA.backgroundColor = [CustomColor colorWithHexString:@"4F81BD"];
    
    UILabel *lblProposalStat = [[UILabel alloc] initWithFrame:CGRectMake(800, 234, 150, 50)];
    lblProposalStat.text = @"Proposal Status";
    lblProposalStat.textAlignment = UITextAlignmentCenter;
    lblProposalStat.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
    lblProposalStat.backgroundColor = [CustomColor colorWithHexString:@"4F81BD"];
    lblProposalStat.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:17];
    [self.view addSubview:lblProposalStat];
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    
    [self LoadAllResult];
    /*
     sqlite3_stmt *statement;
     const char *dbpath = [databasePath UTF8String];
     
     
     if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK){
     NSString *SIListingSQL = [NSString stringWithFormat:@"select A.Sino, createdAT, name, planname, basicSA, 'Not Created', A.CustCode "
     " from trad_lapayor as A, trad_details as B, clt_profile as C, trad_sys_profile as D "
     " where A.sino = B.sino and A.CustCode = C.custcode and B.plancode = D.plancode AND A.Sequence = 1 AND A.ptypeCode = \"LA\" order by createdAt Desc "];
     const char *SelectSI = [SIListingSQL UTF8String];
     if(sqlite3_prepare_v2(contactDB, SelectSI, -1, &statement, NULL) == SQLITE_OK) {
     
     SINO = [[NSMutableArray alloc] init ];
     DateCreated = [[NSMutableArray alloc] init ];
     Name = [[NSMutableArray alloc] init ];
     PlanName = [[NSMutableArray alloc] init ];
     BasicSA = [[NSMutableArray alloc] init ];
     SIStatus = [[NSMutableArray alloc] init ];
     CustomerCode = [[NSMutableArray alloc] init ];
     
     while (sqlite3_step(statement) == SQLITE_ROW){
     NSString *SINumber = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
     NSString *ItemDateCreated = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
     NSString *ItemName = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
     NSString *ItemPlanName = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
     NSString *ItemBasicSA = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
     NSString *ItemStatus = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 5)];
     NSString *ItemCustomerCode = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 6)];
     
     [SINO addObject:SINumber];
     [DateCreated addObject:ItemDateCreated ];
     [Name addObject:ItemName ];
     [PlanName addObject:ItemPlanName ];
     [BasicSA addObject:ItemBasicSA ];
     [SIStatus addObject:ItemStatus];
     [CustomerCode addObject:ItemCustomerCode];
     }
     
     sqlite3_finalize(statement);
     }
     
     sqlite3_close(contactDB);
     }
     
     if (SINO.count == 0) {
     [outletEdit setTitleColor:[UIColor grayColor] forState:UIControlStateNormal ];
     outletEdit.enabled = FALSE;
     }
     else {
     [outletEdit setTitleColor:[UIColor blackColor] forState:UIControlStateNormal ];
     outletEdit.enabled = TRUE;
     }
     */
    //    UITableView *tableView =  [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] style:UITableViewStylePlain];
    
    /*    UITableView *tableView =  [[UITableView alloc] initWithFrame:CGRectMake(100.0,100.0,300,500) style:UITableViewStyleGrouped ];
     
     tableView.delegate = self;
     tableView.dataSource = self;
     
     self.myTableView = tableView;
     
     //self.view = tableView;
     [self.view addSubview:tableView];
     */  
    myTableView.rowHeight = 50;
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.opaque = NO;
    myTableView.backgroundView = nil;
    
    [self.view addSubview:myTableView];
    
    ItemToBeDeleted = [[NSMutableArray alloc] init];
    indexPaths = [[NSMutableArray alloc] init];
    
	if ([TradOrEver  isEqualToString:@"TRAD"]) {
        lblBasicSA.numberOfLines = 2;
		lblBasicSA.text = @"Sum Assured/\nBenefit";
	}
	else{
		lblBasicSA.text = @"Basic Sum Assured";
	}
	
    dirPaths = Nil;
    docsDir = Nil;
    CustomColor = Nil;
    
    txtSINO.clearButtonMode = UITextFieldViewModeWhileEditing;
    txtLAName.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tap.cancelsTouchesInView = NO;
    tap.numberOfTapsRequired = 1;
    
    [self.view addGestureRecognizer:tap];
    
    
}

-(void)hideKeyboard{
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
}

- (void)LoadAllResult{
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK){
        
		NSString *SIListingSQL;
		if ([TradOrEver isEqualToString:@"TRAD"]) {
			
			SIListingSQL = [NSString stringWithFormat:
                            @"select A.Sino, B.createdAT, name, planname, basicSA, F.Status, A.CustCode, B.SIVersion, B.SIStatus, G.ProspectName "
							" from trad_lapayor as A, trad_details as B, clt_profile as C, trad_sys_profile as D, eProposal as E, eProposal_Status as F, prospect_profile as G, eApp_Listing as H "
							" where A.sino = B.sino and A.CustCode = C.custcode and B.plancode = D.plancode AND A.Sequence = 1 AND A.ptypeCode = \"LA\" AND E.Sino = A.Sino "
                            " AND H.Status = F.StatusCode AND C.IndexNo = G.IndexNo AND E.eproposalNo = H.proposalNo "
							"union "
							"select A.Sino, B.createdAT, name, planname, basicSA, 'Not Created', A.CustCode, B.SIVersion, B.SIStatus, E.ProspectName   from Trad_lapayor as A, "
							"Trad_details as B, clt_profile as C, trad_sys_profile as D, prospect_profile as E  where A.sino = B.sino and A.CustCode = C.custcode and B.plancode = D.plancode "
//                            "AND A.Sequence = 1 AND A.ptypeCode = 'LA' AND C.IndexNo = E.IndexNo "];
							"AND A.Sequence = 1 AND A.ptypeCode = 'LA' AND A.sino not in (select sino from eProposal)  AND C.IndexNo = E.IndexNo "]; 
            
            //if (![txtSINO.text isEqualToString:@""]) {
            if ([txtSINO.text length]>0) {
				SIListingSQL = [SIListingSQL stringByAppendingFormat:@" AND A.Sino like \"%%%@%%\"", txtSINO.text ];
				
			}
			
            //			if (![txtLAName.text isEqualToString:@""]) {
            if ([txtLAName.text length]>0) {
				SIListingSQL = [SIListingSQL stringByAppendingFormat:@" AND name like \"%%%@%%\"", txtLAName.text ];
				
			}
			
            //			if ( ![DBDateFrom isEqualToString:@""]) {
            if ([DBDateFrom length]>0) {
				//SIListingSQL = [SIListingSQL stringByAppendingFormat:@" AND createdAT > \"%@ 00:00:00\" ", outletDateFrom.titleLabel.text ];
				SIListingSQL = [SIListingSQL stringByAppendingFormat:@" AND createdAT > \"%@ 00:00:00\" ", DBDateFrom ];
				
			}
			
            //			if ( ![DBDateTo isEqualToString:@""] ) {
            if ( [DBDateTo length]>0 ) {
				//SIListingSQL = [SIListingSQL stringByAppendingFormat:@" AND createdAt < \"%@ 23:59:59\" ", outletDateTo.titleLabel.text ];
				SIListingSQL = [SIListingSQL stringByAppendingFormat:@" AND createdAt < \"%@ 23:59:59\" ", DBDateTo ];
				
			}
			
//			NSLog(@"%@", SIListingSQL);
			NSString *Sorting = [[NSString alloc] init ];
			Sorting = @"";
			
			if (lblBasicSA.highlighted == TRUE) {
				Sorting = @"basicSA";
			}
			
			if (lblDateCreated.highlighted == TRUE) {
				if ([Sorting isEqualToString:@""]) {
					Sorting = @" createdAt";
				}
				else {
					Sorting = [Sorting stringByAppendingFormat:@",createdAt"];
					
				}
			}
			
			if (lblName.highlighted == TRUE) {
				if ([Sorting isEqualToString:@""]) {
					Sorting = @"name";
				}
				else {
					Sorting = [Sorting stringByAppendingFormat:@",name"];
					
				}
			}
			
			if (lblPlan.highlighted == TRUE) {
				if ([Sorting isEqualToString:@""]) {
					Sorting = @"planname";
				}
				else {
					Sorting = [Sorting stringByAppendingFormat:@",planname"];
					
				}
			}
			
			if (lblSINO.highlighted == TRUE) {
				if ([Sorting isEqualToString:@""]) {
					Sorting = @"A.SINO";
				}
				else {
					Sorting = [Sorting stringByAppendingFormat:@",A.SINO"];
				}
			}
			
			if ([Sorting isEqualToString:@""]) {
                SIListingSQL = [SIListingSQL stringByAppendingFormat:@" order by createdAt Desc" ];
			}
			else {
                if( [OrderBy length]==0 )
                {
                    [self segOrderBy:nil];
                }
				SIListingSQL = [SIListingSQL stringByAppendingFormat:@" order by %@ %@ ", Sorting, OrderBy ];
			}
		}
		else{ //for Ever
			
			SIListingSQL = [NSString stringWithFormat:@"select A.Sino, B.DateCreated, name, planname, basicSA, F.Status, A.CustCode, B.SIVersion, B.SIStatus, G.ProspectName "
							" from UL_lapayor as A, UL_details as B, clt_profile as C, trad_sys_profile as D, eProposal as E, eProposal_Status as F, prospect_profile as G  "
							" where A.sino = B.sino and A.CustCode = C.custcode and B.plancode = D.plancode AND A.Seq = 1 AND A.ptypeCode = \"LA\" "
							"AND E.Sino = B.Sino AND E.Status = F.StatusCode AND C.IndexNo = G.IndexNo "
							"Union "
							"select A.Sino, B.DateCreated, name, planname, basicSA, 'Not Created', A.CustCode, B.SIVersion, B.SIStatus, E.ProspectName from UL_lapayor as A, UL_details as B, "
							"clt_profile as C, trad_sys_profile as D, prospect_profile as E  where A.sino = B.sino and A.CustCode = C.custcode and B.plancode = D.plancode AND A.Seq = 1 AND  "
							"A.ptypeCode = 'LA' AND A.sino not in (select sino from eProposal) AND C.IndexNo = E.IndexNo "];
			
			if (![txtSINO.text isEqualToString:@""]) {
				SIListingSQL = [SIListingSQL stringByAppendingFormat:@" AND A.Sino like \"%%%@%%\"", txtSINO.text ];
				
			}
			
			if (![txtLAName.text isEqualToString:@""]) {
				SIListingSQL = [SIListingSQL stringByAppendingFormat:@" AND name like \"%%%@%%\"", txtLAName.text ];
				
			}
			
			if ( ![DBDateFrom isEqualToString:@""]) {
				
				//SIListingSQL = [SIListingSQL stringByAppendingFormat:@" AND createdAT > \"%@ 00:00:00\" ", outletDateFrom.titleLabel.text ];
				SIListingSQL = [SIListingSQL stringByAppendingFormat:@" AND B.DateCreated > \"%@ 00:00:00\" ", DBDateFrom ];
				
			}
			
			if ( ![DBDateTo isEqualToString:@""] ) {
				
				//SIListingSQL = [SIListingSQL stringByAppendingFormat:@" AND createdAt < \"%@ 23:59:59\" ", outletDateTo.titleLabel.text ];
				SIListingSQL = [SIListingSQL stringByAppendingFormat:@" AND B.DateCreated < \"%@ 23:59:59\" ", DBDateTo ];
				
			}
			
			//NSLog(@"%@", SIListingSQL);
			NSString *Sorting = [[NSString alloc] init ];
			Sorting = @"";
			
			if (lblBasicSA.highlighted == TRUE) {
				Sorting = @"basicSA";
			}
			
			if (lblDateCreated.highlighted == TRUE) {
				if ([Sorting isEqualToString:@""]) {
					Sorting = @" DateCreated";
				}
				else {
					Sorting = [Sorting stringByAppendingFormat:@",DateCreated"];
					
				}
			}
			
			if (lblName.highlighted == TRUE) {
				if ([Sorting isEqualToString:@""]) {
					Sorting = @"name";
				}
				else {
					Sorting = [Sorting stringByAppendingFormat:@",name"];
					
				}
			}
			
			if (lblPlan.highlighted == TRUE) {
				if ([Sorting isEqualToString:@""]) {
					Sorting = @"planname";
				}
				else {
					Sorting = [Sorting stringByAppendingFormat:@",planname"];
					
				}
			}
			
			if (lblSINO.highlighted == TRUE) {
				if ([Sorting isEqualToString:@""]) {
					Sorting = @"A.SINO";
				}
				else {
					Sorting = [Sorting stringByAppendingFormat:@",A.SINO"];
				}
			}
			
			if ([Sorting isEqualToString:@""]) {
                SIListingSQL = [SIListingSQL stringByAppendingFormat:@" order by B.DateCreated Desc" ];
			}
			else {
                if( [OrderBy length]==0 )
                {
                    [self segOrderBy:nil];
                }
				SIListingSQL = [SIListingSQL stringByAppendingFormat:@" order by %@ %@ ", Sorting, OrderBy ];
			}
			
		}
		
		//lianshen
//        SIListingSQL = [SIListingSQL stringByAppendingFormat:@" LIMIT %i, %i ", self.kPageIndex, kPageSize ];
        //end
        
        //const char *SelectSI = [SIListingSQL UTF8String];
        if(sqlite3_prepare_v2(contactDB, [SIListingSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            
            if (SINO.count  == 0) {
                SINO = [[NSMutableArray alloc] init ];
                DateCreated = [[NSMutableArray alloc] init ];
                Name = [[NSMutableArray alloc] init ];
                PlanName = [[NSMutableArray alloc] init ];
                BasicSA = [[NSMutableArray alloc] init ];
                SIStatus = [[NSMutableArray alloc] init ];
                CustomerCode = [[NSMutableArray alloc] init ];
                SIVersion = [[NSMutableArray alloc] init ];
                SIValidStatus = [[NSMutableArray alloc] init ];
            } else {
                [SINO removeAllObjects];
                [DateCreated removeAllObjects];
                [Name removeAllObjects];
                [PlanName removeAllObjects];
                [BasicSA removeAllObjects];
                [SIStatus removeAllObjects];
                [CustomerCode removeAllObjects];
                [SIVersion removeAllObjects];
                [SIValidStatus removeAllObjects];
            }
            
            NSString *SINumber;
            NSString *ItemDateCreated;
            NSString *ItemName;
            NSString *ItemPlanName;
            NSString *ItemBasicSA;
            NSString *ItemStatus;
            NSString *ItemCustomerCode;
            NSString *ItemSIVersion;
            NSString *ItemSIValidStatus;
            while (sqlite3_step(statement) == SQLITE_ROW){
                SINumber = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                ItemDateCreated = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                ItemName = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 9)];
                ItemPlanName = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                ItemBasicSA = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                ItemStatus = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 5)];
                ItemCustomerCode = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 6)];
//				ItemSIVersion;
				if (sqlite3_column_text(statement, 7) == NULL) {
					ItemSIVersion = @"";
				}
				else{
					ItemSIVersion = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 7)];
				}
				
				if (sqlite3_column_text(statement, 8) == NULL) {
					ItemSIValidStatus = @"";
				}	
				else{
					ItemSIValidStatus = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 8)];
				}                
				
                [SINO addObject:SINumber];
                [DateCreated addObject:ItemDateCreated ];
                [Name addObject:ItemName ];
                [PlanName addObject:ItemPlanName ];
                [BasicSA addObject:ItemBasicSA ];
                [SIStatus addObject:ItemStatus];
                [CustomerCode addObject:ItemCustomerCode];
				[SIVersion addObject:ItemSIVersion];
                [SIValidStatus addObject:ItemSIValidStatus];
                
                SINumber = Nil;
                ItemDateCreated = Nil;
                ItemName = Nil;
                ItemPlanName = Nil;
                ItemBasicSA = Nil;
                ItemStatus = Nil;
                ItemCustomerCode = Nil;
				ItemSIVersion = Nil;
                ItemSIValidStatus = Nil;
            }
            
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(contactDB);
        
        SIListingSQL = Nil;
        //Sorting = Nil;
        
        //lianshen
        self.kPageModulo = SINO.count;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        //end
        
    }
    
    if (SINO.count == 0) {
        [outletEdit setTitleColor:[UIColor grayColor] forState:UIControlStateNormal ];
        outletEdit.enabled = FALSE;
    }
    else {
        [outletEdit setTitleColor:[UIColor blackColor] forState:UIControlStateNormal ];
        outletEdit.enabled = TRUE;
    }
    
    statement = Nil;
    dbpath = Nil;
    
    
    //lianshen
    [myTableView reloadData];
//    self.isLoading = NO;
}

- (void)viewDidUnload
{
    [self setTxtSINO:nil];
    [self setTxtLAName:nil];
    [self setOutletDateFrom:nil];
    [self setOutletDateTo:nil];
    [self setBtnSortBy:nil];
    [self setOutletDelete:nil];
    [self setMyTableView:nil];
    
    [self setOutletDone:nil];
    [self setLblSINO:nil];
    [self setLblDateCreated:nil];
    [self setLblName:nil];
    [self setLblPlan:nil];
    [self setLblBasicSA:nil];
    [self setOutletDateFrom:nil];
    [self setOutletGender:nil];
    [self setOutletEdit:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    databasePath = Nil, OrderBy = Nil, lblBasicSA = Nil, lblDateCreated = Nil, lblName = Nil, lblPlan = Nil, lblSINO = Nil;
    contactDB = Nil;
    _SortBy = Nil;
    _Popover = Nil;
    _SIDate = Nil;
    _SIDatePopover = Nil;
    
    ItemToBeDeleted = Nil;
    indexPaths = Nil;
    SINO = Nil;
    DateCreated = Nil;
    Name = Nil;
    PlanName= Nil;
    BasicSA= Nil;
    SIStatus= Nil;
    CustomerCode= Nil;
    SIVersion = Nil;
	SIValidStatus = Nil;
	
    FilteredSINO= Nil;
    FilteredDateCreated= Nil;
    FilteredName= Nil;
    FilteredPlanName= Nil;
    FilteredBasicSA= Nil;
    FilteredSIStatus= Nil;
    FilteredCustomerCode= Nil;
	FilteredSIVersion = Nil;
	FilteredSIValidStatus = Nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if (interfaceOrientation==UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft)
        return YES;
    
    return NO;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;   
}

- (NSInteger)tableView:(UITableView *)myTableView numberOfRowsInSection:(NSInteger)section {
    //return List.count;
    if (isFilter == false) {
        return SINO.count;
    }
    else {
        return FilteredSINO.count;
    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)myTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    /*
     cell.textLabel.text = [[List objectAtIndex:indexPath.row] stringByAppendingFormat:@"                 dsadsa"];
     cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
     */
    
    /*
     cell.detailTextLabel.numberOfLines = 0;
     cell.detailTextLabel.text = @"dasdsadsdadas\ndsadsadsa";
     cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
     */
    //cell.backgroundColor = [UIColor redColor];
    
    
    [[cell.contentView viewWithTag:1001] removeFromSuperview ];
    [[cell.contentView viewWithTag:1002] removeFromSuperview ];
    [[cell.contentView viewWithTag:1003] removeFromSuperview ];
    [[cell.contentView viewWithTag:1004] removeFromSuperview ];
    [[cell.contentView viewWithTag:1005] removeFromSuperview ];
    [[cell.contentView viewWithTag:1006] removeFromSuperview ];
    [[cell.contentView viewWithTag:1007] removeFromSuperview ];
    [[cell.contentView viewWithTag:1008] removeFromSuperview ];
    
    ColorHexCode *CustomColor = [[ColorHexCode alloc]init ];
    
    if (isFilter == false) {
        CGRect frame=CGRectMake(-30,0, 200, 50);
        UILabel *label1=[[UILabel alloc]init];            
        label1.frame=frame;
        label1.text= [SINO objectAtIndex:indexPath.row];
        label1.tag = 1001;
        label1.textAlignment = UITextAlignmentCenter;
        [cell.contentView addSubview:label1];
        
//        NSLog(@"DateCreated length = %d", [DateCreated count]);
//        NSLog(@"lol indexPath.row = %d", indexPath.row);
        
        //label1.backgroundColor = [UIColor lightGrayColor];
        
        CGRect frame2=CGRectMake(170,0, 150, 50);
        UILabel *label2=[[UILabel alloc]init];
        label2.frame=frame2;
        label2.text= [DateCreated objectAtIndex:indexPath.row];
        label2.textAlignment = UITextAlignmentCenter;    
        label2.tag = 1002;
        //label2.backgroundColor = [UIColor grayColor];
        [cell.contentView addSubview:label2];
        
        CGRect frame3=CGRectMake(320,0, 180, 50);
        UILabel *label3=[[UILabel alloc]init];            
        label3.frame=frame3;
        label3.text= [Name objectAtIndex:indexPath.row];
        label3.tag = 1003;
        label3.textAlignment = UITextAlignmentCenter;
        [cell.contentView addSubview:label3];
        //label3.backgroundColor = [UIColor lightGrayColor];
        
        CGRect frame4=CGRectMake(500,0, 150, 50);
        UILabel *label4=[[UILabel alloc]init];
        label4.frame=frame4;
        label4.text= [PlanName objectAtIndex:indexPath.row];
        label4.textAlignment = UITextAlignmentCenter;    
        label4.tag = 1004;
        //label4.backgroundColor = [UIColor grayColor];
        [cell.contentView addSubview:label4];
        
        CGRect frame5=CGRectMake(650,0, 150, 50);
        UILabel *label5=[[UILabel alloc]init];            
        label5.frame=frame5;
        double zzz = [[BasicSA objectAtIndex:indexPath.row] doubleValue ] / (double) 1.00 ;
        //label5.text= [BasicSA objectAtIndex:indexPath.row];
        //label5.text = [NSString stringWithFormat:@"%.2f", zzz ];
		label5.text = [NSString stringWithFormat:@"%.2f\n%@", zzz, [SIValidStatus objectAtIndex:indexPath.row]];
        label5.tag = 1005;
        label5.textAlignment = UITextAlignmentCenter;
		label5.numberOfLines = 2;
        [cell.contentView addSubview:label5];
        
        CGRect frame6=CGRectMake(800,0, 150, 50);
        UILabel *label6=[[UILabel alloc]init];	
        label6.frame=frame6;
        //label6.text= [SIStatus objectAtIndex:indexPath.row];
		label6.text = [NSString stringWithFormat:@"%@\n%@", [SIStatus objectAtIndex:indexPath.row], [SIVersion objectAtIndex:indexPath.row]];
        label6.textAlignment = UITextAlignmentCenter;
        label6.tag = 1006;
		label6.numberOfLines = 2;
        [cell.contentView addSubview:label6];
        
        
        if (indexPath.row % 2 == 0) {
            label1.backgroundColor = [CustomColor colorWithHexString:@"D0D8E8"];
            label2.backgroundColor = [CustomColor colorWithHexString:@"D0D8E8"];
            label3.backgroundColor = [CustomColor colorWithHexString:@"D0D8E8"];
            label4.backgroundColor = [CustomColor colorWithHexString:@"D0D8E8"];
            label5.backgroundColor = [CustomColor colorWithHexString:@"D0D8E8"];
            label6.backgroundColor = [CustomColor colorWithHexString:@"D0D8E8"];
			
            label1.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
            label2.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
            label3.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
            label4.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
            label5.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
            label6.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
			
        }
        else {
            label1.backgroundColor = [CustomColor colorWithHexString:@"E9EDF4"];
            label2.backgroundColor = [CustomColor colorWithHexString:@"E9EDF4"];
            label3.backgroundColor = [CustomColor colorWithHexString:@"E9EDF4"];
            label4.backgroundColor = [CustomColor colorWithHexString:@"E9EDF4"];
            label5.backgroundColor = [CustomColor colorWithHexString:@"E9EDF4"];
            label6.backgroundColor = [CustomColor colorWithHexString:@"E9EDF4"];
            
			
            label1.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
            label2.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
            label3.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
            label4.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
            label5.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
            label6.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
			
            
        }
    }
    else {
        CGRect frame=CGRectMake(0,0, 170, 50);
        UILabel *label1=[[UILabel alloc]init];            
        label1.frame=frame;
        label1.text= [FilteredSINO objectAtIndex:indexPath.row];
        //label1.tag = 1001;
        label1.textAlignment = UITextAlignmentCenter;
        [cell.contentView addSubview:label1];
        label1.backgroundColor = [UIColor lightGrayColor];
        
        CGRect frame2=CGRectMake(170,0, 150, 50);
        UILabel *label2=[[UILabel alloc]init];
        label2.frame=frame2;
        label2.text= [FilteredDateCreated objectAtIndex:indexPath.row];
        label2.textAlignment = UITextAlignmentCenter;    
        //label2.tag = 1002;
        //label2.backgroundColor = [UIColor grayColor];
        [cell.contentView addSubview:label2];
        
        CGRect frame3=CGRectMake(320,0, 180, 50);
        UILabel *label3=[[UILabel alloc]init];            
        label3.frame=frame3;
        label3.text= [FilteredName objectAtIndex:indexPath.row];
        //label3.tag = 1003;
        label3.textAlignment = UITextAlignmentCenter;
        [cell.contentView addSubview:label3];
        //label3.backgroundColor = [UIColor lightGrayColor];
        
        CGRect frame4=CGRectMake(500,0, 150, 50);
        UILabel *label4=[[UILabel alloc]init];
        label4.frame=frame4;
        label4.text= [FilteredPlanName objectAtIndex:indexPath.row];
        label4.textAlignment = UITextAlignmentCenter;    
        //label4.tag = 1004;
        //label4.backgroundColor = [UIColor grayColor];
        [cell.contentView addSubview:label4];
        
        CGRect frame5=CGRectMake(650,0, 150, 50);
        UILabel *label5=[[UILabel alloc]init];            
        label5.frame=frame5;
        label5.text= [FilteredBasicSA objectAtIndex:indexPath.row];
        //label5.tag = 1005;
        label5.textAlignment = UITextAlignmentCenter;
        [cell.contentView addSubview:label5];
        //label5.backgroundColor = [UIColor lightGrayColor];
        
        
        CGRect frame6=CGRectMake(800,0, 150, 50);
        UILabel *label6=[[UILabel alloc]init];
        label6.frame=frame6;
        label6.text= [FilteredSIStatus objectAtIndex:indexPath.row];
        label6.textAlignment = UITextAlignmentCenter;
        //        label6.tag = 1006;
        //label6.backgroundColor = [UIColor grayColor];
        [cell.contentView addSubview:label6];
        
		
        if (indexPath.row % 2 == 0) {
            label1.backgroundColor = [CustomColor colorWithHexString:@"D0D8E8"];
            label2.backgroundColor = [CustomColor colorWithHexString:@"D0D8E8"];
            label3.backgroundColor = [CustomColor colorWithHexString:@"D0D8E8"];
            label4.backgroundColor = [CustomColor colorWithHexString:@"D0D8E8"];
            label5.backgroundColor = [CustomColor colorWithHexString:@"D0D8E8"];
            label6.backgroundColor = [CustomColor colorWithHexString:@"D0D8E8"];
            
            label1.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
            label2.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
            label3.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
            label4.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
            label5.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
            label6.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
        }
        else {
            label1.backgroundColor = [CustomColor colorWithHexString:@"E9EDF4"];
            label2.backgroundColor = [CustomColor colorWithHexString:@"E9EDF4"];
            label3.backgroundColor = [CustomColor colorWithHexString:@"E9EDF4"];
            label4.backgroundColor = [CustomColor colorWithHexString:@"E9EDF4"];
            label5.backgroundColor = [CustomColor colorWithHexString:@"E9EDF4"];
            label6.backgroundColor = [CustomColor colorWithHexString:@"E9EDF4"];
            
            label1.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
            label2.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
            label3.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
            label4.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
            label5.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
            label6.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
        }
    }
    //[cell setSelected:NO animated:NO];
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
    
    CustomColor = Nil;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   /*
     UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
     
     UIView *selectionView = [[UIView alloc]initWithFrame:cell.bounds];
     
     [selectionView setBackgroundColor:[UIColor clearColor]];
     
     cell.selectedBackgroundView = selectionView;
     */
    //    [myTableView deselectRowAtIndexPath:indexPath animated:NO];
    if ([myTableView isEditing] == TRUE ) {
        BOOL gotRowSelected = FALSE;
        
        for (UITableViewCell *zzz in [myTableView visibleCells]) {
            
            if (zzz.selected  == TRUE) {
                gotRowSelected = TRUE;
                break;
            }
            
        }
        
        if (!gotRowSelected) {
            [outletDelete setTitleColor:[UIColor grayColor] forState:UIControlStateNormal ];
            outletDelete.enabled = FALSE;
        }
        else {
            [outletDelete setTitleColor:[UIColor blackColor] forState:UIControlStateNormal ];
            outletDelete.enabled = TRUE;
        }
        
        NSString *zzz = [NSString stringWithFormat:@"%d", indexPath.row];
        [ItemToBeDeleted addObject:zzz];
        [indexPaths addObject:indexPath];
        zzz = Nil;
        
        
    }
    else {
        
        AppDelegate *MenuOption= (AppDelegate*)[[UIApplication sharedApplication] delegate ];
        
        MainScreen *main = [self.storyboard instantiateViewControllerWithIdentifier:@"Main"];
        //main.modalPresentationStyle = UIModalPresentationPageSheet;
        //        main.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
		
		//main.tradOrEver = @"TRAD";
		//main.tradOrEver = @"EVER";
		main.tradOrEver = TradOrEver;
        main.IndexTab = MenuOption.NewSIIndex ;
        main.requestSINo = [SINO objectAtIndex:indexPath.row];
        
		[self presentViewController:main animated:NO completion:nil];
		
		MenuOption = Nil;
        main = Nil;
        
        /*
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
         
         EverLifeViewController *Report; 
         Report = [[EverLifeViewController alloc] init ];
         Report.SINo = [SINO objectAtIndex:indexPath.row];
         Report.SimpleOrDetail = @"Detail";
         Report.CheckSustainLevel = @"2";
         Report.NeedFurtherInfo = @"YES";
         
         [self presentViewController:Report animated:NO completion:Nil];
         
         dispatch_async(dispatch_get_main_queue(), ^{
         [Report dismissViewControllerAnimated:NO completion:Nil];
         
         NSString *path;
         
         if ([EngOrBm isEqualToString:@"English"]) {
         
         path = [[NSBundle mainBundle] pathForResource:@"EverLife_SI/Page1" ofType:@"html"];
         }
         else{
         
         path = [[NSBundle mainBundle] pathForResource:@"EverLife_SI_BM/Page1" ofType:@"html"];
         }
         
         NSURL *pathURL = [NSURL fileURLWithPath:path];
         NSArray* path_forDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
         NSString* documentsDirectory = [path_forDirectory objectAtIndex:0];
         
         NSData* data = [NSData dataWithContentsOfURL:pathURL];
         [data writeToFile:[NSString stringWithFormat:@"%@/SI_Temp.html",documentsDirectory] atomically:YES];
         
         NSString *HTMLPath = [documentsDirectory stringByAppendingPathComponent:@"SI_Temp.html"];
         
         
         if([[NSFileManager defaultManager] fileExistsAtPath:HTMLPath]) {
         NSURL *targetURL = [NSURL fileURLWithPath:HTMLPath];
         
         
         
         NSString *SIPDFName = [NSString stringWithFormat:@"Forms/_%@.pdf", [SINO objectAtIndex:indexPath.row]];
         self.PDFCreator = [NDHTMLtoPDF exportPDFWithURL:targetURL
         pathForPDF:[documentsDirectory stringByAppendingPathComponent:SIPDFName]
         delegate:self
         pageSize:kPaperSizeA4
         margins:UIEdgeInsetsMake(0, 0, 0, 0)
         ];
         
         
         
         }
         
         });
         
         
         });
         */  
    }
    
}

-(void)HTMLtoPDFDidSucceed:(NDHTMLtoPDF *)htmlToPDF{
    
}

-(void)HTMLtoPDFDidFail:(NDHTMLtoPDF *)htmlToPDF{
    
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([myTableView isEditing] == TRUE ) {
        BOOL gotRowSelected = FALSE;
        
        for (UITableViewCell *zzz in [myTableView visibleCells]) {
            
            if (zzz.selected  == TRUE) {
                gotRowSelected = TRUE;
                break;
            }
            
        }
        
        if (!gotRowSelected) {
            [outletDelete setTitleColor:[UIColor grayColor] forState:UIControlStateNormal ];
            outletDelete.enabled = FALSE;
        }
        else {
            [outletDelete setTitleColor:[UIColor blackColor] forState:UIControlStateNormal ];
            outletDelete.enabled = TRUE;
        }
        
        NSString *zzz = [NSString stringWithFormat:@"%d", indexPath.row];
        [ItemToBeDeleted removeObject:zzz];
        [indexPaths removeObject:indexPath];
        
        zzz = Nil;
    }
}

- (IBAction)btnDateFrom:(id)sender {
    /*outletDate.hidden = false;
     outletDone.hidden = false;
     outletDate.tag = 1;
     */
    
    /*
     if ([DBDateFrom isEqualToString:@""]) {
     NSDateFormatter* df = [[NSDateFormatter alloc] init];
     [df setDateFormat:@"MM/dd/yyyy"];
     //NSString* d = [df stringFromDate:[[NSDate date] dateByAddingTimeInterval:3600*8]];    
     NSString* d = [df stringFromDate:[NSDate date]];    
     [outletDateFrom setTitle:d forState:UIControlStateNormal];
     DBDateFrom = d;
     }
     */
    
    DateOption = 1;
    if (_SIDate == Nil) {
        
        self.SIDate = [self.storyboard instantiateViewControllerWithIdentifier:@"SIDate"];
        _SIDate.delegate = self;
        self.SIDatePopover = [[UIPopoverController alloc] initWithContentViewController:_SIDate];
    }
    
    [self.SIDatePopover setPopoverContentSize:CGSizeMake(300.0f, 255.0f)];
    [self.SIDatePopover presentPopoverFromRect:[sender frame ]  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    
}
- (IBAction)btnDateTo:(id)sender {
    //outletDate.hidden = false;
    //outletDone.hidden = false;
    
    
    /*
     if ([DBDateTo isEqualToString:@""]) {
     NSDateFormatter* df = [[NSDateFormatter alloc] init];
     [df setDateFormat:@"dd/MM/yyyy"];
     //NSString* d = [df stringFromDate:[[NSDate date] dateByAddingTimeInterval:3600*8]];    
     NSString* d = [df stringFromDate:[NSDate date]];    
     
     [outletDateTo setTitle:d forState:UIControlStateNormal];
     DBDateTo = d;
     }
     */
    
    DateOption = 2;
    if (_SIDate == Nil) {
        
        self.SIDate = [self.storyboard instantiateViewControllerWithIdentifier:@"SIDate"];
        _SIDate.delegate = self;
        self.SIDatePopover = [[UIPopoverController alloc] initWithContentViewController:_SIDate];
    }
    
    [self.SIDatePopover setPopoverContentSize:CGSizeMake(300.0f, 255.0f)];
    [self.SIDatePopover presentPopoverFromRect:[sender frame ]  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}
- (IBAction)segOrderBy:(id)sender {
    if (outletGender.selectedSegmentIndex == 0) {
        OrderBy = @"ASC";
    }
    else {
        OrderBy = @"DESC";
    }
    
}

#pragma mark - Button Action

- (IBAction)btnSearch:(id)sender {
    
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    //isFilter = true;
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate* d = [df dateFromString:DBDateFrom];
    NSDate* d2 = [df dateFromString:DBDateTo];
    
    if ([ d compare:d2] == NSOrderedDescending) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" "
                                                        message:@"Date To cannot be greater than Date From" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil ];
        [alert show ];
    }
    else {
        
        NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docsDir = [dirPaths objectAtIndex:0];
        databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
        
        sqlite3_stmt *statement;
        const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK){
			NSString *SIListingSQL;
			if ([TradOrEver isEqualToString:@"TRAD"]) {
                //				SIListingSQL = [NSString stringWithFormat:@"select A.Sino, E.CreatedAT, name, planname, basicSA, F.statusCode, A.CustCode "
                SIListingSQL = [NSString stringWithFormat:@"select A.Sino, B.CreatedAT, C.name, planname, basicSA, F.status, A.CustCode, G.ProspectName "
                                " from trad_lapayor as A, trad_details as B, clt_profile as C, trad_sys_profile as D, eProposal as E, eProposal_Status as F, prospect_profile as G, eApp_Listing as H   "
                                " where A.sino = B.sino and A.CustCode = C.custcode and B.plancode = D.plancode AND A.Sequence = 1 AND A.ptypeCode = \"LA\"  "
                                "AND H.Status = F.statusCode AND E.sino = A.sino AND C.IndexNo = G.IndexNo AND E.eproposalNo = H.proposalNo   " ];
			}
			else{
				SIListingSQL = [NSString stringWithFormat:@"select A.Sino, B.DateCreated, C.name, planname, basicSA, F.status, A.CustCode, G.ProspectName "
								" from UL_lapayor as A, UL_details as B, clt_profile as C, trad_sys_profile as D, eProposal as E, eProposal_Status as F, prospect_profile as G"
								" where A.sino = B.sino and A.CustCode = C.custcode and B.plancode = D.plancode AND A.Seq = 1 AND A.ptypeCode = \"LA\" "
								"AND F.statusCode = E.Status AND E.sino = A.sino AND C.IndexNo = G.IndexNo  " ];
			}
            
            if (![txtSINO.text isEqualToString:@""]) {
                SIListingSQL = [SIListingSQL stringByAppendingFormat:@" AND A.Sino like \"%%%@%%\"", txtSINO.text ];
                
            }
            
            if (![txtLAName.text isEqualToString:@""]) {
                SIListingSQL = [SIListingSQL stringByAppendingFormat:@" AND name like \"%%%@%%\"", txtLAName.text ];
                
            }
            
            if ( ![DBDateFrom isEqualToString:@""]) {
                
                //SIListingSQL = [SIListingSQL stringByAppendingFormat:@" AND createdAT > \"%@ 00:00:00\" ", outletDateFrom.titleLabel.text ];
				if ([TradOrEver isEqualToString:@"TRAD"]) {
                    SIListingSQL = [SIListingSQL stringByAppendingFormat:@" AND E.createdAT > \"%@ 00:00:00\" ", DBDateFrom ];
				}
				else{
                    SIListingSQL = [SIListingSQL stringByAppendingFormat:@" AND B.DateCreated > \"%@ 00:00:00\" ", DBDateFrom ];
				}
                
            }
            
            if ( ![DBDateTo isEqualToString:@""] ) {
                
                //SIListingSQL = [SIListingSQL stringByAppendingFormat:@" AND createdAt < \"%@ 23:59:59\" ", outletDateTo.titleLabel.text ];
                
				if ([TradOrEver isEqualToString:@"TRAD"]) {
					SIListingSQL = [SIListingSQL stringByAppendingFormat:@" AND E.createdAt < \"%@ 23:59:59\" ", DBDateTo ];
				}
				else{
					SIListingSQL = [SIListingSQL stringByAppendingFormat:@" AND B.DateCreated < \"%@ 23:59:59\" ", DBDateTo ];
				}
                
            }
            
			if ([TradOrEver isEqualToString:@"TRAD"]) {
				SIListingSQL = [SIListingSQL stringByAppendingFormat:@"Union select A.Sino, CreatedAT, name, planname, basicSA, 'Not Created', A.CustCode, E.ProspectName  "
								" from trad_lapayor as A, trad_details as B, clt_profile as C, trad_sys_profile as D, prospect_profile as E   "
								" where A.sino = B.sino and A.CustCode = C.custcode and B.plancode = D.plancode AND A.Sequence = 1 AND A.ptypeCode = \"LA\" AND C.IndexNo = E.IndexNo AND A.sino not in (select sino from eProposal) "];
			}
			else{
				SIListingSQL = [SIListingSQL stringByAppendingFormat:@"Union select A.Sino, B.DateCreated, name, planname, basicSA, 'Not Created' , A.CustCode, E.ProspectName "
								" from UL_lapayor as A, UL_details as B, clt_profile as C, trad_sys_profile as D, prospect_profile as E "
								" where A.sino = B.sino and A.CustCode = C.custcode and B.plancode = D.plancode AND A.Seq = 1 AND A.ptypeCode = \"LA\" AND C.IndexNo = E.IndexNo " ];
			}
            
            if (![txtSINO.text isEqualToString:@""]) {
                SIListingSQL = [SIListingSQL stringByAppendingFormat:@" AND A.Sino like \"%%%@%%\"", txtSINO.text ];
                
            }
            
            if (![txtLAName.text isEqualToString:@""]) {
                SIListingSQL = [SIListingSQL stringByAppendingFormat:@" AND name like \"%%%@%%\"", txtLAName.text ];
                
            }
            
            if ( ![DBDateFrom isEqualToString:@""]) {
                
                //SIListingSQL = [SIListingSQL stringByAppendingFormat:@" AND createdAT > \"%@ 00:00:00\" ", outletDateFrom.titleLabel.text ];
				if ([TradOrEver isEqualToString:@"TRAD"]) {
					SIListingSQL = [SIListingSQL stringByAppendingFormat:@" AND createdAT > \"%@ 00:00:00\" ", DBDateFrom2 ];
				}
				else{
					SIListingSQL = [SIListingSQL stringByAppendingFormat:@" AND B.DateCreated > \"%@ 00:00:00\" ", DBDateFrom ];
				}
                
            }
            
            if ( ![DBDateTo isEqualToString:@""] ) {
                
                //SIListingSQL = [SIListingSQL stringByAppendingFormat:@" AND createdAt < \"%@ 23:59:59\" ", outletDateTo.titleLabel.text ];
                
				if ([TradOrEver isEqualToString:@"TRAD"]) {
					SIListingSQL = [SIListingSQL stringByAppendingFormat:@" AND createdAt < \"%@ 23:59:59\" ", DBDateTo2 ];
				}
				else{
					SIListingSQL = [SIListingSQL stringByAppendingFormat:@" AND B.DateCreated < \"%@ 23:59:59\" ", DBDateTo ];
				}
                
            }
			
            NSLog(@"%@", SIListingSQL);
			
            NSString *Sorting = [[NSString alloc] init ];
            Sorting = @"";
            
            if (lblBasicSA.highlighted == TRUE) {
                Sorting = @"basicSA";
            }
            
            if (lblDateCreated.highlighted == TRUE) {
                if ([Sorting isEqualToString:@""]) {
					if ([TradOrEver isEqualToString:@"TRAD"]) {
						Sorting = @" createdAt";
					}
					else{
						Sorting = @" DateCreated";
					}
                    
                }
                else {
					if ([TradOrEver isEqualToString:@"TRAD"]) {
						Sorting = [Sorting stringByAppendingFormat:@",createdAt"];
					}
					else{
						Sorting = [Sorting stringByAppendingFormat:@",DateCreated"];
					}
                }
            }
            
            if (lblName.highlighted == TRUE) {
                if ([Sorting isEqualToString:@""]) {
                    Sorting = @"name";
                }
                else {
                    Sorting = [Sorting stringByAppendingFormat:@",name"];
                    
                }
            }
            
            if (lblPlan.highlighted == TRUE) {
                if ([Sorting isEqualToString:@""]) {
                    Sorting = @"planname";
                }
                else {
                    Sorting = [Sorting stringByAppendingFormat:@",planname"];
                    
                }
            }
            
            if (lblSINO.highlighted == TRUE) {
                if ([Sorting isEqualToString:@""]) {
                    Sorting = @"A.SINO";
                }
                else {
                    Sorting = [Sorting stringByAppendingFormat:@",A.SINO"];
                }
            }
            
            if ([Sorting isEqualToString:@""]) {
                //SIListingSQL = [SIListingSQL stringByAppendingFormat:@"", Sorting ];
                
            }
            else {
                if( [OrderBy length]==0 )
                {
                    [self segOrderBy:nil];
                }
                
                SIListingSQL = [SIListingSQL stringByAppendingFormat:@" order by %@ %@ ", Sorting, OrderBy ];
            }
            
            NSLog(@"%@", SIListingSQL);
			
            const char *SelectSI = [SIListingSQL UTF8String];
            if(sqlite3_prepare_v2(contactDB, SelectSI, -1, &statement, NULL) == SQLITE_OK) {
                
                
                SINO = nil;
                DateCreated = nil;
                Name = nil;
                PlanName = nil;
                BasicSA = nil;
                SIStatus = nil;
                CustomerCode = nil;
                
                SINO = [[NSMutableArray alloc] init ];
                DateCreated = [[NSMutableArray alloc] init ];
                Name = [[NSMutableArray alloc] init ];
                PlanName = [[NSMutableArray alloc] init ];
                BasicSA = [[NSMutableArray alloc] init ];
                SIStatus = [[NSMutableArray alloc] init ];
                CustomerCode = [[NSMutableArray alloc] init ]; 
                
                /*
                 FilteredSINO = [[NSMutableArray alloc] init ];
                 FilteredDateCreated = [[NSMutableArray alloc] init ];
                 FilteredName = [[NSMutableArray alloc] init ];
                 FilteredPlanName = [[NSMutableArray alloc] init ];
                 FilteredBasicSA = [[NSMutableArray alloc] init ];
                 FilteredSIStatus = [[NSMutableArray alloc] init ];
                 FilteredCustomerCode = [[NSMutableArray alloc] init ];
                 */
                
                while (sqlite3_step(statement) == SQLITE_ROW){
                    NSString *SINumber = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                    NSString *ItemDateCreated = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                    //NSString *ItemName = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                    NSString *ItemName = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 7)];
                    NSString *ItemPlanName = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                    NSString *ItemBasicSA = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                    NSString *ItemStatus = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 5)];
                    NSString *ItemCustomerCode = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 6)];
                    
                    /*
                     [FilteredSINO addObject:SINumber];
                     [FilteredDateCreated addObject:ItemDateCreated ];
                     [FilteredName addObject:ItemName ];
                     [FilteredPlanName addObject:ItemPlanName ];
                     [FilteredBasicSA addObject:ItemBasicSA ];
                     [FilteredSIStatus addObject:ItemStatus];
                     [FilteredCustomerCode addObject:ItemCustomerCode];
                     */
                    
                    [SINO addObject:SINumber];
                    [DateCreated addObject:ItemDateCreated ];
                    [Name addObject:ItemName ];
                    [PlanName addObject:ItemPlanName ];
                    [BasicSA addObject:ItemBasicSA ];
                    [SIStatus addObject:ItemStatus];
                    [CustomerCode addObject:ItemCustomerCode];
                    
                    SINumber = Nil;
                    ItemDateCreated = Nil;
                    ItemName = Nil;
                    ItemPlanName = Nil;
                    ItemBasicSA = Nil;
                    ItemStatus = Nil;
                    ItemCustomerCode = Nil;
                    
                }
                
                sqlite3_finalize(statement);
                
                SIListingSQL = Nil;
                Sorting = Nil;
            }
            else {
                
                //NSLog(@"%@", SIListingSQL);
            }
            
            sqlite3_close(contactDB);
            
            
        }
        else {
            NSLog(@"cannot open DB");
        }
        
        dirPaths = Nil;
        docsDir = Nil;
        statement = Nil;
        dbpath = Nil;
        statement = Nil;
        
        //isFilter = TRUE;
        if (SINO.count == 0) {
            outletEdit.enabled = FALSE;
            [outletEdit setTitleColor:[UIColor grayColor] forState:UIControlStateNormal ];
        }
        else {
            
            [outletEdit setTitleColor:[UIColor blackColor] forState:UIControlStateNormal ];
            outletEdit.enabled = TRUE;
        }
        
        [myTableView reloadData];
    }
    
    df = Nil;
    d = Nil;
    d2 = Nil;
}

- (IBAction)btnEdit:(id)sender {
    if ([self.myTableView isEditing]) {
        [self.myTableView setEditing:NO animated:TRUE];
        outletDelete.hidden = true;
        [outletEdit setTitle:@"Delete" forState:UIControlStateNormal ];
        
        if (SINO.count == 0) {
            outletEdit.enabled = FALSE;
            [outletEdit setTitleColor:[UIColor grayColor] forState:UIControlStateNormal ];
        }
        else {
            [outletEdit setTitleColor:[UIColor blackColor] forState:UIControlStateNormal ];
            outletEdit.enabled = TRUE;
        }
    }
    else{
        [self.myTableView setEditing:YES animated:TRUE]; 
        outletDelete.hidden = FALSE;
        [outletDelete setTitleColor:[UIColor grayColor] forState:UIControlStateNormal ];
        [outletEdit setTitle:@"Cancel" forState:UIControlStateNormal ];
    }
}

#pragma mark - Others

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 1) {
        
        if (buttonIndex == 0) {
            //NSArray *visibleCells = [myTableView visibleCells];
            
            
            /*
             NSMutableArray *ItemToBeDeleted = [[NSMutableArray alloc] init];
             NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
             
             for (UITableViewCell *cell in visibleCells) {
             //[myTableView beginUpdates];
             if (cell.selected) {
             NSIndexPath *indexPath = [myTableView indexPathForCell:cell];
             
             NSString *zzz = [NSString stringWithFormat:@"%d", indexPath.row];
             [ItemToBeDeleted addObject:zzz];
             [indexPaths addObject:indexPath];
             }
             //[myTableView endUpdates];
             }
             */
            
            if (ItemToBeDeleted.count < 1) {
				
                return;
            }
            else{
                NSLog(@"%d", ItemToBeDeleted.count);
            }
            
            NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *docsDir = [dirPaths objectAtIndex:0];
            databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
            
            sqlite3_stmt *statement;
            sqlite3_stmt *statement2;
            sqlite3_stmt *statement3;
            const char *dbpath = [databasePath UTF8String];
            NSArray *sorted = [[NSArray alloc] init ];
            
            sorted = [ItemToBeDeleted sortedArrayUsingComparator:^(id firstObject, id secondObject){
                return [((NSString *)firstObject) compare:((NSString *)secondObject) options:NSNumericSearch];
            }];
            
            
            if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK){
                for(int a=0; a<sorted.count; a++){
                    int value = [[sorted objectAtIndex:a] intValue];
                    
                    value = value - a;
                    
                    
                    NSString *DeleteLAPayorSQL;
                    if (isFilter == false) {
						if ([TradOrEver isEqualToString:@"TRAD"]) {
							DeleteLAPayorSQL = [NSString stringWithFormat:@"Delete from "
												" trad_lapayor where custcode = \"%@\" ", [CustomerCode objectAtIndex:value]];
						}
						else{
							DeleteLAPayorSQL = [NSString stringWithFormat:@"Delete from "
												" UL_lapayor where custcode = \"%@\" ", [CustomerCode objectAtIndex:value]];
						}
                        
                    }
                    else{
						if ([TradOrEver isEqualToString:@"TRAD"]) {
							DeleteLAPayorSQL = [NSString stringWithFormat:@"Delete from "
												" trad_lapayor where custcode = \"%@\" ", [FilteredCustomerCode objectAtIndex:value]];
						}
						else{
							DeleteLAPayorSQL = [NSString stringWithFormat:@"Delete from "
												" UL_lapayor where custcode = \"%@\" ", [FilteredCustomerCode objectAtIndex:value]];
						}
                        
                    }
                    
                    if(sqlite3_prepare_v2(contactDB, [DeleteLAPayorSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                        
                        int zzz = sqlite3_step(statement);
                        if (zzz == SQLITE_DONE) {
                            
                        }
                        sqlite3_finalize(statement);
                    }
                    
                    NSString *DeleteCltProfileSQL;
                    if (isFilter == FALSE) {
                        DeleteCltProfileSQL = [NSString stringWithFormat:@"Delete from clt_Profile where custcode = \"%@\" ", [CustomerCode objectAtIndex:value]];
                    }
                    else{
                        DeleteCltProfileSQL = [NSString stringWithFormat:@"Delete from clt_Profile where custcode = \"%@\" ", [FilteredCustomerCode objectAtIndex:value]];
                    }
                    
                    if(sqlite3_prepare_v2(contactDB, [DeleteCltProfileSQL UTF8String], -1, &statement2, NULL) == SQLITE_OK) {
                        int zzz = sqlite3_step(statement2);
                        if (zzz == SQLITE_DONE) {
                            
                        }
                        sqlite3_finalize(statement2);
                    }
					
					NSString *query;
                    
					if (isFilter == FALSE) {
						if ([TradOrEver isEqualToString:@"TRAD"]) {
							query = [NSString stringWithFormat:@"Delete from clt_profile where custcode = (Select custcode from Trad_LApayor where SINO = \"%@\" AND PTypeCode = 'LA' AND Sequence = '2') ", [SINO objectAtIndex:value]];
						}
						else{
							query = [NSString stringWithFormat:@"Delete from clt_profile where custcode = (Select custcode from UL_lapayor where SINO = \"%@\" AND PTypeCode = 'LA' AND Seq = '2' )", [SINO objectAtIndex:value]];
						}
					}
					else{
						if ([TradOrEver isEqualToString:@"TRAD"]) {
							query = [NSString stringWithFormat:@"Delete from clt_profile where custcode = (Select custcode from Trad_lapayor where SINO = \"%@\" AND PTypeCode = 'LA' AND Sequence = '2') ", [FilteredSINO objectAtIndex:value]];
						}
						else{
							query = [NSString stringWithFormat:@"Delete from clt_profile where custcode = (Select custcode from UL_lapayor where SINO = \"%@\" AND PTypeCode = 'LA' AND Seq = '2') ", [FilteredSINO objectAtIndex:value]];
						}
					}
					
					if(sqlite3_prepare_v2(contactDB, [query UTF8String], -1, &statement2, NULL) == SQLITE_OK) {
                        
                        if (sqlite3_step(statement2) == SQLITE_DONE) {
                            
                        }
                        
                        sqlite3_finalize(statement2);
                    }
                    
					if (isFilter == FALSE) {
						if ([TradOrEver isEqualToString:@"TRAD"]) {
							query = [NSString stringWithFormat:@"Delete from clt_profile where custcode = (Select custcode from Trad_LApayor where SINO = \"%@\" AND PTypeCode = 'PY') ", [SINO objectAtIndex:value]];
						}
						else{
							query = [NSString stringWithFormat:@"Delete from clt_profile where custcode = (Select custcode from UL_lapayor where SINO = \"%@\" AND PTypeCode = 'PY') ", [SINO objectAtIndex:value]];
						}
					}
					else{
						if ([TradOrEver isEqualToString:@"TRAD"]) {
							query = [NSString stringWithFormat:@"Delete from clt_profile where custcode = (Select custcode from Trad_lapayor where SINO = \"%@\" AND PTypeCode = 'PY') ", [FilteredSINO objectAtIndex:value]];
						}
						else{
							query = [NSString stringWithFormat:@"Delete from clt_profile where custcode = (Select custcode from UL_lapayor where SINO = \"%@\" AND PTypeCode = 'PY') ", [FilteredSINO objectAtIndex:value]];
						}
					}
					
					if(sqlite3_prepare_v2(contactDB, [query UTF8String], -1, &statement2, NULL) == SQLITE_OK) {
                        
                        if (sqlite3_step(statement2) == SQLITE_DONE) {
                            
                        }
                        sqlite3_finalize(statement2);
                    }
                    
                    
                    
                    NSString *DeleteTradDetailsSQL;
                    MasterMenuEApp *rrr = [[MasterMenuEApp alloc] init];
                    if (isFilter == FALSE) {
                        
                        DeleteTradDetailsSQL = [NSString stringWithFormat:@"Delete from "
                                                " Trad_Details where SINo = \"%@\" ", [SINO objectAtIndex:value]];
                        
                        if (deleteOption == 101) {
                            [rrr deleteEAppCase:[SINO objectAtIndex:value]];
                        }
                        else if (deleteOption == 102) {
                            //[rrr deleteEAppCase:[SINO objectAtIndex:value]];
                        }
                        else if (deleteOption == 103) {
                            if ([[SIStatus objectAtIndex:value] isEqualToString:@"Created"] || [[SIStatus objectAtIndex:value] isEqualToString:@"Confirmed"] ) {
                                [rrr deleteEAppCase:[SINO objectAtIndex:value]];
                            }

                        }
                        
                    }
                    else {
                        //[rrr deleteEAppCase:[FilteredSINO objectAtIndex:value]];
                        
                        DeleteTradDetailsSQL = [NSString stringWithFormat:@"Delete from "
                                                " Trad_Details where SINo = \"%@\" ", [FilteredSINO objectAtIndex:value]];
                        
                        if (deleteOption == 101) {
                            [rrr deleteEAppCase:[FilteredSINO objectAtIndex:value]];
                        }
                        else if (deleteOption == 102) {
                            //[rrr deleteEAppCase:[SINO objectAtIndex:value]];
                        }
                        else if (deleteOption == 103) {
                            if ([[SIStatus objectAtIndex:value] isEqualToString:@"Created"] || [[SIStatus objectAtIndex:value] isEqualToString:@"Confirmed"] ) {
                                [rrr deleteEAppCase:[FilteredSINO objectAtIndex:value]];
                            }
                            
                        }

                        

                    }
                    
                    if (sqlite3_prepare_v2(contactDB, [DeleteTradDetailsSQL UTF8String], -1, &statement3, NULL) == SQLITE_OK) {
                        int zzz = sqlite3_step(statement3);
                        if (zzz == SQLITE_DONE) {
                            NSLog(@"Trad_Details deleted");
                        }
                        sqlite3_finalize(statement3);
                    }
                    
                    if (isFilter == FALSE) {
                        [SINO removeObjectAtIndex:value];
                        [DateCreated removeObjectAtIndex:value];
                        [Name removeObjectAtIndex:value];
                        [PlanName removeObjectAtIndex:value];
                        [BasicSA removeObjectAtIndex:value];
                        [SIStatus removeObjectAtIndex:value];
                        [CustomerCode removeObjectAtIndex:value];
                    }
                    else{
                        [FilteredSINO removeObjectAtIndex:value];
                        [FilteredDateCreated removeObjectAtIndex:value];
                        [FilteredName removeObjectAtIndex:value];
                        [FilteredPlanName removeObjectAtIndex:value];
                        [FilteredBasicSA removeObjectAtIndex:value];
                        [FilteredSIStatus removeObjectAtIndex:value];
                        [FilteredCustomerCode removeObjectAtIndex:value];
                    }
                    
                    
                    
                    DeleteLAPayorSQL = Nil;
                    DeleteCltProfileSQL = Nil;
                    DeleteTradDetailsSQL = Nil;
                    rrr = Nil;
                    
                }
                sqlite3_close(contactDB);
            }
            
            [myTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            
            [self.myTableView reloadData];
            if(SINO.count == 0){
                outletDelete.hidden = TRUE;
                outletEdit.hidden = FALSE;
                [outletEdit setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [outletEdit setTitle:@"Delete" forState:UIControlStateNormal];
            }
            
            //action performed after deletion success
            outletDelete.enabled = FALSE;
            [outletDelete setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
            ItemToBeDeleted = [[NSMutableArray alloc] init];
            indexPaths = [[NSMutableArray alloc] init];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"SI has been successfully deleted" delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
            [alert show];
            
            dirPaths = Nil;
            docsDir = Nil;
            statement = Nil;
            statement2 = Nil;
            statement3 = Nil;
            dbpath = Nil;
            sorted = Nil;
            
        }
        
    }
    
}


- (IBAction)btnDelete:(id)sender {
    
    int RecCount = 0;
    NSString *FirstSINo;
    bool bCreated = FALSE, bConfirmed = FALSE, bSubmitted = FALSE, bReceived = FALSE, bFailed = FALSE, bNotCreated = FALSE;
    
    for (UITableViewCell *zzz in [myTableView visibleCells]) {
        
        if (zzz.selected  == TRUE) {
            NSIndexPath *selectedIndexPath =  [myTableView indexPathForCell:zzz];
            if (RecCount == 0) {
                FirstSINo = [SINO objectAtIndex:selectedIndexPath.row];
            }
            
            RecCount = RecCount + 1;
            
            if (RecCount > 1) {
                break;
            }
            
            selectedIndexPath = Nil;
        }
        
    }
    
    for (UITableViewCell *zzz in [myTableView visibleCells]) {
        
        if (zzz.selected  == TRUE) {
            NSIndexPath *selectedIndexPath =  [myTableView indexPathForCell:zzz];
            
            if([[SIStatus objectAtIndex:selectedIndexPath.row] isEqualToString:@"Created"]){
                bCreated = TRUE;
            }
            else if([[SIStatus objectAtIndex:selectedIndexPath.row] isEqualToString:@"Confirmed"]){
                bConfirmed = TRUE;
            }
            else if([[SIStatus objectAtIndex:selectedIndexPath.row] isEqualToString:@"Submitted"]){
                bSubmitted = TRUE;
            }
            else if([[SIStatus objectAtIndex:selectedIndexPath.row] isEqualToString:@"Received"]){
                bReceived = TRUE;
            }
            else if([[SIStatus objectAtIndex:selectedIndexPath.row] isEqualToString:@"Failed"]){
                bFailed = TRUE;
            }
            else if([[SIStatus objectAtIndex:selectedIndexPath.row] isEqualToString:@"Not Created"]){
                bNotCreated = TRUE;
            }
            
        }
        
    }
    //    SIStatus objec
    
	if (ItemToBeDeleted.count == 0) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" "
														message:@"Please select at least one record to delete" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil ];
		[alert show ];
		return;
	}
    
    /*
        if (RecCount == 1) {
            NSString *deleteMsg = [NSString stringWithFormat: @"Delete this SI: %@ and all related records?", FirstSINo];
            UIAlertView *alert = [[UIAlertView alloc] 
                                  initWithTitle: NSLocalizedString(@"Delete SI",nil)
                                  message: deleteMsg
                                  delegate: self
                                  cancelButtonTitle: NSLocalizedString(@"Yes",nil)
                                  otherButtonTitles: NSLocalizedString(@"No",nil), nil];
            alert.tag = 1;
            [alert show];
            
            deleteMsg = Nil;
            alert = Nil;
            
        }
        else {
            NSString *deleteMsg = [NSString stringWithFormat: @"Are you sure you want to delete these SI?"];
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: NSLocalizedString(@"Delete SI",nil)
                                  message: deleteMsg
                                  delegate: self
                                  cancelButtonTitle: NSLocalizedString(@"Yes",nil)
                                  otherButtonTitles: NSLocalizedString(@"No",nil), nil];
            alert.tag = 1;
            [alert show];
            
            deleteMsg = Nil;
            alert = Nil;
        }
    */
    
    if ((bCreated == TRUE || bConfirmed == TRUE) && bSubmitted == FALSE && bReceived == FALSE && bFailed == FALSE && bNotCreated == FALSE  ) {
        NSString *deleteMsg = [NSString stringWithFormat: @"There are pending eApp cases created for this client. Should you wish to proceed, system should auto delete all the "
                               " related pending eApp cases and you are required to recreate the necessary should you wish to resubmit the case. "];
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: NSLocalizedString(@" ",nil)
                              message: deleteMsg
                              delegate: self
                              cancelButtonTitle: NSLocalizedString(@"Yes",nil)
                              otherButtonTitles: NSLocalizedString(@"No",nil), nil];
        alert.tag = 1; // delete eApps record and Si record
        deleteOption = 101;
        [alert show];
    }
    else if ((bCreated == FALSE && bConfirmed == FALSE) && (bSubmitted == TRUE || bReceived == TRUE || bFailed == TRUE || bNotCreated == TRUE)  ) {
        NSString *deleteMsg = [NSString stringWithFormat: @"Are you sure want to delete these SI(s) ?"];
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: NSLocalizedString(@" ",nil)
                              message: deleteMsg
                              delegate: self
                              cancelButtonTitle: NSLocalizedString(@"Yes",nil)
                              otherButtonTitles: NSLocalizedString(@"No",nil), nil];
        alert.tag = 1; // delete SI only
        deleteOption = 102;
        [alert show];
    }
    /*
    else if (bCreated == FALSE && bConfirmed == FALSE && bSubmitted == FALSE && bReceived == FALSE && bFailed == FALSE  ) {
        NSString *deleteMsg = [NSString stringWithFormat: @"Are you sure want to delete these SI(s) ?"];
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: NSLocalizedString(@"Delete SI",nil)
                              message: deleteMsg
                              delegate: self
                              cancelButtonTitle: NSLocalizedString(@"Yes",nil)
                              otherButtonTitles: NSLocalizedString(@"No",nil), nil];
        alert.tag = 1;
        deleteOption = 104;
        [alert show];
    }
     */
    else{
        NSString *deleteMsg = [NSString stringWithFormat: @"There are pending eApp cases created for this client. Should you wish to proceed, system should auto delete all the "
                               " related pending eApp cases and you are required to recreate the necessary should you wish to resubmit the case. "];
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: NSLocalizedString(@" ",nil)
                              message: deleteMsg
                              delegate: self
                              cancelButtonTitle: NSLocalizedString(@"Yes",nil)
                              otherButtonTitles: NSLocalizedString(@"No",nil), nil];
        alert.tag = 1; // combination of deleting SI only and SI plus eApps record
        deleteOption = 103;
        [alert show];
    }
    
    FirstSINo = Nil;
    
}
- (IBAction)btnDone:(id)sender {
    
    outletDone.hidden = true;
}
/*
 - (IBAction)ActionDate:(id)sender {
 NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
 [dateFormatter setDateFormat:@"dd/MM/yyyy"];
 
 NSString *pickerDate = [dateFormatter stringFromDate:[outletDate date]];
 
 NSString *msg = [NSString stringWithFormat:@"%@",pickerDate];
 if (outletDate.tag == 1) {
 [self.outletDateFrom setTitle:msg forState:UIControlStateNormal];
 //[dateFormatter setDateFormat:@"yyyy-MM-dd"];
 [dateFormatter setDateFormat:@"MM/dd/yyyy"];
 
 DBDateFrom = [dateFormatter stringFromDate:[outletDate date]];
 
 }
 else {
 [self.outletDateTo setTitle:msg forState:UIControlStateNormal];
 //[dateFormatter setDateFormat:@"yyyy-MM-dd"];
 [dateFormatter setDateFormat:@"MM/dd/yyyy"];
 DBDateTo = [dateFormatter stringFromDate:[outletDate date]];  
 
 }
 
 dateFormatter = Nil;
 pickerDate = Nil;
 msg = Nil;
 }
 */
- (void) SortBySelected:(NSMutableArray *)SortBySelected{
    
    //NSLog(@"%@", [SortBySelected objectAtIndex:0 ]);
    
    lblSINO.highlighted = false;
    lblDateCreated.highlighted= false;
    lblName.highlighted= false;
    lblPlan.highlighted = false;
    lblBasicSA.highlighted = false;
    
    if (SortBySelected.count > 0) {
        outletGender.enabled = true;
        outletGender.selectedSegmentIndex = 0;
        
    }
    else {
        outletGender.enabled = false;
        outletGender.selected = false;
        outletGender.selectedSegmentIndex = -1;
    }
    
    
    for (NSString *zzz in SortBySelected ) {
        if ([zzz isEqualToString:@"SI NO"]) {
            lblSINO.highlightedTextColor = [UIColor blueColor];
            lblSINO.highlighted = TRUE;
            
        }
        else if ([zzz isEqualToString:@"Plan Name"]) {
            lblPlan.highlightedTextColor = [UIColor blueColor];
            lblPlan.highlighted = TRUE;
            
        }
        
        else if ([zzz isEqualToString:@"Name"]) {
            lblName.highlightedTextColor = [UIColor blueColor];
            lblName.highlighted = TRUE;
            
        }
        
        else if ([zzz isEqualToString:@"Date Created"]) {
            lblDateCreated.highlightedTextColor = [UIColor blueColor];
            lblDateCreated.highlighted = TRUE;
            
        }
        
        else if ([zzz isEqualToString:@"Yearly Income"]) {
            lblBasicSA.highlightedTextColor = [UIColor blueColor];
            lblBasicSA.highlighted = TRUE;
            
        }
    }
    
    
}
- (IBAction)btnSortBy:(id)sender {
    if (_SortBy == nil) {
        self.SortBy = [[siListingSortBy alloc] initWithStyle:UITableViewStylePlain];
        _SortBy.delegate = self;
        self.Popover = [[UIPopoverController alloc] initWithContentViewController:_SortBy];               
    }
    [self.Popover setPopoverContentSize:CGSizeMake(300, 300)];
    [self.Popover presentPopoverFromRect:[sender frame ]  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    
}

-(void)DateSelected:(NSString *)strDate:(NSString *)dbDate{
    
    if (DateOption == 1) {
        [outletDateFrom setTitle:strDate forState:UIControlStateNormal];
        DBDateFrom = strDate;
        DBDateFrom2 = [self convertToDateFormat:strDate];
    }
    else {
        [outletDateTo setTitle:strDate forState:UIControlStateNormal];
        DBDateTo = strDate;
        DBDateTo2 = [self convertToDateFormat:strDate];
    }
    
}

-(NSString*)convertToDateFormat:(NSString*)strDate
{
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd/MM/yyyy"];
    
    NSDate *date = [df dateFromString: strDate]; 
    
    df = [[[NSDateFormatter alloc] init] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    
    NSString *convertedString = [df stringFromDate:date];
    
    return convertedString;
}

-(void)CloseWindow{
    [self.SIDatePopover dismissPopoverAnimated:YES];
}

- (IBAction)btnReset:(id)sender {
    txtSINO.text = @"";
    txtLAName.text = @"";
    [outletDateFrom setTitle:@"" forState:UIControlStateNormal];
    [outletDateTo setTitle:@"" forState:UIControlStateNormal];
    DBDateFrom = @"";
    DBDateTo = @"";
    lblBasicSA.highlighted = FALSE;
    lblDateCreated.highlighted = FALSE;
    lblName.highlighted = FALSE;
    lblPlan.highlighted = FALSE;
    lblSINO.highlighted = FALSE;
    [self resignFirstResponder];
    //[self.view endEditing:YES];
    outletGender.selectedSegmentIndex = -1;
    outletGender.enabled = FALSE;
    _SortBy = Nil;
    isFilter = FALSE;
    //[myTableView setEditing:NO animated:NO];
    ItemToBeDeleted = [[NSMutableArray alloc] init ];
	indexPaths = [[NSMutableArray alloc] init ];
	
    [self LoadAllResult];
    
    [myTableView reloadData];
    
}

- (IBAction)btnAddNewSI:(id)sender {
    /*
     NewLAViewController *NewLAPage  = [self.storyboard instantiateViewControllerWithIdentifier:@"LAView"];
     MainScreen *MainScreenPage = [self.storyboard instantiateViewControllerWithIdentifier:@"Main"];
     MainScreenPage.IndexTab = 3;
     NewLAPage.modalPresentationStyle = UIModalPresentationPageSheet;
     
     [self presentViewController:MainScreenPage animated:YES completion:^(){
     [MainScreenPage presentModalViewController:NewLAPage animated:NO];
     NewLAPage.view.superview.bounds =  CGRectMake(-300, 0, 1024, 748);
     }];
     */
    //[self presentViewController:main animated:NO completion:nil];
    
    //    if (_NewLAViewController == Nil) {
    //       self.NewLAViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LAView"];
    //    }
    //    _NewLAViewController.modalPresentationStyle = UIModalPresentationPageSheet;
    //    _NewLAViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //    [self presentModalViewController:_NewLAViewController animated:YES];
    //    _NewLAViewController.view.superview.frame = CGRectMake(100, 0, 970, 768);//50, 0, 970, 768
    
    AppDelegate *MenuOption= (AppDelegate*)[[UIApplication sharedApplication] delegate ];
    MainScreen *main = [self.storyboard instantiateViewControllerWithIdentifier:@"Main"];
    //        main.modalPresentationStyle = UIModalPresentationFullScreen;
    //        main.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    main.IndexTab = MenuOption.NewSIIndex;
	main.tradOrEver = TradOrEver;
    [self presentViewController:main animated:NO completion:nil];
    
    MenuOption = Nil;
    main = Nil;
}

-(void)RefreshZZZ{
    [SINO removeAllObjects];
    [DateCreated removeAllObjects];
    [Name removeAllObjects];
    [PlanName removeAllObjects];
    [BasicSA removeAllObjects];
    [SIStatus removeAllObjects];
    [CustomerCode removeAllObjects];
    [SIVersion removeAllObjects];
    [SIValidStatus removeAllObjects];

    [self LoadAllResult];
    [myTableView reloadData];
}

-(void)SIListingClear{
	myTableView = Nil;
	SINO =Nil;
	DateCreated=Nil;
	Name =Nil;
	PlanName=Nil;
	SIStatus=Nil;
	CustomerCode=Nil;
	BasicSA =Nil;
	FilteredSINO =Nil;
	FilteredDateCreated=Nil;
	FilteredName=Nil;
	FilteredPlanName=Nil;
	FilteredBasicSA=Nil;
	FilteredSIStatus=Nil;
	FilteredCustomerCode=Nil;
	DBDateFrom = Nil, DBDateTo = Nil, OrderBy = Nil, _SIDate = Nil, _SIDatePopover = Nil, _SortBy = Nil;
	ItemToBeDeleted = Nil, indexPaths = Nil;
	lblBasicSA = Nil, lblDateCreated = Nil, lblName = Nil, lblPlan = Nil, lblSINO = Nil;
	outletDateFrom = Nil, outletDateTo = Nil, outletDelete = Nil, outletDone = Nil, outletEdit = Nil;
	outletGender = Nil;
}


#pragma UIScroll View Method::

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.isLoading = NO;
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.isLoading) {
        float endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height;
        if (endScrolling >= scrollView.contentSize.height)
        {
            if (self.kPageModulo % kPageSize == 0 && self.kPageModulo > 0) {
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                self.kPageIndex += kPageSize;
                self.isLoading = YES;
                //[self performSelector:@selector(loadDataDelayed) withObject:nil afterDelay:0.5];
                [self LoadAllResult];
                self.kPageIndex  = 0;
            }
            
        }
    }
}

#pragma UserDefined Method for generating data which are show in Table :::
-(void)loadDataDelayed{
    
    [self LoadAllResult];
}

@end