//
//  PremiumViewController.h
//  HLA
//
//  Created by shawal sapuan on 9/11/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "BasicPlanHandler.h"
#import "SIMenuViewController.h"


@class PremiumViewController;
@protocol PremiumViewControllerDelegate
-(void)setNewBasicSA;
@end


@interface PremiumViewController : UIViewController<SIMenuDelegate> {
    NSString *databasePath;
	NSString *RatesDatabasePath;
    sqlite3 *contactDB;
    NSMutableArray *annRiderCode;

    NSMutableArray *PremWithoutHLoading;
    NSMutableArray *PremWithHLoading;
    NSMutableArray *PremWithTempHLoading;
    
    NSMutableArray *medRiderAnn;
    NSMutableArray *medRiderQuar;
    NSMutableArray *medRiderHalf;
    NSMutableArray *medRiderMonth;
    
    NSMutableArray *waiverRiderAnnWithoutHLAndOccLoading;
    NSMutableArray *waiverRiderQuarWithoutHLAndOccLoading;
    NSMutableArray *waiverRiderHalfWithoutHLAndOccLoading;
    NSMutableArray *waiverRiderMonthWithoutHLAndOccLoading;
    
    double annualMedRiderSum;
    double halfMedRiderSum;
    double quarterMedRiderSum;
    double monthMedRiderSum;
    
    double expAge_PREM;
    double minTerm_PREM;
    double maxTerm_PREM;
    double minSATerm_PREM;
    double maxSATerm_PREM;
    double maxSAFactor_PREM;
    double dblTotalOverallPrem;
    
    double dblTotalGrossPrem;
    
    int maxGycc;
    
    id <PremiumViewControllerDelegate> _delegate;
    SIMenuViewController *_simenu;
    
    float gstValue;
}

@property (nonatomic, assign) float gstValue;
@property (nonatomic,strong) id <PremiumViewControllerDelegate> delegate;
@property (nonatomic, retain) SIMenuViewController *simenu;

@property (retain, nonatomic) IBOutlet UIWebView *WebView;
@property (strong, nonatomic) IBOutlet UIToolbar *myToolBar;
@property (strong, nonatomic) IBOutlet UILabel *headerTitle;
@property (nonatomic,strong) id EAPPorSI;
@property (nonatomic,strong) id executeMHI; //YES or NO

@property (nonatomic,strong) BasicPlanHandler *premBH;
//--request
@property (nonatomic, assign,readwrite) int requestAge;
@property (nonatomic, assign,readwrite) int requestOccpClass;
@property (nonatomic,strong) id requestOccpCode;
@property (nonatomic,strong) id requestSINo;
@property (nonatomic, assign,readwrite) int requestMOP;
@property (nonatomic, assign,readwrite) int requestTerm;
@property (nonatomic,strong) id requestBasicSA;
@property (nonatomic,strong) id requestBasicHL;
@property (nonatomic,strong) id requestBasicTempHL;
@property (nonatomic,strong) id requestPlanCode;
@property (nonatomic,strong) id requestBasicPlan;

