//
//  TYViewController.m
//  TYAlertView
//
//  Created by luckytianyiyan on 09/19/2016.
//  Copyright (c) 2016 luckytianyiyan. All rights reserved.
//

#import "TYViewController.h"
#import <TYAlertView.h>
#import <Masonry.h>

#import <TYPopupView.h>

static NSString * const kActionTitleOK = @"OK";
static NSString * const kActionTitleCancel = @"Cancel";
static NSString * const kActionTitleDelete = @"Delete";
static NSString * const kAlertTitle = @"Title";
static NSString * const kAlertMessage = @"Message";
static NSString * const kAlertTitleLong = @"His flower had told him that she was only one of her kind in all universe. And here were five thousand of them, all alike, in one single garden!";
static NSString * const kAlertMessageLong = @"Objective-C was created primarily by Brad Cox and Tom Love in the early 1980s at their company Stepstone. Both had been introduced to Smalltalk while at ITT Corporation's Programming Technology Center in 1981. The earliest work on Objective-C traces back to around that time. Cox was intrigued by problems of true reusability in software design and programming. He realized that a language like Smalltalk would be invaluable in building development environments for system developers at ITT. However, he and Tom Love also recognized that backward compatibility with C was critically important in ITT's telecom engineering milieu.\nCox began writing a pre-processor for C to add some of the abilities of Smalltalk. He soon had a working implementation of an object-oriented extension to the C language, which he called \"OOPC\" for Object-Oriented Pre-Compiler. Love was hired by Schlumberger Research in 1982 and had the opportunity to acquire the first commercial copy of Smalltalk-80, which further influenced the development of their brainchild.\nIn order to demonstrate that real progress could be made, Cox showed that making interchangeable software components really needed only a few practical changes to existing tools. Specifically, they needed to support objects in a flexible manner, come supplied with a usable set of libraries, and allow for the code (and any resources needed by the code) to be bundled into one cross-platform format.\nLove and Cox eventually formed a new venture, Productivity Products International (PPI), to commercialize their product, which coupled an Objective-C compiler with class libraries. In 1986, Cox published the main description of Objective-C in its original form in the book Object-Oriented Programming, An Evolutionary Approach. Although he was careful to point out that there is more to the problem of reusability than just the language, Objective-C often found itself compared feature for feature with other languages.";

static NSString * const kTableViewCellReuseIndentifier = @"TableViewCellReuseIndentifier";

@interface TYViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray<NSString *> *sectionTitles;
@property (nonatomic, strong) NSArray<NSString *> *cellTitles;

@end

@implementation TYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITableView *tableView = [[UITableView alloc] init];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kTableViewCellReuseIndentifier];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    _sectionTitles = @[@"TYAlertView", @"System UIAlertView", @"System UIAlertController"];
    _cellTitles = @[@"Simply", @"Double Action", @"Multiple Actions", @"Long"];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sectionTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cellTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellReuseIndentifier];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _cellTitles[indexPath.row];
    return cell;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _sectionTitles[section];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        TYAlertView *alertView = [[TYAlertView alloc] initWithTitle:kAlertTitle message:kAlertMessage];
        [alertView show];
        do {
            if (indexPath.row < 1) {
                break;
            }
            [alertView addAction:[TYAlertAction actionWithTitle:kActionTitleOK style:TYAlertActionStyleDefault handler:^(TYAlertAction * _Nonnull action) {
                
            }]];
            if (indexPath.row == 1) {
                break;
            }
            if (indexPath.row == 2) {
                [alertView addAction:[TYAlertAction actionWithTitle:kActionTitleDelete style:TYAlertActionStyleDestructive handler:^(TYAlertAction * _Nonnull action) {
                    
                }]];
                break;
            }
            alertView.title = kAlertTitleLong;
            alertView.message = kAlertMessageLong;
        } while(0);
        [alertView addAction:[TYAlertAction actionWithTitle:kActionTitleCancel style:TYAlertActionStyleCancel handler:^(TYAlertAction * _Nonnull action) {
            
        }]];
    } else if (indexPath.section == 1) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:kAlertTitle message:kAlertMessage delegate:self cancelButtonTitle:kActionTitleCancel otherButtonTitles:nil];
        do {
            if (indexPath.row < 1) {
                break;
            }
            [alertView addButtonWithTitle:kActionTitleOK];
            if (indexPath.row == 1) {
                break;
            }
            if (indexPath.row == 2) {
                [alertView addButtonWithTitle:kActionTitleDelete];
                break;
            }
            alertView.title = kAlertTitleLong;
            alertView.message = kAlertMessageLong;
        } while(0);
        
        [alertView show];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:kAlertTitle message:kAlertMessage preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertController animated:YES completion:nil];
        do {
            if (indexPath.row < 1) {
                break;
            }
            if (indexPath.row == 1) {
                break;
            }
            [alertController addAction:[UIAlertAction actionWithTitle:kActionTitleOK style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            if (indexPath.row == 2) {
                [alertController addAction:[UIAlertAction actionWithTitle:kActionTitleDelete style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                break;
            }
            alertController.title = kAlertTitleLong;
            alertController.message = kAlertMessageLong;
        } while(0);
        [alertController addAction:[UIAlertAction actionWithTitle:kActionTitleCancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
