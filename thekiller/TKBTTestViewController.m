//
//  TKBTTestViewController.m
//  Frienderers
//
//  Created by Ido on 05/Feb/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import "TKBTTestViewController.h"
#import "TKBluetoothManager.h"
#import "TKDevice.h"

@interface TKBTTestViewController ()
@property (strong, nonatomic) NSDictionary* nearbyDevices;
@end

@implementation TKBTTestViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[TKBluetoothManager sharedManager] startWithName:[[UIDevice currentDevice] name]];
    
    [[TKBluetoothManager sharedManager] addObserver:self forKeyPath:@"nearbyDevicesDictionary" options:NSKeyValueObservingOptionInitial context:0];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[TKBluetoothManager sharedManager] removeObserver:self forKeyPath:@"nearbyDevicesDictionary" context:0];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    self.nearbyDevices = [TKBluetoothManager sharedManager].nearbyDevicesDictionary;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.tableView reloadData];
    }];
    
    
    
    /*
    dispatch_async(dispatch_get_main_queue(), ^{
        
        TKDevice *device = [[TKBluetoothManager sharedManager].nearbyDevicesDictionary objectForKey:self.targetProfileID];
        if (device)
        {
            if (device.range == VERY_NEAR)
            {
                _isTargetInRange = YES;
                // add glow to gun icon $$$
                self.gunButton.alpha = 1.0;
                
            }
            else
            {
                _isTargetInRange = NO;
                self.gunButton.alpha = 0.5;
            }
        }
    });
     */
    
}


#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return ([[self.nearbyDevices allKeys] count] + 1);
    
    // Return the number of rows in the section.
    //return 0;
}


-(void)reloadState
{

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BTCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    if (indexPath.row == 0)
    {
        cell.textLabel.text = [UIDevice currentDevice].name;
        cell.detailTextLabel.text = @"MYSELF";
        return cell;
    }
    
    NSString *deviceName = [[self.nearbyDevices allKeys] objectAtIndex:indexPath.row-1];
    TKDevice *device = self.nearbyDevices[deviceName];
    
    /*
    NSString *rangeStr;
    switch (device.range) {
        case VERY_FAR:
            rangeStr = @"Very far";
            break;
        case FAR:
            rangeStr = @"Far";
            break;
        case MEDIUM:
            rangeStr = @"Medium";
            break;
        case NEAR:
            rangeStr = @"Near";
            break;
        case VERY_NEAR:
            rangeStr = @"Very near";
            break;
            
        default:
            break;
    }
     */
    NSString *cellStr = [NSString stringWithFormat:@"%@",deviceName];
    cell.textLabel.text = cellStr;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"(%ld)",(long)device.rssi];
    if (device.inRange)
        cell.textLabel.textColor = [UIColor redColor];
    else
        cell.textLabel.textColor = [UIColor blackColor];
    
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
