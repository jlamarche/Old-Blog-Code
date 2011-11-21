#import "Simple_PlayerViewController.h"
#import "MPMediaItemCollection-Utils.h"

#define kTableRowHeight 34

@implementation Simple_PlayerViewController
@synthesize titleSearch;
@synthesize playPauseButton;
@synthesize tableView;
@synthesize player;
@synthesize collection;
@synthesize nowPlaying;

#pragma mark -
- (IBAction)doTitleSearch {
    if ([titleSearch.text length] == 0)
        return;
    MPMediaPropertyPredicate *titlePredicate =
    [MPMediaPropertyPredicate predicateWithValue: titleSearch.text
                                     forProperty: MPMediaItemPropertyTitle 
                                  comparisonType:MPMediaPredicateComparisonContains];
    MPMediaQuery *query = [[MPMediaQuery alloc] initWithFilterPredicates:[NSSet setWithObject:titlePredicate]];
    
    if ([[query items] count] > 0) {
        if (collection)
            self.collection = [collection collectionByAppendingMediaItems:[query items]];
        else {
            self.collection = [MPMediaItemCollection collectionWithItems:[query items]];
            [player setQueueWithItemCollection:self.collection];
            [player play];
        }
        
        
        collectionModified = YES;
        [self.tableView reloadData];
    }
    [query release];
    titleSearch.text = @"";
    [titleSearch resignFirstResponder];
    
}

- (IBAction)showMediaPicker {
    MPMediaPickerController *picker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeMusic];
    picker.delegate = self;
    [picker setAllowsPickingMultipleItems:YES];
    picker.prompt = NSLocalizedString(@"Select items to play", @"Select items to play");
    [self presentModalViewController:picker animated:YES];
    [picker release];
}

- (IBAction)backgroundClick {
    [titleSearch resignFirstResponder];
}

- (IBAction)seekBackward {
    [player beginSeekingBackward];
    pressStarted = [NSDate timeIntervalSinceReferenceDate];
}

- (IBAction)previousTrack {
    [player endSeeking];
    
    if (pressStarted >= [NSDate timeIntervalSinceReferenceDate] - 0.1)
        [player skipToPreviousItem];
}

- (IBAction)seekForward {
    [player beginSeekingForward];
    pressStarted = [NSDate timeIntervalSinceReferenceDate];
}
- (IBAction)nextTrack {
    [player endSeeking];
    if (pressStarted >= [NSDate timeIntervalSinceReferenceDate] - 0.1)
        [player skipToNextItem];
}

- (IBAction)playOrPause {
    if (player.playbackState == MPMusicPlaybackStatePlaying) {
        [player pause];
        [playPauseButton setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    }
    else {
        [player play];
        [playPauseButton setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    }
    [self.tableView reloadData];
}

- (IBAction)removeTrack:(id)sender {
    NSUInteger index = [sender tag];
    MPMediaItem *itemToDelete = [collection mediaItemAtIndex:index];
    if ([itemToDelete isEqual:nowPlaying])  {
        if (!collectionModified) {
            [player skipToNextItem];
        }
        else {
            [player setQueueWithItemCollection:collection];
            player.nowPlayingItem = [collection mediaItemAfterItem:nowPlaying];
        }
        
    }
    MPMediaItemCollection *newCollection = [collection collectionByDeletingMediaItemAtIndex:index];
    self.collection = newCollection;
    
    collectionModified = YES;
    
    NSUInteger indices[] = {0, index};
    NSIndexPath *deletePath = [NSIndexPath indexPathWithIndexes:indices length:2];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:deletePath] withRowAnimation:UITableViewRowAnimationFade];
    
    if (newCollection == nil && player.playbackState == MPMusicPlaybackStatePlaying) {
        MPMediaItem *next = player.nowPlayingItem;
        self.collection = [MPMediaItemCollection collectionWithItems:[NSArray arrayWithObject:next]];
        [tableView reloadData];
    }
}

