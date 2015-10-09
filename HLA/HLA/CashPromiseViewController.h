//
//  CashPromiseViewController.h
//  iMobile Planner
//
//  Created by infoconnect on 2/1/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

#import "FMDatabase.h"
#import "Constants.h"
@class DataTable,DBController;
@interface CashPromiseViewController : UIViewController
{
	NSString *databasePath;
    NSString *RatesDatabasePath;
    sqlite3 *contactDB;
	NSMutableDictionary *riderCode;
    double totPremPaidL100;
    NSString *pPlanName;
    NSMutableArray *wpGYIRidersCode;
    NSMutableArray *wpGYIRidersSA;
    NSMutableArray *wpGYIRidersTerm;
    NSMutableArray *wpGYIRidersPayingTerm;
    NSMutableArray *wpGYIRiderDesc ;
    NSMutableArray *wpGYIRiderPlanOption ;
    NSMutableArray *wpGYIRiderDeductible ;
	NSMutableArray *wpGYIRiderHL1kSA ;
	NSMutableArray *wpGYIRiderHL1kSATerm ;
	NSMutableArray *wpGYIRiderHL100SA ;
	NSMutableArray *wpGYIRiderHL100SATerm ;
	NSMutableArray *wpGYIRiderHLPercentage ;
	NSMutableArray *wpGYIRiderHLPercentageTerm ;
	NSMutableArray *wpGYIRiderTempHL ;
	NSMutableArray *wpGYIRiderTempHLTerm ;

    
    int premiumPaymentOption;
    
    NSMutableArray *wpGYIRidersPremAnnual;
    NSMutableArray *wpGYIRidersPremSemiAnnual;
    NSMutableArray *wpGYIRidersPremQuarter;
    NSMutableArray *wpGYIRidersPremMonth;
    NSMutableArray *wpGYIRidersPremAnnualWithoutHLoading;
    double TotalPremiumBasicANDWPRiders;
    
    NSMutableArray *SummaryTotalPremiumPaid;
    NSMutableArray *SummaryTotalPayoutOption;
    NSMutableArray *SummaryTotalPayoutAndAccumulate;
    NSMutableArray *SummaryTotalAccumulateWithoutInterest;
    NSMutableArray *SummaryNonGuaranteedCurrentCashDividendA;
    NSMutableArray *SummaryNonGuaranteedCurrentCashDividendB;
    NSMutableArray *SummaryNonGuaranteedTotalTDivA;
    NSMutableArray *SummaryNonGuaranteedTotalTDivB;
    NSMutableArray *SummaryNonGuaranteedTotalSpeA;
    NSMutableArray *SummaryNonGuaranteedTotalSpeB;
    
    NSMutableArray *aStrWPGYIRiderAnnually;
    NSMutableArray *aStrWPGYIRiderSemiAnnually;
    NSMutableArray *aStrWPGYIRiderQuarterly;
    NSMutableArray *aStrWPGYIRiderMonthly;
    
    NSMutableArray *OtherRiderPayingTerm;
    NSMutableArray *OtherRiderPremWithoutHLoading;
    
    float gstValue;
}

@property (nonatomic,assign) int paymentOption;
@property (nonatomic,strong) id SINo;
@property (nonatomic,strong) id PDSorSI;
@property (nonatomic,strong) id YearlyIncome;
@property (nonatomic,strong) id CashDividend;
@property (nonatomic,strong) id CustCode;
@property (nonatomic,strong) id Name;
@property (nonatomic,strong) id strBasicAnnually, strBasicSemiAnnually, strBasicQuarterly, strBasicMonthly;
@property (nonatomic,strong) id strOriBasicAnnually, strOriBasicSemiAnnually, strOriBasicQuarterly, strOriBasicMonthly;
@property (nonatomic,strong) id sex, OccpClass,HealthLoading, HealthLoadingTerm, TempHealthLoading, TempHealthLoadingTerm ;
@property (retain, nonatomic) NSMutableArray *OccLoading;
@property (retain, nonatomic) NSMutableArray *aStrOtherRiderAnnually;
@property (retain, nonatomic) NSMutableArray *aStrOtherRiderSemiAnnually;
@property (retain, nonatomic) NSMutableArray *aStrOtherRiderQuarterly;
@property (retain, nonatomic) NSMutableArray *aStrOtherRiderMonthly;
@property (retain, nonatomic) NSMutableArray *aStrBasicSA;
@property (nonatomic, assign) int Age;
@property (nonatomic, assign) int PayorAge;
@property (nonatomic, assign) int PolicyTerm;
@property (nonatomic, assign) double BasicSA;

