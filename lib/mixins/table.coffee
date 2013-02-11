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

        # Cotain row data
        @data = []

        @options = {
          row_size: 20 # TODO: Get font width
        }

        # Carriage for printing each table element in it's place
        @carriage = {
            x: @tx,
            y: @ty
        }

        # Contain cols cols definition
        @cols_definition = {}

        return this


    _initCarriage: () ->
        @carriage = {
            x: @tx,
            y: @ty
        }

    # Indent carriage
    _indent: ( indent ) ->
        @carriage.x += indent

    # Move carriage to new line
    _return: () ->
        if ( @carriage.y + @options.row_size ) > this.page.height
            @addPage()
            @_initCarriage()
        else
            @carriage.y += @options.row_size # TODO: Calculate from text
            @carriage.x = @tx

    _theader: () ->

        # Loop Col Definitions
        for id, col of @cols_definition
            added_col = this.text col.label, @carriage.x, @carriage.y
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

        # Print Column
        this.text value, @carriage.x, @carriage.y

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
        @options = options if options?

        # Setup Carriage
        @_initCarriage()

        # Build Table Header
        @_theader()

        # Build Table Body
        @_tbody()
