# THE COCOADEX

Documentation lookup for Cocoa APIs, in the spirit of RI

Cocoadex parses Cocoa documentation files and creates a keyword index. Queries can then be run against the index for fast documentation lookup.

## Installation

    gem install cocoadex

## Usage

 - **View Options:** `cocoadex --help`

 - **Loading a DocSet:** `cocoadex --load-docset [path]` (Try `~/Library/Developer/DocSets/[docset name]`)

 - **Look up Documentation:** `cocoadex --search [query]`
   - Valid search terms are Class, method, and property names. Search scope can also be focused using delimiters, such as `ClassName-method` to find instance methods, `Class+method` to find class methods, or `Class.method` to find any matching method or property in `Class`.


*Property Lookup Example*

<pre>
$ cocoadex -s tableView

-------------------------------------------------------------- tableView
                                                 (UITableViewController)

@property(nonatomic, retain) UITableView *tableView
------------------------------------------------------------------------
Returns the table view managed by the controller object.

Available in iOS 2.0 and later.
</pre>


*Method Lookup Example*

<pre>
$ cocoadex -s tableView:viewForFoo

-------------------------------------- tableView:viewForFooterInSection:
                                                   (UITableViewDelegate)

  - (UIView *)tableView:(UITableView *)tableView
      viewForFooterInSection:(NSInteger)section

Returns: A view object to be displayed in the footer of section .
------------------------------------------------------------------------
Asks the delegate for a view object to display in the footer of the
specified section of the table view.

Parameters:

  tableView
    The table-view object asking for the view object.
  section
    An index number identifying a section of tableView .

Available in iOS 2.0 and later.
</pre>

*Class Lookup Example (Clipped for brevity)*

<pre>
$ cocoadex -s UILabel

--------------------------------------------------------- Class: UILabel
                                       (UIView > UIResponder > NSObject)

Describes a control for displaying static text.
------------------------------------------------------------------------

Overview:

   (...)

Instance Methods:
  drawTextInRect:, textRectForBounds:limitedToNumberOfLines:

Properties:
  adjustsFontSizeToFitWidth, baselineAdjustment, enabled, font,
  highlighted, highlightedTextColor, lineBreakMode, minimumFontSize,
  numberOfLines, shadowColor, shadowOffset, text, textAlignment,
  textColor, userInteractionEnabled

</pre>


## Todo

 - Look into other formatting options, like `--plain` and `--html`
 - Allow loading specific components of docs, like `--declaration`,`--overview`, `--methods`, etc
 - Allow loading docs from specific platforms/versions
 - Add option to turn on/off fuzzy matching
 - Support auto-loading DocSets from common locations
 - Persist object model/datastore using AR or similar
 - Support constants, functions, and data types