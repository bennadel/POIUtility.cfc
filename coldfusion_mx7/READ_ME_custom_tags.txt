
Kinky Solutions POI ColdFusion Custom Tag

These ColdFusion custom tags allow you to create native Microsoft Excel binary files. They create PRE-2007 compatible files. The following is a list of the currently supported tags and the current attributes.

NOTE: All tags in the POI systems require the use of both an OPENING and CLOSING tag. If you leave out a closing tag (or self-closing tag), you will get unexpected results.


Document
--------
Name: [optional] If provided, will store a copy of the Excel file in a ByteArrayOutputStream that can easily be converted to a byte array and streamed to the browser using CFContent or written to the file system using CFFile.

File: [optional] If provided, will store a copy of the Excel file at the given expanded file path.

Template: [optional] If provided, this will read in and use an existing Excel file as the base for the new file (it does not affect the template, only copies it's data). 

Style: [optional] Sets default CSS styles for all cells in the document.

** Note: Name and File are optional, but ONE of them is required.


Classes
-------
** No functional value other than containership at this time.


Class
-----
Name: The name of the class (to be used as a struct-key) holding the given CSS styles.

Style: The CSS style for this class.

** Note: You can use the class name "@cell" to override the default cell style for the entire workbook.


Sheets
------
** No functional value other than containership at this time.


Sheet
-----
Name: The name of the sheet to be displayed in the tab at the bottom of the workbook. 

FreezeRow: [optional] The one-based index of the row you want to freeze.

FreezeColumn: [optional] The one-based index of the column you want to freeze.

Orientation: [optional] The print orientation of the sheet. Can be portrait (default) or Landscape.


Columns
-------
** No functional value other than containership at this time.
** This section is optional.


Column
------
Index: [optional] The zero-based index of the column. By default, this will start at zero and increment for each column.

Class: [optional] The class names (defined above) that should be applied to this column. This can be a single class or a space-delimited list of classes (to be taken in order).

Style: [optional] The CSS styles that should be applied to this column.

Freeze: [optional] Boolean value to determine if this column should be frozen in the document.


Row
---
Index: [optional] The zero-based index of this row. By default, this will start at zero and increment for each row. If you set this manually, all subsequent rows will start after the previous one.

Class: [optional] The class names (defined above) that should be applied to this row. This can be a single class or a space-delimited list of classes (to be taken in order).

Style: [optional] The CSS styles that should be applied to this row.

Freeze: [optional] Boolean value to determine if this row should be frozen in the document.


Cell
----
Type: [optional] Type of data in the cell. By default, everything is a string. Currently, can also be Numeric or Date.

Index: [optional] The zero-based index of this cell. By default, this will start at zero and increment for each cell. If you set this manually, all subsequent cells in this row will start after the previous one.

Value: [optional] The value to be used for the cell output. If this is not provided, then the GeneratedContent of the cell tag will be used (space between the opening and closing tags).

ColSpan: [optional] Defaults to one; allows you to create merged cells in a horizontal way.

NumberFormat: [optional] The number mask of the numeric cell. Only a limitted number of masks are available.

DateFormat: [optoinal] The date mask of the date cell. Only a limited number of masks are avilable.

Class: [optional] The class names (defined above) that should be applied to this cell. This can be a single class or a space-delimited list of classes (to be taken in order).

Style: [optional] The CSS styles that should be applied to this cell.



Available Number Formatting Masks
---------------------------------

"General"
"0"
"0.00"
"#,##0"
"#,##0.00"
"($#,##0_);($#,##0)"
"($#,##0_);[Red]($#,##0)"
"($#,##0.00);($#,##0.00)"
"($#,##0.00_);[Red]($#,##0.00)"
"0%"
"0.00%"
"0.00E+00"
"# ?/?"
"# ??/??"
"(#,##0_);[Red](#,##0)"
"(#,##0.00_);(#,##0.00)"
"(#,##0.00_);[Red](#,##0.00)"
"_(*#,##0_);_(*(#,##0);_(* \"-\"_);_(@_)"
"_($*#,##0_);_($*(#,##0);_($* \"-\"_);_(@_)"
"_(*#,##0.00_);_(*(#,##0.00);_(*\"-\"??_);_(@_)"
"_($*#,##0.00_);_($*(#,##0.00);_($*\"-\"??_);_(@_)"
"##0.0E+0"
"@" - This is text format.
"text" - Alias for "@"


Available Date Formatting Masks
-------------------------------

"m/d/yy"
"d-mmm-yy"
"d-mmm"
"mmm-yy"
"h:mm AM/PM"
"h:mm:ss AM/PM"
"h:mm"
"h:mm:ss"
"m/d/yy h:mm"
"mm:ss"
"[h]:mm:ss"
"mm:ss.0"
