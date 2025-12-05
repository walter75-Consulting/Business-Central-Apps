table 90600 "SEW BDE Booking"
{
    Caption = 'BDE Booking';
    DataClassification = CustomerContent;
    LookupPageId = "SEW BDE Booking";
    DrillDownPageId = "SEW BDE Booking";

    fields
    {
        field(50; BookingID; Integer)
        {
            Caption = 'Booking ID';
            ToolTip = 'Specifies the unique identifier for the booking.';
            AutoIncrement = true;
            AllowInCustomizations = Never;
        }

        field(111; "Terminal Code"; Code[10])
        {
            Caption = 'Terminal Code';
            ToolTip = 'Specifies the BDE terminal code where this booking was created.';
            TableRelation = "SEW BDE Terminal";
            AllowInCustomizations = Never;
        }

        field(74; Status; Enum "Production Order Status")
        {
            Caption = 'Status';
            ToolTip = 'Specifies the status of the production order.';
            AllowInCustomizations = Never;
        }

        field(75; "Prod. Order No."; Code[20])
        {
            Caption = 'Prod. Order No.';
            ToolTip = 'Specifies the production order number.';
            Editable = false;
            NotBlank = true;
            TableRelation = "Production Order"."No." where(Status = field(Status));
        }
        field(92; "Order Line No."; Integer)
        {
            Caption = 'Order Line No.';
            ToolTip = 'Specifies the production order line number.';
            AllowInCustomizations = Never;
        }
        field(3; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            ToolTip = 'Specifies the item number.';
            TableRelation = Item;
        }
        field(5403; "Routing No."; Code[20])
        {
            Caption = 'Routing No.';
            ToolTip = 'Specifies the routing number.';
            TableRelation = "Routing Header";
            AllowInCustomizations = Never;
        }
        field(5404; "Routing Reference No."; Integer)
        {
            Caption = 'Routing Reference No.';
            ToolTip = 'Specifies the routing reference number.';
            Editable = false;
            AllowInCustomizations = Never;
        }
        field(5402; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            ToolTip = 'Specifies the variant code of the item.';
            TableRelation = "Item Variant".Code where("Item No." = field("Item No."));
            AllowInCustomizations = Never;
        }
        field(5407; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            ToolTip = 'Specifies the unit of measure code for the item.';
            TableRelation = "Item Unit of Measure".Code where("Item No." = field("Item No."));
            AllowInCustomizations = Never;
        }
        field(4; "Operation No."; Code[10])
        {
            Caption = 'Operation No.';
            ToolTip = 'Specifies the operation number.';
            NotBlank = true;
        }

        field(1; Type; Enum "Capacity Type")
        {
            Caption = 'Capacity Type';
            ToolTip = 'Specifies the type of capacity (Work Center or Machine Center).';
        }
        field(8; "No."; Code[20])
        {
            Caption = 'No.';
            ToolTip = 'Specifies the work center or machine center number.';
            TableRelation = if (Type = const("Work Center")) "Work Center"
            else
            if (Type = const("Machine Center")) "Machine Center";
        }


        field(6998; "BDE Rout. Line Status Start"; Enum "SEW BDE Rout. Line Status")
        {
            Caption = 'BDE Rout. Line Status Start';
            ToolTip = 'Specifies the BDE routing line status at the start of the booking.';
        }

        field(6999; "BDE Rout. Line Status Stop"; Enum "SEW BDE Rout. Line Status")
        {
            Caption = 'BDE Rout. Line Status Stop';
            ToolTip = 'Specifies the BDE routing line status at the end of the booking.';
        }

        field(7000; "Starting Date/Time"; DateTime)
        {
            Caption = 'Starting Date/Time';
            ToolTip = 'Specifies the date and time when the operation started.';
        }
        field(71; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
            ToolTip = 'Specifies the date when the operation started.';
        }
        field(70; "Starting Time"; Time)
        {
            Caption = 'Starting Time';
            ToolTip = 'Specifies the time when the operation started.';
        }

        field(7001; "Ending Date/Time"; DateTime)
        {
            Caption = 'Ending Date/Time';
            ToolTip = 'Specifies the date and time when the operation ended.';
        }
        field(73; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
            ToolTip = 'Specifies the date when the operation ended.';
        }
        field(72; "Ending Time"; Time)
        {
            Caption = 'Ending Time';
            ToolTip = 'Specifies the time when the operation ended.';
        }
        field(100; "Duration Minutes"; Integer)
        {
            Caption = 'Duration Minutes';
            ToolTip = 'Specifies the duration of the operation in minutes.';
        }

        field(999; "User Start"; Code[20])
        {
            Caption = 'User Start';
            ToolTip = 'Specifies the user who started the operation.';
            TableRelation = "Resource";
        }
        field(998; "User Stop"; Code[20])
        {
            Caption = 'User Stop';
            ToolTip = 'Specifies the user who stopped the operation.';
            TableRelation = "Resource";
        }

        field(80; "Comment Start"; Text[255])
        {
            Caption = 'Comment Start';
            ToolTip = 'Specifies a comment entered when starting the operation.';
            AllowInCustomizations = Never;
        }
        field(81; "Comment Stop"; Text[255])
        {
            Caption = 'Comment Stop';
            ToolTip = 'Specifies a comment entered when stopping the operation.';
            AllowInCustomizations = Never;
        }
        field(82; Processed; Boolean)
        {
            Caption = 'Processed';
            ToolTip = 'Specifies whether the booking has been processed.';
        }
        field(83; "Output Quantity"; Decimal)
        {
            Caption = 'Output Quantity';
            ToolTip = 'Specifies the output quantity produced during the operation.';
            DecimalPlaces = 0 : 5;
            AllowInCustomizations = Never;
        }
        field(84; "Scrap Quantity"; Decimal)
        {
            Caption = 'Scrap Quantity';
            ToolTip = 'Specifies the scrap quantity produced during the operation.';
            DecimalPlaces = 0 : 5;
            AllowInCustomizations = Never;
        }
        field(85; "Scrap Code"; Code[10])
        {
            Caption = 'Scrap Code';
            ToolTip = 'Specifies the scrap code for the scrap quantity.';
            TableRelation = Scrap;
            AllowInCustomizations = Never;
        }
        field(86; Finished; Boolean)
        {
            Caption = 'Finished';
            ToolTip = 'Specifies whether the operation is finished.';
            AllowInCustomizations = Never;
        }

    }

    keys
    {
        key(PK; BookingID)
        {
            Clustered = true;
        }
    }

}