@property (nonatomic, assign) int PartialAcc;
@property (nonatomic, assign) int PartialPayout;

@property (retain, nonatomic) NSMutableArray *OtherRiderCode;
@property (retain, nonatomic) NSMutableArray *OtherRiderTerm;
@property (retain, nonatomic) NSMutableArray *OtherRiderDesc;
@property (retain, nonatomic) NSMutableArray *OtherRiderSA;
@property (retain, nonatomic) NSMutableArray *OtherRiderPlanOption;
@property (retain, nonatomic) NSMutableArray *OtherRiderDeductible;
@property (retain, nonatomic) NSMutableArray *OtherRiderHL1kSA;
@property (retain, nonatomic) NSMutableArray *OtherRiderHL1kSATerm;
@property (retain, nonatomic) NSMutableArray *OtherRiderHL100SA;
@property (retain, nonatomic) NSMutableArray *OtherRiderHL100SATerm;
@property (retain, nonatomic) NSMutableArray *OtherRiderHLPercentage;
@property (retain, nonatomic) NSMutableArray *OtherRiderHLPercentageTerm;
@property (retain, nonatomic) NSMutableArray *OtherRiderTempHL;
@property (retain, nonatomic) NSMutableArray *OtherRiderTempHLTerm;

//summary
@property (retain, nonatomic) NSMutableArray *SummaryGuaranteedTotalGYI;
@property (retain, nonatomic) NSMutableArray *SummaryGuaranteedSurrenderValue;
@property (retain, nonatomic) NSMutableArray *SummaryGuaranteedDBValueA;
@property (retain, nonatomic) NSMutableArray *SummaryGuaranteedDBValueB;
@property (retain, nonatomic) NSMutableArray *SummaryGuaranteedAddValue;
@property (retain, nonatomic) NSMutableArray *SummaryNonGuaranteedAccuYearlyIncomeA;
@property (retain, nonatomic) NSMutableArray *SummaryNonGuaranteedAccuYearlyIncomeB;
@property (retain, nonatomic) NSMutableArray *SummaryNonGuaranteedAccuCashDividendA;
@property (retain, nonatomic) NSMutableArray *SummaryNonGuaranteedAccuCashDividendB;
@property (retain, nonatomic) NSMutableArray *SummaryNonGuaranteedSurrenderValueA;
@property (retain, nonatomic) NSMutableArray *SummaryNonGuaranteedSurrenderValueB;
@property (retain, nonatomic) NSMutableArray *SummaryNonGuaranteedDBValueA;
@property (retain, nonatomic) NSMutableArray *SummaryNonGuaranteedDBValueB;


//@property (retain, nonatomic) NSMutableArray *la2RiderDataArray;
//@property (retain, nonatomic) NSMutableArray *payorRiderDataArray;

//for CI
@property (retain, nonatomic) NSMutableArray *CIRiders;
@property (retain, nonatomic) NSMutableArray *CIRiders2;
@property (nonatomic, assign) double TotalCI;
@property (nonatomic, assign) double TotalCI2; 

//for total sum Basic
@property (nonatomic, assign) double BasicTotalPremiumPaid;
@property (nonatomic, assign) double BasicMaturityValueA;
@property (nonatomic, assign) double BasicMaturityValueB;
@property (nonatomic, assign) double BasicTotalYearlyIncome;

//for total entire policy
@property (nonatomic, assign) double EntireTotalPremiumPaid;
@property (nonatomic, assign) double EntireMaturityValueA;
@property (nonatomic, assign) double EntireMaturityValueB;
@property (nonatomic, assign) double EntireTotalYearlyIncome;

//for total premium paid for basic plan and income rider only
@property (nonatomic, assign) double TotalPremiumBasicANDIncomeRider;

@property (strong, nonatomic) DBController* db;
@property (strong, nonatomic) DataTable * dataTable;

@property (nonatomic, retain) NSString *pPlanCode;
@property (nonatomic, retain) NSString *lang;
@property (nonatomic, assign) int coveragePeriod;

@property (nonatomic, assign) BOOL need2PagesUnderwriting;
@property (nonatomic, assign) REPORT_TYPE reportType;

@property (nonatomic, assign) float gstValue;
@property (nonatomic, assign) BOOL isNotSummary;

-(void)generateJSON_HLCP:(BOOL)isPDS;
-(void)deleteTemp;
-(void)copyReportFolderToDoc:(NSString *)dir;


#define IsAtLeastiOSVersion(X) ([[[UIDevice currentDevice] systemVersion] compare:X options:NSNumericSearch] != NSOrderedAscending)

@end
