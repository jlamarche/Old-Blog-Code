#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface MPMediaItemCollection(Utils)
/** Returns the first media item in the collection
 */
- (MPMediaItem *)firstMediaItem;

/** Returns the last media item in the collection
 */
- (MPMediaItem *)lastMediaItem;

/** This method will return the item in this media collection at a specific index
 */
- (MPMediaItem *)mediaItemAtIndex:(NSUInteger)index;

/** Given a particular media item, this method will return the next media item in the collection.
    If there are multiple copies of the same media item in the list, it will return the one
    after the first occurrence.
 */
- (MPMediaItem *)mediaItemAfterItem:(MPMediaItem *)compare;

/** Returns the title of the media item at a given index.
 */
- (NSString *)titleForMediaItemAtIndex:(NSUInteger)index;

/** Returns YES if the given media item occurs at least once in this collection
 */
- (BOOL)containsItem:(MPMediaItem *)compare;

/** Creates a new collection by appending otherCollection to the end of this collection
 */
- (MPMediaItemCollection *)collectionByAppendingCollection:(MPMediaItemCollection *)otherCollection;

/** Creates a new collection by appending an array of media items to the end of this collection
 */
- (MPMediaItemCollection *)collectionByAppendingMediaItems:(NSArray *)items;

/** Creates a new collection by appending a single media item to the end of this collection
 */
- (MPMediaItemCollection *)collectionByAppendingMediaItem:(MPMediaItem *)item;

/** Creates a new collection based on this collection, but excluding the specified items.
 */
- (MPMediaItemCollection *)collectionByDeletingMediaItems:(NSArray *)itemsToRemove;

/** Creates a new collection based on this collection, but which doesn't include the specified media item.
 */
- (MPMediaItemCollection *)collectionByDeletingMediaItem:(MPMediaItem *)itemToRemove;

/** Creates a new collection based on this collection, but excluding the media item at the specified index
 */
- (MPMediaItemCollection *)collectionByDeletingMediaItemAtIndex:(NSUInteger)index;

/** Creates a new collection, based on this collection, but excluding the media items starting with 
    (and including) the objects at index from and ending with (and including) to.
 */
- (MPMediaItemCollection *)collectionByDeletingMediaItemsFromIndex:(NSUInteger)from toIndex:(NSUInteger)to;
@end
