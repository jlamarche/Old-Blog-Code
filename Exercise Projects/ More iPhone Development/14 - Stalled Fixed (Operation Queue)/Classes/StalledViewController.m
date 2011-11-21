#import "StalledViewController.h"

#define kTableRowHeight             40.0
#define kProgressBarLeftMargin      20.0
#define kProgressBarTopMargin       5.0
#define kProgressBarWidth           253.0
#define kProgressBarHeight          9.0   // Standard Height
#define kProgressLabelLeftMargin    20.0
#define kProgressLabelTopMargin     19.0
#define kProgressViewTag            1011
#define kProgressLabelTag           1012

@implementation StalledViewController
@synthesize numOperationsInput;
//@synthesize progressBar;
//@synthesize progressLabel;
@synthesize tableView;
@synthesize queue;
- (IBAction)go {
    NSInteger opCount = [numOperationsInput.text intValue];
    SquareRootOperation *newOp = [[SquareRootOperation alloc] initWithMax:opCount delegate:self];
    [queue addOperation:newOp];
    [newOp release];
}

z {
    NSInteger index = [sender tag];
    NSOperation *op = [[queue operations] objectAtIndex:index];
    
    [op cancel];
    if (![op isExecuting])
        [self.tableView reloadData];
}

- (IBAction)backgroundClick {
    [numOperationsInput resignFirstResponder];
}

#pragma mark -
- (void)viewDidLoad {
    NSOperationQueue *newQueue = [[NSOperationQueue alloc] init]; 
    self.queue = newQueue;
    [newQueue release];   
    [queue addObserver:self
            forKeyPath:@"operations"
               options:0
               context:NULL];
}

- (void)viewDidUnload {
	self.numOperationsInput = nil;
    //    self.progressLabel = nil;
    //    self.progressBar = nil;
    self.tableView = nil;
}

- (void)dealloc {
    [numOperationsInput release];
    //    [progressLabel release];
    //    [progressBar release]
    [tableView release];
    [queue release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark KVO
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    NSIndexSet *indices = [change objectForKey:NSKeyValueChangeIndexesKey];
    if (indices == nil)
        return; // Nothing to do
    
    
    // Build index paths from index sets
    NSUInteger indexCount = [indices count];
    NSUInteger buffer[indexCount];
    [indices getIndexes:buffer maxCount:indexCount inIndexRange:nil];
    
    NSMutableArray *indexPathArray = [NSMutableArray array];
    for (int i = 0; i < indexCount; i++) {
        NSUInteger indexPathIndices[2];
        indexPathIndices[0] = 0;
        indexPathIndices[1] = buffer[i];
        NSIndexPath *newPath = [NSIndexPath indexPathWithIndexes:indexPathIndices length:2];
        [indexPathArray addObject:newPath];
    }
    
    NSNumber *kind = [change objectForKey:NSKeyValueChangeKindKey];
    if ([kind integerValue] == NSKeyValueChangeInsertion)  // Operations were added
        [self.tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
    else if ([kind integerValue] == NSKeyValueChangeRemoval)  // Operations were removed
        [self.tableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
    
}
#pragma mark -
#pragma mark Square Root Operation Delegate Methods
- (void)operationProgressChanged:(SquareRootOperation *)op {
    NSUInteger opIndex = [[queue operations] indexOfObject:op];
    NSUInteger reloadIndices[] = {0, opIndex};
    NSIndexPath *reloadIndexPath = [NSIndexPath indexPathWithIndexes:reloadIndices length:2];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:reloadIndexPath];
    if (cell) {
        UIProgressView *progressView = (UIProgressView *)[cell.contentView viewWithTag:kProgressViewTag];
        progressView.progress = [op percentComplete];
        UILabel *progressLabel = (UILabel *)[cell.contentView viewWithTag:kProgressLabelTag];
        progressLabel.text = [op progressString];
        
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:reloadIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}
#pragma mark -
#pragma mark Table View Methods
- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section {
    return [[queue operations] count];
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Operation Queue Cell";
    UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        
        UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(kProgressBarLeftMargin, kProgressBarTopMargin, kProgressBarWidth, kProgressBarHeight)];
        progressView.tag = kProgressViewTag;
        [cell.contentView addSubview:progressView];
        [progressView release];
        
        UILabel *progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(kProgressLabelLeftMargin, kProgressLabelTopMargin, kProgressBarWidth, 15.0)];
        progressLabel.adjustsFontSizeToFitWidth = YES;
        progressLabel.tag = kProgressLabelTag;
        progressLabel.textAlignment = UITextAlignmentCenter;
        progressLabel.font = [UIFont systemFontOfSize:12.0];
        [cell.contentView addSubview:progressLabel];
        [progressLabel release];
        
        UIButton *removeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *removeImage = [UIImage imageNamed:@"remove.png"];
        [removeButton setBackgroundImage:removeImage forState:UIControlStateNormal];
        [removeButton setFrame:CGRectMake(0.0, 0.0, removeImage.size.width, removeImage.size.height)];
        [removeButton addTarget:self action:@selector(cancelOperation:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryView  = removeButton;
    }
    SquareRootOperation *rowOp = (SquareRootOperation *)[[queue operations] objectAtIndex:[indexPath row]];
    UIProgressView *progressView = (UIProgressView *)[cell.contentView viewWithTag:kProgressViewTag];
    progressView.progress = [rowOp percentComplete];
    
    UILabel *progressLabel = (UILabel *)[cell.contentView viewWithTag:kProgressLabelTag];
    progressLabel.text = [rowOp progressString];
    
    cell.accessoryView.tag = [indexPath row];
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (CGFloat)tableView:(UITableView *)theTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kTableRowHeight;
}

@end
