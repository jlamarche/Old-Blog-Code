#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface Simple_PlayerViewController : UIViewController <MPMediaPickerControllerDelegate, UITableViewDelegate, UITableViewDataSource> {
    UITextField *titleSearch;
    UIButton    *playPauseButton;
    UITableView *tableView;
    
    MPMusicPlayerController *player;
    MPMediaItemCollection   *collection;
    MPMediaItem             *nowPlaying;
    BOOL                    collectionModified;
    NSTimeInterval          pressStarted;
}
@property (nonatomic, retain) IBOutlet UITextField *titleSearch;
@property (nonatomic, retain) IBOutlet UIButton *playPauseButton;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

@property (nonatomic, retain) MPMusicPlayerController *player;
@property (nonatomic, retain) MPMediaItemCollection *collection;
@property (nonatomic, retain) MPMediaItem *nowPlaying;

- (IBAction)doTitleSearch;
- (IBAction)showMediaPicker;
- (IBAction)backgroundClick;

- (IBAction)seekBackward;
- (IBAction)previousTrack;
- (IBAction)seekForward;
- (IBAction)nextTrack;
- (IBAction)playOrPause;
- (IBAction)removeTrack:(id)sender;

- (void)nowPlayingItemChanged:(NSNotification *)notification;
@end

