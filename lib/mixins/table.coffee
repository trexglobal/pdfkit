
module.exports = 
    initTable: ->
        # Current coordinates
        @tx = 0
        @ty = 0

        # Last added line coordinates
        @last_col = {
            x: @tx,
            y: @ty
        }

        # Cotain row data
        @data = []

        # Contain cols definition
        @definition = {}

        return this
    
    _theader: () ->

        header_x_position = @tx
        header_y_position = @ty

        # Loop Col Definitions
        for id, col of @definition
            added_col = this.text col.label, header_x_position, header_y_position
            header_x_position += col.width

    _tbody: () ->

        body_x_position = @tx
        body_y_position = @last_col.y or @ty

        # Loop Row Data
        for row in @data
            body_x_position = @tx
            body_y_position = (@last_col.y or @ty) + @options.row_size
            # Loop Col Definitions
            for id, col of @definition
                @last_col = this.text row[id], body_x_position, body_y_position
                body_x_position += col.width

    table: (x, y, data = [], definition = {}, options = {}) ->

        # Update the current position
        if x? or y?
            @tx = x or @tx
            @ty = y or @ty

        # Assign options and data to instance
        @data = data
        @definition = definition
        @options = options


        # Build Table Header
        @_theader()

        # Build Table Body
        @_tbody()
