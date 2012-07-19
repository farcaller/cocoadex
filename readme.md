# THE COCOADEX

Spartan documentation lookup for Cocoa APIs


## Installation

    gem install cocoadex

## Usage

 - **View Options:** `cocoadex --help`
 - **Loading a DocSet:** `cocoadex --docset [path]` (Try `~/Library/Developer/DocSets/[docset name]`)
 - **Look up:** `cocoadex --search [query]`
   - Valid search terms are Class, method, and property names
   - Example:

<pre>
$ cocoadex -s tableView:didSelectRow
Declared in: UITableView.h

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
    tableView - A table-view object informing the delegate about the new row selection.
    indexPath - An index path locating the new selected row in tableView.
  Returns:
  Tells the delegate that the specified row is now selected.
  Available in iOS 2.0 and later.
</pre>

## Todo

 - Improve UX: Some tasteful usage of text formatting wouldn't hurt
 - Support `--first`, for returning the first result of multiple matches
 - Support auto-loading DocSets from common locations
 - Persist object model/datastore using AR