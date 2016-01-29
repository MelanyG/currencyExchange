//
//  TestCoreData.m
//  CurrencyExchange
//
//  Created by Vitaliy Yarkun on 29.01.16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import "TestCoreData.h"
#import "BankData.h"
#import "CurrencyData.h"
#import "BranchData.h"
#import "AppDelegate.h"

@interface TestCoreData ()

@property (strong, nonatomic) NSManagedObjectContext* context;

@end

@implementation TestCoreData

static NSString* cities[] = {@"Semykhatka",@"Staraya Kuzhel’",@"Круглий",@"Текля",@"Мала Олександрівка",
                             @"Gavro",@"Zadvuzhe",@"Khutor Borutin",@"Shumskoye",@"Sudkovska Volya",
                             @"Vaserovka",@"Khoroshevo",@"Imstichevo",@"Verkhniye Serogozy",
                             @"Pen’ki",@"Yaltushkov",@"Dobrovlyany",@"Sukholuch’ye",@"Vydra",@"Червона Слобода",
                             @"Zorinovka",@"Pervomayskiy",@"Кар’єрне",@"Havrylivka Druha",@"Yagodzin",
                             @"Aleksandrogil’f",@"Troitsk",@"Дулово",@"Kvasovsk Menculi",@"Telyazh",
                             @"Ruda Brodzha",@"Lyutynsk",@"Volosin’",@"Soltysy",@"Zamirtsy",
                             @"Shymkivtsi",@"Podgortse",@"Великий Самбір",@"Sorokino",@"Madar",
                             @"Proyezzheye",@"Chukaluvka",@"Risove",@"Trylisy",@"Kichkas",
                             @"Rechki",@"Мороча",@"Uhil’tsi",@"Korostovitsy",@"Lipetska Polyana"};

static NSString* addresses[] = {@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"G",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"};

-(void) insertFakeDataToCoreData
{
    self.context = [AppDelegate singleton].managedObjectContext;

    NSError* error = nil;
    
    for (int i = 0; i < 10; i++) {
        BankData* fakeBank = [self bankDataByIndex:i];
        CurrencyData* fakeCurrency = [self currencyDataByIndex:i withEUR:29 withUSD:25];
        
        [fakeBank addCurrencyObject:fakeCurrency];
        
        for (int j = 0; j < 5; j++)
        {
            BranchData* fakeBranch = [self branchDataByIndex:j];
            [fakeBank addBranchObject:fakeBranch];
        }
        
        if (![self.context save:&error]) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }
    
}


-(BankData*) bankDataByIndex:(NSInteger) bankIndex
{
    
    BankData* bank = [NSEntityDescription insertNewObjectForEntityForName:@"BankData" inManagedObjectContext:self.context];
    bank.name = [NSString stringWithFormat:@"Bank #%ld", bankIndex];
    bank.region = [NSString stringWithFormat:@"Bank region #%ld", bankIndex];
    bank.city = [NSString stringWithFormat:@"%@",cities[arc4random_uniform(50)]];
    bank.address = [NSString stringWithFormat:@"%@", addresses[arc4random_uniform(26)]];
    
    return bank;
    
}

-(BranchData*) branchDataByIndex:(NSInteger) branchIndex
{
    
    BranchData* branch = [NSEntityDescription insertNewObjectForEntityForName:@"BranchData" inManagedObjectContext:self.context];
    branch.name = [NSString stringWithFormat:@"Branch #%ld", branchIndex];
    branch.region = [NSString stringWithFormat:@"Branch region #%ld", branchIndex];
    branch.city = [NSString stringWithFormat:@"%@",cities[arc4random_uniform(50)]];
    branch.address = [NSString stringWithFormat:@"%@", addresses[arc4random_uniform(26)]];
    return branch;
    
}

-(CurrencyData*) currencyDataByIndex:(NSInteger) currencyIndex withEUR:(NSInteger) eur withUSD:(NSInteger) usd
{
    
    CurrencyData* currency = [NSEntityDescription insertNewObjectForEntityForName:@"CurrencyData" inManagedObjectContext:self.context];
    currency.date = [self generateRandomDateWithinDaysBeforeToday:200];
    currency.eurCurrencyAsk = [NSString stringWithFormat:@"%ld", eur+currencyIndex];
    currency.eurCurrencyBid = [NSString stringWithFormat:@"%ld", (eur-2)+currencyIndex];
    currency.usdCurrencyAsk = [NSString stringWithFormat:@"%ld", usd+currencyIndex];
    currency.usdCurrencyBid = [NSString stringWithFormat:@"%ld", (usd-2)+currencyIndex];

    return currency;
    
}

- (NSDate *) generateRandomDateWithinDaysBeforeToday:(int)days
{
    int r1 = arc4random_uniform(days);
    int r2 = arc4random_uniform(23);
    int r3 = arc4random_uniform(59);
    
    NSDate *today = [NSDate new];
    NSCalendar *gregorian =
    [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *offsetComponents = [NSDateComponents new];
    [offsetComponents setDay:(r1*-1)];
    [offsetComponents setHour:r2];
    [offsetComponents setMinute:r3];
    
    NSDate *rndDate1 = [gregorian dateByAddingComponents:offsetComponents
                                                  toDate:today options:0];
    
    return rndDate1;
}






@end
