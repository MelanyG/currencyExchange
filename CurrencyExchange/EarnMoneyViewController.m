//
//  EarnMoneyViewController.m
//  CurrencyExchange
//
//  Created by alex4eetah on 1/26/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import "EarnMoneyViewController.h"
#import "EarnMoneyGraphView.h"
#import "AddControlPointToEarnMoneyViewController.h"
#import "ControllPoint.h"

@interface EarnMoneyViewController ()

@property (weak, nonatomic) IBOutlet EarnMoneyGraphView *graphView;
@property (weak, nonatomic) IBOutlet UIImageView *USDColorIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *EURColorIndicator;
@property (strong, nonatomic) NSMutableArray *arrayOfControlPoints;
@property (nonatomic, strong) NSMutableArray *avarageCurrencyObjectsArray;

@end

static NSString* USDbid[] = {
    @"25", @"25.5", @"26", @"24", @"25",
    @"22", @"20", @"19", @"18", @"17",
    @"20", @"22", @"25", @"27", @"30"
};
static NSString* USDask[] = {
    @"26", @"27", @"28", @"25", @"26",
    @"23", @"21", @"20", @"19", @"18",
    @"22", @"23", @"26", @"28", @"31"
};
static NSString* EURbid[] = {
    @"26", @"28.5", @"29", @"28", @"27",
    @"25", @"27", @"30", @"33", @"33",
    @"33", @"31", @"31", @"32", @"30"
    
};
static NSString* EURask[] = {
    @"27", @"29", @"30", @"30", @"29",
    @"27", @"27", @"33", @"35", @"35",
    @"35", @"33", @"33", @"34", @"32"
};

@implementation EarnMoneyViewController

- (NSMutableArray *)avarageCurrencyObjectsArray
{
    if (!_avarageCurrencyObjectsArray)
    {
        _avarageCurrencyObjectsArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < 15; i++)
        {
            NSTimeInterval secondsPerDay = 24 * 60 * 60; // Интервал в 1 день равный 86 400 секунд
            NSDate *date = [[NSDate alloc] initWithTimeIntervalSinceNow:secondsPerDay * i];
            
            AvarageCurrency *object = [[AvarageCurrency alloc] init];
            object.USDbid = [NSNumber numberWithFloat:[USDbid[i] floatValue]];
            object.USDask = [NSNumber numberWithFloat:[USDask[i] floatValue]];
            object.EURbid = [NSNumber numberWithFloat:[EURbid[i] floatValue]];
            object.EURask = [NSNumber numberWithFloat:[EURask[i] floatValue]];
            object.date = date;
            
            [_avarageCurrencyObjectsArray addObject:object];
        }
    }
    return _avarageCurrencyObjectsArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.graphView.avarageCurrencyObjectsArray = self.avarageCurrencyObjectsArray;
    /*self.graphView.USDStrokeColor = [UIColor blueColor];
    self.graphView.EURStrokeColor = [UIColor greenColor];
    [self setNeedsOfIndicator:self.USDColorIndicator WithColor:self.graphView.USDStrokeColor];
    [self setNeedsOfIndicator:self.EURColorIndicator WithColor:self.graphView.EURStrokeColor];*/
}

- (void)setNeedsOfIndicator:(UIImageView *)colorIndicator WithColor:(UIColor *)color
{
    CGFloat diametr = MIN(colorIndicator.frame.size.height, colorIndicator.frame.size.width);
    
    UIGraphicsBeginImageContext(colorIndicator.frame.size);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(),diametr);
    
    CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), [color CGColor]);
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), diametr/2, diametr/2);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), diametr/2, diametr/2);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    colorIndicator.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

#pragma mark - create control point
- (void)addControlPointWithAmountOfMoney:(CGFloat)money Currency:(NSString *)currency ForDate:(NSDate *)date
{
    if (!self.arrayOfControlPoints)
        self.arrayOfControlPoints = [NSMutableArray array];
    
    ControllPoint *point = [[ControllPoint alloc] init];
    point.currency = currency;
    point.value = [NSNumber numberWithFloat:money];
   /* NSTimeInterval secondsPerDay = 24 * 60 * 60; // Интервал в 1 день равный 86 400 секунд
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSinceNow:secondsPerDay * 4];
    point.date = [[NSDate alloc] init];*/
    point.date = date;
    AvarageCurrency *thisCurrency = [[AvarageCurrency alloc] init];
    for (AvarageCurrency *currency in self.avarageCurrencyObjectsArray)
    {
        if ([currency.date compare:date] == NSOrderedSame)
            thisCurrency = currency;
    }
    if ([currency isEqualToString:@"dolars"])
        point.exChangeCource = thisCurrency.USDask;
    else if ([currency isEqualToString:@"euro"])
        point.exChangeCource = thisCurrency.EURask;
    
    //adding point to array in EarnMoneyVC
    if (!self.graphView.controlPointsArray)
        self.graphView.controlPointsArray = [NSArray array];
    NSMutableArray *mutableControlPointsArray = [self.graphView.controlPointsArray mutableCopy];
    [mutableControlPointsArray addObject:point];
    self.graphView.controlPointsArray = mutableControlPointsArray;
    [self.graphView drawAllControlpoints];
    
#warning not fully implement
}

#pragma mark - navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString: @"addControlPoint"])
    {
        ((AddControlPointToEarnMoneyViewController *)segue.destinationViewController).owner = self;
        ((AddControlPointToEarnMoneyViewController *)segue.destinationViewController).avarageCurrencyObjectsArray = self.avarageCurrencyObjectsArray;
    }
}


@end
