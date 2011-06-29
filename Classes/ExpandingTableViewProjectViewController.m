//
//  ExpandingTableViewProjectViewController.m
//  ExpandingTableViewProject
//
//  Created by Ryan Newsome on 4/12/11.
//  Hopefully this is helpful
//

#define COMMENT_LABEL_WIDTH 230
#define COMMENT_LABEL_MIN_HEIGHT 65
#define COMMENT_LABEL_PADDING 10

#import "ExpandingTableViewProjectViewController.h"
#import "CommentTableCell.h"

@implementation ExpandingTableViewProjectViewController


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set set our selected Index to -1 to indicate no cell will be expanded
    selectedIndex = -1;
    

    //SetUpTestData with some meaningless strings
    textArray = [[NSMutableArray alloc] init];
    
    NSString *testString;
    
    for(int ii = 0; ii < 6; ii++)
    {
        testString = [NSString stringWithString:@"Test comment. Test comment."];
        for (int jj = 0; jj < ii; jj++) {
            testString = [NSString stringWithFormat:@"%@ %@", testString, testString];
        }
        [testString retain];
        [textArray addObject:testString];
    }
}


//This just a convenience function to get the height of the label based on the comment text
-(CGFloat)getLabelHeightForIndex:(NSInteger)index
{
    CGSize maximumSize = CGSizeMake(COMMENT_LABEL_WIDTH, 10000);
    
    CGSize labelHeighSize = [[textArray objectAtIndex:index] sizeWithFont: [UIFont fontWithName:@"Helvetica" size:14.0f]
                                                                constrainedToSize:maximumSize
                                                                lineBreakMode:UILineBreakModeWordWrap];
    return labelHeighSize.height;
    
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [textArray count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    static NSString *CellIdentifier = @"customCell";
    
    CommentTableCell *cell = (CommentTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //cell = [[[exerciseListUITableCell alloc] init] autorelease];
        
        NSArray * topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CommentTableCell" owner:self options:nil];
        
        for(id currentObject in topLevelObjects)
        {
            if([currentObject isKindOfClass:[UITableViewCell class]])
            {
                cell = (CommentTableCell *)currentObject;
                break;
            }
        }        
    }
    
    //If this is the selected index then calculate the height of the cell based on the amount of text we have
    if(selectedIndex == indexPath.row)
    {
        CGFloat labelHeight = [self getLabelHeightForIndex:indexPath.row];

        cell.commentTextLabel.frame = CGRectMake(cell.commentTextLabel.frame.origin.x, 
                                                cell.commentTextLabel.frame.origin.y, 
                                                cell.commentTextLabel.frame.size.width, 
                                                labelHeight);
    }else{

        //Otherwise just return the minimum height for the label.
        cell.commentTextLabel.frame = CGRectMake(cell.commentTextLabel.frame.origin.x, 
                                                cell.commentTextLabel.frame.origin.y, 
                                                cell.commentTextLabel.frame.size.width, 
                                                COMMENT_LABEL_MIN_HEIGHT);
    }

    cell.commentTextLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0f];
    cell.commentTextLabel.text = [textArray objectAtIndex:indexPath.row];

    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //If this is the selected index we need to return the height of the cell
    //in relation to the label height otherwise we just return the minimum label height with padding
    if(selectedIndex == indexPath.row)
    {
        return [self getLabelHeightForIndex:indexPath.row] + COMMENT_LABEL_PADDING * 2;
    }
    else {
        return COMMENT_LABEL_MIN_HEIGHT + COMMENT_LABEL_PADDING * 2;
    }
}



-(NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //We only don't want to allow selection on any cells which cannot be expanded
    if([self getLabelHeightForIndex:indexPath.row] > COMMENT_LABEL_MIN_HEIGHT)
    {
        return indexPath;
    }
    else {
        return nil;
    }

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    //The user is selecting the cell which is currently expanded
    //we want to minimize it back
    if(selectedIndex == indexPath.row)
    {
        selectedIndex = -1;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        return;
    }
    
    //First we check if a cell is already expanded.
    //If it is we want to minimize make sure it is reloaded to minimize it back
    if(selectedIndex >= 0)
    {
        NSIndexPath *previousPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
        selectedIndex = indexPath.row;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:previousPath] withRowAnimation:UITableViewRowAnimationFade];        
    }
    
    //Finally set the selected index to the new selection and reload it to expand
    selectedIndex = indexPath.row;
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
}

- (void)dealloc {
    [super dealloc];
}

@end
