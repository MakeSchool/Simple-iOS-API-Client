//
//  CandyListTableViewController.m
//  SimpleAPIClient
//
//  Created by Benjamin Encz on 19/09/14.
//  Copyright (c) 2014 MakeSchool. All rights reserved.
//

#import "CandyListTableViewController.h"
#import "Candy.h"

@interface CandyListTableViewController ()

@end

@implementation CandyListTableViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.candies count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CandyCell" forIndexPath:indexPath];
    
    Candy *candy = self.candies[indexPath.row];
    
    cell.textLabel.text = candy.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld$", candy.price];
    
    return cell;
}

@end