@property (nonatomic, assign,readwrite) int getAge;
@property (nonatomic, assign,readwrite) int getOccpClass;
@property (nonatomic,strong) NSString *getOccpCode;
@property (nonatomic,strong) NSString *SINo;
@property (nonatomic, assign,readwrite) int getMOP;
@property (nonatomic, assign,readwrite) int getTerm;
@property (nonatomic,strong) NSString *getBasicSA;
@property (nonatomic,strong) NSString *getBasicHL;
@property (nonatomic,strong) NSString *getBasicTempHL;
@property (nonatomic,strong) NSString *getPlanCode;
@property (nonatomic,strong) NSString *getBasicPlan;
//--
@property (nonatomic, assign,readwrite) double basicRate;
@property (nonatomic, assign,readwrite) int age;
@property (nonatomic,strong) NSString *sex;
@property (nonatomic, assign,readwrite) double LSDRate;
@property (nonatomic, assign,readwrite) double riderRate;
@property (nonatomic, assign,readwrite) int occLoad;
@property (nonatomic, assign,readwrite) double occLoadRider;
@property(nonatomic , retain) NSMutableArray *riderCode;
@property(nonatomic , retain) NSMutableArray *riderDesc;
@property(nonatomic , retain) NSMutableArray *riderTerm;
@property(nonatomic , retain) NSMutableArray *riderSA;
@property(nonatomic , retain) NSMutableArray *riderHL1K;
@property(nonatomic , retain) NSMutableArray *riderTempHL1K;
@property(nonatomic , retain) NSMutableArray *riderHL100;
@property(nonatomic , retain) NSMutableArray *riderHLP;
@property(nonatomic , retain) NSMutableArray *riderPlanOpt;
@property(nonatomic , retain) NSMutableArray *riderUnit;
@property(nonatomic , retain) NSMutableArray *riderDeduct;
@property(nonatomic , retain) NSMutableArray *riderCustCode;
@property(nonatomic , retain) NSMutableArray *riderSmoker;
@property(nonatomic , retain) NSMutableArray *riderSex;
@property(nonatomic , retain) NSMutableArray *riderAge;
@property(nonatomic , retain) NSMutableArray *riderOccp;
@property (nonatomic,strong) NSString *strOccp;
@property (nonatomic,strong) NSString *planCodeRider;
@property (nonatomic,strong) NSString *pentaSQL;
@property (nonatomic,strong) NSString *plnOptC;
@property (nonatomic,strong) NSString *planOptHMM;
@property (nonatomic,strong) NSString *deducHMM;
@property (nonatomic,strong) NSString *planHSPII;
@property (nonatomic,strong) NSString *planMGII;
@property (nonatomic,strong) NSString *planMGIV;
@property (nonatomic,strong) NSString *htmlRider;
@property (nonatomic,strong) NSString *premPayOpt;
@property (nonatomic, assign,readwrite) double annualRider;
@property (nonatomic, assign,readwrite) double halfYearRider;
@property (nonatomic, assign,readwrite) double quarterRider;
@property (nonatomic, assign,readwrite) double monthlyRider;
@property (nonatomic, assign,readwrite) double annualRiderOnly;
@property (nonatomic, assign,readwrite) double halfYearRiderOnly;
@property (nonatomic, assign,readwrite) double quarterRiderOnly;
@property (nonatomic, assign,readwrite) double monthlyRiderOnly;
@property (nonatomic, assign,readwrite) double annualRiderSum;
@property (nonatomic, assign,readwrite) double halfRiderSum;
@property (nonatomic, assign,readwrite) double quarterRiderSum;
@property (nonatomic, assign,readwrite) double monthRiderSum;
@property (nonatomic, assign,readwrite) double basicPremAnn;
@property (nonatomic, assign,readwrite) double basicPremHalf;
@property (nonatomic, assign,readwrite) double basicPremQuar;
@property (nonatomic, assign,readwrite) double basicPremMonth;
@property (nonatomic, assign,readwrite) double gstPremAnn;
@property (nonatomic, assign,readwrite) double gstPremHalf;
@property (nonatomic, assign,readwrite) double gstPremQuar;
@property (nonatomic, assign,readwrite) double gstPremMonth;
@property (nonatomic, assign,readwrite) double annFac;
@property (nonatomic, assign,readwrite) double halfFac;
@property (nonatomic, assign,readwrite) double qtrFac;
@property (nonatomic, assign,readwrite) double monthFac;

//display in table prem
@property (nonatomic,strong) NSString *BasicAnnually;
@property (nonatomic,strong) NSString *BasicHalfYear;
@property (nonatomic,strong) NSString *BasicQuarterly;
@property (nonatomic,strong) NSString *BasicMonthly;
@property (nonatomic,strong) NSString *OccpLoadA;
@property (nonatomic,strong) NSString *OccpLoadH;
@property (nonatomic,strong) NSString *OccpLoadQ;
@property (nonatomic,strong) NSString *OccpLoadM;
@property (nonatomic,strong) NSString *BasicHLAnnually;
@property (nonatomic,strong) NSString *BasicHLHalfYear;
@property (nonatomic,strong) NSString *BasicHLQuarterly;
@property (nonatomic,strong) NSString *BasicHLMonthly;
@property (nonatomic,strong) NSString *LSDAnnually;
@property (nonatomic,strong) NSString *LSDHalfYear;
@property (nonatomic,strong) NSString *LSDQuarterly;
@property (nonatomic,strong) NSString *LSDMonthly;
@property (nonatomic,strong) NSString *basicTotalA;
@property (nonatomic,strong) NSString *basicTotalS;
@property (nonatomic,strong) NSString *basicTotalQ;
@property (nonatomic,strong) NSString *basicTotalM;
@property (nonatomic,strong) NSMutableArray *annualRiderTot;
@property (nonatomic,strong) NSMutableArray *quarterRiderTot;
@property (nonatomic,strong) NSMutableArray *halfRiderTot;
@property (nonatomic,strong) NSMutableArray *monthRiderTot;

@property (nonatomic,strong) NSMutableArray *waiverRiderAnn;
@property (nonatomic,strong) NSMutableArray *waiverRiderQuar;
@property (nonatomic,strong) NSMutableArray *waiverRiderHalf;
@property (nonatomic,strong) NSMutableArray *waiverRiderMonth;
@property (nonatomic,strong) NSMutableArray *waiverRiderAnn2;
@property (nonatomic,strong) NSMutableArray *waiverRiderQuar2;
@property (nonatomic,strong) NSMutableArray *waiverRiderHalf2;
@property (nonatomic,strong) NSMutableArray *waiverRiderMonth2;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *outletEAPP;
- (IBAction)ActionEAPP:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;
@property (weak, nonatomic) IBOutlet UIButton *doGenerate;
- (IBAction)btnGenerate:(id)sender;


@property(nonatomic , retain) NSMutableArray *ReportHMMRates;
@property(nonatomic , retain) NSMutableArray *ReportFromAge;
@property(nonatomic , retain) NSMutableArray *ReportToAge;
@property (nonatomic,assign,readwrite) BOOL fromReport; 

+(NSString *)getMsgTypeL100;
+(NSString *)getMsgTypeWealthPlan;
+(NSString*)getShortSex:(NSString*)sexI;
-(double)ReturnGrossPrem;
-(bool)isRiderWithGST:(NSString*)rider;

@end