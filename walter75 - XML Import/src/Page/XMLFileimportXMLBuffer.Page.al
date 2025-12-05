page 60501 "SEW XML Fileimport XMLBuffer"
{

    Caption = 'XML Fileimport XMLBuffer';
    PageType = List;
    SourceTable = "XML Buffer";
    UsageCategory = None;
    ApplicationArea = All;
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Data Type"; Rec."Data Type")
                {

                    ToolTip = 'Specifies the data type.';
                }
                field(Depth; Rec.Depth)
                {

                    ToolTip = 'Specifies the depth.';
                }
                field("Entry No."; Rec."Entry No.")
                {

                    ToolTip = 'Specifies the entry number.';
                }
                field("Import ID"; Rec."Import ID")
                {

                    ToolTip = 'Specifies the import ID.';
                }
                field(Name; Rec.Name)
                {

                    ToolTip = 'Specifies the name.';
                }
                field(Namespace; Rec.Namespace)
                {

                    ToolTip = 'Specifies the namespace.';
                }
                field("Node Number"; Rec."Node Number")
                {

                    ToolTip = 'Specifies the node number.';
                }
                field("Parent Entry No."; Rec."Parent Entry No.")
                {

                    ToolTip = 'Specifies the parent entry number.';
                }
                field(Path; Rec.Path)
                {

                    ToolTip = 'Specifies the path.';
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {

                    ToolTip = 'Specifies the system created at timestamp.';
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {

                    ToolTip = 'Specifies the system created by.';
                }
                field(SystemId; Rec.SystemId)
                {

                    ToolTip = 'Specifies the system ID.';
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {

                    ToolTip = 'Specifies the system modified at timestamp.';
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {

                    ToolTip = 'Specifies the system modified by.';
                }
                field(Type; Rec."Type")
                {

                    ToolTip = 'Specifies the type.';
                }
                field(Value; Rec."Value")
                {

                    ToolTip = 'Specifies the value.';
                }
            }
        }
    }
}
