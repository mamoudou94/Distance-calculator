//
//  ViewController.m
//  Distance-Calculator
//
//  Created by Mamoudou Barry on 5/22/24.
//

#import "ViewController.h"
#import "DistanceGetter/DGDistanceRequest.h"

@interface ViewController ()
@property (nonatomic) DGDistanceRequest *req;
@property (strong, nonatomic) IBOutlet UITextField *startLocation;
@property (strong, nonatomic) IBOutlet UISegmentedControl *unitController;
@property (strong, nonatomic) IBOutlet UITextField *endLocationA;
@property (strong, nonatomic) IBOutlet UILabel *distanceA;
@property (strong, nonatomic) IBOutlet UITextField *endLocationB;
@property (strong, nonatomic) IBOutlet UILabel *distanceB;
@property (strong, nonatomic) IBOutlet UITextField *endLocationC;
@property (strong, nonatomic) IBOutlet UILabel *distanceC;

@property (strong, nonatomic) IBOutlet UIButton *calculateButton;

@end

NSString* formatNumber(double value, NSString* unit) {
    return [NSString stringWithFormat:@"%.2f %@", value, unit];
}

@implementation ViewController
- (IBAction)calculateButtonTapped:(id)sender {
    self.calculateButton.enabled = NO;
    self.req = [DGDistanceRequest alloc];
    NSString *start = self.startLocation.text;
    NSString *destA = self.endLocationA.text;
    NSString *destB = self.endLocationB.text;
    NSString *destC = self.endLocationC.text;
    NSArray *dests = @[destA, destB, destC];
    self.req = [self.req initWithLocationDescriptions:dests sourceDescription:start];

    __weak ViewController *weakSelf = self;
    self.req.callback = ^(NSArray *responses) {
        ViewController *strongSelf = weakSelf;
        if(!strongSelf) return;
        NSNull *badResult = [NSNull null];
        
        if(responses[0] != badResult) {
            double num;
            double num1;
            double num2;
            if(strongSelf.unitController.selectedSegmentIndex == 0) {
                num =([responses[0] floatValue] /1.0);
                strongSelf.distanceA.text = formatNumber(num, @"m");
                num1 =([responses[1] floatValue] /1.0);
                strongSelf.distanceB.text = formatNumber(num1, @"m");
                num2 =([responses[2] floatValue] /1.0);
                strongSelf.distanceC.text = formatNumber(num2, @"m");
            }
            else if(strongSelf.unitController.selectedSegmentIndex == 1) {
                num =([responses[0] floatValue] /1000.0);
                strongSelf.distanceA.text = formatNumber(num, @"Km");
                num1 =([responses[1] floatValue] /1000.0);
                strongSelf.distanceB.text = formatNumber(num1, @"Km");
                num2 =([responses[2] floatValue] /1000.0);
                strongSelf.distanceC.text = formatNumber(num2, @"Km");
            }
            else {
                num =([responses[0] floatValue] * 0.000621371);
                strongSelf.distanceA.text = formatNumber(num, @"Mille");
                num1 =([responses[1] floatValue] * 0.000621371);
                strongSelf.distanceB.text = formatNumber(num1, @"Mille");
                num2 =([responses[2] floatValue] * 0.000621371);
                strongSelf.distanceC.text = formatNumber(num2, @"Mille");
            }
        } else {
            strongSelf.distanceA.text = @"Error";
            strongSelf.distanceB.text = @"Error";
            strongSelf.distanceC.text = @"Error";
        }
        strongSelf.req = nil;
        strongSelf.calculateButton.enabled = YES;
    };
    [self.req start];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


@end
