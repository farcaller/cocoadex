# THE COCOADEX

Documentation lookup for Cocoa APIs, in the spirit of RI

Cocoadex parses Cocoa documentation files and creates a keyword index. Queries can then be run against the index for fast documentation lookup.

[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/kattrali/cocoadex)


## Installation

    gem install cocoadex

## Configuration

Load any DocSets in known locations:

    cocoadex --configure

## Usage

### View Options

    cocoadex --help


### Loading a Custom DocSet

    cocoadex --load-docset [path] --load-docset [path2] ...


### Look up Documentation

    cocoadex [query]

Valid search terms are Class, method, and property names. Search scope can also be focused using delimiters, such as `ClassName-method` to find instance methods, `Class+method` to find class methods, or `Class.method` to find any matching method or property in `Class`.


## Enabling Tab Completion

Cocoadex generates a tags file of all indexed search terms during configuration. Enable tab completion for bash by linking/saving `bin/cocoadex_completion.sh` and adding the following to your .bash_profile (or similar):

    complete -C /path/to/cocoadex_completion.sh -o default cocoadex

## Example Output

### Property Lookup Example

<pre>
$ cocoadex tableView

-------------------------------------------------------------- tableView
                                                 (UITableViewController)

@property(nonatomic, retain) UITableView *tableView
------------------------------------------------------------------------
Returns the table view managed by the controller object.

Available in iOS 2.0 and later.
</pre>


### Method Lookup Example

<pre>
$ cocoadex tableView:viewForFoo

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

### Class Lookup Example (Clipped for brevity)

<pre>
$ cocoadex UILabel

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