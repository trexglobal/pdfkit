# Add table support
#
# doc.table(20, 20,
#         [
#             {
#                 name: 'first',
#                 amount: '$0.00'
#             },
#             {
#                 name: 'second',
#                 amount: '$0.00'
#             }
#         ],
#         {
#             name: {
#               label: 'name',
#               width: 100
#             },
#             amount: {
#               label: 'amount',
#               width: 100
#             }
#         }
# )

module.exports =
    initTable: ->
        # Current coordinates
        @tx = 0
        @ty = 0

        # Track new line Y
        @_newLineY = 0

        # Cotain row data
        @data = []

        @options = {
          new_page: {} # New page table position
        }

        # Carriage for printing each table element in it's place
        @carriage = {
            x: @tx,
            y: @ty
        }

        # Contain cols cols definition
        @cols_definition = {}

        return this

    # Set carriage for first and new page position
    _initCarriage: ( newPage = false ) ->

        if newPage

            @addPage()

            @carriage = {
                x: @tx,
                y: @currentLineHeight(true)
            }

        else

            @carriage = {
                x: @tx,
                y: @ty
            }

    # Indent carriage
    _indent: ( indent ) ->
        @carriage.x += indent

        # Keep current col next line position
        # if it's bigger than previous col
        if @y > @_newLineY
            @_newLineY = @y

    # Move carriage to new line
    _return: () ->

        # New Page
        # TODO: Fix issue when mutiline col is at the end of page
        if ( @_newLineY + @currentLineHeight(true)*2 ) > this.page.height

            @_initCarriage(true)

        # Normal Return
        else

            @carriage.y = @_newLineY
            @carriage.x = @tx

    _theader: () ->

        # Loop Col Definitions
        for id, col of @cols_definition
            added_col = this.text col.label, @carriage.x, @carriage.y,
                width: col.width
                align: col.align

            @_indent col.width

        @_return()

    _tbody: () ->

        @_rows @data

    _rows: ( data ) ->

        # Loop Rows
        for row in data
            @_row row
            @_return()

    _row: ( row ) ->

        # Loop Col Definitions
        for id, column_options of @cols_definition
            @_col row[id], column_options
            @_indent column_options.width

    _col: ( value, column_options ) ->

        # Get col static value
        col_value = value || column_options.value || ''

        # Prevent white space which is causing issues in Acrobat Reader
        if String(col_value).replace(/^\s+|\s+$/g,'') == ''
            col_value = ''

        # Print Column
        this.text col_value, @carriage.x, @carriage.y,
            width: column_options.width
            align: column_options.align

    table: ( x, y, data = [], cols_definition, options ) ->

        # Update the current position
        if x? or y?
            @tx = x or @tx
            @ty = y or @ty

        # Assign options and data to instance
        ## Rows
        @data = data
        ## Cols
        @cols_definition = cols_definition  if cols_definition?
        ## Other Options
        @options extends options

        # Setup Carriage
        @_initCarriage()

        # Build Table Header
        @_theader()

        # Build Table Body
        @_tbody()
