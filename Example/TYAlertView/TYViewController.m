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
    _cellTitles = @[@"Simply", @"Double Action", @"Multiple Actions"];
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
        TYAlertView *alertView = [[TYAlertView alloc] initWithTitle:@"Title" message:@"Message"];
        [alertView show];
        do {
            if (indexPath.row < 1) {
                break;
            }
            [alertView addAction:[TYAlertAction actionWithTitle:@"OK" style:TYAlertActionStyleDefault handler:^(TYAlertAction * _Nonnull action) {
                
            }]];
            if (indexPath.row == 2) {
                [alertView addAction:[TYAlertAction actionWithTitle:@"Delete" style:TYAlertActionStyleDestructive handler:^(TYAlertAction * _Nonnull action) {
                    
                }]];
            }
        } while(0);
        [alertView addAction:[TYAlertAction actionWithTitle:@"Cancel" style:TYAlertActionStyleCancel handler:^(TYAlertAction * _Nonnull action) {
            
        }]];
    } else if (indexPath.section == 1) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Title" message:@"Message" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        do {
            if (indexPath.row < 1) {
                break;
            }
            [alertView addButtonWithTitle:@"OK"];
            if (indexPath.row == 2) {
                [alertView addButtonWithTitle:@"Delete"];
            }
        } while(0);
        
        [alertView show];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Title" message:@"Message" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertController animated:YES completion:nil];
        do {
            if (indexPath.row < 1) {
                break;
            }
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            if (indexPath.row == 2) {
                [alertController addAction:[UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
            }
        } while(0);
        [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