#pragma mark -
- (void)viewDidLoad {
    MPMusicPlayerController *thePlayer = [MPMusicPlayerController iPodMusicPlayer];
    self.player = thePlayer;
    [thePlayer release];
    
    if (player.playbackState == MPMusicPlaybackStatePlaying) {
        [playPauseButton setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
        MPMediaItemCollection *newCollection = [MPMediaItemCollection collectionWithItems:[NSArray arrayWithObject:[player nowPlayingItem]]];
        self.collection = newCollection;
        self.nowPlaying = [player nowPlayingItem];
    }
    else {
        [playPauseButton setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    }
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self
                           selector:@selector(nowPlayingItemChanged:)
                               name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                             object: player];
    
    [player beginGeneratingPlaybackNotifications];
}

- (void)viewDidUnload {
    self.titleSearch = nil;
    self.playPauseButton = nil;
    self.tableView = nil;
    [super viewDidUnload];
}

- (void)dealloc {
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self 
                      name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification 
                    object:player];
    [player endGeneratingPlaybackNotifications];
    
    [titleSearch release];
    [playPauseButton release];
    [tableView release];
    [player release];
    [collection release];
    [super dealloc];
}

#pragma mark -
#pragma mark Media Picker Delegate Methods
- (void) mediaPicker: (MPMediaPickerController *) mediaPicker
   didPickMediaItems: (MPMediaItemCollection *) theCollection {    
    [self dismissModalViewControllerAnimated: YES];
    
    if (collection == nil){
        self.collection = theCollection;
        [player setQueueWithItemCollection:collection];
        [player setNowPlayingItem:[collection firstMediaItem]];
        self.nowPlaying = [collection firstMediaItem];
        [player play];
        [playPauseButton setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    }
    else {
        self.collection = [collection collectionByAppendingCollection:theCollection];
    }
    
    collectionModified = YES;
    [self.tableView reloadData];
}

- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker {
    [self dismissModalViewControllerAnimated: YES];
}

#pragma mark -
#pragma mark Player Notification Methods
- (void)nowPlayingItemChanged:(NSNotification *)notification {
    if (collection == nil) {
        MPMediaItem *nowPlayingItem = [player nowPlayingItem];
        self.collection = [collection collectionByAppendingMediaItem:nowPlayingItem];
    }
    else {
        
        if (collectionModified) {
            [player setQueueWithItemCollection:collection];
            [player setNowPlayingItem:[collection mediaItemAfterItem:nowPlaying]];
            [player play];
        }
        
        if (![collection containsItem:player.nowPlayingItem] && player.nowPlayingItem != nil) {
            self.collection = [collection collectionByAppendingMediaItem:player.nowPlayingItem];
        }
    }
    
    [tableView reloadData];
    self.nowPlaying = [player nowPlayingItem];
    
    if (nowPlaying == nil) 
        [playPauseButton setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    else 
        [playPauseButton setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    
    
    collectionModified = NO;
}

#pragma mark -
#pragma mark Table View Methods
- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section {
    return [collection count];
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Music Queue Cell";
    UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        
        UIButton *removeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *removeImage = [UIImage imageNamed:@"remove.png"];
        [removeButton setBackgroundImage:removeImage forState:UIControlStateNormal];
        [removeButton setFrame:CGRectMake(0.0, 0.0, removeImage.size.width, removeImage.size.height)];
        [removeButton addTarget:self action:@selector(removeTrack:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryView  = removeButton;
    }
    cell.textLabel.text = [collection titleForMediaItemAtIndex:[indexPath row]];
    if ([nowPlaying isEqual:[collection mediaItemAtIndex:[indexPath row]]]) {
        cell.textLabel.font = [UIFont boldSystemFontOfSize:21.0];
        if (player.playbackState ==  MPMusicPlaybackStatePlaying)
            cell.imageView.image = [UIImage imageNamed:@"play_small.png"];
        else 
            cell.imageView.image = [UIImage imageNamed:@"pause_small.png"];
        
    }
    else {
        cell.textLabel.font = [UIFont systemFontOfSize:21.0];
        cell.imageView.image = [UIImage imageNamed:@"empty.png"];
    }
    
    cell.accessoryView.tag = [indexPath row];
    
    return cell;
}

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MPMediaItem *selected = [collection mediaItemAtIndex:[indexPath row]];
    
    if (collectionModified) {
        [player setQueueWithItemCollection:collection]; 
        collectionModified = NO;
    }
    
    [player setNowPlayingItem:selected];
    [player play];
    
    [playPauseButton setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)theTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kTableRowHeight;
}

@end
